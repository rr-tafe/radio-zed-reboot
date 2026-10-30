// PlayLvl.as: one wave of the defence.

import { Button } from '../engine/button';
import { G, Group, Sprite, State, Text, switchState } from '../engine/core';
import { Emitter } from '../engine/emitter';
import { keys } from '../engine/input';
import { Tilemap, collideStatic } from '../engine/physics';
import { play as playSound } from '../engine/sound';
import { BotArm, BotFriend } from './bots';
import { Bullet } from './bullet';
import { FINAL_WAVE, TEXT_COLOR, TEXT_SHADOW, spawnInterval, zombiesPerSpawner } from './data';
import { LevelLayout, layoutForWave } from './levels';
import { Player, PlayerArm } from './player';
import { Barricade, Block, Cursor, Radio, Zone } from './props';
import { persist, save, stats } from './save';
import { Spawner, World, Zombie } from './zombie';
import { checkAchievements } from './achievements';

export interface Screens {
  menu: () => State;
  afterWave: () => State;
  gameOver: (score: number) => State;
  win: () => State;
}

export class PlayState extends State {
  /** Gameplay states may widen the view beyond 640 px on wide screens. */
  readonly wide = true;

  private map!: Tilemap;
  private player!: Player;
  private arm!: PlayerArm;
  private radio!: Radio;
  private friend1!: BotFriend;
  private friend2!: BotFriend;
  private left!: Barricade;
  private right!: Barricade;
  private blockLeft!: Block;
  private blockRight!: Block;
  private cursor!: Cursor;
  private gibs!: Emitter;
  private zombies = new Group<Zombie>();
  private bullets = new Group<Bullet>();
  private blocks: Sprite[] = [];
  private bulletBlocks: Sprite[] = [];
  private spawners: Spawner[] = [];
  private doorsUp: Zone[] = [];
  private doorsDown: Zone[] = [];
  private markers!: Record<'one' | 'two' | 'left' | 'right', Zone>;
  private hud!: Text;
  private ammoText!: Text;
  private playerGUI!: Sprite;
  private weaponGui!: Sprite;
  private black!: Sprite;
  private fading = false;
  private paused = false;
  private pauseUi: (Sprite | Text)[] = [];

  private zombiesLeft = 0;
  private scoreOnLvl = 0;
  private moneyOnLvl = 0;
  private killsOnLvl = 0;
  private headShots = 0;
  private bulletHit = 0;
  private botPosition = 0;
  private tempLeft = 0;
  private tempRight = 0;

  constructor(private screens: Screens) {
    super();
  }

