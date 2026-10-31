# AI art: prompt guide (Higgsfield Soul 2)

How to get usable building art for story mode out of `higgsfield-ai/soul/v2/standard`, then fit
it to the original with `game/art-pipeline.html`. Generate with:

```bash
cd tools/higgsfield && npm run image -- --name <stem> --prompt "<subject>. <STYLE>"
```

Outputs land in `art/raw/` (git-ignored). Copy one into `game/art-in/` and open
`http://localhost:5173/art-pipeline.html?src=/art-in/<file>` to fit and save it.

## Style text that works best so far

> 2D side-scrolling video game pixel art. Cutaway cross-section view of the building like a
> dollhouse with the front wall removed so every room inside is visible, seen exactly side-on:
> no perspective, no isometric, no depth. Low resolution chunky pixels, flat colours with very
> little texture or noise, crisp dark 1-pixel outlines, muted desaturated palette of browns,
> greys, dull reds and dark teal, in the style of a 2010 Flash zombie defence game. Night-time,
> dim warm interior lighting. No text, no letters, no logos, no signs, no people. Isolated on a
> plain white background.

Keep `enhance_prompt` off (the script's default): it adds photographic detail.

## What the tests showed (Nov 2026)

| Test | Result |
|---|---|
| 1. Gas station, exterior prompt | Clean side view and outlines, but daytime, gritty texture, exterior only. |
| 2a. Gas station, cut-away style | Interior visible, much flatter colour, but the canopy and floor drawn in perspective. |
| 2b. Police station (2 floors) | **Best.** Front-on doll's house, cells/desks/stairs readable, night lighting. Slight floor depth, AI-added pillars, one stray person, garbled sign text. |
| 2c. Hospital (3 floors) | Floors angled in perspective; text scribbles everywhere. |

Findings:

* **"No text" is ignored.** Anything that suggests writing (signs, posters, notice boards,
  screens, "station") comes out as garbled glyphs. Leave those objects out of the subject.
* **Perspective creeps in** with canopies, deep rooms and many floors. One or two storeys,
  wide and shallow, stay flattest.
* **The pipeline handles colour and pixel size well**, but softens detail. At 400 game px wide
  the police station's floors are ~100 px apart (the original's are 80).
* Pillars and "people" appear unprompted; ask for "open rooms without columns".

## Room-panel tests (round 3)

| Test | Result |
|---|---|
| Police ground floor | **Best yet.** Long low strip, front-on, crisp outlines, flat fills; doorway left, desk, bench, cell, stairs right. Side walls slightly angled; one garbled sign. Fits at **256 × 94 game px** (one storey plus roof edge). |
| Police upper floor | Strip, but with an unwanted roof/mezzanine, angled side walls and noise. |
| Gas station shop ("the inside of…") | A deep one-point-perspective box, product labels everywhere. Unusable. |

Findings:

* **A few named pieces of furniture in a long, low strip stays flat.** Busy subjects (shelves of
  products) and "the inside of…" phrasing produce deep perspective boxes.
* Generators rarely return pure white; the pipeline now finds the background colour from the
  border and flood-fills it away, then crops to the content.
* Next tweaks to try: "back wall parallel to the picture plane, side walls not visible, like a
  theatre stage seen straight on"; "no roof"; fewer, larger objects.

## Stage-style tests (round 4)

| Test | Result |
|---|---|
| Police upper floor | Good long low strip with flat desks, lockers and stairs, but "theatre stage" was taken literally: red stage trim and a painted sunset backdrop. Side walls still angled like wings. |
| Gas station shop | Flatter and wider than round 3 (fridges, counter, shelves), but still a perspective box with side walls, darker, garbled signs. |

Findings:

* Don't say "theatre stage": it draws a stage set. Describing the back wall as "flat and
  parallel to the picture" did not remove the side walls.
* Across five panel attempts Soul reliably gets the strip shape, furniture and pixel style, and
  keeps drawing angled side walls. The back-wall area between them is usable as-is.

## Where this leaves the kit (Nov 2026)

1. **Crop to the back wall.** Cut each panel between its side walls in the pipeline; the flat
   middle tiles as a room, and building ends/facades come from separate pieces.
2. **Look for a reference-image model on Higgsfield.** Soul only takes text (or a trained Soul
   ID). A model that accepts an image as a style or layout reference (e.g. an original
   backdrop floor band) would likely match the 2010 art far better than prompts alone.
3. Expect light hand clean-up (stray text, edges) before pieces go in the game.

## Recommended approach: one storey at a time

Whole buildings drift. Generate **single-storey room panels** instead and assemble buildings
in code, which also suits the procedural generator (a building = a stack of panels):

* Subject: "one storey of a <place>: <2–3 furniture items>, a doorway on the left, a staircase
  on the right", avoiding anything with writing on it.
* Add: "orthographic architectural section, front elevation, flat, no vanishing point, the
  floor drawn as a single horizontal line, open room without columns".
* 16:9; fit each panel to 400 × 80 game px (one floor) in the pipeline.
* Generate facade ends, roofs and the ground strip separately the same way.

Each generation is billed to the Higgsfield account.
