// Explorable data for story-mode bases. The Corner Shop is hand-placed on the original art
// (measured from playLvl_ImgBackgr); generated sites will produce the same structures.

import type { Loot } from './items';

type Rect = [x: number, y: number, w: number, h: number];

/** A floor of the building, hidden under fog until someone has stood on it. */
export interface FloorDef { id: string; rect: Rect }

export type DoorKind = 'closed' | 'locked' | 'boarded';

/** A door in the back wall leading to a room the player can't see into. */
export interface DoorDef {
  id: string;
  name: string;
  rect: Rect;
  /** No door in the backdrop art here; draw the reused door decal. */
  decal?: boolean;
  kind: DoorKind;
  keyhole: boolean;
  /** Item that opens a locked door. */
  key?: string;
  zombies: number;
  loot: Loot[];
  /** Shown when the room is searched. */
  text?: string;
}

/** Something visible in the building that can be searched. */
export interface PropDef { id: string; name: string; rect: Rect; loot: Loot[]; text?: string }

export interface SiteDef {
  id: string;
  name: string;
  layout: string; // LevelLayout id
  start: [number, number];
  floors: FloorDef[];
  doors: DoorDef[];
  props: PropDef[];
}

export const CORNER_SHOP: SiteDef = {
  id: 'corner-shop',
  name: 'Corner Shop',
  layout: 'shop',
  start: [430, 400],
  floors: [
    { id: 'ground', rect: [416, 362, 240, 70] },
    { id: 'first', rect: [416, 286, 240, 66] },
  ],
  doors: [
    {
      id: 'storeroom', name: 'Storeroom', rect: [578, 399, 19, 33], kind: 'closed', keyhole: true, zombies: 1,
      loot: [{ item: 'weapon:2', qty: 1 }, { item: 'ammo9', qty: 40 }, { item: 'food', qty: 4 }, { item: 'materials', qty: 2 }],
    },
    {
      id: 'office', name: 'Office', rect: [477, 318, 20, 33], kind: 'locked', key: 'office', keyhole: true, zombies: 0,
      loot: [{ item: 'weapon:1', qty: 1 }, { item: 'ammo50', qty: 16 }, { item: 'cash', qty: 80 }, { item: 'meds', qty: 1 }, { item: 'note:owner', qty: 1 }],
      text: 'A note on the desk: "Radio said head north. Gone to my sister\'s."',
    },
    {
      id: 'washroom', name: 'Washroom', rect: [578, 318, 19, 33], kind: 'closed', keyhole: false, zombies: 2,
      loot: [{ item: 'meds', qty: 2 }],
    },
    {
      id: 'hut', name: 'Roof hut', rect: [476, 240, 20, 32], kind: 'boarded', keyhole: false, zombies: 0,
      loot: [{ item: 'materials', qty: 5 }, { item: 'batteries', qty: 2 }, { item: 'food', qty: 2 }],
    },
  ],
  props: [
    {
      id: 'bar', name: 'Bar shelves', rect: [421, 371, 126, 61],
      loot: [{ item: 'food', qty: 2 }, { item: 'cash', qty: 15 }, { item: 'key:office', qty: 1 }],
      text: 'A key is taped under the counter.',
    },
    { id: 'vending', name: 'Vending machine', rect: [608, 382, 39, 50], loot: [{ item: 'food', qty: 3 }, { item: 'cash', qty: 22 }] },
    { id: 'crates', name: 'Crates', rect: [501, 322, 40, 30], loot: [{ item: 'materials', qty: 4 }] },
    { id: 'bookshelf', name: 'Bookshelf', rect: [608, 313, 32, 39], loot: [{ item: 'batteries', qty: 2 }] },
    { id: 'roofcrate', name: 'Roof crate', rect: [520, 248, 24, 24], loot: [{ item: 'materials', qty: 2 }, { item: 'food', qty: 1 }] },
  ],
};
