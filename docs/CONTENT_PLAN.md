# Radio Zed reboot — new content plan (draft)

**Decided (30 Oct 2026):** Classic mode stays exactly as 2010, and new content lives in a
separate Reboot campaign. New map backdrops are AI-assisted, then locked to the original
palette and pixel grid and hand-fixed. All four content areas are wanted: maps, weapons and
equipment, enemies, and the restored cut skills. The district and item lists below are
still open for changes.

**Superseded in part (30 Oct 2026):** the "Reboot campaign" is now a story mode with
bases, exploration, day/night and scavenging. See [STORY_MODE.md](STORY_MODE.md). The
enemy, weapon, equipment and skill ideas below still apply.

Goal: more maps, more shop items and more variety, without changing what Radio Zed *is*:
a side-on fat-pixel street at night, one building, a radio on top, waves from both sides,
two partners, barricades, and a shop between waves paid for with money and special points.

Rule of thumb for every addition: it should look like it shipped in 2010. Same 17×32
characters, same palette, same 640×480 framing, same Nokia HUD font, same shop layout.

## 0. Modes

| Mode | What it is |
|---|---|
| **Classic** | The 2010 game exactly: 3 maps, 60 waves, original shop. Always available. |
| **Reboot campaign** | Original maps + new maps as "districts", new enemies and shop items. |
| **Endless** (later) | Any unlocked map, waves scale forever, leaderboard of your own runs. |

Classic stays untouched so there is always a faithful baseline to compare against.

## 1. Maps

Same structure as the originals (data format already exists in `game/src/game/levels.ts`):
a building centred in the 1072 px street, floors 80 px apart, doors between floors, radio
on top, a barricade each side, spawners at both ends. Variety comes from floor count,
door placement, building width, and small rule twists.

| # | District | Twist (within the original rules) |
|---|---|---|
| 1–3 | Corner Shop / Apartments / Tower Block | The originals. |
| 4 | **Gas Station** | Wide and low: 1 floor + canopy roof, radio on the canopy. Zombies reach the radio fast; barricades matter most. |
| 5 | **Police Station** | Holding cells: an extra mid-street barricade pair; unlocks the armoury weapons. |
| 6 | **Hospital** | Many short floors; medkits unlock; zombies in gowns (recolour). |
| 7 | **Church** | Tall and narrow, radio in the bell tower, doors alternate sides so zombies zig-zag. |
| 8 | **Radio Station** | Finale: the signal source. Two radios to protect, boss wave. |

Campaign shape: each district ~8 waves, ending in a harder "siege" wave, then the next
district unlocks. Barricades and skills carry over as in the original.

## 2. Enemies

The original has one zombie class with two speed archetypes. New types reuse the 17×32
sheet layout (24 walk frames, 4 attack, 1 dead) so they animate with the same code.

| Type | Behaviour | Art |
|---|---|---|
| Walker / Runner | The originals (slow / fast archetypes). | existing |
| **Brute** | 300 HP, hits barricades for 3, slower. | existing sheet scaled/thickened + recolour |
| **Crawler** | Half-height hitbox, no headshot zone. | new short sheet (edit of dead frame) |
| **Climber** | Ignores doors, climbs the outside wall to the next floor. | recolour |
| **Screamer** | Speeds up nearby zombies. | recolour + new sound |
| **Boss** | One per finale wave, huge HP, knocks partners back. | new 2× sprite |

This also fills in the unused `attack2` hook in `zombie1.as`.

## 3. Shop

Keeps the original four panels (Character / Weapons / Partners / Barricades) and adds a
second page per panel where needed.

**Character skills (SP)** — restores the two skills named in the original text but cut:
* **Damage** (player_damage 1 → 1.1 → 1.25 → 1.5); the variable already exists.
* **Regeneration** (heal 0 / 1 / 2 / 3 HP per second while not hit for 3 s).

**Weapons (money)** — slot after the M249, same buy/upgrade model:
* Remington 870 shotgun: 6 pellets, short range.
* Barrett M82: pierces up to 3 zombies.
* M79 grenade launcher: lobbed, splash damage.
* MP5: cheap, accurate SMG between the Uzi and the G36.

**Equipment (new panel, money)** — consumables, bought per wave:
* Medkit (H): +50 HP. Grenades (G): thrown at the mouse. Radio armour: +50 radio HP for one wave.
* Spike strip: slows zombies on one side. Door lock: a floor's door holds for N seconds.

**Barricades** — levels 4–5, plus door barricades from district 5.

**Partners** — weapon swap for Willson/Summer, and doors for partners (the unused
`_doorsUp`/`_doorsDown` fields in `BotFriend.as`).

## 4. Achievements

Keep the original 42. Replace the dead "Click on the sponsor logo" (#26) with
"Visit the credits screen", and add a second grid for districts, new enemies and weapons.

## 5. Art and sound

| Need | Amount | Approach options |
|---|---|---|
| Map backdrops (1072×480) | 5 | biggest cost — see options below |
| Enemy sheets (17×32) | 4–5 | recolours / edits of existing sheets |
| Weapon arms + shop icons | 4 + icons | edits of existing arms (same angles/sizes) |
| Equipment icons, HUD bits | ~10 | small, hand-pixelled |
| Sounds | ~10 | pitch/variants of the original 23, or CC0 libraries |

Backdrop options:
* **A. Remix**: build new buildings from slices of the three original backdrops (floors,
  balconies, roofs, signage) plus recolours. Consistent style, limited novelty.
* **B. Artist**: you or a commissioned pixel artist draws them against a style sheet
  (palette, pixel scale, floor heights) we extract from the originals.
* **C. AI-assisted**: generate, then downscale to the 2× pixel grid and lock to the original
  palette, then hand-fix. Fast, needs cleanup to match.

## 6. Order of work

1. Port the original shop and stats screen; Classic mode complete. (Required either way.)
2. Make the content data-driven: enemy types, shop catalogue, wave tables per mode.
3. Restore the cut skills, add new enemies and weapons (cheap art).
4. New maps one at a time, then the campaign wrapper.
5. Endless mode, new achievements, polish.
