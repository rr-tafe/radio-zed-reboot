// Radio.as, Barricade.as, Block.as, DoorUp/DoorDown.as, BulletBlock.as, Bot_Marker.as, Cursor.as.

import { LEFT, RIGHT, Sprite, Text, getAngle } from '../engine/core';
import { mouse } from '../engine/input';
import { TEXT_COLOR } from './data';
import { save } from './save';

/** A small health readout (icon + number) that floats above radios and barricades. */
export class HealthTag {
  icon: Sprite;
  label: Text;
  constructor(x: number, y: number, value: number) {
    this.icon = new Sprite(x, y, 'Barricade_ImgHeatlh_bar');
    this.icon.moves = false;
    this.icon.solid = false;
    this.label = new Text(x + 8, y - 4, 100, String(value)).setFormat(8, TEXT_COLOR);
  }
  set(v: number) { this.label.text = String(v); }
  hide() {
    this.icon.exists = false;
    this.label.exists = false;
  }
}

export class Radio extends Sprite {
  tag: HealthTag;
  constructor(x: number, y: number) {
    super(x, y);
    this.loadGraphic('Radio_ImgRadion', false, true, 37, 64);
    this.moves = false;
    this.solid = false;
    this.health = 100;
    this.tag = new HealthTag(this.x + 6, this.y - 4, this.health);
  }
  hurt(d: number) {
    // The original updates the label before applying damage, so it lags one hit behind.
    this.tag.set(this.health);
    if (this.health <= 2) this.tag.hide();
    this.health -= d;
  }
  kill() {}
}

export class Barricade extends Sprite {
  tag: HealthTag | null = null;

  constructor(x: number, y: number, readonly side: 0 | 1) {
    super(x, y);
    const lvl = side === 0 ? save.leftBarricade_lvl : save.rightBarricade_lvl;
    this.loadGraphic(`Barricade_ImgBarricade${lvl}`, true, true, 31, 35);
    this.addAnimation('100', [0]);
    this.addAnimation('80', [1]);
    this.addAnimation('40', [2]);
    this.addAnimation('10', [3]);
    this.addAnimation('0', [4]);
    this.moves = false;
    this.solid = false;
    this.health = side === 0 ? save.leftBarricade : save.rightBarricade;
    this.showDamage();
    if (this.health > 0) this.tag = new HealthTag(this.x + 6, this.y - 5, this.health);
  }

  private get max() { return this.side === 0 ? save.leftBarricade_Max : save.rightBarricade_Max; }

  private showDamage() {
    const r = this.health / this.max;
    if (r >= 0.81) this.play('100');
    else if (r >= 0.41) this.play('80');
    else if (r >= 0.11) this.play('40');
    else if (r > 0) this.play('10');
    else this.play('0');
  }

  hurt(d: number) {
    this.tag?.set(this.health);
    if (this.health <= 2) this.tag?.hide();
    this.health -= d;
    if (this.side === 0) save.leftBarricade = this.health;
    else save.rightBarricade = this.health;
    if (this.health > 0) this.showDamage();
    else this.play('0');
  }
  kill() {}
}

/** Invisible solid that physically stops zombies at a barricade until it breaks. */
export class Block extends Sprite {
  constructor(x: number, y: number) {
    super(x, y);
    this.width = 25;
    this.height = 16;
    this.health = 100;
    this.fixed = true;
    this.moves = false;
    this.visible = false;
  }
}

/** Invisible trigger area (doors, bot markers, bullet stoppers). */
export class Zone extends Sprite {
  constructor(x: number, y: number, w: number, h: number, readonly name = '') {
    super(x, y);
    this.width = w;
    this.height = h;
    this.fixed = true;
    this.moves = false;
    this.solid = false;
    this.visible = false;
  }
}

/** The crosshair line that points from the mouse back toward the player. */
export class Cursor extends Sprite {
  constructor(private target: Sprite) {
    super(0, 0);
    this.loadGraphic('Cursor_ImgCursor', true, true, 15, 3);
    this.solid = false;
    this.moves = false;
  }
  /** Run every rendered frame so the cursor never lags the real pointer. */
  track() {
    this.x = this.px = mouse.x;
    this.y = this.py = mouse.y;
    const tx = this.target.x + 10;
    const ty = this.target.y + 10;
    const da = getAngle(tx - this.x, ty - this.y);
    if (tx > this.x) {
      this.facing = RIGHT;
      this.angle = da;
    } else {
      this.facing = LEFT;
      this.angle = 180 + da;
    }
  }
  update() { this.track(); }
}
