// What happens overnight between the night's fight and the next morning: everyone eats,
// the injured heal, builders fix the barricades. Returns a report for the camp screen.

import { resolveScavenging } from './scavenge';
import { count, story } from './storySave';

const REST_HEAL = 40;
const IDLE_HEAL = 10;
const MED_HEAL = 50;
/** Barricade health restored per material by a builder. */
export const REPAIR_PER_MATERIAL = 25;
const BUILDER_MATERIALS = 2;

export function dawnUpkeep(): string[] {
  // The scavengers come home first (and eat with everyone else).
  const report: string[] = resolveScavenging(story.day * 7919 + story.moonOffset * 31 + story.city.visited.length);
  const take = (id: 'food' | 'meds' | 'materials') => {
    if (count(id) <= 0) return false;
    story.items[id] = count(id) - 1;
    return true;
  };

  // Food: the leader eats first, then the others in order.
  const mouths = 1 + story.group.length;
  let eaten = 0;
  story.leaderHungry = !take('food');
  if (!story.leaderHungry) eaten++;
  else report.push('You went to sleep hungry. (worse aim)');
  for (const s of story.group) {
    s.hungry = !take('food');
    if (!s.hungry) eaten++;
    else report.push(`${s.name} went hungry. (worse aim, no healing)`);
  }
  report.push(`The group ate ${eaten} of ${mouths} food. ${count('food')} left.`);

  // Healing, then medicine for anyone still badly hurt.
  for (const s of story.group) {
    if (s.hungry) continue;
    const heal = s.job === 'rest' ? REST_HEAL : IDLE_HEAL;
    const before = s.hp;
    s.hp = Math.min(s.maxHp, s.hp + heal);
    if (s.hp > before && s.job === 'rest') report.push(`${s.name} rested: +${s.hp - before} health.`);
  }
  for (const s of story.group) {
    if (s.hp < s.maxHp / 2 && take('meds')) {
      s.hp = Math.min(s.maxHp, s.hp + MED_HEAL);
      report.push(`Used medicine on ${s.name}.`);
    }
  }

  // Builders spend materials on whichever barricade is weaker.
  for (const s of story.group.filter((x) => x.job === 'build' && !x.hungry)) {
    let used = 0;
    while (used < BUILDER_MATERIALS) {
      const [l, r] = story.barricades;
      const target = l.hp / l.max <= r.hp / r.max ? l : r;
      if (target.hp >= target.max || !take('materials')) break;
      target.hp = Math.min(target.max, target.hp + REPAIR_PER_MATERIAL);
      used++;
    }
    report.push(used ? `${s.name} repaired the barricades with ${used} materials.` : `${s.name} had nothing to build with.`);
  }
  return report;
}
