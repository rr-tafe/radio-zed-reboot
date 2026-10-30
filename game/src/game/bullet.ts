// Bullet.as. Note the original's velocity split: |vx| + |vy| = speed (Manhattan), so shots
// at 45° travel ~30% slower than horizontal ones. Kept on purpose — it is part of the feel.

import { G, Sprite } from '../engine/core';

export class Bullet extends Sprite {
  visibleTimer = 0;
  /** 1 = fired by the player, 2 = fired by a partner bot. */
  bulletInitial = 0;
  damage = 0;

  constructor() {
    super();
    this.loadGraphic('Bullet_ImgBullet', false, false, 21, 1);
    const alphas = [0.2, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, 1, 1];
    this.alpha = alphas[Math.floor(Math.random() * alphas.length)];
    this.exists = false;
    this.visible = false;
  }

  update() {
    if (this.visibleTimer > 0) this.visibleTimer -= G.elapsed;
    else this.visible = true;
    if (this.x < -10 || this.x > 2000 || this.y < -10 || this.y > 600) this.kill();
    if (!this.dead) super.update();
  }

  kill() {
    if (this.dead) return;
    this.velocity.x = this.velocity.y = 0;
    this.dead = true;
    this.solid = false;
    this.exists = false;
  }

  /** Bullet.shoot(fromX, fromY, toX, toY, speed, spread, damage, owner). */
  shoot(x1: number, y1: number, x2: number, y2: number, speed: number, spread: number, damage: number, owner: number) {
    if (Math.hypot(x2 - x1, y2 - y1) < 100) spread = 0;
    this.bulletInitial = owner;
    this.damage = damage;
    if (x1 < x2 && y1 < y2) {
      y2 -= spread;
      x2 += spread;
    } else if (x1 < x2 && y1 > y2) {
      y2 += spread;
    } else if (x1 > x2 && y1 > y2) {
      y2 += spread;
    } else {
      y2 += spread;
      x2 += spread;
    }
    y2 -= 10;

    const len = Math.hypot(x2 - x1, y2 - y1);
    let deg = (Math.asin(Math.abs(y2 - y1) / len) * 180) / Math.PI;
    if (x2 - x1 > 0) deg = y2 - y1 >= 0 ? deg : -deg;
    else deg = y2 - y1 < 0 ? deg : -deg;
    this.angle = deg;

    const ddx = Math.trunc(x1 - x2);
    const ddy = Math.trunc(y1 - y2);
    const ax = Math.abs(ddx);
    const ay = Math.abs(ddy);
    const vx = Math.floor((ax / (ax + ay)) * speed);
    const vy = Math.floor((ay / (ax + ay)) * speed);
    this.reset(x1, y1 + 15);
    this.solid = true;
    this.velocity.x = ddx > 0 ? -vx : vx;
    this.velocity.y = ddy <= 0 ? vy : -vy;
  }
}