  create() {
    const st = stats();
    const wave = save.lvl;
    const L: LevelLayout = layoutForWave(wave);
    this.tempLeft = save.leftBarricade;
    this.tempRight = save.rightBarricade;

    // Sky. The original picks 0–4 and maps both 1 and 2 to SpaceMoon2 (SpaceMoon1 is unused).
    const sky = ['playLvl_ImgSpaceMoon', 'playLvl_ImgSpaceMoon2', 'playLvl_ImgSpaceMoon2', 'playLvl_ImgSpaceMoon3', 'playLvl_ImgSpaceMoon4'];
    const space = this.add(new Sprite(0, 0, sky[Math.floor(Math.random() * 5)]));
    space.scrollFactor = { x: 0, y: 0 };
    this.parallax('playLvl_ImgCityBack', 0, 336, 0.1);
    this.parallax('playLvl_ImgCityBack2', 100, 316, 0.3);
    this.parallax('playLvl_ImgCityBack3', 0, 336, 0.4);
    if (wave === 1 || wave === 2) this.add(new Sprite(580, 66, 'playLvl_ImgHelp')).moves = false;
    this.add(new Sprite(0, 0, L.backdrop)).moves = false;

    this.zombiesLeft = zombiesPerSpawner(wave) * 2;
    this.gibs = new Emitter();
    this.gibs.setXSpeed(-30, 30);
    this.gibs.setYSpeed(-200, 0);
    this.gibs.createSprites('Bot_friend_ImgGibs', 170, true);

    for (const [x, y] of L.doors) {
      this.doorsUp.push(new Zone(x, y, 20, 32));
      this.doorsDown.push(new Zone(x, y - 80, 20, 32));
    }
    const mk = (r: [number, number, number, number], n: string) => new Zone(r[0], r[1], r[2], r[3], n);
    this.markers = { one: mk(L.markers.one, 'one'), two: mk(L.markers.two, 'two'), left: mk(L.markers.left, 'left'), right: mk(L.markers.right, 'right') };

    for (let i = 0; i < 100; i++) this.bullets.add(new Bullet());
    const bulletList = this.bullets.members;

    const arm1 = new BotArm(1);
    const arm2 = new BotArm(2);
    this.friend1 = new BotFriend(496, L.bots.y1, bulletList, arm1, 1, st, ...(L.bots.defs1 ?? [393, 666]) as [number, number]);
    this.friend2 = new BotFriend(496, L.bots.y2, bulletList, arm2, 2, st, ...(L.bots.defs2 ?? [393, 666]) as [number, number]);
    this.friend1.thisDef = this.friend1.leftDef;
    this.friend2.thisDef = this.friend2.rightDef;

    this.arm = new PlayerArm();
    this.player = new Player(556, 315, bulletList, this.arm, st);

    this.weaponGui = new Sprite(1, 20);
    this.weaponGui.loadGraphic('Player_weaponGui', true, false, 45, 15);
    this.weaponGui.scrollFactor = { x: 0, y: 0 };
    this.weaponGui.moves = false;
    this.add(this.weaponGui);

    this.left = new Barricade(L.barricades[0], 397, 0);
    this.right = new Barricade(L.barricades[1], 397, 1);
    this.right.facing = 0;
    this.add(this.left);
    if (this.left.tag) { this.add(this.left.tag.icon); this.add(this.left.tag.label); }
    this.add(this.right);
    if (this.right.tag) { this.add(this.right.tag.icon); this.add(this.right.tag.label); }
    this.blockLeft = new Block(this.left.x + 6, 417);
    this.blockRight = new Block(this.right.x, 417);
    if (this.left.health <= 0) this.blockLeft.exists = false;
    if (this.right.health <= 0) this.blockRight.exists = false;
    this.blocks.push(this.blockLeft, this.blockRight);

    this.radio = new Radio(L.radio[0], L.radio[1]);
    this.add(this.radio.tag.icon);
    this.add(this.radio.tag.label);
    this.add(this.radio);

    G.follow = { target: this.player, lerp: 1, leadX: 0.1, leadY: 0, minX: 30, maxX: 1055 };
    G.scroll.x = G.scroll.y = 0;
    this.map = Tilemap.fromPng(L.collision, 2);

    for (const r of L.bulletBlocks) this.bulletBlocks.push(new Zone(r[0], r[1], r[2], r[3]));
    this.bulletBlocks.push(this.blockLeft, this.blockRight);

    const world: World = { player: this.player, radio: this.radio, doorsUp: this.doorsUp, targets: [this.player, this.left, this.right], gibs: this.gibs };
    const interval = spawnInterval(wave);
    for (const x of [1, 1051]) {
      const s = new Spawner(x, 400, this.zombies, world, zombiesPerSpawner(wave), interval);
      this.spawners.push(s);
      this.add(s);
    }

    this.add(this.gibs);
    this.add(this.zombies);
    this.add(this.bullets);
    this.add(this.friend1);
    this.add(arm1);
    this.add(this.friend2);
    this.add(arm2);
    this.add(this.player);
    this.add(this.arm);

    this.hud = this.add(new Text(17, 4, 600).setFormat(8, TEXT_COLOR, 'left', TEXT_SHADOW));
    this.hud.scrollFactor = { x: 0, y: 0 };
    this.ammoText = this.add(new Text(0, 0, 200).setFormat(8, TEXT_COLOR));
    const logo = this.add(new Sprite(5, 5, 'playLvl_Imglogo'));
    logo.scrollFactor = { x: 0, y: 0 };
    logo.moves = false;
    this.playerGUI = this.add(new Sprite(0, 0, 'playLvl_ImgPlayerGUI'));
    this.playerGUI.moves = false;
    this.cursor = this.add(new Cursor(this.player));

    this.black = this.add(new Sprite(0, 0));
    this.black.scrollFactor = { x: 0, y: 0 };
    this.black.alpha = 0;
    this.black.moves = false;
    this.updateHud();
  }

  private parallax(name: string, x: number, y: number, f: number) {
    const s = this.add(new Sprite(x, y, name));
    s.scrollFactor = { x: f, y: f };
    s.moves = false;
    s.solid = false;
  }

