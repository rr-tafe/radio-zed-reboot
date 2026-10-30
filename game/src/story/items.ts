// Things that can be found while exploring. Resources match docs/STORY_MODE.md.

import { WEAPONS } from '../game/data';

export type AmmoId = 'ammo9' | 'ammo50' | 'ammo556' | 'ammo762';
export type ItemId = 'food' | AmmoId | 'materials' | 'meds' | 'cash' | 'batteries'
  | `weapon:${number}` | `key:${string}` | `note:${string}`;

/** Calibre for each weapon in WEAPONS order. The Glock (0) never runs dry in story mode. */
export const CALIBRE: AmmoId[] = ['ammo9', 'ammo50', 'ammo9', 'ammo556', 'ammo556', 'ammo762', 'ammo556', 'ammo762', 'ammo556'];

export const AMMO_LABEL: Record<AmmoId, string> = { ammo9: '9mm', ammo50: '.50 AE', ammo556: '5.56', ammo762: '7.62' };

export interface Loot { item: ItemId; qty: number }

/** Resources shown on the HUD, in order. */
export const RESOURCES: { id: ItemId; label: string }[] = [
  { id: 'food', label: 'Food' },
  { id: 'materials', label: 'Materials' },
  { id: 'meds', label: 'Meds' },
  { id: 'batteries', label: 'Batteries' },
  { id: 'cash', label: 'Cash' },
];

const NAMES: Record<string, string> = {
  food: 'food', materials: 'materials', meds: 'medicine', cash: 'cash', batteries: 'batteries',
  ammo9: '9mm rounds', ammo50: '.50 AE rounds', ammo556: '5.56 rounds', ammo762: '7.62 rounds',
};

export function describe(l: Loot): string {
  if (l.item.startsWith('key:')) return `a key (${l.item.slice(4)})`;
  if (l.item.startsWith('weapon:')) {
    const name = WEAPONS[Number(l.item.slice(7))].name;
    return `${/^[AEIOU]/.test(name) ? 'an' : 'a'} ${name}`;
  }
  if (l.item.startsWith('note:')) return 'a note';
  if (l.item === 'cash') return `$${l.qty}`;
  return `${l.qty} ${NAMES[l.item] ?? l.item}`;
}
