#!/bin/bash

set -e

md5_util() {
if [[ "$OSTYPE" == "darwin"* ]]; then
   _md5_util="md5"
else
   _md5_util="md5sum"
fi
echo "$_md5_util"
}

NC='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'

function run_test() {
  set +e
  SECONDS=0
  TEST_ARG=$@
  echo "running test $TEST_ARG"
  RES=$($TEST_ARG 2>&1)
  RESPONSE_CODE=$?
  DURATION=$SECONDS
  if [ $RESPONSE_CODE -eq 0 ]; then
    echo -e "${GREEN} Test $TEST_ARG successful ($DURATION sec) $NC"
  else
    echo "$RES"
    echo -e "${RED} Test $TEST_ARG failed $NC ($DURATION sec) $NC"
    exit $RESPONSE_CODE
  fi
}

test_build_is_identical() {
  bazel build test/...
  $(md5_util) bazel-bin/test/*.{srcjar,jar} > hash1
  bazel clean
  bazel build test/...
  $(md5_util) bazel-bin/test/*.{srcjar,jar} > hash2
  cat hash1 hash2
  diff hash1 hash2
}

run_test bazel build test/...
run_test test_build_is_identical
