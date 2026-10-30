// Story mode at a base. Day: explore the building, open back rooms, peek through keyholes,
// search props, fend off a few wanderers. Dusk, then night: defend the radio against a wave
// sized by the night number and the moon. Dawn starts the next day. Built on PlayState so
// movement, shooting, partners and zombies behave exactly as in Classic.

import { G, switchState } from '../engine/core';
import { keys, mouse } from '../engine/input';
import { play } from '../engine/sound';
import { spawnInterval, zombiesPerSpawner } from '../game/data';
import { LAYOUTS, LevelLayout } from '../game/levels';
import { PlayState, Screens } from '../game/play';
import { BarricadeStore } from '../game/props';
import { Stats, computeStats, freshSave } from '../game/save';
import { CampState } from './camp';
import { dawnUpkeep } from './upkeep';
import type { BotFriend } from '../game/bots';
import { Zombie } from '../game/zombie';
import { RESOURCES, describe } from './items';
import { storyArmoury } from './armoury';
import { MAX_GUARDS, Survivor, partnerStats } from './group';
import { Darkness, Light } from './lighting';
import { DoorDecals, Fog, Keyhole, NameTags, OpenDoorways, Prompt, Toasts } from './overlays';
import { currentNode, siteFor } from './city';
import { party } from './scavenge';
import { CityMapState } from './citymap';
import { DOOR_DECAL } from './templates';
import { DoorDef, PropDef, SiteDef } from './sites';
import { Sky, nightSkyFor } from './sky';
import { BaseState, baseFor, count, give, has, newBase, newStory, persistStory, story } from './storySave';
import type { CityNode } from './city';
import { Radio } from '../game/props';
import {
  DAWN_SECONDS, DAY_RATE, DAY_START, DUSK_SECONDS, DUSK_START, MOON_DARKNESS, MOON_LABEL, Moon, NIGHT_START, WAIT_RATE,
  clockText, moonFor,
} from './time';

/** Barricades keep their own health in the story save. */
const storyBarricades: BarricadeStore = {
  lvl: (s) => story.barricades[s].lvl,
  max: (s) => story.barricades[s].max,
  get: (s) => story.barricades[s].hp,
  set: (s, hp) => { story.barricades[s].hp = Math.max(0, hp); },
};

type Target = { kind: 'door'; def: DoorDef } | { kind: 'prop'; def: PropDef };

/** Holding S longer than this peeks instead of opening. */
const PEEK_DELAY = 0.3;
const PRY_TIME = 3;
const SEARCH_TIME = 1.2;
/** Seconds of flashlight use per battery. */
const BATTERY_SECONDS = 90;
/** Threat: per night survived here (+ more each night), per shot fired by day, prying boards, a quiet day. */
const THREAT_NIGHT = 18;
const THREAT_NIGHT_GROWTH = 4;
const THREAT_PER_SHOT = 0.15;
const THREAT_PRY = 3;
const THREAT_QUIET_DAY = -8;
/** Holding S at the radio this long by day means "move on". */
const LEAVE_HOLD = 2;
/** Seconds into a siege before the radio finds a new bearing and the way out opens. */
const SIEGE_HOLD = 35;
/** A scavenging run starts at 08:00; the place floods at dusk. */
const RUN_START = 8 * 60;
const RUN_WARNING = 17 * 60;
/** Barricades at a scavenging site are long broken. */
const brokenBarricades: BarricadeStore = { lvl: () => 0, max: () => 100, get: () => 0, set: () => {} };
/** The way out during a siege (and of a scavenging run): the street past the left barricade. */
const EXIT: [number, number, number, number] = [170, 360, 50, 72];

export class StoryState extends PlayState {
  private site: SiteDef;
  private base!: BaseState;
  private keyhole = new Keyhole();
  private toasts = new Toasts();
  private prompt = new Prompt();
  private hold: { target: Target; time: number; acted: boolean } | null = null;
  private action: { target: Target; time: number; done: () => void } | null = null;
  /** Seconds into the current dusk or dawn transition. */
  private phaseTime = 0;
  /** Fast-forwarding to dusk after using the radio. */
  private waiting = false;
  private lastShots = 0;
  private radioHold: number | null = null;
  private siege = false;
  private siegeTime = 0;
  private exitOpen = false;
  private flashlight = false;
  private batteryUse = 0;

