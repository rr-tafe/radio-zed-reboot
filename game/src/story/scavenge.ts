// Scavenging parties: friends sent to a nearby location for a day and a night. Resolved at
// dawn with a few dice rolls weighed by who went, how they're doing and how dangerous it was.

import { COLUMNS, CityNode, currentNode } from './city';
import { scavengeLoot } from './generate';
import { MAX_FRIENDS, Survivor, recruit } from './group';
import { describe } from './items';
import { rng } from './rng';
import { give, story } from './storySave';
import { MOON_DARKNESS, moonFor } from './time';

const clamp = (v: number, lo: number, hi: number) => Math.max(lo, Math.min(hi, v));

/** Places a party can reach from here: known or neighbouring locations, never the station. */
export function scavengeTargets(): CityNode[] {
  const here = currentNode();
  return story.city.nodes.filter((n) => n.id !== here.id && n.type !== 'station' && Math.abs(n.col - here.col) <= 1 && n.col < COLUMNS - 1);
}

export function scavengeTarget(): CityNode | null {
  const targets = scavengeTargets();
  return targets.find((n) => n.id === story.scavengeTarget) ?? targets[0] ?? null;
}

export function party(): Survivor[] {
  return story.group.filter((s) => s.job === 'scavenge');
}

/** How capable a scavenger is: partner skills, health, hunger. */
function power(s: Survivor) {
  return (1 + s.skills[1] * 0.3 + s.skills[2] * 0.2 + s.skills[0] * 0.1) * (s.hp / s.maxHp) * (s.hungry ? 0.7 : 1);
}

/** Resolve last night's party, if any. Called at dawn before food. */
export function resolveScavenging(seed: number): string[] {
  const members = party();
  const target = scavengeTarget();
  if (!members.length || !target) return [];
  const r = rng(seed);
  const report: string[] = [];
  const names = members.map((s) => s.name).join(' and ');
  const strength = members.reduce((t, s) => t + power(s), 0);
  const dark = MOON_DARKNESS[moonFor(story.day, story.moonOffset)];
  const danger = target.danger + dark * 2;

  const loot = scavengeLoot(target, 2 + members.length * 2 + Math.round(strength), r);
  for (const l of loot) give(l);
  report.push(`${names} scavenged the ${target.name}: ${loot.length ? loot.map(describe).join(', ') : 'nothing worth carrying'}.`);

  for (const s of members) {
    const death = clamp(0.02 + 0.04 * danger - 0.03 * strength, 0.01, 0.35);
    const hurt = clamp(0.15 + 0.1 * danger - 0.05 * strength, 0.05, 0.75);
    const roll = r();
    if (roll < death) {
      story.group = story.group.filter((x) => x !== s);
      story.fallen.push(s.name);
      report.push(`${s.name} didn't come back.`);
    } else if (roll < death + hurt) {
      const dmg = 15 + Math.floor(r() * 35);
      s.hp = Math.max(1, s.hp - dmg);
      report.push(`${s.name} came back hurt (-${dmg}).`);
    }
  }

  if (story.group.length < MAX_FRIENDS && r() < 0.15 + 0.07 * members.length) {
    const s = recruit(r, [...story.group.map((g) => g.name), ...story.fallen]);
    story.group.push(s);
    report.push(`They found ${s.name}, who joined the group.`);
  }
  return report;
}
