# TriHelix — AI‑Native Project (Genesis Starter)

**Purpose.** This repository seeds an AI‑native implementation of the TriHelix ecosystem:
Atlas (planner), Genom (creator), Diagno (analyst) — orchestrated by Helix (meta‑brain).

**AI‑Persistence.** The project is designed so AI agents never lose context:
- Global context in `CONTEXT.yaml`
- Long‑term memory in `MEMORY.md` and `.helix/memory/*.json`
- Agent operating rules in `.helix/agents/*.yaml`
- Loop/state in `.helix/state.json` (single source of truth)

**Quick start**
```bash
# 1) (Optional) inspect context & memory
cat CONTEXT.yaml
cat MEMORY.md

# 2) Bootstrap AI loop (reads CONTEXT, writes MEMORY)
bash scripts/ai-bootstrap.sh

# 3) Run a single Plan→Build→Analyze loop
bash scripts/loop-run.sh

# 4) Refresh context from latest snapshot
bash scripts/refresh-context.sh
```