  /** A scavenging run the player leads, at `run`. No radio to defend; head back before dusk. */
  private run: CityNode | null;
  private flooded = false;
  /** Zombies on a run hunt the player, so they follow this stand-in for the radio. */
  private bait: Radio | null = null;

  constructor(screens: Screens, run: CityNode | null = null) {
    super(screens);
    this.run = run;
    this.site = siteFor(run ?? currentNode());
    this.spawnsWave = false;
    this.playerStart = this.site.start;
    this.barricades = run ? brokenBarricades : storyBarricades;
    this.armoury = storyArmoury;
  }

  /** Who is standing guard in each partner slot this day. */
  private guards: (Survivor | null)[] = [];

  /** Story mode starts from base stats (Classic's skill purchases don't carry over). */
  protected playerStats(): Stats {
    const st = computeStats(freshSave());
    if (story.leaderHungry) st.player_accuracy *= 1.5;
    return st;
  }

  protected partners(st: Stats) {
    // On a run the scavengers come along; at home the guards stand watch.
    const g = (this.run ? party() : story.group.filter((s) => s.job === 'guard')).slice(0, MAX_GUARDS);
    // Keep a kind-1 guard in slot 1 and a kind-2 guard in slot 2 where possible.
    g.sort((a, b) => a.kind - b.kind);
    this.guards = [g[0] ?? null, g[1] ?? null];
    return this.guards.map((s) => (s ? { kind: s.kind, st: partnerStats(s, st) } : null));
  }

  /** Night N uses Classic wave N's size and spawn rate. */
  protected waveNumber() {
    return story.day;
  }

  private get moon(): Moon {
    return moonFor(story.day, story.moonOffset);
  }

  protected addSky() {
    this.add(new Sky(
      () => ({ phase: story.phase, t: this.phaseTime / (story.phase === 'dawn' ? DAWN_SECONDS : DUSK_SECONDS), moon: this.moon }),
      () => nightSkyFor(this.moon, story.day + story.moonOffset),
    ));
  }

  protected layoutFor(): LevelLayout {
    return LAYOUTS.find((l) => l.id === this.site.layout)!;
  }

  create() {
    if (this.run) {
      // A run spends the day away from home; nothing about this building is kept.
      this.base = newBase(this.site);
      story.phase = 'day';
      story.clock = RUN_START;
    } else this.base = baseFor(this.site);
    super.create();
    if (this.run) {
      this.radio.visible = false;
      this.radio.tag.hide();
      this.bait = new Radio(-500, -500);
      this.bait.health = 0;
      this.world.radio = this.bait;
    }
    // Guards carry their injuries; zombies can now reach them.
    this.slots().forEach(([f, s]) => {
      f.health = s.hp;
      this.world.targets.push(f);
    });
    this.add(this.toasts);
    this.add(this.keyhole);
    this.reveal();
    if (story.phase === 'night') this.startNight();
    else {
      // Reloading mid-dusk or mid-dawn just resumes the day or night either side of it.
      if (story.phase === 'dawn') this.finishDawn();
      else {
        if (story.phase === 'dusk') story.phase = 'day';
        this.armWanderers();
        if (this.run) {
          this.toasts.push(`Scavenging the ${this.site.name}. Grab what you can.`, 5);
          this.toasts.push('Head back by the street on the left (S) before dark.', 6);
        } else this.toasts.push(`Day ${story.day}. ${this.site.name}. ${clockText(story.clock)}.`);
        if (story.day === 1) this.toasts.push('S: open doors and search.  Hold S: peek through a keyhole.');
        const threat = this.base.threat ?? 0;
        if (threat >= 100) this.toasts.push('Threat is full: tonight this place will be overrun. Hold S at the radio to move on.', 7);
        else if (threat >= 70) this.toasts.push(`Threat ${Math.floor(threat)}%. Soon this place won't be safe. (Hold S at the radio to move on.)`, 6);
      }
    }
    persistStory();
  }

  private slots(): [BotFriend, Survivor][] {
    const out: [BotFriend, Survivor][] = [];
    if (this.guards[0]) out.push([this.friend1, this.guards[0]]);
    if (this.guards[1]) out.push([this.friend2, this.guards[1]]);
    return out;
  }

