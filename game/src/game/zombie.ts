// zombie1.as + Spawner.as.

import { G, Group, LEFT, RIGHT, Sprite } from '../engine/core';
import { Emitter } from '../engine/emitter';
import { play } from '../engine/sound';
import { FAST_SKINS, FAST_SPEEDS, SLOW_SPEEDS } from './data';
import type { Player } from './player';
import type { Radio } from './props';

const pick = <T>(a: readonly T[]) => a[Math.floor(Math.random() * a.length)];

export interface World {
  player: Player;
  radio: Radio;
  doorsUp: Sprite[];
  /** Things zombies stop to attack: player and barricades. */
  targets: Sprite[];
  gibs: Emitter;
}

export class Zombie extends Sprite {
  zombieDead = false;
  /** Seconds before this zombie can move or attack (reboot: used for ones that come out of rooms). */
  stun = 0;
  private timer = 1;
  private attack = true;
  private deadTime = 60;
  private deadFix = false;
  private yy = 0;
  private targetX = 0;

  constructor(x: number, y: number, private w: World) {
    super(x, y);
    const skin = Math.floor(Math.random() * 18);
    this.loadGraphic(`zombie1_ImgZombie${String(skin).padStart(2, '0')}`, true, true, 17, 32);
    this.maxVelocity.x = pick(FAST_SKINS.has(skin) ? FAST_SPEEDS : SLOW_SPEEDS);
    this.acceleration.y = 400;
    this.drag.x = this.maxVelocity.x * 4;
    this.health = 100;
    this.width = 14;
    this.height = 32;
    this.addAnimation('walk', Array.from({ length: 24 }, (_, i) => i), this.maxVelocity.x / 2);
    this.addAnimation('attack', [24, 25, 26, 27], 5);
    this.addAnimation('stop', [28]);
    this.addAnimation('idle', [0]);
    const g = Math.floor(Math.random() * 50);
    if (g === 1) play('zombie1_SndGrow1');
    else if (g === 2) play('zombie1_SndGrow2');
    else if (g === 3) play('zombie1_SndGrow3', 0.5);
  }

  hurt(damage: number) {
    this.w.gibs.at(this);
    this.w.gibs.start(1, 3);
    super.hurt(damage);
  }

  kill() {
    if (this.zombieDead || this.dead) return;
    const s = Math.floor(Math.random() * 20);
    if (s === 1) play('zombie1_SndDie1');
    else if (s === 2) play('zombie1_SndDie2');
    else if (s === 3) play('zombie1_SndDie3', 0.5);
    this.zombieDead = true;
    this.w.gibs.at(this);
    this.w.gibs.start(4, 50);
    this.acceleration.x = 0;
    if (Math.random() < 0.5) {
      this.facing = LEFT;
      this.angle = 90;
      this.offset.y = -15;
    } else {
      this.facing = RIGHT;
      this.angle = 270;
      this.offset.y = -14;
    }
    this.yy = this.y;
    this.play('stop');
    this.y -= 11;
    this.solid = false;
  }

  update() {
    const { player, radio, doorsUp, targets } = this.w;
    if (!this.zombieDead && this.stun > 0) {
      this.stun -= G.elapsed;
      this.acceleration.x = 0;
      this.play('idle');
    } else if (!this.zombieDead) {
      if (this.timer > 0 && !this.attack) this.timer -= G.elapsed;
      else this.attack = true;

      const toPlayer = Math.hypot(player.x - this.x, player.y - this.y);
      if (toPlayer < 50) this.targetX = player.x;
      else if (radio.y <= this.y - 50) {
        // Below the radio: head for this floor's door, and climb when standing in it.
        for (const d of doorsUp) {
          if (d.y === this.y) {
            this.targetX = d.x;
            if (this.x > this.targetX - 5 && this.x < this.targetX + 5) {
              this.y -= 80;
              this.px = this.x; // teleport: don't interpolate or sweep
              this.py = this.y;
            }
          }
        }
      } else this.targetX = radio.x;

      const dx = this.x - this.targetX;
      this.acceleration.x = 0;
      if (dx < 0) {
        this.acceleration.x += this.drag.x;
        this.facing = RIGHT;
      } else if (dx > 0) {
        this.acceleration.x -= this.drag.x;
        this.facing = LEFT;
      }
      if (this.overlaps(radio) && radio.health > 0) {
        this.facing = radio.x < this.x ? LEFT : RIGHT;
        this.acceleration.x = 0;
        this.velocity.x = 0;
        if (this.attack) {
          this.attack = false;
          this.timer = 1;
          radio.hurt(1);
        }
      } else {
        for (const t of targets) {
          if (this.overlaps(t) && t.health > 0) {
            this.acceleration.x = 0;
            this.facing = t.x > this.x ? RIGHT : LEFT;
            if (this.attack) {
              this.attack = false;
              this.timer = 1;
              if (t === player) {
                t.hurt(8);
                this.w.gibs.at(t);
                this.w.gibs.start(4, 40);
              } else t.hurt(1);
            }
          }
        }
      }
      if (this.onFloor) this.play(this.velocity.x !== 0 ? 'walk' : 'attack');
    }

    if (this.y >= this.yy && this.zombieDead && !this.deadFix) {
      this.deadFix = true;
      this.acceleration.y = 0;
      this.maxVelocity.y = 0;
      this.fixed = true;
      this.y = this.yy;
    } else if (this.deadFix && this.deadTime > 0) {
      this.deadTime -= G.elapsed;
      if (this.deadTime < 1 && !this.flickering()) this.flicker(1);
    } else if (this.deadTime <= 0) {
      this.exists = false;
    }
    super.update();
  }
}

export class Spawner extends Sprite {
  private timer = Math.random() * 20;
  private spawned = 0;

  constructor(x: number, y: number, private zombies: Group<Zombie>, private world: World, public limit: number, public interval: number) {
    super(x, y);
    this.width = this.height = 16;
    this.visible = false;
    this.solid = false;
    this.moves = false;
  }

  hurt() {}

  /** Start a new batch: `limit` zombies, one every `interval` s, first after up to `firstDelay` s. */
  arm(limit: number, interval: number, firstDelay = 20) {
    this.limit = limit;
    this.interval = interval;
    this.spawned = 0;
    this.timer = Math.max(0, interval - Math.random() * firstDelay);
  }

  get remaining() { return this.limit - this.spawned; }

  update() {
    this.timer += G.elapsed;
    // The original truncated the interval to a uint.
    if (this.timer > Math.trunc(this.interval)) {
      this.timer = 0;
      if (this.spawned < this.limit) {
        const z = new Zombie(this.x + this.width / 2, this.y + this.height / 2, this.world);
        z.x -= z.width / 2;
        z.y -= z.height / 2;
        z.px = z.x;
        z.py = z.y;
        this.zombies.add(z);
        this.spawned++;
      }
    }
  }
}
