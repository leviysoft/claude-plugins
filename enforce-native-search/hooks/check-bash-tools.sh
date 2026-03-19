#!/usr/bin/env bash
set -euo pipefail

# Require jq for input parsing
if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

input=$(cat)
cmd=$(printf "%s" "$input" | jq -r ".tool_input.command // empty")

# Block: grep/egrep/fgrep/rg used as standalone file search (not as a stdin filter after a pipe)
if printf "%s" "$cmd" | grep -qE "(^|&&|\|\||;)[[:space:]]*(grep|egrep|fgrep|rg)[[:space:]]"; then
  printf '{"decision":"block","reason":"Use ast-grep instead of grep/rg for code search"}' >&2
  exit 2
fi

# Block: grep/egrep/fgrep/rg after a pipe but with recursive/file-search flags (still a file search)
if printf "%s" "$cmd" | grep -qE "\|[[:space:]]*(grep|egrep|fgrep|rg)[[:space:]]" \
  && printf "%s" "$cmd" | grep -qE "\|[[:space:]]*(grep|egrep|fgrep|rg)[[:space:]].*(-r[^e]|-R|--recursive)"; then
  printf '{"decision":"block","reason":"Use ast-grep instead of grep/rg for code search"}' >&2
  exit 2
fi

# Block: find used for file discovery (allow attribute-based queries)
if printf "%s" "$cmd" | grep -qE "(^|&&|\|\||;|\|)[[:space:]]*find[[:space:]]" \
  && ! printf "%s" "$cmd" | grep -qE "\-(newer|mtime|atime|ctime|size|perm|exec|delete)" \
  && ! printf "%s" "$cmd" | grep -qE "xargs[[:space:]].*find[[:space:]]"; then
  printf '{"decision":"block","reason":"Use the Glob tool instead of find"}' >&2
  exit 2
fi

exit 0
