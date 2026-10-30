// Shop.as and ShopStatistics.as: the between-wave screen. Two pages share one frame:
// "Skills & Guns" (character/partner skills for special points, weapons and barricades for
// money) and "Achievements & Stats". Layout coordinates are the original's.
//
// Item states follow the original save convention: 0 = locked, 1 = can buy, 2 = owned.
// Like the original, buying rebuilds the whole screen.

import { Button } from '../engine/button';
import { Sprite, State, Text, switchState } from '../engine/core';
import { play } from '../engine/sound';
import { DESCRIPTIONS, checkAch42, checkAchievements } from './achievements';
import { BARRICADE_MAX, BARRICADE_PRICE, PLAYER_SKILLS, REPAIR, SKILL_COST, WEAPONS } from './data';
import { persist, save } from './save';

const LIGHT = 14868183;
const DIM = 11052705;
const SHADOW = 2309720;

export interface ShopNav {
  play: () => State;
  menu: () => State;
}

const click = () => play('Shop_SndMenuClick');

function label(x: number, y: number, text: string, size = 8, color = LIGHT): Text {
  const t = new Text(x, y, 640, text).setFormat(size, color, 'left', SHADOW);
  t.scrollFactor = { x: 0, y: 0 };
  return t;
}

function still(x: number, y: number, name: string): Sprite {
  const s = new Sprite(x, y, name);
  s.scrollFactor = { x: 0, y: 0 };
  s.moves = false;
  return s;
}

/** Common frame: backdrop, panel art, START and MENU buttons. */
abstract class ShopFrame extends State {
  constructor(protected nav: ShopNav) {
    super();
  }

  protected buildFrame(panel: string) {
    this.add(still(0, 0, 'Shop_backGround_Img'));
    this.add(still(0, 0, panel));
    this.add(still(500, 430, 'Shop_Img_button_start_menu'));
    this.add(label(518, 430, 'START'));
    this.add(new Button(503, 431, 'Shop_Img_main_menu_button_light', 'Shop_Img_main_menu_button_light', () => {
      persist();
      switchState(this.nav.play);
    }).setOffAlpha(0));
    this.add(still(85, 430, 'Shop_Img_button_start_menu'));
    this.add(label(103, 430, 'MENU'));
    this.add(new Button(88, 431, 'Shop_Img_main_menu_button_light', 'Shop_Img_main_menu_button_light', () => {
      persist();
      switchState(this.nav.menu);
    }).setOffAlpha(0));
  }

  protected reopen() {
    persist();
    const make = this.constructor as new (nav: ShopNav) => State;
    switchState(() => new make(this.nav));
  }
}

export class ShopState extends ShopFrame {
  create() {
    checkAchievements();
    checkAch42();
    persist();

    this.buildFrame('Shop_shopBack');
    this.add(label(145, 72, 'Skills & Guns', 16, LIGHT));
    this.add(label(337, 72, 'Achievements & Stats', 16, DIM));
    this.add(new Button(320, 63, 'Shop_ImgStat_Button', 'Shop_ImgStat_Button_light', () => {
      click();
      switchState(() => new StatsState(this.nav));
    }));

    this.add(label(120, 416, `Special points: ${save.sp}`));
    this.add(label(353, 416, `Money: ${save.money}$`));

    // Character skills.
    this.add(label(120, 106, 'Character'));
    this.add(label(209, 113, 'lev.1   lev.2   lev.3'));
    PLAYER_SKILLS.forEach((s, i) => this.add(label(120, 126 + i * 16, s.label)));
    this.skillGrid(save.playerSkills, 211, 126);

    // Partners.
    this.add(label(120, 255, 'Willson'));
    this.add(label(209, 260, 'lev.1   lev.2   lev.3'));
    ['Speed Walking', 'Damage', 'Accuracy'].forEach((t, i) => this.add(label(120, 273 + i * 16, t)));
    this.skillGrid(save.bot1Skills, 211, 273);
    this.add(label(120, 338, 'Summer'));
    this.add(label(209, 343, 'lev.1   lev.2   lev.3'));
    ['Speed Walking', 'Damage', 'Accuracy'].forEach((t, i) => this.add(label(120, 356 + i * 16, t)));
    this.skillGrid(save.bot2Skills, 211, 356);

    this.weapons();
    this.barricades();
  }

