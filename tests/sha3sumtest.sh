#!/bin/sh

set -eu

sha3sum=${1:-./sha3sum}

check_hash() {
	expected=$1
	shift
	actual=$("$sha3sum" "$@")
	actual=${actual%% *}
	if [ "$actual" != "$expected" ]; then
		echo "sha3sum output mismatch" >&2
		exit 1
	fi
}

check_failure() {
	if "$sha3sum" "$@" >/dev/null 2>&1; then
		echo "sha3sum accepted invalid arguments" >&2
		exit 1
	fi
}

check_hash \
	a7ffc6f8bf1ed76651c14756a061d662f580ff4de43b49fa82d80a4b80f8434a \
	256 /dev/null
check_hash \
	c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 \
	256 -k /dev/null

check_failure 256junk /dev/null
check_failure 256 --bad /dev/null
check_failure 256 /this/file/does/not/exist

echo "sha3sum tests passed OK"
