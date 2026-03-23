#!/bin/bash
INPUT=$(cat)
CMD=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
if echo "$CMD" | grep -qiE 'rm -rf[[:space:]]+(\/|\.)'; then
  echo "BLOCKED: Destructive rm command" >&2; exit 2
fi
if echo "$CMD" | grep -qiE 'sudo|--force'; then
  echo "BLOCKED: sudo/force not allowed" >&2; exit 2
fi
exit 0
