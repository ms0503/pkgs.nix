#!/usr/bin/env bash
set +e
set -uo pipefail
urxvtc "$@"
if [[ $? == 2 ]]; then
    urxvtd -q -o -f
    urxvtc "$@"
fi
