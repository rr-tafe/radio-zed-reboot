// Night darkness with light sources cut out of it. Rendered at half resolution and scaled
// up without smoothing, with stepped falloff, so light edges land on the same 2×2 "fat
// pixel" grid as the original art.

import { Drawable, G } from '../engine/core';

export interface Light {
  /** World position. */
  x: number;
  y: number;
  radius: number;
  /** 0..1, how much darkness it removes at its centre. */
  intensity: number;
  /** Cone lights (flashlight): direction in radians and half-angle. */
  angle?: number;
  spread?: number;
}

const SCALE = 2;
const BANDS = 4;

export class Darkness implements Drawable {
  exists = true;
  visible = true;
  active = true;
  private canvas = document.createElement('canvas');
  private ctx = this.canvas.getContext('2d')!;

  constructor(private level: () => number, private lights: () => Light[]) {}

  update() {}

  draw(ctx: CanvasRenderingContext2D) {
    const level = this.level();
    if (level <= 0.01) return;
    const w = Math.ceil(G.width / SCALE);
    const h = Math.ceil(G.height / SCALE);
    if (this.canvas.width !== w) this.canvas.width = w;
    if (this.canvas.height !== h) this.canvas.height = h;
    const d = this.ctx;
    d.globalCompositeOperation = 'source-over';
    d.clearRect(0, 0, w, h);
    d.fillStyle = `rgba(4,6,14,${level})`;
    d.fillRect(0, 0, w, h);

    d.globalCompositeOperation = 'destination-out';
    for (const l of this.lights()) {
      const cx = (l.x + G.scroll.x + G.quake.x) / SCALE;
      const cy = (l.y + G.scroll.y + G.quake.y) / SCALE;
      const r = l.radius / SCALE;
      if (cx + r < 0 || cx - r > w) continue;
      const g = d.createRadialGradient(cx, cy, 0, cx, cy, r);
      // Hard-edged bands instead of a smooth falloff.
      for (let b = 0; b < BANDS; b++) {
        const a = l.intensity * (1 - b / BANDS);
        g.addColorStop(b / BANDS, `rgba(0,0,0,${a})`);
        g.addColorStop((b + 1) / BANDS - 0.001, `rgba(0,0,0,${a})`);
      }
      g.addColorStop(1, 'rgba(0,0,0,0)');
      d.fillStyle = g;
      d.beginPath();
      if (l.angle !== undefined && l.spread !== undefined) {
        d.moveTo(cx, cy);
        d.arc(cx, cy, r, l.angle - l.spread, l.angle + l.spread);
        d.closePath();
      } else d.arc(cx, cy, r, 0, Math.PI * 2);
      d.fill();
    }

    ctx.save();
    ctx.imageSmoothingEnabled = false;
    ctx.drawImage(this.canvas, 0, 0, w * SCALE, h * SCALE);
    ctx.restore();
  }
}
