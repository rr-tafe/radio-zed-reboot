// Story mode at a base. Day: explore the building, open back rooms, peek through keyholes,
// search props, fend off a few wanderers. Dusk, then night: defend the radio against a wave
// sized by the night number and the moon. Dawn starts the next day. Built on PlayState so
// movement, shooting, partners and zombies behave exactly as in Classic.

import { G, switchState } from '../engine/core';
import { keys } from '../engine/input';
import { play } from '../engine/sound';
import { spawnInterval, zombiesPerSpawner } from '../game/data';
import { LAYOUTS, LevelLayout } from '../game/levels';
import { PlayState, Screens } from '../game/play';
import { BarricadeStore } from '../game/props';
import { Zombie } from '../game/zombie';
import { RESOURCES, describe } from './items';
import { Fog, Keyhole, OpenDoorways, Prompt, Toasts } from './overlays';
import { CORNER_SHOP, DoorDef, PropDef, SiteDef } from './sites';
import { Sky, nightSkyFor } from './sky';
import { BaseState, baseFor, count, give, has, newStory, persistStory, story } from './storySave';
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

export class StoryState extends PlayState {
  private site: SiteDef = CORNER_SHOP;
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

  constructor(screens: Screens) {
    super(screens);
    this.spawnsWave = false;
    this.playerStart = CORNER_SHOP.start;
    this.barricades = storyBarricades;
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
    this.base = baseFor(this.site);
    super.create();
    this.add(this.toasts);
    this.add(this.keyhole);
    this.reveal();
    if (story.phase === 'night') this.startNight();
    else {
      // Reloading mid-dusk or mid-dawn just resumes the day or night either side of it.
      if (story.phase === 'dawn') this.beginDay();
      else {
        if (story.phase === 'dusk') story.phase = 'day';
        this.armWanderers();
        this.toasts.push(`Day ${story.day}. ${this.site.name}. ${clockText(story.clock)}.`);
        if (story.day === 1) this.toasts.push('S: open doors and search.  Hold S: peek through a keyhole.');
      }
    }
    persistStory();
  }

  // --- Day and night -------------------------------------------------------------------------

  /** A few slow wanderers by day. */
  private armWanderers() {
    for (const s of this.spawners) s.arm(2, 45, 40);
  }

  private startNight() {
    story.phase = 'night';
    this.waiting = false;
    const wave = this.waveNumber();
    // Darker nights bring more of them.
    const n = Math.round(zombiesPerSpawner(wave) * (1 + MOON_DARKNESS[this.moon] * 0.4));
    for (const s of this.spawners) s.arm(n, spawnInterval(wave), 10);
    this.radio.health = 100;
    this.radio.tag.set(100);
    this.toasts.push(`Night ${story.day}, ${MOON_LABEL[this.moon]}. Protect the radio.`, 5);
    persistStory();
  }

  private beginDay() {
    if (story.phase === 'dawn') story.day++;
    story.phase = 'day';
    story.clock = DAY_START;
    this.phaseTime = 0;
    this.armWanderers();
    this.toasts.push(`Day ${story.day}. ${this.site.name}.`);
    persistStory();
  }

  private nightOver(): boolean {
    return this.spawners.every((s) => s.remaining <= 0) && !this.zombies.members.some((z) => z.exists && !z.zombieDead);
  }

  private updateTime() {
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
          this.toasts.push('Dusk. Get ready.');
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
        if (this.nightOver()) {
          story.phase = 'dawn';
          this.phaseTime = 0;
          this.toasts.push(`Dawn. You made it through night ${story.day}.`, 5);
          persistStory();
        }
        break;
      case 'dawn':
        this.phaseTime += dt;
        if (this.phaseTime >= DAWN_SECONDS) this.beginDay();
        break;
    }
  }

  protected addWorldOverlays() {
    const doors = this.site.doors.map((d) => ({ rect: d.rect, isOpen: () => this.base.doors[d.id].state === 'open' }));
    this.add(new OpenDoorways(doors));
    this.add(new Fog(this.site.floors, (id) => this.base.revealed.includes(id)));
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
    return !this.player.dead && this.player.overlaps(this.radio);
  }

  protected handleUse(): boolean {
    if (story.phase === 'day' && this.nearRadio()) {
      this.waiting = !this.waiting;
      this.toasts.push(this.waiting ? 'Waiting for nightfall... (S again to stop)' : 'Stopped waiting.');
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
    // Daylight for now; night and moon phases come with the day/night cycle.
    return { zombies: s.zombies, items: s.searched ? 0 : d.loot.length, light: 1 };
  }

  private updateInteraction() {
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
      : story.phase === 'day' && this.nearRadio() ? (this.waiting ? 'Waiting... (S: stop)' : 'S: wait for nightfall') : '';
    const boarded = h && h.target.kind === 'door' && this.doorState(h.target.def).state === 'boarded' && !h.acted;
    this.prompt.progress = this.action ? this.action.time / SEARCH_TIME : boarded ? h!.time / PRY_TIME : -1;
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
    }
    super.update();
  }

  protected updateHud() {
    super.updateHud();
    const res = RESOURCES.map((r) => `${r.label} ${count(r.id)}`).join('   ');
    const when = story.phase === 'night' ? `Night ${story.day}, ${MOON_LABEL[this.moon]}`
      : story.phase === 'dawn' ? `Dawn after night ${story.day}`
      : `Day ${story.day}  ${clockText(story.clock)}`;
    this.hud.text = `${when}   ${this.site.name}      ${res}`;
  }

  protected checkEnd() {
    if (this.player.health <= 0 || this.radio.health <= 0) {
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