  /** Per-render hook: keep aim and crosshair glued to the real pointer between ticks. */
  onRender() {
    if (this.paused) return;
    this.cursor.track();
    if (!this.player.dead) {
      this.arm.aim();
      this.player.placeArm();
    }
  }

  update() {
    if (keys.justPressed('ESCAPE')) this.togglePause();
    if (this.paused) {
      for (const u of this.pauseUi) u.update();
      return;
    }

    // Dev-server only: "\" clears the wave, for testing transitions.
    if (import.meta.env.DEV && keys.justPressed('BACKSLASH')) this.zombiesLeft = 0;
    if (keys.justPressed('F')) this.cycleBots();
    const p = this.player;
    if (keys.anyJust('DOWN', 'S')) {
      if (this.doorsUp.some((d) => p.overlaps(d))) this.teleport(-81);
      else if (this.doorsDown.some((d) => p.overlaps(d))) this.teleport(79);
    }

    this.weaponGui.frame = p.weaponNumber;
    super.update();

    // FlxU.collide(_blocks, _objects)
    const solids = this.blocks;
    collideStatic(p, this.map, solids);
    collideStatic(this.friend1, this.map, solids);
    collideStatic(this.friend2, this.map, solids);
    for (const z of this.zombies.members) collideStatic(z, this.map, solids);
    for (const g of this.gibs.members) if (g.exists) collideStatic(g, this.map, solids);

    this.bulletOverlaps();
    this.botTargeting();
    this.zombies.prune();

    if (this.left.health <= 0 && this.blockLeft.exists) this.blockLeft.exists = false;
    else if (this.right.health <= 0 && this.blockRight.exists) this.blockRight.exists = false;

    this.updateHud();
    this.checkEnd();
  }

  private teleport(dy: number) {
    this.player.y += dy;
    this.player.py = this.player.y;
  }

  private cycleBots() {
    this.botPosition = (this.botPosition + 1) % 3;
    const [f1, f2] = [this.friend1, this.friend2];
    if (this.botPosition === 0) { f1.thisDef = f1.leftDef; f2.thisDef = f2.rightDef; }
    else if (this.botPosition === 1) { f1.thisDef = f1.leftDef; f2.thisDef = f2.leftDef; }
    else { f1.thisDef = f1.rightDef; f2.thisDef = f2.rightDef; }
  }

  private bulletOverlaps() {
    const st = stats();
    for (const b of this.bullets.members) {
      if (!b.exists || !b.solid) continue;
      // Bullets vs enemies (zombies and the spawner pads).
      let hit = false;
      for (const s of this.spawners) {
        if (b.overlaps(s)) { b.kill(); hit = true; break; }
      }
      if (hit) continue;
      for (const z of this.zombies.members) {
        if (!z.exists || z.health <= 0 || !b.overlaps(z)) continue;
        if (b.bulletInitial === 1) this.bulletHit++;
        b.kill();
        z.acceleration.x = 0;
        const head = b.y > z.y && b.y - 7 < z.y && b.bulletInitial === 1;
        if (head) {
          z.hurt(b.damage * st.player_zHunter);
          this.headShots++;
        } else z.hurt(b.damage);
        if (z.health <= 0) {
          this.zombiesLeft--;
          this.scoreOnLvl += 100;
          this.killsOnLvl++;
          this.moneyOnLvl += Math.floor(Math.random() * 20) + st.player_luck;
        }
        hit = true;
        break;
      }
      if (hit) continue;
      // Bullets vs floors/walls/ground/barricade blocks.
      for (const k of this.bulletBlocks) {
        if (k.exists && b.overlaps(k)) { b.kill(); break; }
      }
    }
  }

  private botTargeting() {
    const { one, two, left, right } = this.markers;
    const [f1, f2] = [this.friend1, this.friend2];
    for (const m of [one, two, left, right]) {
      for (const z of this.zombies.members) {
        if (!z.exists || z.health <= 0 || !m.overlaps(z)) continue;
        if (f1.acceleration.x === 0 && (m === one || (f1.thisDef === f1.leftDef && m === left) || (f1.thisDef === f1.rightDef && m === right))) {
          f1.facing = f1.arm.facing;
          f1.shoot(z.x, z.y);
        }
        if (f2.acceleration.x === 0 && (m === two || (f2.thisDef === f2.leftDef && m === left) || (f2.thisDef === f2.rightDef && m === right))) {
          f2.facing = f2.arm.facing;
          f2.shoot(z.x, z.y);
        }
      }
    }
  }

