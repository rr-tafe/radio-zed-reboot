// Story-mode save, separate from the Classic save.

import type { ItemId, Loot } from './items';
import type { DoorKind, SiteDef } from './sites';

const KEY = 'radiozed.story.v1';

export type DoorState = DoorKind | 'open';

export interface BaseState {
  site: string;
  revealed: string[];
  doors: Record<string, { state: DoorState; zombies: number; searched: boolean }>;
  searched: string[];
}

export interface StorySave {
  version: 1;
  day: number;
  items: Partial<Record<ItemId, number>>;
  base: BaseState | null;
}

function fresh(): StorySave {
  return { version: 1, day: 1, items: {}, base: null };
}

export let story: StorySave = load();

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
  if (!story.base || story.base.site !== site.id) {
    story.base = {
      site: site.id,
      revealed: [],
      doors: Object.fromEntries(site.doors.map((d) => [d.id, { state: d.kind as DoorState, zombies: d.zombies, searched: false }])),
      searched: [],
    };
  }
  return story.base;
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
