#!/usr/bin/env bash
set -euo pipefail

key_file="${OPENROUTER_KEY_FILE:-$HOME/.config/openrouter/management-key}"
[ -r "$key_file" ] || exit 0

auth="Authorization: Bearer $(<"$key_file")"

spent=$(curl -sf --max-time 10 -X POST https://openrouter.ai/api/v1/analytics/query \
  -H "$auth" -H 'Content-Type: application/json' \
  -d "$(jq -cn \
    --arg start "$(date -u +%Y-%m-01T00:00:00Z)" \
    --arg end "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    '{metrics: ["total_usage"], granularity: "day", time_range: {start: $start, end: $end}}')" \
  | jq -er '(.data.data | map(.total_usage) | add) // 0') || exit 0

remaining=$(curl -sf --max-time 10 https://openrouter.ai/api/v1/credits -H "$auth" \
  | jq -er '.data.total_credits - .data.total_usage') || exit 0

gross=$(awk -v c="$spent" 'BEGIN { printf "%.2f\n", c * 1.055 * 1.19 }')

jq -cn \
  --arg spent "$(printf '%.2f' "$spent")" \
  --arg gross "$gross" \
  --arg remaining "$(printf '%.2f' "$remaining")" \
  --arg month "$(date -u +'%B %Y')" \
  '{
    text: ("$" + $spent + " · $" + $remaining),
    tooltip: ("<b>OpenRouter — " + $month + "</b>\n"
      + "Spent\t$" + $spent + "\n"
      + "Incl. fee + VAT\t$" + $gross + "\n"
      + "Credits left\t$" + $remaining)
  }'
