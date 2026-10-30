// Balance tables, copied from source_recovered/radiozed/Params.as and PlayerArm.as.

export interface WeaponDef {
  name: string;
  arm: string; // arm_with_pistol_* sprite
  frameW: number;
  frameH: number;
  shiftX1: number; // arm offset when facing left
  shiftX2: number; // ... facing right
  shiftY1: number;
  mag: number;
  reload: number;
  delay: number;
  damage: [number, number]; // [base, upgraded]
  price: [number, number]; // [buy, upgrade]
  auto: boolean; // hold to fire
  sound: string;
  volume: number;
}

export const WEAPONS: WeaponDef[] = [
  { name: 'Glock-17', arm: 'arm_with_pistol_glock', frameW: 50, frameH: 50, shiftX1: -17, shiftX2: -16, shiftY1: -11, mag: 15, reload: 4, delay: 0, damage: [10, 15], price: [0, 400], auto: false, sound: 'Player_Snd9mm', volume: 1 },
  { name: 'Desert Eagle', arm: 'arm_with_pistol_eagle', frameW: 50, frameH: 50, shiftX1: -17, shiftX2: -16, shiftY1: -11, mag: 8, reload: 5, delay: 0, damage: [15, 21], price: [800, 1000], auto: false, sound: 'Player_Snd5_7mm', volume: 0.5 },
  { name: 'Uzi', arm: 'arm_with_pistol_uzi', frameW: 50, frameH: 50, shiftX1: -17, shiftX2: -16, shiftY1: -11, mag: 40, reload: 5, delay: 0.09, damage: [6, 10], price: [1400, 1800], auto: true, sound: 'Player_Snd6', volume: 1 },
  { name: 'HK G36', arm: 'arm_with_pistol_G36', frameW: 52, frameH: 50, shiftX1: -17, shiftX2: -16, shiftY1: -11, mag: 35, reload: 6, delay: 0.15, damage: [8, 12], price: [2400, 3000], auto: true, sound: 'Player_SndM16', volume: 1 },
  { name: 'Steyr AUG', arm: 'arm_with_pistol_steyr', frameW: 62, frameH: 50, shiftX1: -22, shiftX2: -23, shiftY1: -11, mag: 30, reload: 4, delay: 0.15, damage: [10, 15], price: [3800, 4200], auto: true, sound: 'Player_Snd4_6', volume: 1 },
  { name: 'AK-47', arm: 'arm_with_pistol_akm', frameW: 62, frameH: 50, shiftX1: -22, shiftX2: -23, shiftY1: -11, mag: 30, reload: 7, delay: 0.2, damage: [13, 16], price: [4800, 5800], auto: true, sound: 'Player_Snd357', volume: 1 },
  { name: 'M-16', arm: 'arm_with_pistol_m16', frameW: 62, frameH: 50, shiftX1: -22, shiftX2: -23, shiftY1: -11, mag: 30, reload: 6, delay: 0.14, damage: [15, 18], price: [6400, 7200], auto: true, sound: 'Player_SndM16', volume: 1 },
  { name: 'SM SSG 69', arm: 'arm_with_pistol_ssg', frameW: 72, frameH: 57, shiftX1: -27, shiftX2: -28, shiftY1: -14, mag: 6, reload: 5, delay: 1, damage: [70, 100], price: [12000, 14000], auto: true, sound: 'Player_SndSvg', volume: 1 },
  { name: 'FN M249 SAW', arm: 'arm_with_pistol_m249', frameW: 72, frameH: 57, shiftX1: -27, shiftX2: -28, shiftY1: -14, mag: 100, reload: 16, delay: 0.08, damage: [15, 25], price: [24000, 28000], auto: true, sound: 'Player_SndMGun', volume: 1 },
];

/** Zombies per spawner per wave (Params.numberOfZombie); total is ×2. Index 0 unused. */
const ZOMBIES = [0, 15, 15, 10, 16, 15, 20, 25, 20, 32, 35, 30, 35, 40, 35, 35, 35, 40, 25, 40, 45, 50, 60, 60, 60, 65, 60, 70, 75, 80, 80, 65, 60, 80, 85, 80];
export function zombiesPerSpawner(wave: number): number {
  return wave < ZOMBIES.length ? ZOMBIES[wave] : 100;
}

/** Seconds between spawns per wave (Params.spawnersArray_for_spawn). */
const SPAWN = [0, 9, 8, 2, 5, 1, 3, 3, 2, 3, 3, 1, 3, 2, 3, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 1, 1, 2, 3, 1, 2, 2, 2, 3, 2, 1];
const SPAWN_REPEAT = [2, 2, 2, 3, 2, 1];
export function spawnInterval(wave: number): number {
  return wave < SPAWN.length ? SPAWN[wave] : SPAWN_REPEAT[(wave - SPAWN.length) % SPAWN_REPEAT.length];
}

/** The original's last wave before the win screen (17 Sep build). */
export const FINAL_WAVE = 60;

/** Skill tables: value at [none, tier1, tier2, tier3]. Costs 5/10/15 SP. */
export const SKILL_COST = [5, 10, 15];
export const PLAYER_SKILLS = [
  { key: 'health', label: 'Health', values: [100, 125, 150, 200] },
  { key: 'educability', label: 'Educability', values: [8, 9, 11, 12] },
  { key: 'accuracy', label: 'Accuracy', values: [20, 15, 10, 5] },
  { key: 'speed', label: 'Speed Walking', values: [100, 115, 130, 150] },
  { key: 'recharge', label: 'Reload Speed', values: [1, 0.8, 0.6, 0.4] },
  { key: 'zHunter', label: 'Headshot Damage', values: [1.2, 1.4, 1.6, 2] },
  { key: 'luck', label: 'Luck', values: [20, 25, 30, 35] },
] as const;
export const BOT_SKILLS = [
  // [speed, damage, spread]
  { name: 'Willson', speed: [60, 70, 80, 100], damage: [10, 15, 20, 25], accuracy: [20, 15, 10, 5] },
  { name: 'Summer', speed: [60, 70, 80, 100], damage: [20, 30, 40, 50], accuracy: [15, 10, 5, 2] },
];

export const BARRICADE_PRICE = [1000, 3000, 9000];
export const BARRICADE_MAX = [100, 150, 200, 250];
export const REPAIR = [
  { price: 50, fraction: 0.1 },
  { price: 150, fraction: 0.3 },
  { price: 500, fraction: 1 },
];

/** Zombie walk speeds (two archetypes share the 18 skins). */
export const SLOW_SPEEDS = [10, 16, 14, 17, 18, 19, 20, 30];
export const FAST_SPEEDS = [20, 25, 27, 30, 37, 40];
export const FAST_SKINS = new Set([2, 3, 5, 6, 7]);

export const TEXT_COLOR = 14868183; // 0xE2DCD7
export const TEXT_SHADOW = 2309720; // 0x233E58
