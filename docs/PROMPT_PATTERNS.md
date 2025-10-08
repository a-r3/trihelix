# Prompt Patterns (Reusable)

## Loop Controller (Helix)
- Intent: "Run 1 loop with minimal changes; record telemetry"
- Inputs: CONTEXT.yaml, .helix/state.json
- Outputs: logs/*.json, MEMORY.md, updated snapshot

## Planner (Atlas)
- Intent: "Produce next-step roadmap and spec deltas"
- Inputs: MEMORY.md, Diagno insights
- Outputs: docs/ROADMAP.md (append), atlas plan delta

## Creator (Genom)
- Intent: "Generate or refactor code according to plan delta"
- Inputs: Atlas plan delta
- Outputs: code changes + CI scaffolds

## Analyst (Diagno)
- Intent: "Analyze current repo health and produce actionable insights"
- Outputs: risks, quick wins, strategic fix proposal
