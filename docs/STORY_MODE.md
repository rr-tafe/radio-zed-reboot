# Radio Zed — Story mode design (draft)

Classic mode stays the exact 2010 game. Story mode is a new mode built from the same
pieces: the side-on fat-pixel street, one building at a time, the radio, partners,
barricades, and doors between floors.

**Decided (30 Oct 2026):**
* Friends' deaths are permanent; new survivors can be found.
* Scavenging works both ways: send a party off-screen, or lead a run yourself.
* Locations and their contents are **procedural** each run, with a light story.
* Cash exists only for traders; supplies are the main economy.

## Premise

A group of friends hold out in a city overrun by zombies. They keep a battered radio
running because it picks up a looping broadcast, faint at first, that promises an
evacuation point. Every base they hold gets overrun in the end, so they flee, regroup
somewhere new, and follow the signal across the city. The story ends at the Radio Station,
the source of the broadcast.

The radio stays the thing you protect, as in the original. Now it also has a reason to
matter: it's how the group tracks the signal, and if it is lost the night is lost.

## The loop

```
 ┌──────────── one base (a "chapter") ─────────────┐
 │  DAY   explore the building · scavenge · build  │
 │   ↓                                             │
 │  NIGHT defend the radio (original gameplay)     │──► threat full ──► OVERRUN:
 │   ↓                                             │     flee sequence → travel
 │  DAWN  injuries, food, threat rises             │     → new, unexplored base
 └──────────────── repeat ─────────────────────────┘
```

### Day: exploration and preparation

