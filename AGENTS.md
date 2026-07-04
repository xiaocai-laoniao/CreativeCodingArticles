# CreativeCodingArticles Instructions

This repository stores creative-coding article projects and runnable browser sketches.

## Project Layout

- Put new article projects under `YYYY/MM/<article-or-sketch-title>/`.
- Prefer `index.html` for the runnable sketch, `content.md` for the article, and `preview.png` for a checked visual preview.
- Keep browser sketches self-contained unless a local image, font, or data asset is necessary.
- Update `README.md` whenever a new article project is added.

## p5.js Sketches

- Read and apply the repo-local `.codex/skills/p5js` skill before creating p5.js work.
- When the user asks for the latest p5.js CDN, use the official p5.js latest 2.x CDN URL: `https://cdn.jsdelivr.net/npm/p5@2/lib/p5.min.js`.
- If reproducibility requires pinning an exact p5.js version, document the reason in `content.md`.
- Disable p5 Friendly Error System in production sketches after loading p5.js and before sketch code.
- Keep export shortcuts in runnable sketches when relevant: `S` for PNG, `G` for GIF, `F` for frame sequence, and `Space` for pause.

## Perfect Loop Requirements

- Drive loop animations from a normalized `0..1` progress value derived from modulo frame count.
- Use periodic functions (`sin`, `cos`, integer-cycle rotation, triangle waves, phase offsets) for all animated state.
- Avoid unwrapped `millis()`, non-periodic noise coordinates, or random calls inside `draw()` for loop-critical visuals.
- For GIF or frame-sequence output, document the loop frame count, frame rate, and total duration in `content.md`.

## Verification

- Run the sketch locally in a browser or local static server before finishing.
- Capture or update `preview.png` when the visual output changes.
- For perfect loops, verify that frame `0` and frame `loopFrames` render equivalently, not only that the animation looks smooth by eye.
