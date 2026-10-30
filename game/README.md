# Radio Zed — reboot

A TypeScript rebuild of *Radio Zed* (BadHed, 2010), ported from the decompiled original.
The recovered rules and numbers are in [`../docs/ORIGINAL_SPEC.md`](../docs/ORIGINAL_SPEC.md);
the readable original source is in `../source_recovered/radiozed/`.

## Run

```bash
npm install
npm run dev        # http://localhost:5173
npm run build      # static site in dist/
```

## Controls (as the original)

A/D or ←/→ move · W/↑/Space jump · S/↓ use a door · mouse aim, click/hold to fire ·
R reload · 1–9 weapons, Q/E or wheel to cycle · F reposition partners · Esc menu ·
0 mute, −/+ volume.

## Layout

```
src/engine/   mini Flixel 2.23: sprites, groups, text, camera, physics, emitter, input, sound
src/game/     the game, one file per original class (play.ts = PlayLvl.as, zombie.ts = zombie1.as ...)
src/assets/   images, sounds and fonts extracted from the SWF (sponsor/Flixel branding removed)
```

## What differs from the 2010 original

* Logic at a fixed 60 Hz (was 30 fps), rendered at the display rate with interpolation.
* Crosshair and gun arm re-aim every rendered frame; presses are latched so quick clicks
  are never dropped.
* Integer pixel scaling to any window size; optional "Wide view" (menu) shows more street.
* Esc pauses the game behind the "Return to main menu?" dialog.
* R does nothing on a full magazine.
* Sponsor links, MochiBot, Zattikka hi-scores and the Flixel social panel are gone.

## Status

Done (Classic mode): menu, waves 1–60 on the three original maps, player, all 9 weapons,
zombies, partner bots, barricades, radio, doors, gibs, HUD, the shop (skills, partners,
weapons, barricade upgrades and repairs), achievements and stats screen, game over / win,
saving.

Reboot change: achievement 26 ("click the sponsor logo") is awarded for opening Help.

Not yet checked against the original by hand: a full 60-wave run, the win screen, sound
levels, fade timing.

Story mode (prototype, `src/story/`, design in `../docs/STORY_MODE.md`): explore the
Corner Shop by day, defend it at night. S opens doors and searches; holding S peeks through
keyholes or pries boards; S at the radio waits for nightfall; L toggles the flashlight.
Each dawn opens the camp: set jobs, check weapons and ammo, repair or reinforce barricades,
put up street lamps. Threat builds the longer you stay and the more noise you make; when it
fills, the night is a siege and you run for it. Hold S at the radio to move on early. The city
map leads through generated buildings to the Radio Station.
