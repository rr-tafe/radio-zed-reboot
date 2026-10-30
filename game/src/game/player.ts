// Player.as + PlayerArm.as.

import { G, LEFT, RIGHT, Sprite, getAngle, startQuake } from '../engine/core';
import { keys, mouse } from '../engine/input';
import { play } from '../engine/sound';
import { Bullet } from './bullet';
import { WEAPONS } from './data';
import { save, Stats } from './save';

export class PlayerArm extends Sprite {
  dist = 0;

  constructor() {
    super(100, 100);
    this.solid = false;
    this.moves = false;
  }

  setWeapon(i: number) {
    const w = WEAPONS[i];
    this.loadGraphic(w.arm, false, true, w.frameW, w.frameH);
    this.addAnimation('pew', [0, 1, 0], 20, false);
    this.facing = RIGHT;
  }

  /** Aim at the mouse. Also called at render time so aiming tracks the pointer every frame. */
  aim() {
    this.dist = Math.hypot(mouse.x - (this.x + 20), mouse.y - (this.y + 20));
    if (this.dist <= 5) {
      this.angle = 0;
      return;
    }
    const da = getAngle(mouse.x - 20 - this.x, mouse.y - 20 - this.y);
    if (mouse.x > this.x + 19) {
      this.facing = RIGHT;
      this.angle = da;
    } else {
      this.facing = LEFT;
      this.angle = 180 + da;
    }
  }

  update() {
    this.aim();
    super.update();
  }
}

/** Which weapons the player has and where reloads come from. */
export interface Armoury {
  owns(i: number): boolean;
  upgraded(i: number): boolean;
  /** Take up to n rounds for weapon i from the reserve; returns how many were given. */
  take(i: number, n: number): number;
  /** Rounds left in reserve for weapon i (Infinity = unlimited). */
  reserve(i: number): number;
}

/** The original: bought weapons, endless reloads. */
export const classicArmoury: Armoury = {
  owns: (i) => save.playerWeapons[i][0] === 2,
  upgraded: (i) => save.playerWeapons[i][1] === 2,
  take: (_i, n) => n,
  reserve: () => Infinity,
};

export class Player extends Sprite {
  maxHealth: number;
  weaponNumber = 0;
  weaponBullets: number[];
  bulletNumber = 0;
  holderReload = true;
  reloadTime = 0;
  reloadTimeMax = 0;
  attackDelay = 0;
  attackDelayMax = 0;
  bulletDamage = 0;
  shiftX1 = 0;
  shiftX2 = 0;
  shiftY1 = 0;
  allBullet = 0;
  private curBullet = 0;
  private posMark = true;
  private deadFix = false;
  private yy = 0;