  /** Copy guards' health back to the group; a guard who fell is gone for good. */
  private syncGuards() {
    for (const [f, s] of this.slots()) {
      if (!story.group.includes(s)) continue;
      s.hp = Math.max(0, Math.round(f.health));
      if (f.dead || s.hp <= 0) {
        story.group = story.group.filter((x) => x !== s);
        story.fallen.push(s.name);
        this.toasts.push(`${s.name} is dead.`, 6);
        persistStory();
      }
    }
  }

  // --- Day and night -------------------------------------------------------------------------

  private addThreat(n: number) {
    if (this.run) return;
    this.base.threat = Math.max(0, Math.min(100, (this.base.threat ?? 0) + n));
  }

  /** Gunfire by day draws attention. */
  private updateNoise() {
    const shots = this.player.allBullet - this.lastShots;
    this.lastShots = this.player.allBullet;
    if (shots > 0 && story.phase === 'day') {
      this.base.dayShots = (this.base.dayShots ?? 0) + shots;
      this.addThreat(shots * THREAT_PER_SHOT);
    }
  }

  /** A few slow wanderers by day. */
  private armWanderers() {
    // Away from home there are more of them about.
    const danger = this.run?.danger ?? 0;
    for (const s of this.spawners) s.arm(this.run ? 3 + danger * 2 : 2, this.run ? 25 : 45, this.run ? 15 : 40);
  }

  /** Run clock: warning at 17:00, then at dusk the place floods. */
  private updateRun() {
    const before = story.clock;
    story.clock += G.elapsed * DAY_RATE;
    if (before < RUN_WARNING && story.clock >= RUN_WARNING) this.toasts.push('An hour of light left. Time to head back.', 5);
    if (!this.flooded && story.clock >= DUSK_START) {
      this.flooded = true;
      story.phase = 'dusk';
      this.phaseTime = 0;
      for (const s of this.spawners) s.arm(zombiesPerSpawner(this.waveNumber()) * 2, 1, 2);
      this.toasts.push("It's getting dark and they're pouring in. Get out!", 6);
    }
    if (this.flooded) this.phaseTime = Math.min(DUSK_SECONDS, this.phaseTime + G.elapsed);
    if (this.bait) {
      this.bait.x = this.player.x;
      this.bait.y = this.player.y - 32;
    }
  }

  private inExit() {
    const p = this.player;
    const [x, y, w, h] = EXIT;
    return !p.dead && p.x < x + w && p.x + p.width > x && p.y < y + h && p.y + p.height > y;
  }

  /** Back home at dusk with whatever was found. */
  private endRun() {
    this.syncGuards();
    for (const s of party()) s.job = 'rest';
    story.phase = 'day';
    story.clock = DUSK_START - 1;
    persistStory();
    const screens = this.screens;
    switchState(() => new StoryState(screens));
  }

  private startNight() {
    story.phase = 'night';
    this.waiting = false;
    const wave = this.waveNumber();
    this.radio.health = 100;
    this.radio.tag.set(100);
    if ((this.base.threat ?? 0) >= 100) {
      // Overrun: a flood from both sides that can't be held.
      this.siege = true;
      this.siegeTime = 0;
      for (const s of this.spawners) s.arm(zombiesPerSpawner(wave) * 3, 1, 3);
      this.toasts.push(`Night ${story.day}. They've found you. Hold on as long as you can.`, 6);
    } else {
      // Darker nights bring more of them.
      const n = Math.round(zombiesPerSpawner(wave) * (1 + MOON_DARKNESS[this.moon] * 0.4));
      for (const s of this.spawners) s.arm(n, spawnInterval(wave), 10);
      this.toasts.push(`Night ${story.day}, ${MOON_LABEL[this.moon]}. Protect the radio.`, 5);
    }
    persistStory();
  }

  /** Mid-siege: the radio picks up a new bearing and the way out opens past the left barricade. */
  private openExit(why: string) {
    if (this.exitOpen) return;
    this.exitOpen = true;
    this.toasts.push(why, 6);
    this.toasts.push('Run for the street on the left!', 6);
    // Break through our own barricade; stop the left side from refilling.
    this.left.health = 0;
    this.left.play('0');
    this.left.tag?.hide();
    this.blockLeft.exists = false;
    const left = this.spawners[0];
    left.limit = left.limit - left.remaining;
  }

