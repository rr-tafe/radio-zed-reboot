// Keyboard and mouse state. Presses are latched until the next logic tick reads them, so a
// quick click or tap between two ticks is never lost (the original could drop these).

const down = new Set<string>();
const pressedSinceTick = new Set<string>();
const releasedSinceTick = new Set<string>();
let justDown = new Set<string>();
let justUp = new Set<string>();

export const mouse = {
  /** Position in game-view pixels (before camera scroll). */
  screenX: 0,
  screenY: 0,
  /** Position in world pixels, refreshed every tick and every render. */
  x: 0,
  y: 0,
  wheel: 0,
};

let wheelAccum = 0;
let toView: (clientX: number, clientY: number) => [number, number] = (x, y) => [x, y];

export function setViewMapping(fn: (clientX: number, clientY: number) => [number, number]) {
  toView = fn;
}

function keyName(e: KeyboardEvent): string {
  // Normalise to the names the original used (FlxG.keys.A, LEFT, SPACE, ONE...).
  const map: Record<string, string> = {
    ArrowLeft: 'LEFT', ArrowRight: 'RIGHT', ArrowUp: 'UP', ArrowDown: 'DOWN',
    Space: 'SPACE', Escape: 'ESCAPE', Enter: 'ENTER',
    Digit1: 'ONE', Digit2: 'TWO', Digit3: 'THREE', Digit4: 'FOUR', Digit5: 'FIVE',
    Digit6: 'SIX', Digit7: 'SEVEN', Digit8: 'EIGHT', Digit9: 'NINE', Digit0: 'ZERO',
  };
  if (map[e.code]) return map[e.code];
  if (e.code.startsWith('Key')) return e.code.slice(3);
  return e.code.toUpperCase();
}

function press(k: string) {
  if (!down.has(k)) pressedSinceTick.add(k);
  down.add(k);
}

function release(k: string) {
  if (down.has(k)) releasedSinceTick.add(k);
  down.delete(k);
}

export function attachInput(target: HTMLElement) {
  window.addEventListener('keydown', (e) => {
    const k = keyName(e);
    if (['SPACE', 'UP', 'DOWN', 'LEFT', 'RIGHT'].includes(k)) e.preventDefault();
    if (!e.repeat) press(k);
  });
  window.addEventListener('keyup', (e) => release(keyName(e)));
  window.addEventListener('blur', () => { for (const k of [...down]) release(k); });

  const move = (e: PointerEvent) => {
    [mouse.screenX, mouse.screenY] = toView(e.clientX, e.clientY);
  };
  target.addEventListener('pointermove', move);
  target.addEventListener('pointerdown', (e) => {
    move(e);
    target.setPointerCapture(e.pointerId);
    press(e.button === 2 ? 'MOUSE2' : 'MOUSE');
  });
  target.addEventListener('pointerup', (e) => release(e.button === 2 ? 'MOUSE2' : 'MOUSE'));
  target.addEventListener('contextmenu', (e) => e.preventDefault());
  target.addEventListener('wheel', (e) => { wheelAccum += Math.sign(e.deltaY); e.preventDefault(); }, { passive: false });
}

/** Called once at the start of each logic tick. */
export function beginTick() {
  justDown = new Set(pressedSinceTick);
  justUp = new Set(releasedSinceTick);
  pressedSinceTick.clear();
  releasedSinceTick.clear();
  // Flash reports wheel-up as positive delta; DOM reports it negative.
  mouse.wheel = -wheelAccum;
  wheelAccum = 0;
}

export const keys = {
  pressed: (k: string) => down.has(k) || justDown.has(k),
  justPressed: (k: string) => justDown.has(k),
  justReleased: (k: string) => justUp.has(k),
  any: (...ks: string[]) => ks.some((k) => down.has(k) || justDown.has(k)),
  anyJust: (...ks: string[]) => ks.some((k) => justDown.has(k)),
};
