// Menu.as, BlackScreenDialog.as (game over) and WinScreenDialog.as.

import { Button } from '../engine/button';
import { Sprite, State, Text, switchState } from '../engine/core';
import { play } from '../engine/sound';
import { award } from './achievements';
import { PlayState, Screens } from './play';
import { persist, resetSave, save } from './save';
import { settings, toggleWide } from './settings';
import { ShopState } from './shop';
import { StoryDayState } from '../story/day';

const DIM = 11052705;
const LIGHT = 14868183;
const SHADOW = 2309720;

const click = () => play('Menu_SndMenuClick');

export const screens: Screens = {
  menu: () => new MenuState(),
  afterWave: () => new ShopState({ play: () => new PlayState(screens), menu: screens.menu }),
  gameOver: (score) => new EndDialog(score, false),
  win: () => new EndDialog(save.score, true),
};

const newPlay = () => new PlayState(screens);

function fixed<T extends Sprite | Text>(d: T): T {
  d.scrollFactor = { x: 0, y: 0 };
  if (d instanceof Sprite) d.moves = false;
  return d;
}

class MenuState extends State {
  private overlay: (Sprite | Text | Button)[] = [];

  create() {
    this.add(fixed(new Sprite(0, 0, 'blackScreen_dialog_backGround_Img')));
    this.add(fixed(new Sprite(528, 16, 'playLvl_ImgMenuSign')));
    this.add(fixed(new Text(550, 18, 200, 'MENU').setFormat(16, DIM, 'left', SHADOW)));
    const items: [string, () => void][] = [
      ['New Game', () => this.newGame()],
      ['Continue', () => this.continueGame()],
      ['Story mode', () => switchState(() => new StoryDayState(screens))],
      [settings.wide ? 'Wide view: on' : 'Wide view: off', () => { toggleWide(); switchState(() => new MenuState()); }],
      ['Credits', () => { award(1, 3, { sp: 5 }); persist(); this.popup('playLvl_ImgCredits'); }],
      // Achievement 26 was "click the sponsor logo"; with no sponsor, Help awards it.
      ['Help', () => { award(4, 1, { sp: 5 }); persist(); this.popup('Menu_ImgHelpWindow'); }],
    ];
    this.add(fixed(new Text(542, 46, 200, items.map((i) => i[0]).join('\n')).setFormat(8, LIGHT, 'left', SHADOW)));
    items.forEach(([, fn], i) => this.add(new Button(531, 47 + i * 10, 'Shop_Img_main_menu_button_light', 'Shop_Img_main_menu_button_light', () => { click(); fn(); }).setOffAlpha(0)));
    this.add(fixed(new Text(560, 468, 100, 'reboot 0.1').setFormat(8, LIGHT)));
    this.add(new Button(1, 468, 'playLvl_Img_clear_data_Graphic', 'playLvl_Img_clear_data_Graphic_Light', () => this.confirm(
      'Hey, this will delete your data!', 'Delete                  Cancel', () => { resetSave(); switchState(() => new MenuState()); })));
  }

  private newGame() {
    if (save.lvl !== 1) {
      this.confirm('This will remove your last game!', 'New Game               Cancel', () => { resetSave(); switchState(newPlay); });
    } else {
      resetSave();
      switchState(newPlay);
    }
  }

  private continueGame() {
    if (save.lvl >= 2) switchState(screens.afterWave);
  }

  private closeOverlay() {
    for (const o of this.overlay) this.root.remove(o);
    this.overlay = [];
  }

  private popup(image: string) {
    this.closeOverlay();
    this.overlay = [
      fixed(new Sprite(200, 200, image)),
      new Button(437, 202, 'Menu_ImgHelp_close_button_light', 'Menu_ImgHelp_close_button_light', () => { click(); this.closeOverlay(); }).setOffAlpha(0),
    ];
    for (const o of this.overlay) this.root.add(o);
  }

  private confirm(question: string, choices: string, yes: () => void) {
    this.closeOverlay();
    this.overlay = [
      fixed(new Sprite(235, 222, 'playLvl_Img_dialog')),
      fixed(new Text(238, 225, 300, question).setFormat(8, DIM, 'left', SHADOW)),
      fixed(new Text(251, 242, 300, choices).setFormat(8, LIGHT, 'left', SHADOW)),
      new Button(238, 241, 'playLvl_Img_dialog_button', 'playLvl_Img_dialog_button', () => { click(); yes(); }).setOffAlpha(0),
      new Button(323, 241, 'playLvl_Img_dialog_button', 'playLvl_Img_dialog_button', () => { click(); this.closeOverlay(); }).setOffAlpha(0),
    ];
    for (const o of this.overlay) this.root.add(o);
  }

  update() {
    // While a dialog is open only its buttons respond, like the original deactivating the menu.
    if (this.overlay.length) for (const o of this.overlay) o.update();
    else super.update();
  }
}

class EndDialog extends State {
  constructor(private score: number, private won: boolean) { super(); }
  create() {
    this.add(fixed(new Sprite(0, 0, 'blackScreen_dialog_backGround_Img')));
    this.add(fixed(new Sprite(255, 430, 'blackScreen_dialog_dialog_img')));
    this.add(fixed(new Text(this.won ? 290 : 300, 433, 200, this.won ? 'You survived!' : 'You died').setFormat(8, DIM, 'left', SHADOW)));
    this.add(fixed(new Text(270, 449, 200, this.won ? ' Menu' : 'Menu              Retry').setFormat(8, LIGHT, 'left', SHADOW)));
    this.add(fixed(new Text(0, 190, 640, `Final score: ${this.score}`).setFormat(32, 0xffffff, 'center', SHADOW)));
    this.add(new Button(256, 449, 'Shop_Img_main_menu_button_light', 'Shop_Img_main_menu_button_light', () => { click(); switchState(screens.menu); }).setOffAlpha(0));
    if (!this.won) {
      this.add(new Button(322, 449, 'Shop_Img_main_menu_button_light', 'Shop_Img_main_menu_button_light', () => {
        click();
        switchState(save.lvl === 1 ? newPlay : screens.afterWave);
      }).setOffAlpha(0));
    }
  }
}