  private updateSiege() {
    if (!this.siege) return;
    this.siegeTime += G.elapsed;
    if (this.siegeTime >= SIEGE_HOLD) this.openExit('The radio crackles: a new bearing!');
    if (this.radio.health <= 0) this.openExit('The radio is lost under them.');
    const p = this.player;
    if (this.exitOpen && !p.dead) {
      const [x, y, w, h] = EXIT;
      if (p.x < x + w && p.x + p.width > x && p.y < y + h && p.y + p.height > y) this.flee();
    }
  }

  private flee() {
    this.syncGuards();
    this.siege = false;
    persistStory();
    switchState(() => new CityMapState(this.screens, 'flee', () => new StoryState(this.screens)));
  }

  private leaveEarly() {
    this.syncGuards();
    persistStory();
    const back = () => new StoryState(this.screens);
    switchState(() => new CityMapState(this.screens, 'leave', back, back));
  }

  /** Overnight upkeep, then the camp screen; the next day starts from there. */
  private finishDawn() {
    this.syncGuards();
    story.report = dawnUpkeep();
    story.day++;
    story.phase = 'day';
    story.clock = DAY_START;
    persistStory();
    const screens = this.screens;
    switchState(() => new CampState(screens, () => new StoryState(screens)));
  }

  private nightOver(): boolean {
    return this.spawners.every((s) => s.remaining <= 0) && !this.zombies.members.some((z) => z.exists && !z.zombieDead);
  }

  // --- Light ---------------------------------------------------------------------------------

  /** 0 by day; at night set by the moon; ramps through dusk and dawn. */
  private darkness(): number {
    const night = MOON_DARKNESS[this.moon];
    switch (story.phase) {
      case 'day': return 0;
      case 'dusk': return night * Math.min(1, this.phaseTime / DUSK_SECONDS);
      case 'dawn': return night * Math.max(0, 1 - this.phaseTime / DAWN_SECONDS);
      default: return night;
    }
  }

  private lights(): Light[] {
    const out: Light[] = [];
    const p = this.player;
    const pcx = p.x + p.width / 2;
    const pcy = p.y + 10;
    if (!p.dead) {
      // Eyes adjust: a small pool of visibility around the player.
      out.push({ x: pcx, y: p.y + 16, radius: 30, intensity: 0.6 });
      if (this.flashlight) {
        const angle = Math.atan2(mouse.y - pcy, mouse.x - pcx);
        out.push({ x: pcx, y: pcy, radius: 210, intensity: 0.95, angle, spread: 0.38 });
      }
    }
    for (const f of [this.friend1, this.friend2]) out.push({ x: f.x + 8, y: f.y + 16, radius: 20, intensity: 0.45 });
    out.push({ x: this.radio.x + 18, y: this.radio.y + 20, radius: 26, intensity: 0.55 });
    if (this.exitOpen || this.run) out.push({ x: EXIT[0] + 20, y: 400, radius: 70, intensity: 0.8 });
    // Street lamps built at the barricades light the approach.
    (this.base.lamps ?? []).forEach((lit, i) => {
      if (!lit) return;
      const b = i === 0 ? this.left : this.right;
      out.push({ x: b.x + 15, y: b.y - 10, radius: 110, intensity: 0.85 });
    });
    for (const b of this.bullets.members) {
      if (!b.exists) continue;
      // Muzzle flash on the frames right after firing, then a faint tracer glow.
      if (b.age < 0.05) out.push({ x: b.x, y: b.y, radius: 56, intensity: 0.9 });
      else out.push({ x: b.x + 10, y: b.y, radius: 12, intensity: 0.5 });
    }
    return out;
  }

  private updateFlashlight() {
    if (keys.justPressed('L')) {
      if (this.flashlight) this.flashlight = false;
      else if (count('batteries') > 0) this.flashlight = true;
      else this.toasts.push('No batteries for the flashlight.');
    }
    if (!this.flashlight) return;
    this.batteryUse += G.elapsed;
    if (this.batteryUse >= BATTERY_SECONDS) {
      this.batteryUse = 0;
      story.items.batteries = Math.max(0, count('batteries') - 1);
      persistStory();
      if (count('batteries') === 0) {
        this.flashlight = false;
        this.toasts.push('The flashlight dies. No batteries left.');
      }
    }
  }

