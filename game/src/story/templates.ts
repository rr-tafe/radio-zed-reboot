// Where things can go in each of the three original buildings. Measured from the backdrop
// art (playLvl_ImgBackgr, ImgBackgr2, ImgBackgr3). The generator fills these slots.

type Rect = [x: number, y: number, w: number, h: number];

export type LootTag = 'kitchen' | 'living' | 'storage' | 'office' | 'bar' | 'tools' | 'guns' | 'medical';

export interface DoorSlot {
  rect: Rect;
  /** The backdrop has no door drawn here: stamp the Corner Shop's door art on the wall. */
  decal?: boolean;
}

export interface PropSlot { name: string; rect: Rect; tag: LootTag }

export interface SiteTemplate {
  layout: string; // LevelLayout id
  start: [number, number];
  floors: { id: string; rect: Rect }[];
  doors: DoorSlot[];
  props: PropSlot[];
}

/** The closed door in the Corner Shop art, reused as a decal elsewhere. */
export const DOOR_DECAL = { image: 'playLvl_ImgBackgr', rect: [577, 398, 21, 34] as Rect };

export const TEMPLATES: Record<'shop' | 'apartments' | 'tower', SiteTemplate> = {
  shop: {
    layout: 'shop',
    start: [430, 400],
    floors: [
      { id: 'ground', rect: [416, 362, 240, 70] },
      { id: 'first', rect: [416, 286, 240, 66] },
    ],
    doors: [
      { rect: [578, 399, 19, 33] },
      { rect: [477, 318, 20, 33] },
      { rect: [578, 318, 19, 33] },
      { rect: [476, 240, 20, 32] },
    ],
    props: [
      { name: 'Bar shelves', rect: [421, 371, 126, 61], tag: 'bar' },
      { name: 'Vending machine', rect: [608, 382, 39, 50], tag: 'kitchen' },
      { name: 'Crates', rect: [501, 322, 40, 30], tag: 'storage' },
      { name: 'Bookshelf', rect: [608, 313, 32, 39], tag: 'office' },
      { name: 'Roof crate', rect: [520, 248, 24, 24], tag: 'storage' },
    ],
  },
  apartments: {
    layout: 'apartments',
    start: [372, 400],
    floors: [
      { id: 'ground', rect: [352, 368, 352, 64] },
      { id: 'middle', rect: [368, 288, 320, 64] },
      { id: 'top', rect: [400, 208, 256, 64] },
    ],
    doors: [
      { rect: [600, 399, 21, 33], decal: true },
      { rect: [600, 319, 21, 33], decal: true },
      { rect: [600, 239, 21, 33], decal: true },
    ],
    props: [
      { name: 'Wall shelf', rect: [360, 380, 40, 52], tag: 'kitchen' },
      { name: 'Kitchen cupboards', rect: [487, 390, 40, 42], tag: 'kitchen' },
      { name: 'Fridge', rect: [527, 386, 24, 46], tag: 'kitchen' },
      { name: 'Corner shelf', rect: [640, 380, 32, 52], tag: 'medical' },
      { name: 'Bedside drawer', rect: [368, 318, 24, 34], tag: 'living' },
      { name: 'Cabinet', rect: [498, 306, 30, 46], tag: 'living' },
      { name: 'Wall safe', rect: [538, 318, 22, 34], tag: 'office' },
      { name: 'TV cabinet', rect: [627, 306, 56, 46], tag: 'living' },
      { name: 'Wardrobe', rect: [405, 228, 20, 44], tag: 'living' },
      { name: 'Side table', rect: [509, 248, 44, 24], tag: 'storage' },
      { name: 'Tool rack', rect: [636, 232, 26, 40], tag: 'tools' },
    ],
  },
  tower: {
    layout: 'tower',
    start: [420, 400],
    floors: [
      { id: 'ground', rect: [352, 368, 352, 64] },
      { id: 'middle', rect: [352, 288, 352, 64] },
      { id: 'top', rect: [352, 208, 352, 64] },
    ],
    doors: [
      { rect: [386, 398, 20, 34] },
      { rect: [386, 318, 20, 34] },
      { rect: [530, 318, 20, 34] },
      { rect: [530, 238, 20, 34] },
      { rect: [674, 238, 20, 34] },
    ],
    props: [
      { name: 'Glass cabinet', rect: [410, 390, 37, 42], tag: 'living' },
      { name: 'TV stand', rect: [497, 400, 35, 32], tag: 'living' },
      { name: 'Rifle on the wall', rect: [552, 392, 30, 40], tag: 'guns' },
      { name: 'Bookcase', rect: [620, 390, 28, 42], tag: 'office' },
      { name: 'Wall shelf', rect: [664, 392, 40, 40], tag: 'medical' },
      { name: 'Dining table', rect: [413, 318, 45, 34], tag: 'kitchen' },
      { name: 'Drawers', rect: [470, 318, 26, 34], tag: 'living' },
      { name: 'Fridge', rect: [557, 300, 26, 52], tag: 'kitchen' },
      { name: 'Kitchen units', rect: [597, 300, 43, 52], tag: 'kitchen' },
      { name: 'Gun rack', rect: [362, 208, 132, 64], tag: 'guns' },
      { name: 'Shelf of boxes', rect: [606, 222, 48, 50], tag: 'tools' },
    ],
  },
};
