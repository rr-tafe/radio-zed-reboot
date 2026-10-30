# Radio Zed (2010) — recovered specification

Everything here was read out of the decompiled original (`source_recovered/radiozed/`, the
17 Sep 2010 build, Flixel 2.23, sponsor BadHed). File references point at that tree. The
9 Sep and 7 Sep builds have identical balance numbers; the only gameplay difference is the
final wave (7 Sep: wins after wave 31; 9 & 17 Sep: after wave 60).

## Engine facts

| Thing | Value | Source |
|---|---|---|
| Stage | 640×480, zoom 1 (art is drawn with 2×2 "fat" pixels) | `Zombie_game.as` |
| Frame rate | 30 fps, `FlxG.elapsed` = real frame time capped at 0.0333 s | `FlxGame.as` |
| World | 1072×480; collision tilemap = map PNG (67×30) scaled ×2 into 8 px tiles → 16 px cells | `PlayLvl.create` |
| Camera | follows player, lerp 1, `followAdjust(0.1, 0)` (look-ahead 0.1 × velocity), clamped to x 30…1055 | `PlayLvl` |
| Motion | Flixel 2 `computeVelocity`: accel if non-zero else drag, then clamp to maxVelocity | `FlxU.computeVelocity` |
| Collision | only dynamic-vs-static: `_blocks` (tilemap + barricade blocks) vs player, bots, zombies, gibs | `PlayLvl.update` |
| Parallax | sky (scroll 0), city layers at 0.1 / 0.3 / 0.4, building backdrop at 1.0 | `PlayLvl.create` |
| Save | `SharedObject "reloaded"` — single save slot, keys listed below | `Zombie_game.as` |

## Maps (the original's "levels")

The wave number selects one of three layouts of the same street. All have two barricades,
a radio, two partner bots and two zombie spawners at x=1 and x=1051 (y=400).

| Waves | Backdrop | Collision map | Floors | Radio | Barricades (x) |
|---|---|---|---|---|---|
| 1–8 | `playLvl_ImgBackgr` | `ImgMap` | 2-storey shop | (586, 208) | 317 / 716 |
| 9–18 | `ImgBackgr2` | `ImgMap2` | 3-storey | (446, 128) | 280 / 746 |
| 19–60 | `ImgBackgr3` | `ImgMap3` | 3-storey, wider | (446, 128) | 280 / 746 |

Doors (`DoorUp`/`DoorDown`, 20×32, invisible): standing in one and pressing S/↓ moves the
player 81 px up (DoorUp) or 79 px down (DoorDown). Zombies use DoorUp only: when a zombie
is 50+ px below the radio it walks to the DoorUp on its floor and teleports 80 px up.
Help graphic `playLvl_ImgHelp` is painted into the sky at (580, 66) on waves 1–2.

## Waves

* Zombies per wave (per spawner — total is ×2): `Params.numberOfZombie`
  `[_,15,15,10,16,15,20,25,20,32,35,30,35,40,35,35,35,40,25,40,45,50,60,60,60,65,60,70,75,80,80,65,60,80,85,80,100…]`
* Seconds between spawns: `Params.spawnersArray_for_spawn`
  `[_,9,8,2,5,1,3,3,2,3,3,1,3,2,3,2,1,2,1,2,2,1,2,1,2,1,1,2,3,1,2,2,2,3,2,1, then 2,2,2,3,2,1 repeating]`
* Each spawner starts with a random 0–20 s timer, so the first zombie can take a while.
* The wave ends when every zombie is dead → 1 s fade → rewards banked → shop. Losing the
  player or the radio → fail sound, fade, game-over dialog; barricade damage that wave is rolled back.
* After wave 60 → win screen.

## Player (`Player.as`)

* Hitbox 14×32 (sprite 17×32), gravity 400, `maxVelocity.x` = speed skill, drag = 4 × speed.
* Movement clamped to x 170…900. Jump (W/↑/Space, on floor only): vy = −124.
* Faces the mouse. Arm sprite rotates toward the mouse (`PlayerArm.update`).
* Fire: click for pistols (Glock, Eagle); hold for everything else. Can't fire within 5 px of the arm.
* Shot: camera shake 0.005 for 0.1 s; bullet speed 1100 with **Manhattan-normalised** velocity
  (|vx|+|vy| = 1100, so diagonal shots are slower — part of the feel). Spread: ± random(accuracy)
  px added to the target point, ignored if the target is < 100 px away.
* R reloads, 1–9 select weapon, Q/E or mouse wheel cycle owned weapons, F cycles bot positions,
  Esc opens "Return to main menu?".
* Headshot: bullet y within 7 px below zombie's top → damage × `player_zHunter`.
* Each kill: +100 score, money + floor(random 0–19) + `player_luck`.
* Zombie hit on player: 8 damage per second of contact.

## Weapons (`PlayerArm.as`, `Params.as`)