  private updateTime() {
    if (this.run) {
      this.updateRun();
      return;
    }
    const dt = G.elapsed;
    switch (story.phase) {
      case 'day': {
        const before = Math.floor(story.clock / 60);
        story.clock += dt * (this.waiting ? WAIT_RATE : DAY_RATE);
        if (Math.floor(story.clock / 60) !== before) persistStory();
        if (story.clock >= DUSK_START) {
          story.clock = DUSK_START;
          story.phase = 'dusk';
          this.phaseTime = 0;
          this.waiting = false;
          this.toasts.push((this.base.threat ?? 0) >= 100 ? 'Dusk. There are too many of them out there tonight.' : 'Dusk. Get ready.');
          if (!this.base.dayShots) {
            this.addThreat(THREAT_QUIET_DAY);
            this.toasts.push('A quiet day. Fewer of them know you are here.');
          }
          persistStory();
        }
        break;
      }
      case 'dusk':
        this.phaseTime += dt;
        story.clock = DUSK_START + (this.phaseTime / DUSK_SECONDS) * (NIGHT_START - DUSK_START);
        if (this.phaseTime >= DUSK_SECONDS) {
          story.clock = NIGHT_START;
          this.startNight();
        }
        break;
      case 'night':
        this.updateSiege();
        if (!this.siege && this.nightOver()) {
          story.phase = 'dawn';
          this.phaseTime = 0;
          this.toasts.push(`Dawn. You made it through night ${story.day}.`, 5);
          this.addThreat(THREAT_NIGHT + THREAT_NIGHT_GROWTH * (this.base.nights ?? 0));
          this.base.nights = (this.base.nights ?? 0) + 1;
          this.base.dayShots = 0;
          persistStory();
        }
        break;
      case 'dawn':
        this.phaseTime += dt;
        if (this.phaseTime >= DAWN_SECONDS) this.finishDawn();
        break;
    }
  }

  protected addWorldOverlays() {
    const doors = this.site.doors.map((d) => ({ rect: d.rect, isOpen: () => this.base.doors[d.id].state === 'open' }));
    this.add(new DoorDecals(this.site.doors.filter((d) => d.decal).map((d) => d.rect), DOOR_DECAL));
    this.add(new OpenDoorways(doors));
    this.add(new Fog(this.site.floors, (id) => this.base.revealed.includes(id)));
    this.add(new Darkness(() => this.darkness(), () => this.lights()));
    this.add(new NameTags(() => this.slots().filter(([f]) => !f.dead).map(([f, s]) => ({ x: f.x + 8, y: f.y - 14, text: `${s.name} ${Math.max(0, Math.round(f.health))}` }))));
    this.add(this.prompt);
  }

  // --- Interaction -------------------------------------------------------------------------

  private nearest(): Target | null {
    const p = this.player;
    if (p.dead) return null;
    const cx = p.x + p.width / 2;
    const cy = p.y + p.height / 2;
    const inside = ([x, y, w, h]: [number, number, number, number]) => cx >= x && cx < x + w && cy >= y - 8 && cy < y + h + 8;
    const door = this.site.doors.find((d) => inside(d.rect));
    if (door) return { kind: 'door', def: door };
    const prop = this.site.props.find((d) => inside(d.rect));
    return prop ? { kind: 'prop', def: prop } : null;
  }

  private nearRadio() {
    return !this.run && !this.player.dead && this.player.overlaps(this.radio);
  }

  protected handleUse(): boolean {
    if (this.run && this.inExit()) {
      this.endRun();
      return true;
    }
    if (story.phase === 'day' && this.nearRadio()) {
      this.radioHold = 0;
      return true;
    }
    const t = this.nearest();
    if (!t) return false;
    this.hold = { target: t, time: 0, acted: false };
    return true;
  }

  private doorState(d: DoorDef) {
    return this.base.doors[d.id];
  }

