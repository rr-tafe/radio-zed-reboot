// A small re-implementation of the parts of Flixel 2.23 that Radio Zed uses. Names and
// semantics follow the original (FlxObject/FlxSprite/FlxGroup/FlxG) so the game code can be
// ported line-by-line from source_recovered/.

import { img } from './assets';

export const LEFT = 0;
export const RIGHT = 1;

/** Global game state, the equivalent of FlxG. */
export const G = {
  /** Logic step in seconds. The original used the real frame time capped at 1/30 s. */
  elapsed: 1 / 60,
  /** Width/height of the visible game view in game pixels. Height is always 480. */
  width: 640,
  height: 480,
  scroll: { x: 0, y: 0 },
  quake: { intensity: 0, timer: 0, x: 0, y: 0 },
  follow: null as null | {
    target: Sprite;
    lerp: number;
    leadX: number;
    leadY: number;
    minX: number; // world-space camera bounds, as passed to followBounds()
    maxX: number;
  },
  state: null as null | State,
  nextState: null as null | (() => State),
};

export function startQuake(intensity: number, duration: number) {
  G.quake.intensity = intensity;
  G.quake.timer = duration;
}

export function switchState(make: () => State) {
  G.nextState = make;
}

/** FlxG.doFollow: lerped camera with look-ahead, clamped to the follow bounds. */
export function updateCamera() {
  const f = G.follow;
  if (f) {
    const t = f.target;
    const tx = (G.width >> 1) - t.x - (t.width >> 1) + t.offset.x - t.velocity.x * f.leadX;
    const ty = (G.height >> 1) - t.y - (t.height >> 1) + t.offset.y - t.velocity.y * f.leadY;
    G.scroll.x += (tx - G.scroll.x) * f.lerp * G.elapsed;
    G.scroll.y += (ty - G.scroll.y) * f.lerp * G.elapsed;
    const hi = -f.minX;
    const lo = Math.min(hi, -f.maxX + G.width);
    if (G.scroll.x > hi) G.scroll.x = hi;
    if (G.scroll.x < lo) G.scroll.x = lo;
    if (G.scroll.y > 0) G.scroll.y = 0;
    if (G.scroll.y < 0) G.scroll.y = 0;
  }
  const q = G.quake;
  if (q.timer > 0) {
    q.timer -= G.elapsed;
    q.x = (Math.random() * q.intensity * G.width * 2 - q.intensity * G.width) | 0;
    q.y = (Math.random() * q.intensity * G.height * 2 - q.intensity * G.height) | 0;
  } else {
    q.x = q.y = 0;
  }
}

/** Flixel 2 FlxU.computeVelocity. */
export function computeVelocity(v: number, accel: number, drag: number, max: number): number {
  if (accel !== 0) v += accel * G.elapsed;
  else if (drag !== 0) {
    const d = drag * G.elapsed;
    if (v - d > 0) v -= d;
    else if (v + d < 0) v += d;
    else v = 0;
  }
  if (v !== 0 && max !== 10000) {
    if (v > max) v = max;
    else if (v < -max) v = -max;
  }
  return v;
}

export function getAngle(dx: number, dy: number): number {
  return (Math.atan2(dy, dx) * 180) / Math.PI;
}

export interface Drawable {
  exists: boolean;
  visible: boolean;
  active: boolean;
  update(): void;
  draw(ctx: CanvasRenderingContext2D): void;
}

interface Anim { frames: number[]; delay: number; looped: boolean }

export class Sprite implements Drawable {
  x: number;
  y: number;
  width = 0;
  height = 0;
  /** Previous-tick position, used to interpolate rendering between logic ticks. */
  px: number;
  py: number;
  offset = { x: 0, y: 0 };
  velocity = { x: 0, y: 0 };
  acceleration = { x: 0, y: 0 };
  drag = { x: 0, y: 0 };
  maxVelocity = { x: 10000, y: 10000 };
  scrollFactor = { x: 1, y: 1 };
  scale = { x: 1, y: 1 };
  angle = 0;
  alpha = 1;
  facing = RIGHT;
  health = 1;
  exists = true;
  visible = true;
  active = true;
  dead = false;
  solid = true;
  fixed = false;
  moves = true;
  onFloor = false;
  collideLeft = true;
  collideRight = true;
  collideTop = true;
  collideBottom = true;
  frame = 0;
  finished = false;

