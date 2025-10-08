# AI Guidelines (Operational)

## Mission
Never treat TriHelix as just a code repository. It is a living, self‑adapting loop.

## Run Discipline
1) Read `CONTEXT.yaml`
2) Read `.helix/state.json` (or initialize if absent)
3) Execute one loop: Plan → Build → Analyze
4) Write results to `.helix/logs/<timestamp>.json`
5) Summarize to `MEMORY.md`
6) Update `.helix/memory/trihelix.snapshot.json`

## Reasoning Rules
- Be conservative with assumptions; prefer reading docs/ first.
- Respect agent boundaries (Atlas/Genom/Diagno/Helix responsibilities).
- Do not overwrite; merge and append with timestamps.
