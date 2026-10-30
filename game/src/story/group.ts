// The group of friends. You play the leader; up to MAX_FRIENDS others can join. Each day
// every friend gets a job; guards stand on the floors as partners (the original's two
// partner slots). Deaths are permanent.

import { BOT_SKILLS } from '../game/data';
import type { Stats } from '../game/save';

export type Job = 'guard' | 'rest' | 'build' | 'scavenge';
export const JOBS: Job[] = ['guard', 'rest', 'build', 'scavenge'];
export const JOB_LABEL: Record<Job, string> = { guard: 'Guard', rest: 'Rest', build: 'Build', scavenge: 'Scav' };

export const MAX_FRIENDS = 4;
export const MAX_GUARDS = 2;

export interface Survivor {
  id: string;
  name: string;
  /** Partner kind: 1 = AK and Willson's sprite, 2 = SSG and Summer's sprite. */
  kind: 1 | 2;
  hp: number;
  maxHp: number;
  job: Job;
  /** Skill tiers 0–3 for [speed, damage, accuracy], as in the original's partner skills. */
  skills: [number, number, number];
  hungry: boolean;
}

/** Survivors who can be found and join. */
const RECRUIT_NAMES = ['Marta', 'Dev', 'Ollie', 'June', 'Kofi', 'Rosa', 'Theo', 'Imani', 'Pete', 'Ana', 'Sami', 'Lou'];

export function recruit(r: () => number, taken: string[]): Survivor {
  const free = RECRUIT_NAMES.filter((n) => !taken.includes(n));
  const name = free.length ? free[Math.floor(r() * free.length)] : `Survivor ${taken.length + 1}`;
  const kind = (r() < 0.5 ? 1 : 2) as 1 | 2;
  const tier = () => (r() < 0.3 ? 1 : 0);
  const maxHp = 100;
  return {
    id: name.toLowerCase().replace(/\s+/g, '-'), name, kind, hp: 50 + Math.floor(r() * 40), maxHp,
    job: 'rest', skills: [tier(), tier(), tier()], hungry: false,
  };
}

export function startingGroup(): Survivor[] {
  return [
    { id: 'willson', name: 'Willson', kind: 1, hp: 100, maxHp: 100, job: 'guard', skills: [0, 0, 0], hungry: false },
    { id: 'summer', name: 'Summer', kind: 2, hp: 100, maxHp: 100, job: 'guard', skills: [0, 0, 0], hungry: false },
  ];
}

/** Partner stats for a survivor, using the original's tables. Hunger costs accuracy. */
export function partnerStats(s: Survivor, base: Stats): Stats {
  const t = BOT_SKILLS[s.kind - 1];
  const spread = t.accuracy[s.skills[2]] * (s.hungry ? 1.5 : 1);
  const own = s.kind === 1
    ? { bot1_speed: t.speed[s.skills[0]], bot1_damage: t.damage[s.skills[1]], bot1_accuracy: spread }
    : { bot2_speed: t.speed[s.skills[0]], bot2_damage: t.damage[s.skills[1]], bot2_accuracy: spread };
  return { ...base, ...own };
}