  constructor(x: number, y: number, private bullets: Bullet[], readonly arm: PlayerArm, private st: Stats, readonly armoury: Armoury = classicArmoury) {
    super(x, y);
    // Weapons with a limited reserve start empty and load from it on first use.
    this.weaponBullets = WEAPONS.map((w, i) => (armoury.reserve(i) === Infinity ? w.mag : 0));
    this.loadGraphic('Player_ImgPlayer', true, true, 17, 32);
    this.maxVelocity.x = st.player_speed;
    this.acceleration.y = 400;
    this.drag.x = this.maxVelocity.x * 4;
    this.width = 14;
    this.height = 32;
    this.maxHealth = this.health = st.player_health;
    this.addAnimation('idle', [0], 0, false);
    this.addAnimation('walk', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 22, 25, 26], this.maxVelocity.x / 3);
    this.addAnimation('flail', [29], 5, false);
    this.addAnimation('jump', [27, 28, 29], 5, false);
    this.addAnimation('dead', [30]);
    this.selectWeapon(0);
  }

  get weapon() { return WEAPONS[this.weaponNumber]; }
  owns(i: number) { return this.armoury.owns(i); }

  /** Equip weapon i and load its stats (Player.OBF_191c). */
  selectWeapon(i: number) {
    this.weaponNumber = i;
    const w = WEAPONS[i];
    const upgraded = this.armoury.upgraded(i) ? 1 : 0;
    this.arm.setWeapon(i);
    this.holderReload = true;
    this.reloadTime = this.reloadTimeMax = w.reload * this.st.player_recharge;
    this.bulletNumber = this.weaponBullets[i];
    this.attackDelay = this.attackDelayMax = w.delay;
    this.bulletDamage = w.damage[upgraded] * this.st.player_damage;
    this.shiftX1 = w.shiftX1;
    this.shiftX2 = w.shiftX2;
    this.shiftY1 = w.shiftY1;
    if (this.weaponBullets[i] <= 0 && this.armoury.reserve(i) > 0) {
      this.holderReload = false;
      this.reloadTime = this.reloadTimeMax;
    }
  }

  cycleWeapon(dir: 1 | -1) {
    let i = this.weaponNumber;
    for (let n = 0; n < WEAPONS.length; n++) {
      i = (i + dir + WEAPONS.length) % WEAPONS.length;
      if (this.owns(i)) break;
    }
    this.selectWeapon(i);
  }

  kill() {
    if (this.dead) return;
    this.health = 0;
    this.arm.exists = false;
    this.dead = true;
    this.acceleration.x = 0;
    this.angle = this.facing === LEFT ? 90 : 270;
    this.offset.y = -15;
    this.play('dead');
    this.y -= 15;
  }

  update() {
    if (this.dead && !this.deadFix && this.y >= this.yy) {
      this.deadFix = true;
      this.acceleration.y = 0;
      this.maxVelocity.y = 0;
      this.fixed = true;
      this.y = this.yy;
    }
    if (!this.dead) {
      if (this.posMark) {
        this.posMark = false;
        this.facing = LEFT;
      } else {
        this.acceleration.x = 0;
        if (keys.any('A', 'LEFT') && this.x > 170) {
          this.facing = LEFT;
          this.acceleration.x -= this.drag.x;
        } else if (keys.any('D', 'RIGHT') && this.x < 900) {
          this.facing = RIGHT;
          this.acceleration.x += this.drag.x;
        }
        if (this.onFloor) {
          this.yy = this.y;
          if (keys.anyJust('UP', 'W', 'SPACE')) {
            this.velocity.y = -this.acceleration.y * 0.31;
            this.play('jump');
          } else if (this.velocity.x !== 0) this.play('walk');
          else this.play('idle');
        } else if (this.velocity.y >= 0) this.play('flail');
        else this.play('jump');
        this.facing = mouse.x >= this.x + 3 ? RIGHT : LEFT;
      }

      if (this.reloadTime > 0 && !this.holderReload) this.reloadTime -= G.elapsed;
      else if (this.reloadTime < 0 && !this.holderReload) {
        this.holderReload = true;
        // Rounds still in the magazine stay there; the rest come from the reserve. With an
        // unlimited reserve (Classic) this always fills the magazine, as the original did.
        const i = this.weaponNumber;
        const have = Math.max(0, this.weaponBullets[i]);
        this.bulletNumber = have + this.armoury.take(i, this.weapon.mag - have);
        this.weaponBullets[i] = this.bulletNumber;
      }
      if (this.attackDelay > 0) this.attackDelay -= G.elapsed;

      const canFire = this.holderReload && this.bulletNumber > 0 && this.attackDelay <= 0 && this.arm.dist > 5;
      const trigger = this.weapon.auto ? keys.pressed('MOUSE') : keys.justPressed('MOUSE');
      if (canFire && (trigger || keys.justPressed('MOUSE'))) this.fire();

      if (keys.justPressed('R') && this.holderReload && this.bulletNumber < this.weapon.mag && this.armoury.reserve(this.weaponNumber) > 0) {
        this.bulletNumber = 0;
        this.holderReload = false;
        this.reloadTime = this.reloadTimeMax;
      }
      const digits = ['ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE'];
      const d = digits.findIndex((k) => keys.justPressed(k));
      if (d >= 0 && this.owns(d)) this.selectWeapon(d);
      else if (keys.justPressed('Q') || mouse.wheel < 0) this.cycleWeapon(-1);
      else if (keys.justPressed('E') || mouse.wheel > 0) this.cycleWeapon(1);
    }

    super.update();
    this.placeArm();
  }

  placeArm() {
    this.arm.x = this.x + (this.facing !== LEFT ? this.shiftX2 : this.shiftX1);
    this.arm.y = this.y + this.shiftY1;
    this.facing = this.arm.facing !== LEFT ? RIGHT : LEFT;
  }

  private fire() {
    this.attackDelay = this.attackDelayMax;
    this.bulletNumber--;
    this.weaponBullets[this.weaponNumber]--;
    if (this.bulletNumber <= 0 && this.armoury.reserve(this.weaponNumber) > 0) {
      this.holderReload = false;
      this.reloadTime = this.reloadTimeMax;
    }
    let spread = Math.random() * this.st.player_accuracy;
    if (Math.random() > 0.5) spread = -spread;
    startQuake(0.005, 0.1);
    const b = this.bullets[this.curBullet];
    b.visibleTimer = 0.00001;
    b.visible = false;
    this.arm.play('pew', true);
    play(this.weapon.sound, this.weapon.volume);
    save.bulletShot[this.weaponNumber]++;
    b.shoot(Math.trunc(this.x), Math.trunc(this.y), mouse.x, mouse.y, 1100, spread, this.bulletDamage, 1);
    this.allBullet++;
    this.curBullet = (this.curBullet + 1) % this.bullets.length;
  }
}
