// The city map: pick where the group goes next. Drawn over the original menu's isometric
// city art, darkened, with the run's locations as nodes and the radio signal's bearing.

import { G, Sprite, State, Text, switchState } from '../engine/core';
import { keys, mouse } from '../engine/input';
import { play } from '../engine/sound';
import { TEXT_COLOR, TEXT_SHADOW } from '../game/data';
import type { Screens } from '../game/play';
import { CampState } from './camp';
import { CityNode, Departure, currentNode, nextNodes, travelTo } from './city';
import { newStory, persistStory, story } from './storySave';
import { dawnUpkeep } from './upkeep';

const DIM = 11052705;
const nodePos = (n: CityNode): [number, number] => [80 + n.col * 96, 150 + n.row * 90];

function label(x: number, y: number, text: string, size = 8, color = TEXT_COLOR, align: CanvasTextAlign = 'left', w = 640): Text {
  const t = new Text(x, y, w, text).setFormat(size, color, align, TEXT_SHADOW);
  t.scrollFactor = { x: 0, y: 0 };
  return t;
}

class MapDrawing {
  exists = true;
  visible = true;
  active = true;
  hover: CityNode | null = null;
  constructor(private reachable: CityNode[]) {}
  update() {
    this.hover = this.reachable.find((n) => {
      const [x, y] = nodePos(n);
      return Math.abs(mouse.screenX - x) < 40 && Math.abs(mouse.screenY - y) < 22;
    }) ?? null;
  }
  draw(ctx: CanvasRenderingContext2D) {
    const city = story.city;
    const cur = currentNode();
    ctx.lineWidth = 2;
    for (const [a, b] of city.edges) {
      const na = city.nodes.find((n) => n.id === a)!;
      const nb = city.nodes.find((n) => n.id === b)!;
      const live = a === cur.id;
      const travelled = city.visited.includes(a) && city.visited.includes(b);
      ctx.strokeStyle = live ? '#e2dcd7' : travelled ? '#a8a29a' : 'rgba(168,162,154,0.35)';
      ctx.setLineDash(live || travelled ? [] : [4, 4]);
      const [x1, y1] = nodePos(na);
      const [x2, y2] = nodePos(nb);
      ctx.beginPath();
      ctx.moveTo(x1 + 0.5, y1 + 0.5);
      ctx.lineTo(x2 + 0.5, y2 + 0.5);
      ctx.stroke();
    }
    ctx.setLineDash([]);
    for (const n of city.nodes) {
      const [x, y] = nodePos(n);
      const reach = this.reachable.includes(n);
      const fill = n.id === cur.id ? '#e2dcd7' : reach ? (this.hover === n ? '#ffe28a' : '#d8b25a') : city.visited.includes(n.id) ? '#8a857e' : '#4b4741';
      ctx.fillStyle = '#233e58';
      ctx.fillRect(x - 6, y - 6, 14, 14);
      ctx.fillStyle = fill;
      ctx.fillRect(x - 7, y - 7, 14, 14);
      if (n.type === 'station') {
        // A little mast for the signal source.
        ctx.fillRect(x - 1, y - 19, 2, 12);
        ctx.fillRect(x - 5, y - 19, 10, 2);
      }
    }
  }
}

export class CityMapState extends State {
  private reachable = nextNodes();

  constructor(private screens: Screens, private how: Departure | 'view', private makeDay: () => State, private back?: () => State) {
    super();
  }

