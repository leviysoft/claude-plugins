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

# Block: python with inline JSON code (-c, heredoc stdin, or any inline invocation)
if printf "%s" "$cmd" | grep -qE "python3?" \
  && printf "%s" "$cmd" | grep -qiE "import json|json\.(load|loads|dumps|dump)\b"; then
  printf '{"decision":"block","reason":"Use jq instead of python for JSON processing"}' >&2
  exit 2
fi

exit 0
