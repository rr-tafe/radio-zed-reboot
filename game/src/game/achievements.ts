// Params.achievements() + Shop's ach42(): checked on entering the shop and after every
// cleared wave. Grid position = [row][col], 7×6. Descriptions are verbatim from Texts.as
// (they don't always match the real reward — that's the original's quirk, kept as-is).

import { save } from './save';

export const DESCRIPTIONS = [
  '1. Make 500 shots from a glock.\n+1000 score points.',
  '2. Kill 5 zombies.\n+1000 score points',
  '3. Kill 80 zombies.\n+3000 score points',
  '4. Kill 150 zombies.\n+5000 score points',
  '5. Kill 350 zombies.\n+5 special points',
  '6. Kill 500 zombies.\n+5000 score points',
  '7. Kill 700 zombies.\n+5000 score points',
  '8. Kill 900 zombies.\n+5 special points',
  '9. Kill 1200 zombies.\n+5 special points',
  '10. Visit the credits screen.\n+5 special points',
  '11. Having a fully upgraded\nbarricades.\n+5 special points',
  '12. Make 300 shots from a SSG.\n+3000 score points',
  '13. Make 3000 shots from a Uzi.\n+3000 score points',
  '14. Holding out to 2 waves.\n+2000 score points',
  '15. Holding out to 3 waves.\n+3000 score points',
  '16. Holding out to 5 waves.\n+5000 score points',
  '17. Holding out to 7 waves.\n+7000 score points',
  '18. Holding out to 11 waves.\n+11000 score points',
  '19. Holding out to 13 waves.\n+13000 score points',
  '20. Holding out to 17 waves.\n+17000 score points',
  '21. Holding out to 19 waves.\nYou are alive?\n+19000 score points',
  '22. Holding out to 23 waves.\nYou are still alive?\n+230000 score points',
  '23. Make more than 5000 shots.\n+5000 score points',
  '24. Have a full improvement of\nyour educability.\nBraaains... +5 special points',
  '25. Kill 1500 zombies.\n+5 special points',
  // Was "Click on the sponsor logo" — the sponsor is gone, so the reboot awards it for Help.
  '26. Read the help screen.\nMake us happy.   *Click-click*\n+5 special points',
  '27. Buy the whole range of\nweapons.\n+5000 score points',
  '28. Just die...\nMrh?\n+0 score points. ',
  '29. Fully improve your partners.\n+20 special points',
  '30. Save up 50 special points.\n+25 special points',
  '31. Have a full improvement of\nyour luck.\n+10000 monies',
  '32. Have a 0.6% accuracy at 1000\nshots.\n+5000 score points',
  '33. Have a 0.6% accuracy at 7000\nshots.\n+7000 score points',
  '34. Make 200 shots from a \ndesert eagle.\n+3000 score points',
  '35. Buy all of the improvements.\n+10000 score points',
  '36. Make 10 headshots.\n+1000 score points',
  '37. Make 50 headshots.\n+2000 score points',
  '38. Make 300 headshots.\n+3000 score points',
  '39. Make 500 headshots.\n+5000 score points',
  '40. Make 3000 headshots.\n+6000 score points',
  '41. Make 5000 shots from a M249.\n+3000 score points',
  '42. Get 41 achievements.\nSomeone?\n+42 score points',
];

type Reward = { score?: number; sp?: number; money?: number };
interface Rule { r: number; c: number; test: () => boolean; reward: Reward }

const all2 = (rows: number[][]) => rows.every((row) => row[2] === 2);
const shots = () => save.bulletMiss + save.bulletHit;
const accuracy = () => save.bulletHit / shots(); // NaN with no shots, as in the original

