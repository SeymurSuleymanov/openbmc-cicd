#!/usr/bin/env bash
# Автотесты Redfish API (набор из лабораторной работы 5)
TESTS_DIR="${TESTS_DIR:-/mnt/c/Users/seymu/Desktop/Univer/Test/openbmc-redfish-tests}"
ART="${ART:-artifacts}"
cd "$TESTS_DIR" || exit 1
python3 -m pytest test_redfish.py -v --junitxml="$OLDPWD/$ART/02-redfish-junit.xml" \
  > "$OLDPWD/$ART/02-redfish-console.log" 2>&1
tail -3 "$OLDPWD/$ART/02-redfish-console.log"
cat "$OLDPWD/$ART/02-redfish-console.log"
