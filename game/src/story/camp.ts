// The camp screen, shown each dawn. It reuses the original shop's frame and panel art:
// the left column holds last night's report and the group's jobs; the right column holds the
// armoury (where the shop listed weapons) and fortifications (where it listed barricades).

import { Button } from '../engine/button';
import { G, Sprite, State, Text, switchState } from '../engine/core';
import { keys, mouse } from '../engine/input';
import { play } from '../engine/sound';
import { BARRICADE_MAX, TEXT_COLOR, TEXT_SHADOW, WEAPONS } from '../game/data';
import type { Screens } from '../game/play';
import { storyArmoury } from './armoury';
import { JOBS, JOB_LABEL, Job, MAX_GUARDS } from './group';
import { AMMO_LABEL, CALIBRE } from './items';
import { CORNER_SHOP } from './sites';
import { baseFor, count, persistStory, story } from './storySave';
import { REPAIR_PER_MATERIAL } from './upkeep';

const DIM = 11052705;
const REINFORCE_COST = [6, 12, 20];
const LAMP_MATERIALS = 2;

function label(x: number, y: number, text: string, size = 8, color = TEXT_COLOR): Text {
  const t = new Text(x, y, 640, text).setFormat(size, color, 'left', TEXT_SHADOW);
  t.scrollFactor = { x: 0, y: 0 };
  return t;
}

/** Word-wrap to a character budget (the Nokia font is about 5 px per character). */
function wrap(s: string, chars: number): string[] {
  const out: string[] = [];
  let line = '';
  for (const w of s.split(' ')) {
    if ((line + ' ' + w).trim().length > chars) {
      out.push(line);
      line = w;
    } else line = (line + ' ' + w).trim();
  }
  if (line) out.push(line);
  return out;
}

/** A clickable word in the original's font: bright when available, dim when not. */
class TextButton extends Text {
  private hover = false;
  constructor(x: number, y: number, text: string, private enabled: boolean, private selected: boolean, private onClick: () => void) {
    super(x, y, 120, text);
    this.setFormat(8, enabled || selected ? TEXT_COLOR : DIM, 'left', TEXT_SHADOW);
    this.scrollFactor = { x: 0, y: 0 };
  }
  private get w() { return this.text.length * 5 + 4; }
  update() {
    this.hover = mouse.screenX >= this.x && mouse.screenX < this.x + this.w && mouse.screenY >= this.y && mouse.screenY < this.y + 11;
    if (this.hover && this.enabled && keys.justReleased('MOUSE')) this.onClick();
  }
  draw(ctx: CanvasRenderingContext2D) {
    if (this.selected || (this.hover && this.enabled)) {
      ctx.fillStyle = this.selected ? 'rgba(226,220,215,0.25)' : 'rgba(226,220,215,0.12)';
      ctx.fillRect(Math.floor(this.x), Math.floor(this.y) + 1, this.w, 10);
    }
    super.draw(ctx);
  }
}

export class CampState extends State {
  constructor(private screens: Screens, private makeDay: () => State, private notice = '') {
    super();
  }

  private still(x: number, y: number, name: string) {
    const s = this.add(new Sprite(x, y, name));
    s.scrollFactor = { x: 0, y: 0 };
    s.moves = false;
  }

  private reopen(notice = '') {
    play('Shop_SndMenuClick');
    persistStory();
    switchState(() => new CampState(this.screens, this.makeDay, notice));
  }

  create() {
    G.scroll.x = G.scroll.y = 0;
    this.still(0, 0, 'Shop_backGround_Img');
    this.still(0, 0, 'Shop_shopBack');
    this.add(label(150, 72, 'Camp', 16));
    this.add(label(337, 72, `Day ${story.day}`, 16, DIM));

    this.report();
    this.group();
    this.armoury();
    this.fortify();

    this.add(label(120, 416, `Food ${count('food')}   Meds ${count('meds')}`));
    this.add(label(353, 416, `Materials ${count('materials')}   Batteries ${count('batteries')}`));
    this.still(500, 430, 'Shop_Img_button_start_menu');
    this.add(label(512, 430, 'START DAY'));
    this.add(new Button(503, 431, 'Shop_Img_main_menu_button_light', 'Shop_Img_main_menu_button_light', () => {
      play('Shop_SndMenuClick');
      persistStory();
      switchState(this.makeDay);
    }).setOffAlpha(0));
    this.still(85, 430, 'Shop_Img_button_start_menu');
    this.add(label(103, 430, 'MENU'));
    this.add(new Button(88, 431, 'Shop_Img_main_menu_button_light', 'Shop_Img_main_menu_button_light', () => {
      persistStory();
      switchState(this.screens.menu);
    }).setOffAlpha(0));
  }

