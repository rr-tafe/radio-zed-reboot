// FlxEmitter, as used for the blood gibs: a fixed pool of 1×1 particles that explode from a
// point, fall under gravity, collide with the level and vanish after `delay` seconds.

import { G, Group, Sprite } from './core';

export class Particle extends Sprite {
  life = 0;
  update() {
    this.life -= G.elapsed;
    if (this.life <= 0) {
      this.kill();
      return;
    }
    this.angularVelocityStep();
    super.update();
  }
  angularVelocity = 0;
  private angularVelocityStep() {
    this.angle += this.angularVelocity * G.elapsed;
  }
}

export class Emitter extends Group<Particle> {
  x = 0;
  y = 0;
  width = 0;
  height = 0;
  minVelocity = { x: -100, y: -100 };
  maxVelocity = { x: 100, y: 100 };
  minRotation = -360;
  maxRotation = 360;
  gravity = 400;
  delay = 0.1;
  quantity = 0;
  private next = 0;

  setXSpeed(min: number, max: number) { this.minVelocity.x = min; this.maxVelocity.x = max; }
  setYSpeed(min: number, max: number) { this.minVelocity.y = min; this.maxVelocity.y = max; }

  /** createSprites(graphic, quantity, bakedRotations, multiple, collide). */
  createSprites(graphic: string, quantity: number, collide: boolean) {
    for (let i = 0; i < quantity; i++) {
      const p = new Particle();
      p.loadGraphic(graphic, true, false, 1, 1);
      p.frame = Math.floor(Math.random() * p.frameCount);
      p.exists = false;
      p.solid = collide;
      this.add(p);
    }
  }

  at(o: { x: number; y: number; width: number; height: number }) {
    this.x = o.x + o.width / 2;
    this.y = o.y + o.height / 2;
  }

  /** FlxEmitter.start(explode=true, delay, quantity). */
  start(delay: number, quantity: number) {
    this.delay = delay;
    this.quantity = quantity;
    for (let i = 0; i < quantity; i++) this.emit();
  }

  private emit() {
    const p = this.members[this.next];
    this.next = (this.next + 1) % this.members.length;
    p.reset(this.x - (p.width >> 1) + Math.random() * this.width, this.y - (p.height >> 1) + Math.random() * this.height);
    p.visible = true;
    p.life = this.delay;
    p.velocity.x = this.minVelocity.x + Math.random() * (this.maxVelocity.x - this.minVelocity.x);
    p.velocity.y = this.minVelocity.y + Math.random() * (this.maxVelocity.y - this.minVelocity.y);
    p.acceleration.y = this.gravity;
    p.angularVelocity = this.minRotation + Math.random() * (this.maxRotation - this.minRotation);
    p.angle = 0;
  }
}
