// Static-world collision. In Radio Zed every collision is a moving object against the
// level (`FlxU.collide(_blocks, _objects)`): the tilemap plus the invisible barricade
// blocks. Nothing collides with anything else that moves, so a swept AABB-vs-static
// resolver (X then Y, as Flixel did) reproduces the original behaviour.

import { img } from './assets';
import { Sprite } from './core';

export interface Box { x: number; y: number; width: number; height: number }

export class Tilemap {
  readonly tile = 8;
  cols = 0;
  rows = 0;
  private solid: Uint8Array = new Uint8Array(0);

  /** FlxTilemap.pngToCSV(map, false, scale): dark pixels become solid tiles. */
  static fromPng(name: string, scale = 2): Tilemap {
    const image = img(name);
    const c = document.createElement('canvas');
    c.width = image.width;
    c.height = image.height;
    const ctx = c.getContext('2d')!;
    ctx.drawImage(image, 0, 0);
    const px = ctx.getImageData(0, 0, c.width, c.height).data;
    const t = new Tilemap();
    t.cols = image.width * scale;
    t.rows = image.height * scale;
    t.solid = new Uint8Array(t.cols * t.rows);
    for (let y = 0; y < t.rows; y++) {
      for (let x = 0; x < t.cols; x++) {
        const i = (Math.floor(y / scale) * image.width + Math.floor(x / scale)) * 4;
        // pngToCSV: a pixel counts as a tile when it is darker than mid-grey (and opaque).
        const on = px[i + 3] > 0 && px[i] < 128;
        t.solid[y * t.cols + x] = on ? 1 : 0;
      }
    }
    return t;
  }

  isSolid(col: number, row: number): boolean {
    if (col < 0 || row < 0 || col >= this.cols || row >= this.rows) return false;
    return this.solid[row * this.cols + col] === 1;
  }

  /** Solid tile rectangles that intersect the box. */
  boxesIn(b: Box, out: Box[]) {
    const t = this.tile;
    const c0 = Math.floor(b.x / t), c1 = Math.floor((b.x + b.width - 0.0001) / t);
    const r0 = Math.floor(b.y / t), r1 = Math.floor((b.y + b.height - 0.0001) / t);
    for (let r = r0; r <= r1; r++) {
      for (let c = c0; c <= c1; c++) {
        if (this.isSolid(c, r)) out.push({ x: c * t, y: r * t, width: t, height: t });
      }
    }
  }
}

const EPS = 0.0001;
const scratch: Box[] = [];

function overlapping(a: Box, b: Box) {
  return a.x + a.width > b.x + EPS && a.x < b.x + b.width - EPS && a.y + a.height > b.y + EPS && a.y < b.y + b.height - EPS;
}

function gather(b: Box, map: Tilemap | null, blocks: Sprite[]): Box[] {
  scratch.length = 0;
  map?.boxesIn(b, scratch);
  for (const k of blocks) if (k.exists && k.solid && overlapping(b, k)) scratch.push(k);
  return scratch;
}

/** Resolve one moving sprite against the level. Uses px/py (position before this tick). */
export function collideStatic(s: Sprite, map: Tilemap | null, blocks: Sprite[]) {
  if (!s.exists || !s.solid || s.fixed) return;
  const dx = s.x - s.px;
  const dy = s.y - s.py;

  // X pass, at the old Y.
  if (dx !== 0) {
    const box = { x: s.x, y: s.py, width: s.width, height: s.height };
    for (const o of gather(box, map, blocks)) {
      if (!overlapping(box, o)) continue;
      // Flixel ignores overlaps deeper than 80% of the object's size on this axis.
      const pen = dx > 0 ? box.x + box.width - o.x : o.x + o.width - box.x;
      if (pen > s.width * 0.8 + Math.abs(dx)) continue;
      box.x = dx > 0 ? o.x - s.width : o.x + o.width;
      s.hitSide(o, 0);
    }
    s.x = box.x;
  }

  // Y pass.
  if (dy !== 0 || s.acceleration.y !== 0) {
    const box = { x: s.x, y: s.y, width: s.width, height: s.height };
    const down = dy >= 0;
    for (const o of gather(box, map, blocks)) {
      if (!overlapping(box, o)) continue;
      const pen = down ? box.y + box.height - o.y : o.y + o.height - box.y;
      if (pen > s.height * 0.8 + Math.abs(dy)) continue;
      if (down) {
        box.y = o.y - s.height;
        s.hitBottom(o, 0);
      } else {
        box.y = o.y + o.height;
        s.hitTop(o, 0);
      }
    }
    s.y = box.y;
    // Standing still on the ground: Flixel re-detects the floor every frame because gravity
    // pushes the object 1 frame's worth into it. Mirror that with a probe just below.
    if (!s.onFloor && down && s.velocity.y >= 0) {
      const probe = { x: s.x, y: s.y + 0.5, width: s.width, height: s.height };
      if (gather(probe, map, blocks).some((o) => overlapping(probe, o))) s.onFloor = true;
    }
  }
}