  private report() {
    this.add(label(120, 106, 'Last night'));
    const lines = (story.report.length ? story.report : ['A quiet start.']).flatMap((l) => wrap(l, 36));
    this.add(label(120, 122, lines.slice(0, 11).join('\n')));
  }

  private group() {
    this.add(label(120, 255, 'Group'));
    this.add(label(200, 260, 'Job (2 guards at most)', 8, DIM));
    const guards = story.group.filter((s) => s.job === 'guard').length;
    story.group.forEach((s, i) => {
      const y = 274 + i * 18;
      this.add(label(120, y, `${s.name} ${s.hp}`));
      if (s.hungry) this.add(label(120, y + 8, 'hungry', 8, DIM));
      JOBS.forEach((job: Job, k) => {
        const selected = s.job === job;
        const allowed = job !== 'guard' || selected || guards < MAX_GUARDS;
        this.add(new TextButton(212 + k * 34, y, JOB_LABEL[job], allowed && !selected, selected, () => {
          s.job = job;
          this.reopen();
        }));
      });
    });
    if (!story.group.length) this.add(label(120, 274, 'You are on your own.'));
    if (story.fallen.length) this.add(label(120, 274 + Math.max(1, story.group.length) * 18 + 4, `Lost: ${story.fallen.join(', ')}`, 8, DIM));
  }

  private armoury() {
    this.add(label(353, 106, 'Weapon'));
    this.add(label(480, 113, 'Ammo'));
    WEAPONS.forEach((w, i) => {
      const owned = storyArmoury.owns(i);
      this.add(label(353, 126 + i * 16, w.name, 8, owned ? TEXT_COLOR : DIM));
      const ammo = i === 0 ? 'no limit' : `${AMMO_LABEL[CALIBRE[i]]} ${count(CALIBRE[i])}`;
      this.add(label(480, 126 + i * 16, owned ? ammo : '-', 8, owned ? TEXT_COLOR : DIM));
    });
  }

  private fortify() {
    const base = baseFor(CORNER_SHOP);
    base.lamps ??= [false, false];
    const [L, R] = story.barricades;
    this.add(label(353, 295, `Barricades   Left ${L.hp}/${L.max}   Right ${R.hp}/${R.max}`));
    const sides: [string, 0 | 1][] = [['Left', 0], ['Right', 1]];

    this.add(label(353, 313, `Repair +${REPAIR_PER_MATERIAL} (1 mat)`));
    sides.forEach(([name, i], k) => {
      const b = story.barricades[i];
      this.add(new TextButton(476 + k * 38, 313, name, b.hp < b.max && count('materials') >= 1, false, () => {
        story.items.materials = count('materials') - 1;
        b.hp = Math.min(b.max, b.hp + REPAIR_PER_MATERIAL);
        this.reopen();
      }));
    });

    this.add(label(353, 331, 'Reinforce'));
    sides.forEach(([name, i], k) => {
      const b = story.barricades[i];
      const cost = REINFORCE_COST[b.lvl];
      const text = b.lvl >= 3 ? `${name} max` : `${name} ${cost}`;
      this.add(new TextButton(476 + k * 38 - (k ? 0 : 20), 331, text, b.lvl < 3 && count('materials') >= cost, false, () => {
        story.items.materials = count('materials') - cost;
        b.lvl++;
        b.max = BARRICADE_MAX[b.lvl];
        b.hp += 50;
        this.reopen(`${name} barricade reinforced.`);
      }));
    });

    this.add(label(353, 349, `Street lamp (${LAMP_MATERIALS} mat + 1 battery)`));
    sides.forEach(([name, i], k) => {
      const built = base.lamps[i];
      const can = !built && count('materials') >= LAMP_MATERIALS && count('batteries') >= 1;
      this.add(new TextButton(380 + k * 60, 363, built ? `${name}: lit` : `Build ${name.toLowerCase()}`, can, built, () => {
        story.items.materials = count('materials') - LAMP_MATERIALS;
        story.items.batteries = count('batteries') - 1;
        base.lamps[i] = true;
        this.reopen(`Street lamp put up on the ${name.toLowerCase()}.`);
      }));
    });

    if (this.notice) this.add(label(353, 383, this.notice));
  }
}