  /** Three tiers per row costing 5 / 10 / 15 SP, bought left to right. */
  private skillGrid(rows: number[][], x0: number, y0: number) {
    rows.forEach((row, i) => {
      for (let k = 0; k < 3; k++) {
        let img: [string, string];
        if (row[k] === 2) img = ['Shop_ImgButtonCheck', 'Shop_ImgButtonCheck'];
        else {
          const ok = save.sp >= SKILL_COST[k] && (k === 0 || row[k - 1] === 2);
          row[k] = ok ? 1 : 0;
          img = ok ? [`Shop_ImgButtonBuy${k + 1}`, `Shop_ImgButtonBuy${k + 1}_light`] : [`Shop_ImgButtonBlock${k + 1}`, `Shop_ImgButtonBlock${k + 1}`];
        }
        this.add(new Button(x0 + k * 31, y0 + i * 16, img[0], img[1], () => {
          if (row[k] !== 1) return;
          click();
          if (save.sp >= SKILL_COST[k]) {
            save.sp -= SKILL_COST[k];
            row[k] = 2;
            this.reopen();
          }
        }));
      }
    });
  }

  private weapons() {
    this.add(label(353, 106, 'Weapon'));
    this.add(label(485, 113, 'Buy   Upgrade'));
    WEAPONS.forEach((w, i) => {
      this.add(label(353, 126 + i * 16, w.name));
      const row = save.playerWeapons[i];
      for (let k = 0; k < 2; k++) {
        // The Glock row reuses its upgrade art for the (always owned) buy slot.
        const base = i === 0 ? 'Shop_ImgWeapon1_2' : `Shop_ImgWeapon${i + 1}_${k + 1}`;
        const price = w.price[k];
        let img: [string, string];
        if (row[k] === 2) img = ['Shop_ImgWeaponCheck', 'Shop_ImgWeaponCheck'];
        else if (save.money <= price) img = [`${base}_block`, `${base}_block`];
        else if (k === 0 || row[k - 1] === 2) {
          row[k] = 1;
          img = [base, `${base}_light`];
        } else {
          row[k] = 0;
          img = [`${base}_block`, `${base}_block`];
        }
        this.add(new Button(480 + k * 38, 126 + i * 16, img[0], img[1], () => {
          // The original needs strictly more money than the price.
          if (row[k] === 1 && save.money > price) {
            save.money -= price;
            row[k] = 2;
            click();
            this.reopen();
          }
        }));
      }
    });
  }

