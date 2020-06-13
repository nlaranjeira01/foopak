#!/bin/bash

script_dir=$(realpath $(dirname "${BASH_SOURCE[0]}"))
dev_environment=$(realpath "$script_dir/..")

dev_environment_owner=$(stat --format=%U "$dev_environment")

if [ "$dev_environment_owner" != "$USER" ]; then
	echo "ERROR: user '$USER' does not own the project root located in '$dev_environment'" >&2
	return 1
fi

mkdir -p /tmp/foopak_test_environments
test_environment=$(mktemp -d /tmp/foopak_test_environments/XXXXXX)

cp -R "$dev_environment"/* "$dev_environment"/.[!.]* $test_environment/

"$test_environment"/build.sh
mv "$test_environment/build/foopak" "$test_environment/foopak"

teardown_environment() {
	cd "$dev_environment"
	rm -rf "$test_environment"
}

cd "$test_environment"

