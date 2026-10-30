// Rolls a site from a template: what each door hides and how it's secured, and what each
// prop holds. Seeded, so revisiting a saved run rebuilds the same building.

import { WEAPONS } from '../game/data';
import { CALIBRE, Loot } from './items';
import { Rng, between, chance, pick, rng, shuffle } from './rng';
import { DoorDef, DoorKind, PropDef, SiteDef } from './sites';
import { LootTag, SiteTemplate, TEMPLATES } from './templates';

export type SiteType = 'shop' | 'apartments' | 'tower';

export const SITE_NAMES: Record<SiteType, string[]> = {
  shop: ['Corner Shop', 'Off-licence', 'Pawn Shop', 'Hardware Store'],
  apartments: ['Apartments', 'Boarding House', 'Flats on Elm St'],
  tower: ['Tower Block', 'Old Hotel', 'Office Block'],
};

/** Weighted loot by prop tag. */
const TABLES: Record<LootTag, [weight: number, roll: (r: Rng, d: number) => Loot][]> = {
  kitchen: [[5, (r) => ({ item: 'food', qty: between(r, 1, 4) })], [1, (r) => ({ item: 'batteries', qty: between(r, 1, 2) })], [1, (r) => ({ item: 'cash', qty: between(r, 5, 30) })]],
  living: [[3, (r) => ({ item: 'cash', qty: between(r, 10, 60) })], [2, () => ({ item: 'batteries', qty: 1 })], [2, (r) => ({ item: 'food', qty: between(r, 1, 2) })], [1, () => ({ item: 'meds', qty: 1 })]],
  storage: [[4, (r) => ({ item: 'materials', qty: between(r, 2, 5) })], [2, (r) => ({ item: 'food', qty: between(r, 1, 3) })], [1, (r) => ({ item: 'ammo9', qty: between(r, 10, 25) })]],
  office: [[3, (r) => ({ item: 'cash', qty: between(r, 20, 90) })], [2, (r) => ({ item: 'batteries', qty: between(r, 1, 2) })], [1, (r) => ({ item: 'ammo50', qty: between(r, 6, 16) })]],
  bar: [[3, (r) => ({ item: 'food', qty: between(r, 1, 3) })], [3, (r) => ({ item: 'cash', qty: between(r, 10, 40) })]],
  tools: [[5, (r) => ({ item: 'materials', qty: between(r, 3, 6) })], [1, (r) => ({ item: 'batteries', qty: between(r, 1, 3) })]],
  medical: [[4, (r) => ({ item: 'meds', qty: between(r, 1, 2) })], [1, () => ({ item: 'food', qty: 1 })]],
  guns: [[1, (r, d) => gunLoot(r, d)]],
};

/** A weapon worth the danger, with some rounds for it. */
function gunLoot(r: Rng, danger: number): Loot {
  const pool = danger >= 3 ? [5, 6, 7, 8] : danger >= 2 ? [3, 4, 5, 6] : [1, 2, 3];
  return { item: `weapon:${pick(r, pool)}`, qty: 1 };
}

function roll(r: Rng, tag: LootTag, danger: number): Loot[] {
  const table = TABLES[tag];
  const total = table.reduce((s, [w]) => s + w, 0);
  const n = tag === 'guns' ? 1 : between(r, 1, 2);
  const out: Loot[] = [];
  for (let i = 0; i < n; i++) {
    let x = r() * total;
    for (const [w, f] of table) {
      if ((x -= w) <= 0) {
        out.push(f(r, danger));
        break;
      }
    }
  }
  // Guns come with ammo for themselves.
  for (const l of [...out]) {
    if (l.item.startsWith('weapon:')) out.push({ item: CALIBRE[Number(l.item.slice(7))], qty: between(r, 20, 45) });
  }
  return out;
}

/** A scavenging party's haul from a location: `rolls` draws on that kind of place's tables. */
export function scavengeLoot(node: { type: string; danger: number }, rolls: number, r: Rng): Loot[] {
  const type = (node.type === 'station' ? 'tower' : node.type) as SiteType;
  const tags = [...ROOM_TAGS[type], ...TEMPLATES[type].props.map((p) => p.tag)];
  const merged = new Map<string, number>();
  for (let i = 0; i < rolls; i++) {
    for (const l of roll(r, pick(r, tags), node.danger)) {
      // Keys and notes only make sense inside the building itself.
      if (l.item.startsWith('key:')) continue;
      merged.set(l.item, (merged.get(l.item) ?? 0) + l.qty);
    }
  }
  return [...merged].map(([item, qty]) => ({ item: item as Loot['item'], qty: item.startsWith('weapon:') ? 1 : qty }));
}

/** What tends to be behind doors here. */
const ROOM_TAGS: Record<SiteType, LootTag[]> = {
  shop: ['storage', 'office', 'kitchen'],
  apartments: ['living', 'kitchen', 'medical', 'storage'],
  tower: ['storage', 'office', 'guns', 'medical', 'living'],
};
const ROOM_NAMES: Record<LootTag, string[]> = {
  storage: ['Storeroom', 'Cupboard', 'Utility room'],
  office: ['Office', 'Study'],
  kitchen: ['Pantry', 'Kitchen'],
  living: ['Bedroom', 'Flat', 'Back room'],
  medical: ['Bathroom', 'First-aid room'],
  guns: ['Locker room', 'Gun closet'],
  tools: ['Workshop'],
  bar: ['Cellar'],
};

export function generateSite(id: string, type: SiteType, name: string, danger: number, seed: number): SiteDef {
  const r = rng(seed);
  const t: SiteTemplate = TEMPLATES[type];

  const doors: DoorDef[] = t.doors.map((slot, i) => {
    const tag = pick(r, ROOM_TAGS[type]);
    const kind: DoorKind = pick(r, ['closed', 'closed', 'locked', 'boarded'] as DoorKind[]);
    const zombieOdds = 0.25 + 0.12 * danger + (type === 'tower' ? 0.1 : 0);
    return {
      id: `door${i}`,
      name: pick(r, ROOM_NAMES[tag]),
      rect: slot.rect,
      decal: slot.decal,
      kind,
      key: kind === 'locked' ? `room${i}` : undefined,
      keyhole: kind !== 'boarded' && chance(r, 0.65),
      zombies: chance(r, zombieOdds) ? between(r, 1, Math.min(3, 1 + danger)) : 0,
      loot: [...roll(r, tag, danger), ...roll(r, tag, danger)],
    };
  });

  const props: PropDef[] = t.props.map((p, i) => ({
    id: `prop${i}`,
    name: p.name,
    rect: p.rect,
    loot: chance(r, 0.8) ? roll(r, p.tag, danger) : [],
  }));

  // Each locked door's key is hidden in some prop.
  const hiding = shuffle(r, [...props]);
  doors.filter((d) => d.key).forEach((d, i) => {
    const prop = hiding[i % hiding.length];
    prop.loot.push({ item: `key:${d.key!}`, qty: 1 });
    prop.text = `A key is tucked away in the ${prop.name.toLowerCase()}.`;
  });

  return { id, name, layout: t.layout, start: t.start, floors: t.floors, doors, props };
}

/** The names of weapons a site's gun props could hold, for the city map's hints. */
export const weaponName = (i: number) => WEAPONS[i].name;
