# 🧭 Atlas — Module

**Purpose.** Planlayır, arxitektura və xəritə yaradır; roadmap və sprintləri idarə edir.

**Independence.** Atlas works standalone and within the TriHelix loop.

## CLI (concept)
```bash
# Version & doctor
atlas --version
atlas doctor

# Core commands
atlas new            # init skeleton/spec
atlas plan           # (atlas) create roadmap / (genom) plan gen / (diagno) plan scans
atlas run            # execute module's primary function
atlas report         # produce human/JSON report
```

## Inputs / Outputs
- Inputs: see `SPEC.yaml`
- Outputs: artifacts in `./out/`, logs in `./logs/`
