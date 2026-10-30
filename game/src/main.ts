// Boot, scaling and the main loop.
//
// Responsiveness changes vs. the 2010 original (which ran logic and rendering together at
// 30 fps): logic runs at a fixed 60 Hz, rendering runs at the display's refresh rate with
// interpolation, and the crosshair/arm are re-aimed every rendered frame from the latest
// pointer position. Input presses are latched so short clicks are never dropped.

import { img, loadAll } from './engine/assets';
import { G, State, updateCamera } from './engine/core';
import { attachInput, beginTick, keys, mouse, setViewMapping } from './engine/input';
import { changeVolume, toggleMute, unlockAudio } from './engine/sound';
import { screens } from './game/screens';
import { settings } from './game/settings';

const STEP = 1 / 60;
const BASE_W = 640;
const BASE_H = 480;
/** Widest gameplay view: the camera can show world x 30…1055. */
const MAX_W = 1024;

const screen = document.getElementById('screen') as HTMLCanvasElement;
const sctx = screen.getContext('2d')!;
const view = document.createElement('canvas');
const ctx = view.getContext('2d')!;

let scale = 1;
let offX = 0;
let offY = 0;

function wantsWide(s: State | null) {
  return settings.wide && !!s && (s as { wide?: boolean }).wide === true;
}

function layout() {
  const dpr = window.devicePixelRatio || 1;
  const W = window.innerWidth * dpr;
  const H = window.innerHeight * dpr;
  // Integer scaling keeps the fat pixels crisp; fall back to fractional on small windows.
  const fit = Math.min(W / BASE_W, H / BASE_H);
  scale = fit >= 1 ? Math.floor(fit) : fit;
  const vw = wantsWide(G.state) ? Math.min(MAX_W, Math.max(BASE_W, Math.floor(W / scale))) : BASE_W;
  if (view.width !== vw) view.width = vw;
  view.height = BASE_H;
  G.width = vw;
  screen.width = W;
  screen.height = H;
  screen.style.width = `${window.innerWidth}px`;
  screen.style.height = `${window.innerHeight}px`;
  offX = Math.floor((W - vw * scale) / 2);
  offY = Math.floor((H - BASE_H * scale) / 2);
}

setViewMapping((cx, cy) => {
  const dpr = window.devicePixelRatio || 1;
  return [(cx * dpr - offX) / scale, (cy * dpr - offY) / scale];
});

function refreshMouseWorld() {
  mouse.x = mouse.screenX - G.scroll.x;
  mouse.y = mouse.screenY - G.scroll.y;
}

function enter(make: () => State) {
  G.state?.destroy();
  G.follow = null;
  G.scroll.x = G.scroll.y = 0;
  const s = make();
  G.state = s;
  layout();
  s.create();
}

let acc = 0;
let last = performance.now();
let prevScroll = { x: 0, y: 0 };

function tick() {
  beginTick();
  refreshMouseWorld();
  if (keys.justPressed('ZERO')) toggleMute();
  if (keys.justPressed('MINUS')) changeVolume(-0.1);
  if (keys.justPressed('EQUAL')) changeVolume(0.1);
  if (keys.justPressed('MOUSE')) unlockAudio();
  const s = G.state!;
  s.forEachSprite((sp) => sp.savePrev());
  prevScroll = { ...G.scroll };
  s.update();
  updateCamera();
  if (G.nextState) {
    const next = G.nextState;
    G.nextState = null;
    enter(next);
    prevScroll = { ...G.scroll };
  }
}

function frame(now: number) {
  try {
    step(now);
  } catch (e) {
    // Keep the loop alive so one bad frame doesn't freeze the game; surface the error.
    console.error(e);
    acc = 0;
  }
  requestAnimationFrame(frame);
}

function step(now: number) {
  acc += Math.min(0.25, (now - last) / 1000);
  last = now;
  G.elapsed = STEP;
  while (acc >= STEP) {
    tick();
    acc -= STEP;
  }
  const alpha = acc / STEP;

  // Render with the camera interpolated between the last two ticks.
  const realScroll = { ...G.scroll };
  G.scroll.x = prevScroll.x + (realScroll.x - prevScroll.x) * alpha;
  G.scroll.y = prevScroll.y + (realScroll.y - prevScroll.y) * alpha;
  refreshMouseWorld();
  (G.state as State & { onRender?: () => void }).onRender?.();

  ctx.imageSmoothingEnabled = false;
  ctx.fillStyle = '#fff'; // FlxState.bgColor in the original
  ctx.fillRect(0, 0, view.width, view.height);
  G.state!.draw(ctx, alpha);
  // Menus used their own arrow cursor (gameplay draws its crosshair itself).
  if (!(G.state as { wide?: boolean }).wide) ctx.drawImage(img('winScreen_dialog_ImgCursor'), Math.floor(mouse.screenX), Math.floor(mouse.screenY));
  G.scroll.x = realScroll.x;
  G.scroll.y = realScroll.y;

  sctx.imageSmoothingEnabled = false;
  sctx.fillStyle = '#000';
  sctx.fillRect(0, 0, screen.width, screen.height);
  sctx.drawImage(view, offX, offY, view.width * scale, view.height * scale);
}

if (import.meta.env.DEV) (window as unknown as { G: typeof G }).G = G;

async function boot() {
  layout();
  window.addEventListener('resize', layout);
  attachInput(screen);
  sctx.fillStyle = '#000';
  sctx.fillRect(0, 0, screen.width, screen.height);
  await loadAll((f) => {
    sctx.fillStyle = '#fff';
    sctx.fillRect(offX, offY + 470 * scale, 640 * scale * f, 4 * scale);
  });
  enter(screens.menu);
  last = performance.now();
  requestAnimationFrame(frame);
}

boot().catch((e) => {
  console.error(e);
  document.body.textContent = `Failed to start: ${e}`;
  document.body.style.color = '#fff';
});