  private tap(t: Target) {
    if (t.kind === 'prop') {
      if (this.base.searched.includes(t.def.id)) this.toasts.push(`${t.def.name}: nothing else here.`);
      else this.search(t);
      return;
    }
    const d = t.def;
    const s = this.doorState(d);
    if (s.state === 'open') {
      if (s.searched) this.toasts.push(`${d.name}: already searched.`);
      else this.search(t);
    } else if (s.state === 'closed') this.openDoor(d);
    else if (s.state === 'locked') {
      if (d.key && has(`key:${d.key}`)) {
        this.toasts.push(`Unlocked the ${d.name.toLowerCase()} with the key.`);
        this.openDoor(d);
      } else this.toasts.push(`${d.name}: locked.${d.keyhole ? ' Hold S to peek.' : ''}`);
    } else if (s.state === 'boarded') this.toasts.push(`${d.name}: boarded up. Hold S to pry it open.`);
  }

  private openDoor(d: DoorDef) {
    const s = this.doorState(d);
    s.state = 'open';
    play('Shop_SndMenuClick');
    if (s.zombies > 0) {
      const [x, y, w, h] = d.rect;
      for (let i = 0; i < s.zombies; i++) {
        const z = new Zombie(x + w / 2 - 7 + i * 6, y + h - 32, this.world);
        // Stumbling out of the dark gives the player a moment to back off.
        z.stun = 1.2 + i * 0.4;
        z.px = z.x;
        z.py = z.y;
        this.zombies.add(z);
      }
      play('zombie1_SndGrow1');
      this.toasts.push(s.zombies > 1 ? `Zombies stumble out of the ${d.name.toLowerCase()}!` : `Something lurches out of the ${d.name.toLowerCase()}!`);
      s.zombies = 0;
    } else this.search({ kind: 'door', def: d });
    persistStory();
  }

  private search(t: Target) {
    this.action = {
      target: t,
      time: 0,
      done: () => {
        const def = t.def;
        const found = def.loot.map(describe).join(', ');
        for (const l of def.loot) give(l);
        if (t.kind === 'prop') this.base.searched.push(def.id);
        else this.doorState(t.def).searched = true;
        this.toasts.push(`${def.name}: found ${found || 'nothing'}.`);
        if (def.text) this.toasts.push(def.text, 5);
        play('Menu_SndMenuClick');
        persistStory();
      },
    };
  }

  private peekView(d: DoorDef) {
    const s = this.doorState(d);
    // A flashlight through the keyhole helps on dark nights.
    const dark = this.darkness() * (this.flashlight ? 0.3 : 1);
    return { zombies: s.zombies, items: s.searched ? 0 : d.loot.length, light: 1 - dark };
  }

  private updateRadio() {
    if (this.radioHold === null) return;
    if (story.phase !== 'day' || !this.nearRadio()) {
      this.radioHold = null;
      return;
    }
    if (keys.any('S', 'DOWN')) {
      this.radioHold += G.elapsed;
      if (this.radioHold >= LEAVE_HOLD) {
        this.radioHold = null;
        this.leaveEarly();
      }
    } else {
      if (this.radioHold < PEEK_DELAY) {
        this.waiting = !this.waiting;
        this.toasts.push(this.waiting ? 'Waiting for nightfall... (S again to stop)' : 'Stopped waiting.');
      }
      this.radioHold = null;
    }
  }

