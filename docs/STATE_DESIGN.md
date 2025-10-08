# State Design

## Files
- `.helix/state.json`: runtime counters, last loop status, pointers to last artifacts
- `.helix/logs/*.json`: immutable loop logs
- `.helix/memory/*.json`: snapshot(s) for fast reload

## Principles
- Append-only logs
- Deterministic merges
- Human-readable summaries in MEMORY.md
