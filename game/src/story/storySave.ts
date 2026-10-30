// Story-mode save, separate from the Classic save.

import type { ItemId, Loot } from './items';
import type { DoorKind, SiteDef } from './sites';
import type { City } from './city';
import { Survivor, startingGroup } from './group';
import { DAY_START, Phase } from './time';

const KEY = 'radiozed.story.v1';

export type DoorState = DoorKind | 'open';

export interface BaseState {
  site: string;
  revealed: string[];
  doors: Record<string, { state: DoorState; zombies: number; searched: boolean }>;
  searched: string[];
  /** Street lamps built at [left, right] barricades. */
  lamps: [boolean, boolean];
  /** 0–100. At 100 the next night is a siege that can't be held. */
  threat: number;
  /** Nights survived at this base. */
  nights: number;
  /** Shots the player fired today (noise). */
  dayShots: number;
}

export interface BarricadeState { hp: number; max: number; lvl: number }

export interface StorySave {
  version: 1;
  day: number;
  /** Game minutes after midnight. */
  clock: number;
  phase: Phase;
  /** Where in the 8-night moon cycle this run started. */
  moonOffset: number;
  items: Partial<Record<ItemId, number>>;
  base: BaseState | null;
  /** [left, right], as in the original. */
  barricades: [BarricadeState, BarricadeState];
  /** Friends (not including the player). */
  group: Survivor[];
  /** Fallen friends, for the record. */
  fallen: string[];
  /** The last dawn's report, shown on the camp screen. */
  report: string[];
  /** The leader went without food last night (worse aim). */
  leaderHungry: boolean;
  city: City;
  /** Where scavengers go today (a city node id). */
  scavengeTarget: string | null;
}

/** Set by city.ts to avoid an import cycle at module load. */
let makeCity: (seed: number) => City = () => ({ nodes: [], edges: [], current: 'start', visited: ['start'] });
export function setCityGenerator(f: (seed: number) => City) {
  makeCity = f;
}

function fresh(): StorySave {
  return {
    version: 1,
    day: 1,
    clock: DAY_START,
    phase: 'day',
    moonOffset: Math.floor(Math.random() * 8),
    // Everyone starts with a flashlight and one battery.
    items: { batteries: 1 },
    base: null,
    barricades: [{ hp: 100, max: 100, lvl: 0 }, { hp: 100, max: 100, lvl: 0 }],
    group: startingGroup(),
    fallen: [],
    report: [],
    leaderHungry: false,
    city: makeCity(Math.floor(Math.random() * 1e9)),
    scavengeTarget: null,
  };
}

export let story: StorySave = load();

/** Old saves (before the city existed) get one on first use. */
export function ensureCity() {
  if (!story.city || !story.city.nodes.length) story.city = makeCity(Math.floor(Math.random() * 1e9));
}

function load(): StorySave {
  try {
    const raw = localStorage.getItem(KEY);
    if (raw) return { ...fresh(), ...JSON.parse(raw) };
  } catch {
    // Unavailable or corrupt: start fresh.
  }
  return fresh();
}

export function persistStory() {
  try {
    localStorage.setItem(KEY, JSON.stringify(story));
  } catch {
    // Not persisted.
  }
}

export function newStory() {
  story = fresh();
  persistStory();
}

export function hasStory() {
  return story.base !== null;
}

/** State for a site, created on first arrival. */
export function baseFor(site: SiteDef): BaseState {
  if (!story.base || story.base.site !== site.id) story.base = newBase(site);
  return story.base;
}

/** Fresh, unexplored state for a site (used directly for scavenging runs, which aren't saved). */
export function newBase(site: SiteDef): BaseState {
  return {
    site: site.id,
    revealed: [],
    doors: Object.fromEntries(site.doors.map((d) => [d.id, { state: d.kind as DoorState, zombies: d.zombies, searched: false }])),
    searched: [],
    lamps: [false, false],
    threat: 0,
    nights: 0,
    dayShots: 0,
  };
}

export function give(l: Loot) {
  story.items[l.item] = (story.items[l.item] ?? 0) + l.qty;
}

export function has(item: ItemId) {
  return (story.items[item] ?? 0) > 0;
}

export function count(item: ItemId) {
  return story.items[item] ?? 0;
}