  private updateHud() {
    const p = this.player;
    this.hud.text = `Wave: ${save.lvl}   Score: ${save.score + this.scoreOnLvl}   Money: ${save.money + this.moneyOnLvl}`;
    if (p.health > 0) {
      this.ammoText.x = p.x + 5;
      this.ammoText.y = p.y - 20;
      this.playerGUI.x = this.playerGUI.px = p.x - 4;
      this.playerGUI.y = this.playerGUI.py = p.y - 17;
      this.ammoText.text = (p.bulletNumber <= 0 ? 'Reloading... ' : String(p.bulletNumber)) + '\n' + String(p.health);
    } else {
      this.ammoText.exists = false;
      this.playerGUI.exists = false;
    }
  }

  private checkEnd() {
    if (this.player.health <= 0 || this.radio.health <= 0) {
      if (this.player.health <= 0 && !this.player.dead) this.player.kill();
      save.leftBarricade = this.tempLeft;
      save.rightBarricade = this.tempRight;
      this.startFade();
      if (this.black.alpha > 0.95) {
        save.archivement[4][3] = 1; // "Just die..."
        persist();
        const score = save.score + this.scoreOnLvl;
        switchState(() => this.screens.gameOver(score));
      }
    } else if (this.zombiesLeft <= 0) {
      this.startFade();
      if (this.black.alpha > 0.95) {
        save.sp += stats().specialPoints;
        save.money += this.moneyOnLvl;
        save.bulletMiss = this.player.allBullet - this.bulletHit;
        save.bulletHit += this.bulletHit;
        save.headShoot += this.headShots;
        save.score += this.scoreOnLvl;
        save.zombieKilled += this.killsOnLvl;
        save.moneyEarned += this.moneyOnLvl;
        if (save.lvl > save.maxLvl) save.maxLvl = save.lvl;
        checkAchievements();
        if (save.lvl >= FINAL_WAVE) {
          persist();
          switchState(this.screens.win);
        } else {
          save.lvl++;
          persist();
          switchState(this.screens.afterWave);
        }
      }
    }
    if (this.fading) this.black.alpha = Math.min(1, this.black.alpha + G.elapsed);
  }

  private startFade() {
    if (this.fading) return;
    this.fading = true;
    playSound('blackScreen_SndFail');
  }

  private togglePause() {
    this.paused = !this.paused;
    for (const u of this.pauseUi) this.root.remove(u);
    this.pauseUi = [];
    if (!this.paused) return;
    // "Return in to main menu?" dialog from PlayLvl.update (the original kept the game running
    // underneath; the reboot pauses it).
    const cx = (G.width - 640) / 2;
    const dialog = new Sprite(cx + 235, 222, 'playLvl_Img_dialog');
    dialog.scrollFactor = { x: 0, y: 0 };
    dialog.moves = false;
    const q = new Text(cx + 243, 225, 200, '     Return in to main menu?').setFormat(8, 11052705, 'left', TEXT_SHADOW);
    const opts = new Text(cx + 259, 242, 200, 'Return                  Cancel').setFormat(8, TEXT_COLOR, 'left', TEXT_SHADOW);
    q.scrollFactor = opts.scrollFactor = { x: 0, y: 0 };
    const ret = new Button(cx + 238, 241, 'playLvl_Img_dialog_button', 'playLvl_Img_dialog_button', () => {
      save.leftBarricade = this.tempLeft;
      save.rightBarricade = this.tempRight;
      persist();
      switchState(this.screens.menu);
    }).setOffAlpha(0);
    const cancel = new Button(cx + 323, 241, 'playLvl_Img_dialog_button', 'playLvl_Img_dialog_button', () => this.togglePause()).setOffAlpha(0);
    this.pauseUi = [dialog, q, opts, ret, cancel];
    for (const u of this.pauseUi) this.root.add(u);
  }

  /** Bring the black fade layer to the window size each frame (wide views). */
  draw(ctx: CanvasRenderingContext2D, alpha: number) {
    super.draw(ctx, alpha);
    if (this.black.alpha > 0) {
      ctx.globalAlpha = this.black.alpha;
      ctx.fillStyle = '#000';
      ctx.fillRect(0, 0, G.width, G.height);
      ctx.globalAlpha = 1;
    }
  }
}
