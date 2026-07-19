#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
top_dir=$(dirname "$script_dir")

cd "$top_dir"
if [ -n "${FUZZ_CC:-}" ]; then
	make FUZZ_CC="$FUZZ_CC" sha3fuzz
else
	make sha3fuzz
fi
exec ./sha3fuzz "$script_dir/seeds" "-max_total_time=${FUZZ_SECONDS:-100}"
