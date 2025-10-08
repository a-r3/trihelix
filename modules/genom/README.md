# 🧬 Genom — Module

**Purpose.** Planı koda çevirir; struktur, pattern və CI qurur; refaktor edir.

**Independence.** Genom works standalone and within the TriHelix loop.

## CLI (concept)
```bash
# Version & doctor
genom --version
genom doctor

# Core commands
genom new            # init skeleton/spec
genom plan           # (atlas) create roadmap / (genom) plan gen / (diagno) plan scans
genom run            # execute module's primary function
genom report         # produce human/JSON report
```

## Inputs / Outputs
- Inputs: see `SPEC.yaml`
- Outputs: artifacts in `./out/`, logs in `./logs/`
