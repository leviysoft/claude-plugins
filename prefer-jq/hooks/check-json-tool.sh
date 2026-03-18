#!/usr/bin/env bash
set -euo pipefail

# Require jq for input parsing
if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

input=$(cat)
cmd=$(printf "%s" "$input" | jq -r ".tool_input.command // empty")

# Block: python -m json.*
if printf "%s" "$cmd" | grep -qE "python3?[[:space:]]+-m[[:space:]]+json"; then
  printf '{"decision":"block","reason":"Use jq instead of python for JSON processing"}' >&2
  exit 2
fi

# Block: python -c '...json...'
if printf "%s" "$cmd" | grep -qE "python3?[[:space:]]+-c" \
  && printf "%s" "$cmd" | grep -qiE "json\.load|json\.dumps|json\.loads|import json"; then
  printf '{"decision":"block","reason":"Use jq instead of python for JSON processing"}' >&2
  exit 2
fi

exit 0
