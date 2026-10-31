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

/**
 * Background removal for generated art: the background colour is the median of the border
 * pixels (generators rarely give pure white), and everything connected to the border within
 * `tol` of it becomes transparent. Light colours inside the building are untouched because
 * the fill can't reach them. Returns the keyed image and the bounding box of what's left.
 * A negative tolerance skips keying.
 */
function removeBackground(img: HTMLImageElement, tol: number): { canvas: OffscreenCanvas; box: [number, number, number, number] } {
  const W = img.width, H = img.height;
  const data = pixels(img, W, H);
  const d = data.data;
  const canvas = new OffscreenCanvas(W, H);
  if (tol < 0) {
    canvas.getContext('2d')!.putImageData(data, 0, 0);
    return { canvas, box: [0, 0, W, H] };
  }
  const border: number[][] = [[], [], []];
  const sample = (x: number, y: number) => {
    const i = (y * W + x) * 4;
    for (let c = 0; c < 3; c++) border[c].push(d[i + c]);
  };
  for (let x = 0; x < W; x += 4) { sample(x, 0); sample(x, H - 1); }
  for (let y = 0; y < H; y += 4) { sample(0, y); sample(W - 1, y); }
  const bg = border.map((v) => v.sort((a, b) => a - b)[v.length >> 1]);
  const t2 = tol * tol;
  const near = (p: number) => {
    const i = p * 4;
    const dr = d[i] - bg[0], dg = d[i + 1] - bg[1], db = d[i + 2] - bg[2];
    return dr * dr + dg * dg + db * db <= t2;
  };
  const seen = new Uint8Array(W * H);
  const stack: number[] = [];
  const push = (p: number) => {
    if (!seen[p] && near(p)) { seen[p] = 1; stack.push(p); }
  };
  for (let x = 0; x < W; x++) { push(x); push((H - 1) * W + x); }
  for (let y = 0; y < H; y++) { push(y * W); push(y * W + W - 1); }
  while (stack.length) {
    const p = stack.pop()!;
    const x = p % W;
    if (x > 0) push(p - 1);
    if (x < W - 1) push(p + 1);
    if (p >= W) push(p - W);
    if (p < W * (H - 1)) push(p + W);
  }
  let x0 = W, y0 = H, x1 = -1, y1 = -1;
  for (let p = 0; p < W * H; p++) {
    if (seen[p]) { d[p * 4 + 3] = 0; continue; }
    const x = p % W, y = (p / W) | 0;
    if (x < x0) x0 = x;
    if (x > x1) x1 = x;
    if (y < y0) y0 = y;
    if (y > y1) y1 = y;
  }
  canvas.getContext('2d')!.putImageData(data, 0, 0);
  return { canvas, box: x1 < 0 ? [0, 0, W, H] : [x0, y0, x1 - x0 + 1, y1 - y0 + 1] };
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
  const tol = Number($<HTMLInputElement>('thresh').value);
  const key = $<HTMLInputElement>('key').checked;
  // Remove the background by flood-filling from the edges, then crop to what's left.
  const { canvas: keyed, box } = removeBackground(raw, key ? tol : -1);
  let [cx, cy, cw, ch] = [0, 0, raw.width, raw.height];
  if ($<HTMLInputElement>('crop').checked) [cx, cy, cw, ch] = box;
  const cropped = new OffscreenCanvas(cw, ch);
  cropped.getContext('2d')!.drawImage(keyed, cx, cy, cw, ch, 0, 0, cw, ch);
  const artW = outW / 2;
  const artH = Math.max(1, Math.round((ch / cw) * artW));
  // Downscale in steps so detail averages out instead of aliasing.
  let src: CanvasImageSource = cropped, w = cw, h = ch;
  while (w / 2 > artW) {
    const c = new OffscreenCanvas(Math.round(w / 2), Math.round(h / 2));
    const g = c.getContext('2d')!;
    g.imageSmoothingQuality = 'high';
    g.drawImage(src, 0, 0, c.width, c.height);
    src = c; w = c.width; h = c.height;
  }
  const small = pixels(src, artW, artH);
  const d = small.data;
  // Downscaling blends edge alpha; snap it to fully on or off (no semi-transparent pixels).
  for (let i = 0; i < d.length; i += 4) d[i + 3] = d[i + 3] >= 160 ? 255 : 0;
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
  $('info').textContent = `Output ${outW} × ${artH * 2} game px (cropped from ${cw} × ${ch} raw px).`;
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
const params = new URLSearchParams(location.search);
const src = params.get('src');
if (params.get('width')) $<HTMLInputElement>('width').value = params.get('width')!;
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
