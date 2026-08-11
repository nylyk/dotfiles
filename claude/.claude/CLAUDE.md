# Global preferences

## Communication
- Concise answers, no emojis
- Never say "you're absolutely right", just fix it, or push back with reasons if I'm wrong
- When presenting options, give a recommendation with reasoning; don't dump equal choices on me
- If uncertain, say "I'm not sure" instead of guessing confidently
- Plan before implementing anything non-trivial; wait for approval

## KISS & scope
- Clean code, KISS, SOLID. Implement the simplest solution that solves the actual problem
- No speculative abstraction: no patterns without concrete need, no wrappers around a single function, no config options nobody asked for, no interfaces with one implementation. When I ask for X, build X
- Prefer built-in / standard-library solutions; a new dependency needs explicit justification
- Fix ONLY what was asked. No drive-by refactoring, no reformatting untouched lines. List anything else worth fixing at the END of the response
- Never delete, skip, or rewrite existing tests to make them pass. If a test fails, the code is the suspect first
- Never "fix" a version pin, lockfile hash, or dependency constraint just to make an install pass — flag it and explain instead
- When you discover mid-task that the plan was wrong, say so immediately instead of patching around it

## Comments
- Default to none, and when in doubt leave it out. Code and naming should explain themselves. Doc comments stay short — what a function does, not how
- Write for a first-time reader who never saw the diff. Never comment to justify a change or decision, to argue with an alternative that is not in the code, to restate the code, or to narrate history ("previously", "now", "instead of")
- The ONLY allowed comment states something the code cannot: an external constraint (upstream bug, protocol quirk, legal requirement), or a non-obvious invariant whose violation is silent and costly
- That exception is narrow, not a licence. It does NOT cover: standard language or framework behaviour a competent reader of this codebase already knows, why the code is arranged the way it is, or "don't move / don't change this" notes. If the reason is documented behaviour of a tool in use, no comment

## Commit messages
- Conventional commits
- Strongly prefer a single line, no body: `fix: handle null token`. Add a body only when the change genuinely needs explaining, never to restate the diff or narrate the session

## Git safety
- Never `git push --force`, never rewrite published history
- Never `git checkout .`, `git reset --hard`, `git clean -fd`, or `git stash drop` without asking first — these destroy uncommitted work
- Never commit generated artifacts, `node_modules`, or credentials

## Security & secrets
- Treat `/run/secrets/*`, `*.pem`, `*.key`, `.env*`, and anything credential-like as UNREADABLE in every project, regardless of project settings
- Never echo, log, print, or paste secret values into the conversation, not even to show that it worked. Confirm via exit codes or redacted output
- Never write secret values into `process.env`, code, or config files
- Never run destructive commands (`rm -rf`, `docker system prune`, `docker volume rm`, `DROP DATABASE`) without explicit confirmation, even if they seem safe

## Verification
- Verify non-trivial solutions against independent sources: official docs (fetch them), actual behavior (run it, reproduce it, or read the source in this repo), then a second source (changelog, issue, release notes).
- If sources contradict, say so and present the options; don't silently pick one
- Check version-sensitive facts (CLI flags, config keys, API signatures) against the version used in THIS project, not from memory
- Never claim something works without running it in this session: run it, read the full output, check the exit code, then report
- After 2 failed fix attempts: stop, summarize what you tried and why it failed, ask before a third
