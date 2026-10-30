// BotFriend.as + BotArm.as: the two partners, Willson (AK) and Summer (SSG).

import { G, LEFT, RIGHT, Sprite, getAngle } from '../engine/core';
import { play } from '../engine/sound';
import { Bullet } from './bullet';
import { Stats } from './save';

export class BotArm extends Sprite {
  ddx = 0;
  ddy = 100;
  constructor(readonly botNumber: 1 | 2) {
    super(345, 707);
    if (botNumber === 2) this.loadGraphic('bot_arm_with_gun_ssg', false, true, 72, 57);
    else this.loadGraphic('bot_arm_with_gun_akm', false, true, 62, 50);
    this.solid = false;
    this.moves = false;
    this.addAnimation('pew', [0, 1, 0], 20, false);
  }
  update() {
    const da = getAngle(this.ddx - 20 - this.x, this.ddy - 20 - this.y);
    if (this.ddx > this.x + 15) {
      this.facing = RIGHT;
      this.angle = da;
    } else {
      this.facing = LEFT;
      this.angle = 180 + da;
    }
    super.update();
  }
}

export class BotFriend extends Sprite {
  /** Zombies hit people for 8 (barricades take 1). */
  readonly isPerson = true;
  thisDef: number;
  private shiftX1: number;
  private shiftX2: number;
  private shiftY1: number;
  private holderReload = false;
  private reloadTime = 5;
  private reloadTimeMax = 5;
  private bulletNumber: number;
  private bulletNumberMax: number;
  private attackDelay: number;
  private attackDelayMax: number;
  private bulletDamage: number;
  private dispersion: number;
  private curBullet = 0;

  constructor(
    x: number, y: number,
    private bullets: Bullet[],
    readonly arm: BotArm,
    readonly number: 1 | 2,
    st: Stats,
    readonly leftDef = 393,
    readonly rightDef = 666,
  ) {
    super(x, y);
    this.thisDef = leftDef;
    this.health = 100;
    if (number === 1) {
      this.loadGraphic('Bot_friend_ImgBot1', true, true, 17, 32);
      this.shiftX1 = -22; this.shiftX2 = -23; this.shiftY1 = -11;
      this.bulletNumber = this.bulletNumberMax = 30;
      this.attackDelay = this.attackDelayMax = 0.2;
      this.bulletDamage = st.bot1_damage;
      this.dispersion = st.bot1_accuracy;
      this.maxVelocity.x = st.bot1_speed;
    } else {
      this.loadGraphic('Bot_friend_ImgBot2', true, true, 17, 32);
      this.shiftX1 = -27; this.shiftX2 = -28; this.shiftY1 = -14;
      this.bulletNumber = this.bulletNumberMax = 6;
      this.attackDelay = this.attackDelayMax = 1;
      this.bulletDamage = st.bot2_damage;
      this.dispersion = st.bot2_accuracy;
      this.maxVelocity.x = st.bot2_speed;
    }
    this.acceleration.y = 400;
    this.drag.x = 1000;
    this.addAnimation('walk', Array.from({ length: 24 }, (_, i) => i), this.maxVelocity.x / 2);
    this.addAnimation('idle', [0], 0);
  }

  shoot(tx: number, ty: number) {
    if (this.dead || !this.holderReload || this.attackDelay > 0) return;
    this.arm.ddx = tx;
    this.arm.ddy = ty;
    this.attackDelay = this.attackDelayMax;
    if (--this.bulletNumber <= 0) {
      this.holderReload = false;
      this.reloadTime = this.reloadTimeMax;
    }
    let spread = Math.random() * this.dispersion;
    if (Math.random() > 0.5) spread = -spread;
    const b = this.bullets[this.curBullet];
    b.visibleTimer = 0.001;
    b.visible = false;
    this.arm.play('pew', true);
    play(this.number === 2 ? 'Bot_friend_SndSvg' : 'Bot_friend_SndAk', 0.5);
    b.shoot(Math.trunc(this.x), Math.trunc(this.y), tx, ty, 1100, spread, this.bulletDamage, 2);
    this.curBullet = (this.curBullet + 1) % this.bullets.length;
  }

  /** The original's partners could never be hurt; in story mode they can die. */
  kill() {
    if (this.dead) return;
    this.dead = true;
    this.health = 0;
    this.arm.exists = false;
    this.acceleration.x = 0;
    this.velocity.x = 0;
    this.angle = this.facing === LEFT ? 90 : 270;
    this.offset.y = -15;
    this.play('idle');
  }

  update() {
    if (this.dead) {
      super.update();
      return;
    }
    const dx = Math.abs(this.x - this.thisDef);
    this.acceleration.x = 0;
    if (this.x < this.thisDef && dx > 5) {
      this.acceleration.x += this.drag.x;
      this.facing = RIGHT;
    } else if (this.x > this.thisDef && dx > 5) {
      this.acceleration.x -= this.drag.x;
      this.facing = LEFT;
    }
    if (this.acceleration.x > 0) {
      this.arm.ddx = this.x + 100;
      this.arm.ddy = this.y + 5;
    } else if (this.acceleration.x < 0) {
      this.arm.ddx = this.x - 100;
      this.arm.ddy = this.y + 5;
    }
    this.play(this.velocity.x !== 0 ? 'walk' : 'idle');
    if (this.reloadTime > 0 && !this.holderReload) this.reloadTime -= G.elapsed;
    else if (this.reloadTime < 0 && !this.holderReload) {
      this.holderReload = true;
      this.bulletNumber = this.bulletNumberMax;
    }
    if (this.attackDelay > 0) this.attackDelay -= G.elapsed;
    super.update();
    this.arm.x = this.x + (this.facing === LEFT ? this.shiftX1 : this.shiftX2);
    this.arm.y = this.y + this.shiftY1;
  }
}
