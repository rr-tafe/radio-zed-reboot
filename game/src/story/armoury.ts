// Story-mode armoury: weapons are found, not bought, and draw on per-calibre reserves.

import type { Armoury } from '../game/player';
import { CALIBRE } from './items';
import { story } from './storySave';

export const storyArmoury: Armoury = {
  owns: (i) => i === 0 || (story.items[`weapon:${i}`] ?? 0) > 0,
  upgraded: () => false,
  take(i, n) {
    if (i === 0) return n;
    const id = CALIBRE[i];
    const got = Math.min(n, story.items[id] ?? 0);
    story.items[id] = (story.items[id] ?? 0) - got;
    return got;
  },
  reserve: (i) => (i === 0 ? Infinity : story.items[CALIBRE[i]] ?? 0),
};
