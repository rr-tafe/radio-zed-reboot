// FlxButton: shows `off` normally and `on` while hovered; fires on click.

import { G, Sprite } from './core';
import { keys, mouse } from './input';

type Face = string | Sprite;
const face = (f: Face) => (typeof f === 'string' ? new Sprite(0, 0, f) : f);

export class Button extends Sprite {
  private on: Sprite;
  private off: Sprite;
  hovering = false;
  /** Called when the button is clicked. */
  onClick: () => void;

  constructor(x: number, y: number, off: Face, on: Face, onClick: () => void) {
    super(x, y);
    this.off = face(off);
    this.on = face(on);
    this.width = this.off.frameWidth || this.off.width;
    this.height = this.off.frameHeight || this.off.height;
    this.solid = false;
    this.moves = false;
    this.scrollFactor = { x: 0, y: 0 };
    this.onClick = onClick;
  }

  /** Hide the idle graphic (the original used alpha 0 for invisible hit areas). */
  setOffAlpha(a: number): this {
    this.off.alpha = a;
    return this;
  }

  update() {
    const mx = mouse.screenX - G.scroll.x * (1 - this.scrollFactor.x);
    const my = mouse.screenY - G.scroll.y * (1 - this.scrollFactor.y);
    this.hovering = mx >= this.x && mx < this.x + this.width && my >= this.y && my < this.y + this.height;
    if (this.hovering && keys.justReleased('MOUSE')) this.onClick();
  }

  draw(ctx: CanvasRenderingContext2D) {
    const s = this.hovering ? this.on : this.off;
    s.x = s.px = this.x;
    s.y = s.py = this.y;
    s.scrollFactor = this.scrollFactor;
    s.draw(ctx);
  }
}
