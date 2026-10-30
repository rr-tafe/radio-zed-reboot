// The story-mode sky. By day it's a painted gradient with drifting fat-pixel clouds; at night
// it's one of the original's five night skies (only one has a moon), cross-faded at dusk
// and dawn.

import { img } from '../engine/assets';
import { Drawable, G } from '../engine/core';
import type { Moon } from './time';

type RGB = [number, number, number];
const hexRGB = (h: string): RGB => [1, 3, 5].map((i) => parseInt(h.slice(i, i + 2), 16)) as RGB;
const mix = (a: RGB, b: RGB, t: number): string =>
  `rgb(${a.map((v, i) => Math.round(v + (b[i] - v) * t)).join(',')})`;

const DAY: [RGB, RGB] = [hexRGB('#5d8fc4'), hexRGB('#c3d9e6')];
const DUSK: [RGB, RGB] = [hexRGB('#2b2f55'), hexRGB('#d9884f')];
const DAWN: [RGB, RGB] = [hexRGB('#3e4f7d'), hexRGB('#f0c27e')];

export interface SkyState {
  /** 'day' | 'dusk' | 'night' | 'dawn', with t = progress through dusk/dawn (0..1). */
  phase: 'day' | 'dusk' | 'night' | 'dawn';
  t: number;
  moon: Moon;
}

export function nightSkyFor(moon: Moon, seed: number): string {
  // Bright nights show the original's moon sky; darker ones use the moonless skies,
  // including SpaceMoon1, which the 2010 game never showed.
  if (moon === 'full' || moon === 'gibbous') return 'playLvl_ImgSpaceMoon';
  return ['playLvl_ImgSpaceMoon1', 'playLvl_ImgSpaceMoon2', 'playLvl_ImgSpaceMoon3', 'playLvl_ImgSpaceMoon4'][seed % 4];
}

export class Sky implements Drawable {
  exists = true;
  visible = true;
  active = true;
  private clouds = Array.from({ length: 7 }, (_, i) => ({ x: (i * 173) % 1100, y: 30 + ((i * 47) % 150), w: 3 + (i % 4), drift: 2 + (i % 3) }));

  constructor(private state: () => SkyState, private nightImage: () => string) {}

  update() {
    for (const c of this.clouds) {
      c.x += c.drift * G.elapsed;
      if (c.x > 1200) c.x = -120;
    }
  }

  private gradient(ctx: CanvasRenderingContext2D, top: string, bottom: string) {
    const g = ctx.createLinearGradient(0, 0, 0, 432);
    g.addColorStop(0, top);
    g.addColorStop(1, bottom);
    ctx.fillStyle = g;
    ctx.fillRect(0, 0, G.width, 432);
  }

  private drawClouds(ctx: CanvasRenderingContext2D, alpha: number) {
    if (alpha <= 0) return;
    ctx.globalAlpha = alpha;
    ctx.fillStyle = '#eef3f6';
    for (const c of this.clouds) {
      // Clouds scroll a little with the camera, like a far parallax layer.
      const x = Math.floor(c.x + G.scroll.x * 0.05);
      for (let k = 0; k < c.w; k++) {
        const bw = 12 + ((k * 7) % 10);
        ctx.fillRect(x + k * 10, c.y - ((k % 2) * 4), bw * 2, 8);
      }
    }
    ctx.globalAlpha = 1;
  }

  draw(ctx: CanvasRenderingContext2D) {
    const { phase, t } = this.state();
    if (phase === 'day') {
      this.gradient(ctx, mix(DAY[0], DAY[0], 0), mix(DAY[1], DAY[1], 0));
      this.drawClouds(ctx, 0.9);
      return;
    }
    if (phase === 'dusk') {
      // Day → dusk colours over the first 70%, then fade in the night sky.
      const k = Math.min(1, t / 0.7);
      this.gradient(ctx, mix(DAY[0], DUSK[0], k), mix(DAY[1], DUSK[1], k));
      this.drawClouds(ctx, 0.9 * (1 - k));
      this.night(ctx, Math.max(0, (t - 0.7) / 0.3));
      return;
    }
    if (phase === 'dawn') {
      this.night(ctx, 1);
      const k = Math.min(1, t / 0.4);
      ctx.globalAlpha = k;
      const d = Math.max(0, (t - 0.4) / 0.6);
      this.gradient(ctx, mix(DAWN[0], DAY[0], d), mix(DAWN[1], DAY[1], d));
      ctx.globalAlpha = 1;
      this.drawClouds(ctx, 0.9 * d);
      return;
    }
    this.night(ctx, 1);
  }

  private night(ctx: CanvasRenderingContext2D, alpha: number) {
    if (alpha <= 0) return;
    ctx.globalAlpha = alpha;
    const image = img(this.nightImage());
    // The original skies are 640 wide; stretch to wide views.
    ctx.drawImage(image, 0, 0, image.width, image.height, 0, 0, Math.max(G.width, image.width), image.height);
    ctx.globalAlpha = 1;
  }
}
