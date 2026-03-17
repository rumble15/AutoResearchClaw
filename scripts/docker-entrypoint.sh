#!/bin/sh
set -u

status=0
researchclaw "$@" || status=$?

if [ "${RC_KEEP_ALIVE:-0}" = "1" ]; then
    echo "[RC] Command finished (exit code: $status). Keeping container active because RC_KEEP_ALIVE=1."
    exec tail -f /dev/null
fi

exit "$status"
