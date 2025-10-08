# Context Refresh Protocol

- Source of truth memory: `.helix/memory/trihelix.snapshot.json`
- Global context file: `CONTEXT.yaml`

**Refresh Steps**
1. Validate snapshot is newer than CONTEXT.yaml
2. Merge `current_phase` and `last_updated`
3. Keep an audit line in `MEMORY.md`
4. Never discard previous context