  private updateInteraction() {
    this.updateRadio();
    const near = this.nearest();
    const same = (a: Target | null, b: Target | null) => !!a && !!b && a.def === b.def;

    // An in-progress search: stay put until it finishes.
    if (this.action) {
      if (!same(near, this.action.target)) {
        this.toasts.push('Search interrupted.');
        this.action = null;
      } else {
        this.action.time += G.elapsed;
        if (this.action.time >= SEARCH_TIME) {
          const done = this.action.done;
          this.action = null;
          done();
        }
      }
    }

    const h = this.hold;
    if (h) {
      const held = keys.any('S', 'DOWN');
      if (!same(near, h.target)) this.endHold();
      else if (!held) {
        if (h.time < PEEK_DELAY && !h.acted) this.tap(h.target);
        this.endHold();
      } else {
        h.time += G.elapsed;
        if (h.target.kind === 'door' && !h.acted) {
          const d = h.target.def;
          const s = this.doorState(d);
          if (s.state === 'boarded') {
            if (h.time >= PRY_TIME) {
              h.acted = true;
              this.addThreat(THREAT_PRY);
              this.toasts.push(`Pried the boards off the ${d.name.toLowerCase()}.`);
              this.openDoor(d);
            }
          } else if ((s.state === 'closed' || s.state === 'locked') && h.time >= PEEK_DELAY) {
            if (d.keyhole) this.keyhole.show(this.peekView(d));
            else if (h.time - G.elapsed < PEEK_DELAY) this.toasts.push('No keyhole on this door.');
          }
        }
      }
    }

    // Prompt above the player.
    const p = this.player;
    this.prompt.x = p.x + p.width / 2;
    this.prompt.y = p.y;
    this.prompt.text = near && !this.keyhole.view ? this.promptFor(near)
      : story.phase === 'day' && this.nearRadio() ? (this.waiting ? 'Waiting... (S: stop)' : 'S: wait for night  Hold S: move on')
      : this.exitOpen && this.player.x < 330 ? 'Keep going!'
      : this.run && this.inExit() ? 'S: head back' : '';
    const boarded = h && h.target.kind === 'door' && this.doorState(h.target.def).state === 'boarded' && !h.acted;
    this.prompt.progress = this.action ? this.action.time / SEARCH_TIME : boarded ? h!.time / PRY_TIME
      : this.radioHold !== null && this.radioHold > PEEK_DELAY ? this.radioHold / LEAVE_HOLD : -1;
  }

  private promptFor(t: Target): string {
    if (this.action) return 'Searching...';
    if (t.kind === 'prop') return this.base.searched.includes(t.def.id) ? '' : `S: search ${t.def.name.toLowerCase()}`;
    const d = t.def;
    const s = this.doorState(d);
    if (s.state === 'open') return s.searched ? '' : 'S: search';
    if (s.state === 'boarded') return 'Hold S: pry open';
    const peek = d.keyhole ? '  (hold: peek)' : '';
    return s.state === 'locked' ? `Locked${peek}` : `S: open${peek}`;
  }

  private endHold() {
    this.hold = null;
    this.keyhole.hide();
  }

  private reveal() {
    const p = this.player;
    const cx = p.x + p.width / 2;
    const cy = p.y + p.height / 2;
    for (const f of this.site.floors) {
      const [x, y, w, h] = f.rect;
      if (cx >= x && cx < x + w && cy >= y && cy < y + h && !this.base.revealed.includes(f.id)) {
        this.base.revealed.push(f.id);
        persistStory();
      }
    }
  }

  // --- PlayState overrides -----------------------------------------------------------------

  update() {
    if (!this.paused) {
      this.updateInteraction();
      this.reveal();
      if (!this.fading) this.updateTime();
      this.updateFlashlight();
      this.updateNoise();
      this.syncGuards();
    }
    super.update();
  }

  protected updateHud() {
    super.updateHud();
    // Show the reserve for weapons that have one ("12 / 40"); the Glock never runs out.
    const p = this.player;
    const reserve = this.armoury.reserve(p.weaponNumber);
    if (p.health > 0 && reserve !== Infinity) {
      const [mag, hp] = this.ammoText.text.split('\n');
      this.ammoText.text = `${mag} / ${reserve}\n${hp}`;
    }
    const res = RESOURCES.map((r) => `${r.label} ${count(r.id)}`).join('   ');
    const when = this.run ? `Scavenging  ${clockText(story.clock)}`
      : story.phase === 'night' ? `Night ${story.day}, ${MOON_LABEL[this.moon]}`
      : story.phase === 'dawn' ? `Dawn after night ${story.day}`
      : `Day ${story.day}  ${clockText(story.clock)}`;
    this.hud.text = `${when}   ${this.site.name}   Threat ${Math.floor(this.base.threat ?? 0)}%      ${res}`;
  }

  protected checkEnd() {
    if (this.player.health <= 0 || (this.radio.health <= 0 && !this.siege)) {
      if (this.player.health <= 0 && !this.player.dead) this.player.kill();
      this.startFade();
      if (this.black.alpha > 0.95) {
        // Permadeath: the run is over.
        newStory();
        switchState(this.screens.menu);
      }
    }
    if (this.fading) this.black.alpha = Math.min(1, this.black.alpha + G.elapsed);
  }
}

CampState.makeRun = (screens, target) => new StoryState(screens, target);
