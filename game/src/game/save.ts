// The original kept everything in one Flash SharedObject called "reloaded". This mirrors
// its fields (same names, same 0/1/2 conventions) in localStorage.

import { BOT_SKILLS, PLAYER_SKILLS } from './data';

const KEY = 'radiozed.reloaded.v1';

export interface SaveData {
  visits: number;
  lvl: number;
  maxLvl: number;
  score: number;
  sp: number;
  money: number;
  moneyEarned: number;
  bulletMiss: number;
  bulletHit: number;
  headShoot: number;
  zombieKilled: number;
  bulletShot: number[];
  leftBarricade: number;
  rightBarricade: number;
  leftBarricade_Max: number;
  rightBarricade_Max: number;
  leftBarricade_lvl: number;
  rightBarricade_lvl: number;
  /** [skill][tier] — 2 means bought. */
  playerSkills: number[][];
  bot1Skills: number[][];
  bot2Skills: number[][];
  /** [weapon][buy, upgrade] — 2 means owned. */
  playerWeapons: number[][];
  barricadesUpgrade: number[][];
  /** [row][col] — 1 means achieved. */
  archivement: number[][];
}

export function freshSave(): SaveData {
  const grid = (r: number, c: number) => Array.from({ length: r }, () => new Array(c).fill(0));
  const weapons = grid(9, 2);
  weapons[0][0] = 2;
  return {
    visits: 1,
    lvl: 1,
    maxLvl: 0,
    score: 0,
    sp: 0,
    money: 0,
    moneyEarned: 0,
    bulletMiss: 0,
    bulletHit: 0,
    headShoot: 0,
    zombieKilled: 0,
    bulletShot: new Array(9).fill(0),
    leftBarricade: 100,
    rightBarricade: 100,
    leftBarricade_Max: 100,
    rightBarricade_Max: 100,
    leftBarricade_lvl: 0,
    rightBarricade_lvl: 0,
    playerSkills: grid(7, 3),
    bot1Skills: grid(3, 3),
    bot2Skills: grid(3, 3),
    playerWeapons: weapons,
    barricadesUpgrade: grid(2, 3),
    archivement: grid(7, 6),
  };
}

export let save: SaveData = load();

function load(): SaveData {
  try {
    const raw = localStorage.getItem(KEY);
    if (raw) return { ...freshSave(), ...JSON.parse(raw) };
  } catch {
    // Storage unavailable or corrupt: start fresh.
  }
  return freshSave();
}

export function persist() {
  try {
    localStorage.setItem(KEY, JSON.stringify(save));
  } catch {
    // Private mode etc. — progress just won't survive a reload.
  }
}

export function resetSave() {
  save = freshSave();
  persist();
}

/** Highest bought tier (0 = none, 3 = all) of a [tier] row. */
export function tierOf(row: number[]): number {
  let t = 0;
  while (t < 3 && row[t] === 2) t++;
  return t;
}

/** Derived stats, as Params' constructor computed them from the save. */
export function stats() {
  return computeStats(save);
}

/** Stats for any set of skill purchases (Classic's save, or none at all). */
export function computeStats(src: Pick<SaveData, 'playerSkills' | 'bot1Skills' | 'bot2Skills'>) {
  const p = (i: number) => PLAYER_SKILLS[i].values[tierOf(src.playerSkills[i])];
  const b = (bot: 0 | 1, i: number, key: 'speed' | 'damage' | 'accuracy') =>
    BOT_SKILLS[bot][key][tierOf((bot === 0 ? src.bot1Skills : src.bot2Skills)[i])];
  return {
    player_health: p(0),
    specialPoints: p(1),
    player_accuracy: p(2),
    player_speed: p(3),
    player_recharge: p(4),
    player_zHunter: p(5),
    player_luck: p(6),
    player_damage: 1,
    bot1_speed: b(0, 0, 'speed'),
    bot1_damage: b(0, 1, 'damage'),
    bot1_accuracy: b(0, 2, 'accuracy'),
    bot2_speed: b(1, 0, 'speed'),
    bot2_damage: b(1, 1, 'damage'),
    bot2_accuracy: b(1, 2, 'accuracy'),
  };
}
export type Stats = ReturnType<typeof stats>;
