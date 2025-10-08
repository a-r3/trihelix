# 🩺 Diagno — Module

**Purpose.** Layihəni analiz edir; riskləri ölçür; düzəliş tövsiyələri verir.

**Independence.** Diagno works standalone and within the TriHelix loop.

## CLI (concept)
```bash
# Version & doctor
diagno --version
diagno doctor

# Core commands
diagno new            # init skeleton/spec
diagno plan           # (atlas) create roadmap / (genom) plan gen / (diagno) plan scans
diagno run            # execute module's primary function
diagno report         # produce human/JSON report
```

## Inputs / Outputs
- Inputs: see `SPEC.yaml`
- Outputs: artifacts in `./out/`, logs in `./logs/`
