// Dev-only page (art-pipeline.html): fit generated art to the original's style.
// 1. Box-downscale to half the target width (each art pixel is 2×2 game pixels).
// 2. Snap every pixel to the nearest colour of a palette built from the original art.
// 3. Key out a light background to transparency.
// 4. Nearest-neighbour upscale ×2.

const SOURCES = ['playLvl_ImgBackgr', 'playLvl_ImgBackgr2', 'playLvl_ImgBackgr3', 'playLvl_ImgCityBack', 'playLvl_ImgCityBack2', 'Shop_shopBack'];
const urls = import.meta.glob('../assets/images/*.png', { eager: true, query: '?url', import: 'default' }) as Record<string, string>;
const urlFor = (n: string) => Object.entries(urls).find(([p]) => p.endsWith(`/${n}.png`))?.[1];

type RGB = [number, number, number];
const $ = <T extends HTMLElement>(id: string) => document.getElementById(id) as T;

function load(src: string): Promise<HTMLImageElement> {
  return new Promise((ok, fail) => {
    const i = new Image();
    i.onload = () => ok(i);
    i.onerror = fail;
    i.src = src;
  });
}

function pixels(img: CanvasImageSource, w: number, h: number): ImageData {
  const c = new OffscreenCanvas(w, h);
  const g = c.getContext('2d')!;
  g.drawImage(img, 0, 0, w, h);
  return g.getImageData(0, 0, w, h);
}

/** The most-used opaque colours in the original art, with near-duplicates merged. */
async function buildPalette(size: number): Promise<RGB[]> {
  const counts = new Map<number, number>();
  for (const name of SOURCES) {
    const u = urlFor(name);
    if (!u) continue;
    const img = await load(u);
    const d = pixels(img, img.width, img.height).data;
    for (let i = 0; i < d.length; i += 4) {
      if (d[i + 3] < 200) continue;
      const k = (d[i] << 16) | (d[i + 1] << 8) | d[i + 2];
      counts.set(k, (counts.get(k) ?? 0) + 1);
    }
  }
  const sorted = [...counts].sort((a, b) => b[1] - a[1]).map(([k]) => [k >> 16, (k >> 8) & 255, k & 255] as RGB);
  const out: RGB[] = [];
  for (const c of sorted) {
    if (out.every((p) => dist(p, c) > 180)) out.push(c);
    if (out.length >= size) break;
  }
  return out;
}

const dist = (a: RGB, b: RGB) => {
  // Weighted RGB distance (rough perceptual weighting).
  const dr = a[0] - b[0], dg = a[1] - b[1], db = a[2] - b[2];
  return 2 * dr * dr + 4 * dg * dg + 3 * db * db;
};

function nearest(p: RGB[], c: RGB): RGB {
  let best = p[0], bd = Infinity;
  for (const q of p) {
    const d = dist(q, c);
    if (d < bd) { bd = d; best = q; }
  }
  return best;
}

let palette: RGB[] = [];
let raw: HTMLImageElement | null = null;
let result: HTMLCanvasElement | null = null;

async function process() {
  if (!raw) return;
  const psize = Number($<HTMLInputElement>('psize').value);
  if (palette.length !== psize) palette = await buildPalette(psize);
  $('palette').innerHTML = palette.map((c) => `<span style="background:rgb(${c.join(',')})"></span>`).join('');

  const outW = Math.max(2, Number($<HTMLInputElement>('width').value) & ~1);
  const artW = outW / 2;
  const artH = Math.max(1, Math.round((raw.height / raw.width) * artW));
  // Downscale in steps so detail averages out instead of aliasing.
  let src: CanvasImageSource = raw, w = raw.width, h = raw.height;
  while (w / 2 > artW) {
    const c = new OffscreenCanvas(Math.round(w / 2), Math.round(h / 2));
    const g = c.getContext('2d')!;
    g.imageSmoothingQuality = 'high';
    g.drawImage(src, 0, 0, c.width, c.height);
    src = c; w = c.width; h = c.height;
  }
  const small = pixels(src, artW, artH);
  const d = small.data;
  const key = $<HTMLInputElement>('key').checked;
  const thresh = Number($<HTMLInputElement>('thresh').value);
  for (let i = 0; i < d.length; i += 4) {
    if (key && d[i] >= thresh && d[i + 1] >= thresh && d[i + 2] >= thresh) {
      d[i + 3] = 0;
      continue;
    }
    d[i + 3] = 255;
  }
  // Remove the light halo that anti-aliased edges leave against the keyed background:
  // pale pixels touching transparency become transparent (two passes eat a 2-pixel fringe).
  if (key) {
    const fringe = thresh - 60;
    for (let pass = 0; pass < 2; pass++) {
      const clear: number[] = [];
      for (let y = 0; y < artH; y++) {
        for (let x = 0; x < artW; x++) {
          const i = (y * artW + x) * 4;
          if (d[i + 3] === 0 || Math.min(d[i], d[i + 1], d[i + 2]) < fringe) continue;
          const open = [[1, 0], [-1, 0], [0, 1], [0, -1]].some(([dx, dy]) => {
            const nx = x + dx, ny = y + dy;
            return nx < 0 || ny < 0 || nx >= artW || ny >= artH || d[(ny * artW + nx) * 4 + 3] === 0;
          });
          if (open) clear.push(i);
        }
      }
      for (const i of clear) d[i + 3] = 0;
    }
  }
  for (let i = 0; i < d.length; i += 4) {
    if (d[i + 3] === 0) continue;
    const c = nearest(palette, [d[i], d[i + 1], d[i + 2]]);
    d[i] = c[0]; d[i + 1] = c[1]; d[i + 2] = c[2];
  }
  const sc = new OffscreenCanvas(artW, artH);
  sc.getContext('2d')!.putImageData(small, 0, 0);
  const out = $<HTMLCanvasElement>('out');
  out.width = artW * 2;
  out.height = artH * 2;
  const og = out.getContext('2d')!;
  og.imageSmoothingEnabled = false;
  og.drawImage(sc, 0, 0, out.width, out.height);
  result = out;
  ($('save') as HTMLButtonElement).disabled = false;
}

$<HTMLInputElement>('file').addEventListener('change', async (e) => {
  const f = (e.target as HTMLInputElement).files?.[0];
  if (!f) return;
  raw = await load(URL.createObjectURL(f));
  const c = $<HTMLCanvasElement>('raw');
  c.width = raw.width;
  c.height = raw.height;
  c.style.width = '480px';
  c.getContext('2d')!.drawImage(raw, 0, 0);
  await process();
});
$('run').addEventListener('click', () => void process());
$('save').addEventListener('click', () => {
  if (!result) return;
  const a = document.createElement('a');
  a.download = 'fitted.png';
  a.href = result.toDataURL('image/png');
  a.click();
});

// Dev convenience: ?src=/path loads an image served by the dev server.
const src = new URLSearchParams(location.search).get('src');
if (src) {
  load(src).then(async (img) => {
    raw = img;
    const c = $<HTMLCanvasElement>('raw');
    c.width = img.width;
    c.height = img.height;
    c.style.width = '480px';
    c.getContext('2d')!.drawImage(img, 0, 0);
    await process();
  });
}
