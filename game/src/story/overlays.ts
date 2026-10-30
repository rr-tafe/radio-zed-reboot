// Story-mode drawables: floor fog, the keyhole view, toasts, prompts and progress bars.
// All drawn with the original's palette and Nokia font.

import { img } from '../engine/assets';
import { Drawable, G, Text } from '../engine/core';
import { TEXT_COLOR, TEXT_SHADOW } from '../game/data';

type Rect = [number, number, number, number];

const worldX = (x: number) => Math.floor(x + G.scroll.x + G.quake.x);
const worldY = (y: number) => Math.floor(y + G.scroll.y + G.quake.y);

abstract class Overlay implements Drawable {
  exists = true;
  visible = true;
  active = true;
  update() {}
  abstract draw(ctx: CanvasRenderingContext2D): void;
}

/** Darkens unexplored floors. Revealed floors fade in over half a second. */
export class Fog extends Overlay {
  private alpha = new Map<string, number>();
  constructor(private floors: { id: string; rect: Rect }[], private isRevealed: (id: string) => boolean) {
    super();
    for (const f of floors) this.alpha.set(f.id, isRevealed(f.id) ? 0 : 0.92);
  }
  update() {
    for (const f of this.floors) {
      const a = this.alpha.get(f.id)!;
      if (this.isRevealed(f.id) && a > 0) this.alpha.set(f.id, Math.max(0, a - G.elapsed * 2));
    }
  }
  draw(ctx: CanvasRenderingContext2D) {
    for (const f of this.floors) {
      const a = this.alpha.get(f.id)!;
      if (a <= 0) continue;
      const [x, y, w, h] = f.rect;
      ctx.globalAlpha = a;
      ctx.fillStyle = '#0d0b0a';
      ctx.fillRect(worldX(x), worldY(y), w, h);
    }
    ctx.globalAlpha = 1;
  }
}

/** Opened doors show a dark doorway, like the stairwell openings in the original art. */
export class OpenDoorways extends Overlay {
  constructor(private doors: { rect: Rect; isOpen: () => boolean }[]) {
    super();
  }
  draw(ctx: CanvasRenderingContext2D) {
    for (const d of this.doors) {
      if (!d.isOpen()) continue;
      const [x, y, w, h] = d.rect;
      ctx.fillStyle = '#16120f';
      ctx.fillRect(worldX(x + 2), worldY(y + 2), w - 4, h - 2);
      ctx.fillStyle = '#2b231d';
      ctx.fillRect(worldX(x + 2), worldY(y + 2), w - 4, 2);
    }
  }
}

export interface PeekView {
  zombies: number;
  items: number;
  /** 0 = pitch black, 1 = fully lit. */
  light: number;
}

/** A keyhole-shaped window onto a room, drawn in screen space while peeking. */
export class Keyhole extends Overlay {
  view: PeekView | null = null;
  private t = 0;
  private skins: number[] = [];

  update() {
    this.t += G.elapsed;
  }

  show(v: PeekView) {
    if (!this.view) this.skins = Array.from({ length: v.zombies }, () => Math.floor(Math.random() * 18));
    this.view = v;
  }
  hide() {
    this.view = null;
  }

