// Small seeded random generator so a run's city and buildings are reproducible.

export type Rng = () => number;

/** mulberry32 */
export function rng(seed: number): Rng {
  let a = seed >>> 0;
  return () => {
    a = (a + 0x6d2b79f5) >>> 0;
    let t = a;
    t = Math.imul(t ^ (t >>> 15), t | 1);
    t ^= t + Math.imul(t ^ (t >>> 7), t | 61);
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export const pick = <T>(r: Rng, a: readonly T[]): T => a[Math.floor(r() * a.length)];
export const between = (r: Rng, lo: number, hi: number) => lo + Math.floor(r() * (hi - lo + 1));
export const chance = (r: Rng, p: number) => r() < p;

export function shuffle<T>(r: Rng, a: T[]): T[] {
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(r() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}