// Stat-based rules, in Params.achievements() order. [1][3], [4][1] and [4][3] are event-based.
const RULES: Rule[] = [
  { r: 0, c: 0, test: () => save.bulletShot[0] > 500, reward: { score: 1000 } },
  { r: 0, c: 1, test: () => save.zombieKilled > 5, reward: { score: 1000 } },
  { r: 0, c: 2, test: () => save.zombieKilled > 80, reward: { score: 3000 } },
  { r: 0, c: 3, test: () => save.zombieKilled > 150, reward: { score: 5000 } },
  { r: 0, c: 4, test: () => save.zombieKilled > 350, reward: { score: 5000 } },
  { r: 0, c: 5, test: () => save.zombieKilled > 500, reward: { score: 5000 } },
  { r: 1, c: 0, test: () => save.zombieKilled > 700, reward: { score: 5000 } },
  { r: 1, c: 1, test: () => save.zombieKilled > 900, reward: { sp: 5 } },
  { r: 1, c: 2, test: () => save.zombieKilled > 1200, reward: { sp: 5 } },
  { r: 1, c: 4, test: () => save.barricadesUpgrade[0][2] === 2 && save.barricadesUpgrade[1][2] === 2, reward: { sp: 5 } },
  { r: 1, c: 5, test: () => save.bulletShot[7] > 300, reward: { score: 3000 } },
  { r: 2, c: 0, test: () => save.bulletShot[2] > 3000, reward: { score: 3000 } },
  { r: 2, c: 1, test: () => save.maxLvl >= 2, reward: { score: 2000 } },
  { r: 2, c: 2, test: () => save.maxLvl >= 3, reward: { score: 3000 } },
  { r: 2, c: 3, test: () => save.maxLvl >= 5, reward: { score: 5000 } },
  { r: 2, c: 4, test: () => save.maxLvl >= 7, reward: { score: 7000 } },
  { r: 2, c: 5, test: () => save.maxLvl >= 11, reward: { score: 11000 } },
  { r: 3, c: 0, test: () => save.maxLvl >= 13, reward: { score: 13000 } },
  { r: 3, c: 1, test: () => save.maxLvl >= 17, reward: { score: 17000 } },
  { r: 3, c: 2, test: () => save.maxLvl >= 19, reward: { score: 19000 } },
  { r: 3, c: 3, test: () => save.maxLvl >= 23, reward: { score: 23000 } },
  { r: 3, c: 4, test: () => shots() >= 5000, reward: { score: 5000 } },
  { r: 3, c: 5, test: () => save.playerSkills[1][2] === 2, reward: { sp: 5 } },
  { r: 4, c: 0, test: () => save.zombieKilled > 1500, reward: { sp: 5 } },
  { r: 4, c: 2, test: () => save.playerWeapons.every((w) => w[0] === 2), reward: { score: 5000 } },
  { r: 4, c: 4, test: () => all2(save.bot1Skills) && all2(save.bot2Skills), reward: { sp: 20 } },
  { r: 4, c: 5, test: () => save.sp > 50, reward: { sp: 25 } },
  { r: 5, c: 0, test: () => save.playerSkills[6][2] === 2, reward: { money: 10000 } },
  { r: 5, c: 1, test: () => accuracy() > 0.6 && shots() >= 1000, reward: { score: 5000 } },
  { r: 5, c: 2, test: () => accuracy() > 0.6 && shots() >= 7000, reward: { score: 7000 } },
  { r: 5, c: 3, test: () => save.bulletShot[1] > 200, reward: { score: 3000 } },
  { r: 5, c: 4, test: () => all2(save.playerSkills), reward: { score: 10000 } },
  { r: 5, c: 5, test: () => save.headShoot > 10, reward: { score: 1000 } },
  { r: 6, c: 0, test: () => save.headShoot > 50, reward: { score: 2000 } },
  { r: 6, c: 1, test: () => save.headShoot > 300, reward: { score: 3000 } },
  { r: 6, c: 2, test: () => save.headShoot > 500, reward: { score: 5000 } },
  { r: 6, c: 3, test: () => save.headShoot > 3000, reward: { score: 6000 } },
  { r: 6, c: 4, test: () => save.bulletShot[8] > 5000, reward: { score: 3000 } },
];

function grant(reward: Reward) {
  if (reward.score) save.score += reward.score;
  if (reward.sp) save.sp += reward.sp;
  if (reward.money) {
    save.money += reward.money;
    save.moneyEarned = reward.money; // sic: the original overwrote rather than added
  }
}

/** One-off achievements triggered by an action rather than a stat. */
export function award(r: number, c: number, reward: Reward = {}) {
  if (save.archivement[r][c] !== 0) return;
  save.archivement[r][c] = 1;
  grant(reward);
}

export function checkAchievements() {
  for (const a of RULES) {
    if (save.archivement[a.r][a.c] === 0 && a.test()) {
      save.archivement[a.r][a.c] = 1;
      grant(a.reward);
    }
  }
}

/**
 * Shop.ach42(). The original's test skips any slot in row 6 *or* column 5 (the condition was
 * meant to skip only [6][5]), so it only needs rows 0–5 × columns 0–4.
 */
export function checkAch42() {
  if (save.archivement[6][5] !== 0) return;
  for (let r = 0; r < 7; r++) {
    for (let c = 0; c < 6; c++) {
      if (save.archivement[r][c] === 0 && r !== 6 && c !== 5) return;
    }
  }
  save.archivement[6][5] = 1;
  save.score += 42;
}
