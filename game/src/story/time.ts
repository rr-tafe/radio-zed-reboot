// Story-mode clock: day (explore) → dusk → night (defend) → dawn → next day.

export type Phase = 'day' | 'dusk' | 'night' | 'dawn';

/** Clock in game minutes after midnight. */
export const DAY_START = 6 * 60;
export const DUSK_START = 18 * 60;
export const NIGHT_START = 19 * 60;
/** Game minutes per real second during the day (12 h ≈ 4 min). */
export const DAY_RATE = 3;
/** Fast-forward rate when waiting for nightfall at the radio. */
export const WAIT_RATE = 60;
export const DUSK_SECONDS = 15;
export const DAWN_SECONDS = 8;

export type Moon = 'full' | 'gibbous' | 'half' | 'crescent' | 'new';
const MOON_CYCLE: Moon[] = ['full', 'gibbous', 'half', 'crescent', 'new', 'crescent', 'half', 'gibbous'];

export function moonFor(night: number, offset: number): Moon {
  return MOON_CYCLE[(night - 1 + offset) % MOON_CYCLE.length];
}

/** How dark a night is with this moon (0 = as bright as the original, 1 = black). */
export const MOON_DARKNESS: Record<Moon, number> = {
  full: 0.15,
  gibbous: 0.45,
  half: 0.62,
  crescent: 0.78,
  new: 0.9,
};

export const MOON_LABEL: Record<Moon, string> = {
  full: 'full moon',
  gibbous: 'bright moon',
  half: 'half moon',
  crescent: 'thin moon',
  new: 'no moon',
};

export function clockText(minutes: number): string {
  const m = Math.floor(minutes) % (24 * 60);
  return `${String(Math.floor(m / 60)).padStart(2, '0')}:${String(m % 60).padStart(2, '0')}`;
}