  image: HTMLImageElement | null = null;
  frameWidth = 0;
  frameHeight = 0;
  reverse = false;
  private anims = new Map<string, Anim>();
  private curAnim: Anim | null = null;
  private curName = '';
  private curIndex = 0;
  private frameTimer = 0;
  private flickerTimer = -1;

  constructor(x = 0, y = 0, graphic?: string) {
    this.x = this.px = x;
    this.y = this.py = y;
    if (graphic) this.loadGraphic(graphic);
  }

  loadGraphic(name: string, animated = false, reverse = false, w = 0, h = 0): this {
    const i = img(name);
    this.image = i;
    this.reverse = reverse;
    this.frameWidth = w || (animated ? i.height : i.width);
    this.frameHeight = h || i.height;
    this.width = this.frameWidth;
    this.height = this.frameHeight;
    this.frame = 0;
    return this;
  }

  get frameCount(): number {
    return this.image ? Math.max(1, Math.floor(this.image.width / this.frameWidth)) : 0;
  }

  addAnimation(name: string, frames: number[], fps = 0, looped = true) {
    this.anims.set(name, { frames, delay: fps > 0 ? 1 / fps : 0, looped });
  }

  play(name: string, force = false) {
    if (!force && this.curAnim && name === this.curName && (this.curAnim.looped || !this.finished)) return;
    const a = this.anims.get(name);
    if (!a) return;
    this.curAnim = a;
    this.curName = name;
    this.curIndex = 0;
    this.frameTimer = 0;
    this.finished = false;
    this.frame = a.frames[0];
  }

  get animName() { return this.curName; }

  flicker(duration = 1) { this.flickerTimer = duration; }
  flickering() { return this.flickerTimer >= 0; }

  hurt(damage: number) {
    this.health -= damage;
    if (this.health <= 0) this.kill();
  }

  kill() {
    this.exists = false;
    this.dead = true;
  }

  reset(x: number, y: number) {
    this.x = this.px = x;
    this.y = this.py = y;
    this.exists = true;
    this.dead = false;
  }

  overlaps(o: { x: number; y: number; width: number; height: number; exists?: boolean } | null | undefined): boolean {
    if (!o || o.exists === false) return false;
    return !(o.x + o.width <= this.x || o.x >= this.x + this.width || o.y + o.height <= this.y || o.y >= this.y + this.height);
  }

  onScreen(): boolean {
    const sx = this.x + G.scroll.x * this.scrollFactor.x;
    return sx + this.width > 0 && sx < G.width;
  }

  // Collision callbacks (FlxObject.hitLeft/hitRight/hitTop/hitBottom).
  hitSide(_contact: unknown, _v: number) { if (!this.fixed) this.velocity.x = 0; }
  hitTop(_contact: unknown, _v: number) { if (!this.fixed) this.velocity.y = 0; }
  hitBottom(_contact: unknown, _v: number) {
    this.onFloor = true;
    if (!this.fixed) this.velocity.y = 0;
  }

  updateMotion() {
    if (!this.moves) return;
    this.onFloor = false;
    this.velocity.x = computeVelocity(this.velocity.x, this.acceleration.x, this.drag.x, this.maxVelocity.x);
    this.velocity.y = computeVelocity(this.velocity.y, this.acceleration.y, this.drag.y, this.maxVelocity.y);
    this.x += this.velocity.x * G.elapsed;
    this.y += this.velocity.y * G.elapsed;
  }

  updateAnimation() {
    const a = this.curAnim;
    if (a && a.delay > 0 && (a.looped || !this.finished)) {
      this.frameTimer += G.elapsed;
      while (this.frameTimer > a.delay) {
        this.frameTimer -= a.delay;
        if (this.curIndex === a.frames.length - 1) {
          if (a.looped) this.curIndex = 0;
          this.finished = true;
        } else this.curIndex++;
        this.frame = a.frames[this.curIndex];
      }
    }
    if (this.flickerTimer >= 0) {
      this.flickerTimer -= G.elapsed;
      if (this.flickerTimer < 0) this.visible = true;
      else this.visible = !this.visible;
    }
  }

  update() {
    this.updateMotion();
    this.updateAnimation();
  }

  /** Called by the state before each tick so rendering can interpolate. */
  savePrev() {
    this.px = this.x;
    this.py = this.y;
  }

