// The three layouts hard-coded in PlayLvl.create(), as data. New maps are added here.

type Rect = [x: number, y: number, w: number, h: number];

export interface LevelLayout {
  id: string;
  name: string;
  /** Waves (inclusive) this layout is used for in the original campaign. */
  waves: [number, number];
  backdrop: string;
  collision: string;
  radio: [number, number];
  barricades: [left: number, right: number];
  /** DoorUp positions; the matching DoorDown is 80 px above each. */
  doors: [number, number][];
  markers: { one: Rect; two: Rect; left: Rect; right: Rect };
  bots: { y1: number; y2: number; defs1?: [number, number]; defs2?: [number, number] };
  /** Invisible strips that stop bullets (floors, walls, ground). */
  bulletBlocks: Rect[];
}

const STREET_MARKERS_WIDE = {
  one: [345, 335, 370, 4] as Rect,
  two: [350, 250, 335, 4] as Rect,
  left: [54, 405, 230, 4] as Rect,
  right: [776, 405, 210, 4] as Rect,
};

export const LAYOUTS: LevelLayout[] = [
  {
    id: 'shop',
    name: 'Corner Shop',
    waves: [1, 8],
    backdrop: 'playLvl_ImgBackgr',
    collision: 'playLvl_ImgMap',
    radio: [586, 208],
    barricades: [317, 716],
    doors: [[556, 400], [456, 320]],
    markers: {
      one: [406, 335, 260, 4],
      two: [406, 250, 260, 4],
      left: [54, 405, 260, 4],
      right: [721, 405, 270, 4],
    },
    bots: { y1: 315, y2: 230 },
    bulletBlocks: [
      [415, 272, 242, 18], [415, 352, 242, 18], [0, 432, 1680, 48],
      [400, 290, 17, 27], [400, 365, 17, 33], [655, 292, 17, 25], [655, 372, 17, 25],
    ],
  },
  {
    id: 'apartments',
    name: 'Apartments',
    waves: [9, 18],
    backdrop: 'playLvl_ImgBackgr2',
    collision: 'playLvl_ImgMap2',
    radio: [446, 128],
    barricades: [280, 746],
    doors: [[583, 400], [439, 320], [583, 240]],
    markers: STREET_MARKERS_WIDE,
    bots: { y1: 315, y2: 230, defs1: [335, 707], defs2: [346, 695] },
    bulletBlocks: [
      [397, 192, 259, 25], [384, 210, 20, 30], [653, 210, 20, 30],
      [367, 272, 322, 25], [352, 290, 20, 30], [686, 290, 20, 30],
      [350, 352, 355, 25], [336, 368, 20, 30], [700, 368, 20, 30],
      [0, 432, 1680, 48],
    ],
  },
  {
    id: 'tower',
    name: 'Tower Block',
    waves: [19, 60],
    backdrop: 'playLvl_ImgBackgr3',
    collision: 'playLvl_ImgMap3',
    radio: [446, 128],
    barricades: [280, 746],
    doors: [[362, 400], [508, 320], [652, 240]],
    markers: STREET_MARKERS_WIDE,
    bots: { y1: 315, y2: 230, defs1: [330, 707], defs2: [330, 707] },
    bulletBlocks: [
      [350, 192, 355, 25], [336, 210, 20, 30], [700, 210, 20, 30],
      [350, 272, 355, 25], [336, 290, 20, 30], [700, 290, 20, 30],
      [350, 352, 355, 25], [336, 368, 20, 30], [700, 368, 20, 30],
      [0, 432, 1280, 48],
    ],
  },
];

export function layoutForWave(wave: number): LevelLayout {
  return LAYOUTS.find((l) => wave >= l.waves[0] && wave <= l.waves[1]) ?? LAYOUTS[LAYOUTS.length - 1];
}
