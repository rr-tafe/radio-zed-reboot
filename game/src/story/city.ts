// The run's city: columns of locations from the Corner Shop (start) to the Radio Station
// (the broadcast's source). Each move goes one column further along the signal's bearing.

import { SITE_NAMES, SiteType, generateSite } from './generate';
import { describe } from './items';
import { Rng, between, pick, rng } from './rng';
import { CORNER_SHOP, SiteDef } from './sites';
import { ensureCity, setCityGenerator, story } from './storySave';

export type NodeType = SiteType | 'station';

export interface CityNode {
  id: string;
  type: NodeType;
  name: string;
  col: number;
  row: number;
  /** 0 (start) … 4: more zombies inside, better guns. */
  danger: number;
  seed: number;
}

export interface City {
  nodes: CityNode[];
  edges: [string, string][];
  current: string;
  visited: string[];
}

export const COLUMNS = 6;

export function generateCity(seed: number): City {
  const r: Rng = rng(seed);
  const nodes: CityNode[] = [{ id: 'start', type: 'shop', name: 'Corner Shop', col: 0, row: 1, danger: 0, seed: 0 }];
  const used = new Set(['Corner Shop']);
  for (let col = 1; col < COLUMNS - 1; col++) {
    const count = between(r, 2, 3);
    const rows = count === 3 ? [0, 1, 2] : pick(r, [[0, 1], [1, 2], [0, 2]]);
    for (const row of rows) {
      const type: SiteType = pick(r, ['shop', 'apartments', 'apartments', 'tower', 'tower'] as SiteType[]);
      let name = pick(r, SITE_NAMES[type]);
      for (let k = 0; used.has(name) && k < 6; k++) name = pick(r, SITE_NAMES[type]);
      if (used.has(name)) name = `${name} ${col}`;
      used.add(name);
      nodes.push({ id: `n${col}-${row}`, type, name, col, row, danger: Math.min(4, col), seed: Math.floor(r() * 1e9) });
    }
  }
  nodes.push({ id: 'station', type: 'station', name: 'Radio Station', col: COLUMNS - 1, row: 1, danger: 4, seed: 0 });

  // Every node links forward to one or two in the next column; every node is reachable.
  const edges: [string, string][] = [];
  for (let col = 0; col < COLUMNS - 1; col++) {
    const here = nodes.filter((n) => n.col === col);
    const next = nodes.filter((n) => n.col === col + 1);
    const linked = new Set<string>();
    for (const a of here) {
      const near = [...next].sort((x, y) => Math.abs(x.row - a.row) - Math.abs(y.row - a.row));
      const n = Math.min(near.length, between(r, 1, 2));
      for (const b of near.slice(0, n)) {
        edges.push([a.id, b.id]);
        linked.add(b.id);
      }
    }
    for (const b of next) {
      if (!linked.has(b.id)) {
        const a = [...here].sort((x, y) => Math.abs(x.row - b.row) - Math.abs(y.row - b.row))[0];
        edges.push([a.id, b.id]);
      }
    }
  }
  return { nodes, edges, current: 'start', visited: ['start'] };
}

setCityGenerator(generateCity);

export function currentNode(): CityNode {
  ensureCity();
  return story.city.nodes.find((n) => n.id === story.city.current)!;
}

export function nextNodes(): CityNode[] {
  const ids = story.city.edges.filter(([a]) => a === story.city.current).map(([, b]) => b);
  return story.city.nodes.filter((n) => ids.includes(n.id));
}

export function siteFor(node: CityNode): SiteDef {
  if (node.id === 'start') return CORNER_SHOP;
  return generateSite(node.id, node.type === 'station' ? 'tower' : node.type, node.name, node.danger, node.seed);
}

export type Departure = 'flee' | 'leave';

const CONSUMABLES = ['food', 'materials', 'meds', 'batteries', 'cash', 'ammo9', 'ammo50', 'ammo556', 'ammo762'] as const;
/** Materials each person can carry when leaving in good order. */
const CARRY_MATERIALS = 6;

/** Move the group to `node`. Fleeing a siege loses half of everything; leaving loses bulky materials. */
export function travelTo(node: CityNode, how: Departure): string[] {
  const report: string[] = [];
  if (how === 'flee') {
    const lost: string[] = [];
    for (const id of CONSUMABLES) {
      const have = story.items[id] ?? 0;
      const drop = Math.ceil(have / 2);
      if (drop > 0) {
        story.items[id] = have - drop;
        lost.push(describe({ item: id, qty: drop }));
      }
    }
    report.push('You ran with whatever you could grab.');
    if (lost.length) report.push(`Left behind: ${lost.join(', ')}.`);
  } else {
    const cap = CARRY_MATERIALS * (1 + story.group.length);
    const have = story.items.materials ?? 0;
    if (have > cap) {
      story.items.materials = cap;
      report.push(`You packed up and left. Couldn't carry ${have - cap} materials.`);
    } else report.push('You packed up and moved on.');
  }
  report.push(`After a day on the road you reach the ${node.name}.`);
  story.city.current = node.id;
  story.city.visited.push(node.id);
  story.base = null;
  story.barricades = [{ hp: 100, max: 100, lvl: 0 }, { hp: 100, max: 100, lvl: 0 }];
  return report;
}