* **Arriving at a new base, the building is unexplored.** Rooms behind closed doors are
  drawn dark (a fog layer over each room's rectangle) until someone opens the door.
* **Doors** can be: open, closed, locked (needs a key or crowbar), or barricaded from inside.
* **Keyholes**: some doors have one. Peeking (hold S at a door) shows a small circular
  view of the room: whether there are zombies, supplies or a survivor. Some doors have no
  keyhole, some are too dark to see through on a moonless night, and a zombie may be
  pressed against the other side.
* **Rooms hold** supplies, cash, ammo, weapons and notes (story fragments), and
  sometimes zombies or a survivor who can join the group.
* **Building**: spend materials on barricades, door locks, repairs, and boarding up
  stairwells to change which routes zombies use at night.
* Zombies still wander by day, fewer and slower. Gunfire is loud and raises threat.

### Night: defence

The original gameplay: waves from both sides, partners on their floors, zombies climbing
through doors toward the radio. What changes:

* **Moon phases**: a full moon lights the street; on a moonless night the screen is dark
  apart from light sources (muzzle flashes, a flashlight cone, lamps you placed, fires).
  Dark nights bring more zombies.
* Each night's size depends on how long you've stayed and how much noise you've made.

### Threat and being overrun

* Every base has a **threat meter**. It rises each night, rises faster with gunfire and
  with zombies left alive at dawn, and drops a little if you stay quiet by day.
* When it fills, the next night is a **siege** that cannot be held. Partway through, the
  radio crackles with a new bearing and the group must **flee**: a short run to the exit
  with whatever people can carry. Anything left behind is lost.
* You can also choose to leave early, before the siege.

### Travel and the city map

* A **city map** screen shows known locations and the signal's bearing. Exploring and
  radio fragments reveal new locations.
* Moving the group takes a day. Locations differ in size, floors, loot and danger.

### Scavenging parties

* From the city map, send 1–3 friends (not the player) to a known location for a day.
* The odds depend on their weapons, skills, the location's danger, and the moon. They
  come back with supplies, injured, with a new survivor, or not at all.
* Whoever is out scavenging isn't defending that night: fewer partners on the walls.
* Or **lead the run yourself**: a short daytime side level at that location (generated
  the same way as a base), playing as the leader with up to two friends. You only bring
  back what you carry, and you must reach the exit before dusk.

## The group

* You play one character. Up to 4 friends can join, two of whom guard floors at night as
  partners (Willson and Summer from the original are the first two).
* Each friend has a name, a portrait in the shop's person slot, a weapon, health, and
  skills (the original partner skills: speed, damage, accuracy).
* Jobs each day: **guard** (night partner), **scavenge**, **rest** (heal), **build**.
* Injuries carry over between days. **Deaths are permanent.** If the player character
  dies, the run ends.

## Resources

| Resource | Used for |
|---|---|
| Food | each survivor eats daily; hungry survivors heal slower and aim worse |
| Ammo (by calibre: 9mm, 5.56, 7.62, 12ga, .50) | each weapon draws from its calibre pool |
| Materials | barricades, repairs, door locks, boarding up stairs |
| Medicine | heal injuries |
| Cash | trade with traders found in some locations (the original's money) |
| Batteries / fuel | flashlights, lamps, the radio itself on dark nights |

Weapons are found in rooms or bought from traders rather than unlocked in a menu.
Upgrades and skills still use the original shop panels, reached at the base by day.

## A run (procedural)

* Each run generates a **city**: a graph of locations spread between the start and the
  Radio Station, with the signal's bearing pointing the way. A run is roughly 6–10 bases.
* **Location types** set the shape and loot of the generated building:

  | Type | Shape | Leans toward |
  |---|---|---|
  | Corner shop | 2 floors, wide | food, cash |
  | Apartments | 3–4 floors | survivors, mixed supplies |
  | Gas station | 1 floor + canopy | fuel, materials, a trader |
  | Police station | 2–3 floors, cells | ammo, weapons, locked doors |
  | Hospital | 3–5 short floors | medicine, many closed rooms |
  | Tower block | 5–6 floors | everything, more zombies inside |
  | Church | narrow + bell tower | few supplies, very defensible |

* The **first base is the original Corner Shop** and the **last is the Radio Station**,
  both hand-built. Everything between is generated from the type's rules.
* **Light story**: a pool of radio fragments, notes and survivor encounters is drawn
  each run, plus fixed beats at the start, the midpoint and the Radio Station.
* Difficulty grows with distance from the start: more zombies, darker nights, fewer
  supplies, and new enemy types appearing.

## Procedural buildings and art

The originals are single painted backdrops, but generated buildings need **modular art**
that snaps together on the 16 px grid with 80 px floors:

* facade pieces (walls, windows, balconies, roofs, signs) per location type;
* room interiors in a few widths (kitchen, office, cell, ward, storage, stairwell...);
* doors in each state (open, closed, locked, barricaded, with or without a keyhole);
* props that hold loot (cabinets, lockers, crates, bodies).

The plan is still AI-assisted: generate each kit, cut it to the 2×2 pixel grid, lock it to
the original palette, and hand-fix it. Pieces can be checked against the three original
buildings, which were drawn the same way. The generator writes the same data a
hand-built map uses (collision, doors, rooms, radio, barricades, markers), so Classic and
story mode share one engine.

## Fit with the original

* Same view, scale, palette, font, controls and the same core night fight.
* Day versions of the backdrops: AI-assisted art locked to the original palette, plus a
  lighting pass. The building backdrops stay; rooms gain fog and lighting layers.
* Moon/no-moon skies already exist in the original's assets.
* New characters, enemies and weapons use the original sprite sizes and layouts.

## Build order

1. **Classic complete**: port the original shop and stats screen (needed by both modes).
2. **Rooms and doors on the original Corner Shop**: fog of war, door states, keyholes,
   loot props. Tested on hand-made room data before any generator exists.
3. **Day/night and lighting**: the day phase, moon phases, the darkness layer, a flashlight.
4. **Group and resources**: friends with jobs, calibre ammo, food, materials, campaign save.
5. **Threat, overrun and flight**: the siege, the escape run, then the city map and travel.
6. **Scavenging**: off-screen parties first, then playable runs.
7. **Generator plus the first art kit** (one location type, e.g. apartments), then more types.
8. New enemies and weapons, traders, story fragments, Radio Station finale.

Steps 2–5 can be prototyped on the original art before any new art exists.

### Progress

* **Step 1 done** (on `main`): Classic mode complete.
* **Step 2 done** (branch `story-mode`): Corner Shop exploration in `game/src/story/`.
  Fogged floors; four back rooms (storeroom with a zombie, office locked behind a key from
  the bar, washroom with no keyhole and two zombies, boarded roof hut); five searchable
  props; keyhole peeking; resource HUD; separate save; permadeath.
  * Zombies that come out of a room now stumble for 1.2 s (+0.4 s each extra) before they
    can attack, since a zombie landing on the player with only the Glock was a near-certain loss.
* **Step 3 done** (branch `story-mode`): day/night and lighting.
  * Clock 06:00–18:00 over about 4 real minutes; at the radio, S waits for nightfall (fast-forward).
  * Dusk (15 s) and dawn (8 s) transitions; painted day sky with drifting clouds; the
    original's night skies at night (moon sky on bright nights, moonless skies otherwise).
  * 8-night moon cycle (random start per run). Darkness: full 0.15 → bright 0.45 → half 0.62
    → thin 0.78 → none 0.9. Darker nights bring up to 36% more zombies.
  * Night N sends Classic wave N's size and spawn rate; two wanderers per side by day.
  * Lights: player pool, partners, radio, muzzle flashes, tracers, flashlight cone (L; one
    battery per 90 s; new runs start with one battery). Keyholes are too dark to see through
    on black nights without the flashlight.
  * Story barricades are stored in the story save; the radio resets each night.
* **Step 4 done** (branch `story-mode`): group and resources.
  * Armoury: weapons are found as loot (Uzi in the storeroom, Desert Eagle in the office) and
    reload from calibre reserves (9mm, .50 AE, 5.56, 7.62). **Decision:** the Glock never runs
    dry, so a run can't end just because ammo did; partners also have unlimited ammo for now.
  * Group: Willson and Summer to start (up to 4 friends). Jobs: guard (up to two, filling the
    original's partner slots), rest, build. Guards can be hurt (8 per hit) and die for good.
  * Dawn upkeep: 1 food each (hungry = no healing, worse aim); rest heals 40, otherwise 10;
    medicine on anyone below half; builders spend 2 materials on the weaker barricade.
  * Camp screen at dawn on the original shop frame: report, jobs, armoury, fortify (repair,
    reinforce with the original barricade upgrade art, street lamps).
  * Story mode uses base stats; Classic's skill purchases don't carry over.
  * Not yet: new survivors to recruit, a trader for cash, ammo for partners, a lamp sprite,
    leader health carried between days, opening the camp mid-day.
* **Step 5 done** (branch `story-mode`): threat, overrun, flight, city map.
  * Threat per base (HUD): +18 per night survived (+4 per night already there), +0.15 per shot
    by day, +3 for prying boards, −8 for a day without gunfire. At 100 the next night is a siege.
  * Siege: three times the wave, one zombie a second from each side. After 35 s (or if the radio
    falls) the radio finds a new bearing, the left barricade is breached, and reaching the street
    on the left opens the city map. Losing the radio during a siege doesn't end the run.
  * Leaving early: hold S at the radio by day (2 s); the map offers "Stay here".
  * City: 6 columns from the Corner Shop to the Radio Station, 2–3 locations per column, seeded
    per run, drawn over the darkened menu art. Travel takes a day; fleeing loses half of every
    consumable, leaving in good order only drops materials beyond 6 per person. Barricades and
    lamps stay behind.
  * Generated bases use the three original buildings as templates (doors, props and floors
    measured from the art). The Apartments have no back doors drawn, so the Corner Shop's door
    art is stamped onto the wall. Door kinds, keyholes, zombies and loot are rolled by location
    type and danger; locked doors' keys are hidden in props.
  * Radio Station: placeholder ending (days survived, who made it, who was lost); closes the run.
  * Only three location types exist until new art arrives (step 7): shop, apartments, tower. Gas
    station, police station, hospital and church need their own art kits.
* **Step 6 done** (branch `story-mode`): scavenging.
  * Off-screen: give friends the **Scav** job and pick a target at camp (any location within one
    column, not the station). They're away for the day and night, so they can't guard. At dawn:
    loot rolled from that kind of place (more for bigger, stronger parties), injury or death odds
    that rise with danger and the night's darkness and fall with the party's strength, and a
    chance of finding a survivor who joins (up to four friends, named from a pool).
  * Playable: **Lead the run** at camp plays a daytime level at the target with the scavengers as
    partners, no radio and broken barricades; zombies hunt the player. A warning at 17:00, the
    place floods at dusk; S on the left street heads home, arriving at dusk with what was found.
  * Not yet: a flooded run's dusk was not exercised in the browser; partner names for recruits
    reuse Willson's and Summer's sprites until new art exists.

## Open questions

* If the player character dies, does the run end, or does a friend take over?
  (Assumed for now: the run ends.)
* How long is a run? Assumed 6–10 bases, about 1–2 hours.

## Technical additions

* **Room data per map**: rectangles, doors (type, keyhole yes/no, lock), loot tables.
* **Lighting**: a darkness layer with light holes (moon level, flashes, flashlight, lamps).
* **Persistence**: a campaign save (group, resources, map knowledge, current base state)
  separate from the Classic save.
* **Event and dialogue system**: short text boxes in the original dialog style, for
  story beats, notes and scavenging reports.
