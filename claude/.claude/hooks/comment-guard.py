#!/usr/bin/env python3
"""PostToolUse guard: flag comment lines added by Edit/Write so they get re-justified.

Reads the hook payload on stdin, prints a JSON verdict on stdout, always exits 0.
"""

import difflib
import json
import re
import sys
from pathlib import Path

SLASH_EXT = {
    '.ts', '.tsx', '.js', '.jsx', '.mjs', '.cjs', '.mts', '.cts', '.rs', '.go', '.java', '.kt',
    '.kts', '.swift', '.c', '.h', '.cc', '.cpp', '.hpp', '.cs', '.scala', '.dart', '.php', '.css',
    '.scss', '.less', '.vue', '.svelte',
}
HASH_EXT = {'.py', '.sh', '.bash', '.zsh', '.fish', '.rb', '.pl', '.tf', '.nix', '.just'}

# functional directives, not prose - never flagged
DIRECTIVE = re.compile(
    r'(eslint|prettier-ignore|biome-ignore|oxlint|ts-ignore|ts-expect-error|ts-nocheck|@ts-|'
    r'<reference|noqa|pylint|mypy|ruff|shellcheck|istanbul|c8 ignore|deno-lint|swiftlint|nolint|'
    r'go:generate|go:build|\+build|#!|#region|#endregion|SPDX|@vite-ignore|webpackIgnore)',
    re.IGNORECASE,
)


def comment_markers(path: Path):
    if path.suffix in SLASH_EXT:
        return ('//', '/*', '*/', '*')
    if path.suffix in HASH_EXT or path.name in {'Dockerfile', 'Makefile'}:
        return ('#',)
    return ()


def is_comment(line: str, markers) -> bool:
    stripped = line.strip()
    if not stripped or DIRECTIVE.search(stripped):
        return False
    return any(stripped.startswith(m) for m in markers)


def added_lines(tool_input: dict) -> list[str]:
    if 'content' in tool_input:
        return tool_input['content'].splitlines()
    old = tool_input.get('old_string', '').splitlines()
    new = tool_input.get('new_string', '').splitlines()
    matcher = difflib.SequenceMatcher(None, old, new, autojunk=False)
    added = []
    for tag, _, _, j1, j2 in matcher.get_opcodes():
        if tag in ('insert', 'replace'):
            added.extend(new[j1:j2])
    return added


def main() -> None:
    try:
        payload = json.load(sys.stdin)
    except (json.JSONDecodeError, ValueError):
        return

    tool_input = payload.get('tool_input') or {}
    raw_path = tool_input.get('file_path') or (payload.get('tool_response') or {}).get('filePath')
    if not raw_path:
        return

    path = Path(raw_path)
    markers = comment_markers(path)
    if not markers:
        return

    found = [line.strip() for line in added_lines(tool_input) if is_comment(line, markers)]
    if not found:
        return

    verb = 'contains' if 'content' in tool_input else 'adds'
    preview = '; '.join(line[:90] for line in found[:4])
    if len(found) > 4:
        preview += f'; ... (+{len(found) - 4} more)'

    print(
        json.dumps(
            {
                'systemMessage': f'comment-guard: {len(found)} comment line(s) in {path.name}',
                'suppressOutput': True,
                'hookSpecificOutput': {
                    'hookEventName': 'PostToolUse',
                    'additionalContext': (
                        f'comment-guard: this write {verb} {len(found)} comment line(s) in '
                        f'{path.name}: {preview}\n'
                        'CLAUDE.md permits a comment ONLY for an external constraint or an '
                        'invariant that would break under an innocent edit - never to justify a '
                        'change, argue with an alternative absent from the code, restate the code, '
                        'or narrate history. For each line above, name which of the two allowed '
                        'cases it falls under; if you cannot, delete it now rather than at review '
                        'time.'
                    ),
                },
            }
        )
    )


if __name__ == '__main__':
    main()
