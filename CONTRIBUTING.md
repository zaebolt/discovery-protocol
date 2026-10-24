# Contributing

## Develop locally

Load the plugin straight from your checkout. No install is needed, and edits apply after `/reload-plugins`:

```bash
claude --plugin-dir /path/to/discovery-protocol
```

Validate the manifests after any change:

```bash
claude plugin validate .
```

## Design rules (keep these true)

- **Hooks enforce structure; agents use judgment.** Don't move enforcement into prompts, and don't move judgment into hooks.
- **Dormant by default.** Every hook does nothing unless `./STATE.dp3.md` exists, and ignores paths outside `./artifacts`.
- **Fail open.** A hook blocks (`exit 2`, reason on stderr) only on a real, detected violation. Bad input or a missing tool (`jq`, `perl`) means allow.
- **Keep the orchestrator thin.** Rubrics, templates and conventions live in skills, which load only when used.
- **Every new rule must earn its place.** This protocol got better by removing rules. A new hook or instruction needs a failure from a real run behind it, and should name the rule it replaces if it can.
- **Lessons expire.** Seed lessons and promoted lessons carry a `Retire when:` line.
- Scripts must run on macOS bash 3.2 with BSD tools: no associative arrays, no `mapfile`. Reference plugin files through `${CLAUDE_PLUGIN_ROOT}` and keep scripts `chmod +x`.

## Test a hook

From a scratch folder containing a `STATE.dp3.md`:

```bash
jq -n --arg p "$PWD/artifacts/discovery/framing-v1.md" '{tool_input:{file_path:$p}}' \
  | bash /path/to/discovery-protocol/scripts/post-write-check.sh; echo $?   # 2 = violation
```

`scripts/gate.sh` takes the same input and checks stage order.

## Release

1. Bump `version` in **both** `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`.
2. Add an entry to `CHANGELOG.md`.
3. Run `claude plugin validate .`.
4. Commit, then tag the release: `git tag -a v<version> -m "v<version>" && git push --follow-tags`.
5. Users update with `/plugin marketplace update discovery-protocol` and then update the plugin.