  private barricades() {
    this.add(label(353, 295, 'Barricades'));
    this.add(label(420, 295, `Left: ${save.leftBarricade}/${save.leftBarricade_Max}  Right: ${save.rightBarricade}/${save.rightBarricade_Max}`));
    this.add(label(441, 310, 'lev.1     lev.2     lev.3'));
    this.add(label(353, 321, 'Upgrade Right'));
    this.add(label(353, 337, 'Upgrade Left'));

    // Row 0 is the right barricade, row 1 the left (as in the original).
    for (let i = 0; i < 2; i++) {
      const row = save.barricadesUpgrade[i];
      for (let k = 0; k < 3; k++) {
        const price = BARRICADE_PRICE[k];
        const base = `Shop_ImgButtonBuyBarricad${k + 1}`;
        let img: [string, string];
        if (row[k] === 2) img = ['Shop_ImgWeaponCheck', 'Shop_ImgWeaponCheck'];
        else if (save.money <= price) img = [`${base}_block`, `${base}_block`];
        else if (k === 0 || row[k - 1] === 2) {
          row[k] = 1;
          img = [base, `${base}_light`];
        } else {
          row[k] = 0;
          img = [`${base}_block`, `${base}_block`];
        }
        this.add(new Button(442 + k * 38, 323 + i * 16, img[0], img[1], () => {
          if (row[k] !== 1 || save.money <= price) return;
          save.money -= price;
          row[k] = 2;
          if (i === 0) {
            save.rightBarricade_lvl++;
            save.rightBarricade_Max = BARRICADE_MAX[save.rightBarricade_lvl];
            save.rightBarricade += 50;
          } else {
            save.leftBarricade_lvl++;
            save.leftBarricade_Max = BARRICADE_MAX[save.leftBarricade_lvl];
            save.leftBarricade += 50;
          }
          click();
          this.reopen();
        }));
      }
    }

    this.add(label(447, 359, ' 10%      30%      100%'));
    this.add(label(353, 370, 'Repair Right'));
    this.add(label(353, 386, 'Repair Left'));
    for (let i = 0; i < 2; i++) {
      const right = i === 0;
      for (let k = 0; k < 3; k++) {
        const { price, fraction } = REPAIR[k];
        const hp = () => (right ? save.rightBarricade : save.leftBarricade);
        const max = right ? save.rightBarricade_Max : save.leftBarricade_Max;
        const base = `Shop_ImgButtonRepairBarricad${k + 1}`;
        const ok = save.money > price && hp() < max;
        this.add(new Button(442 + k * 38, 372 + i * 16, ok ? base : `${base}_block`, ok ? `${base}_light` : `${base}_block`, () => {
          if (hp() >= max || save.money < price) return;
          save.money -= price;
          const healed = fraction === 1 ? max : Math.min(max, hp() + Math.floor(max * fraction));
          if (right) save.rightBarricade = healed;
          else save.leftBarricade = healed;
          click();
          this.reopen();
        }));
      }
    }
  }
}

export class StatsState extends ShopFrame {
  create() {
    this.buildFrame('Shop_statistics_shopBack');
    this.add(label(145, 72, 'Skills & Guns', 16, DIM));
    this.add(label(337, 72, 'Achievements & Stats', 16, LIGHT));
    this.add(new Button(85, 63, 'Shop_statistics_ImgGun_Button', 'Shop_statistics_ImgGun_Button_light', () => {
      click();
      switchState(() => new ShopState(this.nav));
    }));

    this.add(label(113, 106, 'Achievements'));
    this.add(label(330, 106, 'Statistics'));
    const description = this.add(label(118, 375, 'Click on icons for information'));

    const shots = save.bulletMiss + save.bulletHit;
    const acc = shots ? Math.floor((save.bulletHit / shots) * 100) / 100 : 0;
    this.add(label(330, 126, 'Zombie killing:  \nMax wave: \nMoney earned: \nMoney spent: \nShots made: \nMisses: \nHits: \nAccuracy: \nHeadshots: '));
    this.add(label(410, 126, [save.zombieKilled, save.maxLvl, save.moneyEarned, save.moneyEarned - save.money, shots, save.bulletMiss, save.bulletHit, acc, save.headShoot].join('\n')));
    this.add(label(451, 126, 'Glocks-17:  \nDesert Eagle: \nUzi: \nHK G36: \nSteyr AUG: \nAK-47: \nM-16:\nSM SSG 69: \nFN M249 SAW: '));
    this.add(label(523, 126, save.bulletShot.join('\n')));
    this.add(label(353, 416, `Total score: ${save.score}`));

    for (let i = 0; i < 7; i++) {
      for (let k = 0; k < 6; k++) {
        const n = i * 6 + k;
        let icon: string | Sprite = 'Shop_statistics_ImgNone_Archivement';
        if (save.archivement[i][k] === 1) {
          const s = new Sprite(0, 0);
          s.loadGraphic('Shop_statistics_Img_Archivement48', true, false, 25, 25);
          s.frame = n;
          icon = s;
        }
        this.add(new Button(113 + k * 31, 130 + i * 31, icon, icon, () => {
          click();
          description.text = DESCRIPTIONS[n];
        }));
      }
    }
  }
}
