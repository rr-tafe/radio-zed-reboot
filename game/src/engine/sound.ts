import { audio, snd } from './assets';

let master: GainNode | null = null;
let volume = 0.5;
let muted = false;

function out(): GainNode {
  if (!master) {
    master = audio().createGain();
    master.gain.value = muted ? 0 : volume;
    master.connect(audio().destination);
  }
  return master;
}

/** FlxG.play equivalent. */
export function play(name: string, vol = 1) {
  const buf = snd(name);
  if (!buf) return;
  const ctx = audio();
  if (ctx.state === 'suspended') void ctx.resume();
  const src = ctx.createBufferSource();
  src.buffer = buf;
  const g = ctx.createGain();
  g.gain.value = vol;
  src.connect(g).connect(out());
  src.start();
}

export function changeVolume(delta: number) {
  volume = Math.max(0, Math.min(1, volume + delta));
  muted = false;
  out().gain.value = volume;
}

export function toggleMute() {
  muted = !muted;
  out().gain.value = muted ? 0 : volume;
}

export function unlockAudio() {
  const ctx = audio();
  if (ctx.state === 'suspended') void ctx.resume();
}
