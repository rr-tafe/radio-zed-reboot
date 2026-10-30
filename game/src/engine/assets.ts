// Loads the PNGs and MP3s extracted from the original SWF (see tools/ and docs/ORIGINAL_SPEC.md).

import fontUrl from '../assets/fonts/nokia.ttf?url';

const imageUrls = import.meta.glob('../assets/images/*.png', { eager: true, query: '?url', import: 'default' }) as Record<string, string>;
const soundUrls = import.meta.glob('../assets/sounds/*.mp3', { eager: true, query: '?url', import: 'default' }) as Record<string, string>;

const images = new Map<string, HTMLImageElement>();
const sounds = new Map<string, AudioBuffer>();
let audioCtx: AudioContext | null = null;

const baseName = (p: string) => p.slice(p.lastIndexOf('/') + 1).replace(/\.\w+$/, '');

export function audio(): AudioContext {
  if (!audioCtx) audioCtx = new AudioContext();
  return audioCtx;
}

/**
 * The SWF stored identical bitmaps once under one class name; these are the other names the
 * original code used for them (from extracted/radiozed/manifest.json).
 */
const ALIASES: Record<string, string> = {
  Shop_ImgWeapon2_2: 'Shop_ImgButtonBuyBarricad1',
  Shop_ImgWeapon2_2_block: 'Shop_ImgButtonBuyBarricad1_block',
  Shop_ImgButtonBuyBarricad1_light: 'Shop_ImgWeapon2_2_light',
  Shop_statistics_Img_button_start_menu: 'Shop_Img_button_start_menu',
  Shop_statistics_Img_main_menu_button_light: 'Shop_Img_main_menu_button_light',
  Shop_statistics_backGround_Img: 'blackScreen_dialog_backGround_Img',
  Shop_backGround_Img: 'blackScreen_dialog_backGround_Img',
};

export function img(name: string): HTMLImageElement {
  const i = images.get(ALIASES[name] ?? name);
  if (!i) throw new Error(`image not loaded: ${name}`);
  return i;
}

export function snd(name: string): AudioBuffer | undefined {
  return sounds.get(name);
}

function loadImage(name: string, url: string): Promise<void> {
  return new Promise((resolve, reject) => {
    const i = new Image();
    i.onload = () => { images.set(name, i); resolve(); };
    i.onerror = () => reject(new Error(`failed to load image ${name}`));
    i.src = url;
  });
}

async function loadSound(name: string, url: string): Promise<void> {
  const res = await fetch(url);
  sounds.set(name, await audio().decodeAudioData(await res.arrayBuffer()));
}

export async function loadAll(onProgress?: (f: number) => void) {
  const imgs = Object.entries(imageUrls);
  const snds = Object.entries(soundUrls);
  const total = imgs.length + snds.length;
  let done = 0;
  const tick = () => onProgress?.(++done / total);
  const font = new FontFace('nokia', `url(${fontUrl})`);
  document.fonts.add(await font.load());
  await Promise.all([
    ...imgs.map(([p, u]) => loadImage(baseName(p), u).then(tick)),
    // A sound that fails to decode shouldn't stop the game from starting.
    ...snds.map(([p, u]) => loadSound(baseName(p), u).catch((e) => console.warn(e)).then(tick)),
  ]);
}