  draw(ctx: CanvasRenderingContext2D) {
    const v = this.view;
    if (!v) return;
    const cx = Math.floor(G.width / 2);
    const cy = 150;
    const r = 70;
    ctx.save();
    // Dim the scene around the keyhole.
    ctx.fillStyle = 'rgba(0,0,0,0.75)';
    ctx.fillRect(0, 0, G.width, G.height);
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0, Math.PI * 2);
    ctx.moveTo(cx - 22, cy + 40);
    ctx.lineTo(cx + 22, cy + 40);
    ctx.lineTo(cx + 34, cy + 130);
    ctx.lineTo(cx - 34, cy + 130);
    ctx.closePath();
    ctx.clip();
    ctx.fillStyle = '#211b16';
    ctx.fillRect(cx - r, cy - r, r * 2, 220);
    ctx.fillStyle = '#2e261f';
    ctx.fillRect(cx - r, cy + 72, r * 2, 70); // floor
    // Room contents, scaled up 2× as if seen up close.
    ctx.imageSmoothingEnabled = false;
    this.skins.forEach((skin, i) => {
      const zx = cx - 40 + i * 44 + Math.round(Math.sin(this.t * 1.5 + i) * 3);
      const sheet = img(`zombie1_ImgZombie${String(skin).padStart(2, '0')}`);
      const frame = Math.floor(this.t * 4 + i * 7) % 24;
      ctx.drawImage(sheet, frame * 17, 0, 17, 32, zx, cy + 8, 34, 64);
    });
    for (let i = 0; i < v.items; i++) {
      // A glint per item: you can tell something is there, not what it is.
      const gx = cx - 50 + ((i * 37) % 100);
      const gy = cy + 80 + ((i * 13) % 30);
      const on = Math.sin(this.t * 3 + i * 2) > 0.2;
      ctx.fillStyle = on ? '#e2dcd7' : '#8a7f72';
      ctx.fillRect(gx, gy, 2, 2);
      if (on) ctx.fillRect(gx - 2, gy, 6, 1), ctx.fillRect(gx, gy - 2, 1, 6);
    }
    // Darkness in the room itself.
    ctx.fillStyle = `rgba(0,0,0,${1 - v.light})`;
    ctx.fillRect(cx - r, cy - r, r * 2, 220);
    ctx.restore();
    // Rim.
    ctx.strokeStyle = '#5a4c40';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.arc(cx, cy, r, 0.3, Math.PI - 0.3, true);
    ctx.stroke();
    if (v.light < 0.15) this.caption(ctx, 'Too dark to see anything.', cx, cy + 140);
    else this.caption(ctx, v.zombies ? 'Something is moving in there.' : v.items ? 'Looks quiet. Something glints.' : 'Looks empty.', cx, cy + 140);
  }

  private caption(ctx: CanvasRenderingContext2D, s: string, cx: number, y: number) {
    ctx.font = '8px nokia';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'top';
    ctx.fillStyle = '#233e58';
    ctx.fillText(s, cx + 1, y + 1);
    ctx.fillStyle = '#e2dcd7';
    ctx.fillText(s, cx, y);
    ctx.textAlign = 'left';
  }
}

/** Short messages at the top of the screen that fade out. */
export class Toasts extends Overlay {
  private items: { text: Text; life: number }[] = [];
  push(message: string, seconds = 3.5) {
    const t = new Text(0, 0, 640, message).setFormat(8, TEXT_COLOR, 'center', TEXT_SHADOW);
    t.scrollFactor = { x: 0, y: 0 };
    this.items.push({ text: t, life: seconds });
    if (this.items.length > 4) this.items.shift();
  }
  update() {
    for (const i of this.items) i.life -= G.elapsed;
    this.items = this.items.filter((i) => i.life > 0);
  }
  draw(ctx: CanvasRenderingContext2D) {
    let y = 40;
    for (const i of this.items) {
      i.text.x = (G.width - 640) / 2;
      i.text.y = y;
      i.text.alpha = Math.min(1, i.life);
      i.text.draw(ctx);
      y += 10 * i.text.text.split('\n').length + 2;
    }
  }
}

/** A hint floating above the player ("S: open"), plus an optional progress bar. */
export class Prompt extends Overlay {
  text = '';
  progress = -1;
  x = 0;
  y = 0;
  private label = new Text(0, 0, 200, '', '#ffffff').setFormat(8, TEXT_COLOR, 'center', TEXT_SHADOW);
  draw(ctx: CanvasRenderingContext2D) {
    if (this.text) {
      this.label.text = this.text;
      this.label.x = this.x - 100;
      this.label.y = this.y - 34;
      this.label.draw(ctx);
    }
    if (this.progress >= 0) {
      const bx = worldX(this.x - 15);
      const by = worldY(this.y - 26);
      ctx.fillStyle = '#233e58';
      ctx.fillRect(bx, by, 30, 4);
      ctx.fillStyle = '#e2dcd7';
      ctx.fillRect(bx + 1, by + 1, Math.round(28 * Math.min(1, this.progress)), 2);
    }
  }
}

/** Name and health above each guard. */
export class NameTags extends Overlay {
  private label = new Text(0, 0, 80, '').setFormat(8, TEXT_COLOR, 'center', TEXT_SHADOW);
  constructor(private tags: () => { x: number; y: number; text: string }[]) {
    super();
  }
  draw(ctx: CanvasRenderingContext2D) {
    for (const t of this.tags()) {
      this.label.text = t.text;
      this.label.x = t.x - 40;
      this.label.y = t.y;
      this.label.draw(ctx);
    }
  }
}

/** Door art stamped onto walls where the backdrop has none (cut from the Corner Shop art). */
export class DoorDecals extends Overlay {
  constructor(private rects: Rect[], private source: { image: string; rect: Rect }) {
    super();
  }
  draw(ctx: CanvasRenderingContext2D) {
    const [sx, sy, sw, sh] = this.source.rect;
    const image = img(this.source.image);
    for (const [x, y, w, h] of this.rects) {
      ctx.drawImage(image, sx, sy, sw, sh, worldX(x + w / 2 - sw / 2), worldY(y + h - sh), sw, sh);
    }
  }
}
