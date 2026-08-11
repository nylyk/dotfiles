# Global preferences

## Communication
- Concise answers, no emojis
- Never say "you're absolutely right", just fix it, or push back with reasons if I'm wrong
- When presenting options, give a recommendation with reasoning; don't dump equal choices on me
- If uncertain, say "I'm not sure" instead of guessing confidently
- Plan before implementing anything non-trivial; wait for approval
- A question is a question: answer it in prose and stop. "Why is X like this?" and "Should we do Y instead?" are not approval to change anything — wait until I say to

## KISS & scope
- Clean code, KISS, SOLID. Implement the simplest solution that solves the actual problem
- No speculative abstraction: no patterns without concrete need, no wrappers around a single function, no config options nobody asked for, no interfaces with one implementation. When I ask for X, build X
- Prefer built-in / standard-library solutions; a new dependency needs explicit justification
- Fix ONLY what was asked. No drive-by refactoring, no reformatting untouched lines. List anything else worth fixing at the END of the response
- Never delete, skip, or rewrite existing tests to make them pass. If a test fails, the code is the suspect first
- Never "fix" a version pin, lockfile hash, or dependency constraint just to make an install pass — flag it and explain instead
- When you discover mid-task that the plan was wrong, say so immediately instead of patching around it

## Comments
- Default to none, and when in doubt leave it out. Code and naming must explain themselves; rename before you reach for a comment, because a comment is an admission the name failed
- A doc comment is allowed only where the name alone cannot carry what the item does, and then at most two lines saying what it does — never how, never why. If a better name removes the need, use the better name instead
- No module- or file-level doc blocks. A rule binding a whole file, module or package goes in the project's agent instructions file, where it governs everything at once and cannot drift out of sync with the code it describes. The name of a module or file must explain what its contents are about.
- Write for a first-time reader who never saw the diff, and who therefore cannot see what is absent. Never comment on an absence, a removal, or a road not taken — the subject of such a comment does not exist on the page, so it describes a diff rather than a codebase, and it is unreadable the moment the diff scrolls out of history
- Never comment to justify a change or decision, to argue with an alternative that is not in the code, to restate the code, or to narrate history ("previously", "now", "instead of", "no longer", "deliberately not")
- The ONLY allowed inline comment states something the code cannot: an external constraint (upstream bug, protocol quirk, legal requirement), or a non-obvious invariant whose violation is silent and costly
- That exception is narrow, not a licence. It does NOT cover: standard language or framework behaviour a competent reader of this codebase already knows, why the code is arranged the way it is, design rationale (that goes in the design doc, if there is one), or "don't move / don't change this" notes. If the reason is documented behaviour of a tool in use, no comment

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
