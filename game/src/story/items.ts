// Things that can be found while exploring. Resources match docs/STORY_MODE.md.

export type ItemId = 'food' | 'ammo9' | 'materials' | 'meds' | 'cash' | 'batteries' | `key:${string}` | `note:${string}`;

export interface Loot { item: ItemId; qty: number }

/** Resources shown on the HUD, in order. */
export const RESOURCES: { id: ItemId; label: string }[] = [
  { id: 'food', label: 'Food' },
  { id: 'ammo9', label: '9mm' },
  { id: 'materials', label: 'Materials' },
  { id: 'meds', label: 'Meds' },
  { id: 'batteries', label: 'Batteries' },
  { id: 'cash', label: 'Cash' },
];

const NAMES: Record<string, string> = {
  food: 'food', ammo9: '9mm rounds', materials: 'materials', meds: 'medicine', cash: 'cash', batteries: 'batteries',
};

export function describe(l: Loot): string {
  if (l.item.startsWith('key:')) return `a key (${l.item.slice(4)})`;
  if (l.item.startsWith('note:')) return 'a note';
  if (l.item === 'cash') return `$${l.qty}`;
  return `${l.qty} ${NAMES[l.item] ?? l.item}`;
}