  create() {
    G.scroll.x = G.scroll.y = 0;
    const bg = this.add(new Sprite(0, 0, 'blackScreen_dialog_backGround_Img'));
    bg.scrollFactor = { x: 0, y: 0 };
    bg.moves = false;

    this.add(label(0, 40, 'The city', 16, TEXT_COLOR, 'center'));
    const sub = this.how === 'flee' ? 'Run! Pick somewhere to regroup.' : this.how === 'leave' ? 'Where to next?' : 'The signal is coming from the Radio Station.';
    this.add(label(0, 62, sub, 8, DIM, 'center'));

    const map = this.add(new MapDrawing(this.how === 'view' ? [] : this.reachable));
    for (const n of story.city.nodes) {
      const [x, y] = nodePos(n);
      const danger = n.danger ? ' ' + '!'.repeat(n.danger) : '';
      this.add(label(x - 50, y + 10, n.name, 8, story.city.visited.includes(n.id) || this.reachable.includes(n) ? TEXT_COLOR : DIM, 'center', 100));
      if (n.id !== 'start') this.add(label(x - 50, y + 20, n.type === 'station' ? 'signal' : `danger${danger}`, 8, DIM, 'center', 100));
    }
    this.add(label(0, 420, 'You are at the white square. Paths lead east, toward the signal.', 8, DIM, 'center'));

    const go = { update: () => {
      if (!map.hover || !keys.justReleased('MOUSE')) return;
      this.travel(map.hover);
    }, draw: () => {}, exists: true, visible: false, active: true };
    this.add(go);

    if (this.back) {
      const stay = new Text(0, 444, 640, '[ Stay here ]').setFormat(8, TEXT_COLOR, 'center', TEXT_SHADOW);
      stay.scrollFactor = { x: 0, y: 0 };
      this.add(stay);
      this.add({ update: () => {
        if (keys.justReleased('MOUSE') && mouse.screenY > 440 && mouse.screenY < 456 && Math.abs(mouse.screenX - 320) < 40) switchState(this.back!);
      }, draw: () => {}, exists: true, visible: false, active: true });
    }
  }

  draw(ctx: CanvasRenderingContext2D, alpha: number) {
    // Background, then a dark wash, then the map.
    const [bg, ...rest] = this.root.members;
    (bg.draw as (c: CanvasRenderingContext2D, a: number) => void)(ctx, alpha);
    ctx.fillStyle = 'rgba(8,10,16,0.72)';
    ctx.fillRect(0, 0, G.width, G.height);
    for (const m of rest) if (m.exists && m.visible) (m.draw as (c: CanvasRenderingContext2D, a: number) => void)(ctx, alpha);
  }

  private travel(node: CityNode) {
    play('Shop_SndMenuClick');
    if (this.how === 'view') return;
    const report = travelTo(node, this.how);
    const screens = this.screens;
    if (node.type === 'station') {
      persistStory();
      switchState(() => new StoryEndState(screens));
      return;
    }
    story.report = [...report, ...dawnUpkeep()];
    story.day++;
    story.phase = 'day';
    story.clock = 6 * 60;
    persistStory();
    switchState(() => new CampState(screens, this.makeDay));
  }
}

/** Placeholder ending until the Radio Station finale is built (step 8). */
export class StoryEndState extends State {
  constructor(private screens: Screens) {
    super();
  }
  create() {
    G.scroll.x = G.scroll.y = 0;
    const bg = this.add(new Sprite(0, 0, 'blackScreen_dialog_backGround_Img'));
    bg.scrollFactor = { x: 0, y: 0 };
    bg.moves = false;
    const alive = story.group.map((s) => s.name);
    const lines = [
      'You reach the Radio Station.',
      '',
      `Days survived: ${story.day}`,
      `With you: ${alive.length ? alive.join(', ') : 'no one'}`,
      `Lost along the way: ${story.fallen.length ? story.fallen.join(', ') : 'no one'}`,
      '',
      'The broadcast is still playing. Someone has to be running it...',
      '(The finale comes in a later build.)',
    ];
    this.add(label(0, 150, lines.join('\n'), 8, TEXT_COLOR, 'center'));
    this.add(label(0, 300, '[ Back to the menu ]', 8, TEXT_COLOR, 'center'));
    this.add({ update: () => {
      if (keys.justReleased('MOUSE') && mouse.screenY > 296 && mouse.screenY < 312) {
        // The run is complete; the next Story mode starts a new one.
        newStory();
        switchState(this.screens.menu);
      }
    }, draw: () => {}, exists: true, visible: false, active: true });
  }
  draw(ctx: CanvasRenderingContext2D, alpha: number) {
    const [bg, ...rest] = this.root.members;
    (bg.draw as (c: CanvasRenderingContext2D, a: number) => void)(ctx, alpha);
    ctx.fillStyle = 'rgba(8,10,16,0.78)';
    ctx.fillRect(0, 0, G.width, G.height);
    for (const m of rest) if (m.exists && m.visible) (m.draw as (c: CanvasRenderingContext2D, a: number) => void)(ctx, alpha);
  }
}