  draw(ctx: CanvasRenderingContext2D, alpha = 1) {
    if (!this.image || !this.visible || this.alpha <= 0) return;
    const ix = this.px + (this.x - this.px) * alpha;
    const iy = this.py + (this.y - this.py) * alpha;
    const sx = Math.floor(ix - this.offset.x + G.scroll.x * this.scrollFactor.x + G.quake.x);
    const sy = Math.floor(iy - this.offset.y + G.scroll.y * this.scrollFactor.y + G.quake.y);
    const fw = this.frameWidth;
    const fh = this.frameHeight;
    const flip = this.reverse && this.facing === LEFT;
    const srcX = (this.frame % this.frameCount) * fw;
    ctx.globalAlpha = this.alpha;
    if (this.angle === 0 && !flip && this.scale.x === 1 && this.scale.y === 1) {
      ctx.drawImage(this.image, srcX, 0, fw, fh, sx, sy, fw, fh);
    } else {
      ctx.save();
      ctx.translate(sx + fw / 2, sy + fh / 2);
      if (this.angle) ctx.rotate((this.angle * Math.PI) / 180);
      ctx.scale(flip ? -this.scale.x : this.scale.x, this.scale.y);
      ctx.drawImage(this.image, srcX, 0, fw, fh, -fw / 2, -fh / 2, fw, fh);
      ctx.restore();
    }
    ctx.globalAlpha = 1;
  }
}

export class Group<T extends Drawable = Drawable> implements Drawable {
  members: T[] = [];
  exists = true;
  visible = true;
  active = true;

  add<U extends T>(m: U): U {
    this.members.push(m);
    return m;
  }

  remove(m: T) {
    const i = this.members.indexOf(m);
    if (i >= 0) this.members.splice(i, 1);
  }

  update() {
    for (const m of this.members) if (m.exists && m.active) m.update();
  }

  draw(ctx: CanvasRenderingContext2D, alpha = 1) {
    for (const m of this.members) if (m.exists && m.visible) (m.draw as (c: CanvasRenderingContext2D, a: number) => void)(ctx, alpha);
  }

  /** Drop members that no longer exist (the original never pruned; this just saves work). */
  prune() {
    this.members = this.members.filter((m) => m.exists);
  }
}

export class Text implements Drawable {
  exists = true;
  visible = true;
  active = true;
  scrollFactor = { x: 1, y: 1 };
  size = 8;
  align: CanvasTextAlign = 'left';
  shadow: string | null = null;
  alpha = 1;

  constructor(public x: number, public y: number, public fieldWidth: number, public text = '', public color = '#ffffff') {}

  setFormat(size: number, color: number, align: CanvasTextAlign = 'left', shadow: number | null = null): this {
    this.size = size;
    this.color = hex(color);
    this.align = align;
    this.shadow = shadow === null ? null : hex(shadow);
    return this;
  }

  kill() { this.exists = false; }
  update() {}

  draw(ctx: CanvasRenderingContext2D) {
    if (!this.text) return;
    ctx.font = `${this.size}px nokia`;
    ctx.textBaseline = 'top';
    ctx.textAlign = this.align;
    ctx.globalAlpha = this.alpha;
    const bx = Math.floor(this.x + G.scroll.x * this.scrollFactor.x + G.quake.x * this.scrollFactor.x);
    const by = Math.floor(this.y + G.scroll.y * this.scrollFactor.y + G.quake.y * this.scrollFactor.y);
    const ax = this.align === 'center' ? this.fieldWidth / 2 : this.align === 'right' ? this.fieldWidth : 0;
    const lineH = this.size + 2;
    this.text.split('\n').forEach((line, i) => {
      // Flash pads text fields by 2 px; keep that so positions copied from the original line up.
      const tx = bx + 2 + ax;
      const ty = by + 2 + i * lineH;
      if (this.shadow) {
        ctx.fillStyle = this.shadow;
        ctx.fillText(line, tx + 1, ty + 1);
      }
      ctx.fillStyle = this.color;
      ctx.fillText(line, tx, ty);
    });
    ctx.globalAlpha = 1;
  }
}

export function hex(c: number): string {
  return '#' + (c & 0xffffff).toString(16).padStart(6, '0');
}

export abstract class State {
  root = new Group();
  add<T extends Drawable>(d: T): T {
    return this.root.add(d);
  }
  abstract create(): void;
  update() {
    this.root.update();
  }
  draw(ctx: CanvasRenderingContext2D, alpha: number) {
    this.root.draw(ctx, alpha);
  }
  /** Visit every Sprite in the tree (for interpolation bookkeeping). */
  forEachSprite(fn: (s: Sprite) => void, g: Group = this.root) {
    for (const m of g.members) {
      if (m instanceof Sprite) fn(m);
      else if (m instanceof Group) this.forEachSprite(fn, m);
    }
  }
  destroy() {}
}