| # | Name | Mag | Reload s | Delay s | Dmg | Dmg upgraded | Buy $ | Upgrade $ |
|---|---|---|---|---|---|---|---|---|
| 1 | Glock-17 | 15 | 4 | 0 (click) | 10 | 15 | owned | 400 |
| 2 | Desert Eagle | 8 | 5 | 0 (click) | 15 | 21 | 800 | 1000 |
| 3 | Uzi | 40 | 5 | 0.09 | 6 | 10 | 1400 | 1800 |
| 4 | HK G36 | 35 | 6 | 0.15 | 8 | 12 | 2400 | 3000 |
| 5 | Steyr AUG | 30 | 4 | 0.15 | 10 | 15 | 3800 | 4200 |
| 6 | AK-47 | 30 | 7 | 0.2 | 13 | 16 | 4800 | 5800 |
| 7 | M-16 | 30 | 6 | 0.14 | 15 | 18 | 6400 | 7200 |
| 8 | SM SSG 69 | 6 | 5 | 1.0 | 70 | 100 | 12000 | 14000 |
| 9 | FN M249 SAW | 100 | 16 | 0.08 | 15 | 25 | 24000 | 28000 |

Reload time × `player_recharge`. Ammo is tracked per weapon between switches.

## Zombies (`zombie1.as`)

* 18 skins (`zombie1_ImgZombie00…17`), 100 HP, 14×32, gravity 400, drag = 4 × speed.
* Slow skins (00,01,04,08–17) pick speed from `[10,16,14,17,18,19,20,30]`;
  fast skins (02,03,05,06,07) from `[20,25,27,30,37,40]`. Walk anim fps = speed / 2.
* Target: player if within 50 px; else the radio (climbing via doors when 50+ px below it).
* Attack once per second on contact: radio −1, barricade −1, player −8 (+40 blood gibs).
* Blocked by a barricade's invisible `Block` until the barricade reaches 0 HP.
* Hit: 3 gibs. Death: 50 gibs, falls flat, corpse stays 60 s, flickers in its last second.
* Sounds: 1-in-50 chance of a growl on spawn; 3-in-20 chance of a death sound.

## Partner bots (`BotFriend.as`, `BotArm.as`)

* Willson (bot 1, AK, mag 30, delay 0.2) on the lower floor; Summer (bot 2, SSG, mag 6, delay 1)
  upstairs. Reload 5 s. They patrol to a defend x (left/right) and fire at zombies that enter
  invisible marker strips (`Bot_Marker`) covering their floor or the street side they guard.
* F cycles: split (Willson left, Summer right) → both left → both right.

## Barricades, radio

* Barricade HP persists between waves. Max HP 100 → 150 → 200 → 250 with upgrades
  ($1000 / $3000 / $9000, each +50 HP). Repairs: +10% $50, +30% $150, full $500.
* Radio: 100 HP, resets every wave.

## Progression / shop (`Shop.as`, `Params.as`)

Special points (SP) are earned per wave (8 base, raised by the "Educability" skill) and from
achievements. Skills have 3 tiers costing 5 / 10 / 15 SP, bought in order.

| Skill | Base → tier 1 → 2 → 3 |
|---|---|
| Health | 100 → 125 → 150 → 200 |
| Educability (SP per wave) | 8 → 9 → 11 → 12 |
| Accuracy (spread px) | 20 → 15 → 10 → 5 |
| Speed | 100 → 115 → 130 → 150 |
| Reload multiplier | 1 → 0.8 → 0.6 → 0.4 |
| Headshot multiplier | 1.2 → 1.4 → 1.6 → 2 |
| Luck (money per kill bonus) | 20 → 25 → 30 → 35 |
| Willson speed / damage / spread | 60→70→80→100 / 10→15→20→25 / 20→15→10→5 |
| Summer speed / damage / spread | 60→70→80→100 / 20→30→40→50 / 15→10→5→2 |

A new save starts with 0 SP and $0; SP is credited at the end of each cleared wave.

## Achievements

42 achievements in a 7×6 grid (`Params.achievements`, text in `Texts.as`). Rewards are score,
SP or money. Two referenced dead features: #26 "click the sponsor logo" and #28 "just die".

## Save keys (`SharedObject "reloaded"`)

`visits, lvl, maxLvl, score, sp, money, moneyEarned, stat[7], bulletMiss, bulletHit, headShoot,
zombieKilled, bulletShot[9], leftBarricade(_Max,_lvl), rightBarricade(_Max,_lvl),
playerSkills[7][3], bot1Skills[3][3], bot2Skills[3][3], playerWeapons[9][buy,upgrade],
barricadesUpgrade[2][3], archivement[7][6]` (value 2 = owned/bought, 1 = achieved).

## Assets

`extracted/<build>/images` (191 PNGs, named by original class) and `sounds` (25 MP3s,
44.1 kHz). There is no music in the original. Sponsor/social art (BadHed, Andkon, Flixel
social panel) is not used by the rebuild.
