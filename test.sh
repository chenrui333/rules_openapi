#!/bin/bash

set -e

md5_util() {
  if [[ $OSTYPE == "darwin"* ]]; then
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

CODEGEN_CLI_VERSION_DEFAULT="2.4.16"
CODEGEN_CLI_SHA256_DEFAULT="154b5a37254a3021a8cb669a1c57af78b45bb97e89e0425e3f055b1c79f74a93"
CODEGEN_CLI_PROVIDER_DEFAULT="swagger"
test_version() {
  local CODEGEN_CLI_VERSION=${1:-$CODEGEN_CLI_VERSION_DEFAULT}
  local CODEGEN_CLI_SHA256=${2:-$CODEGEN_CLI_SHA256_DEFAULT}
  local CODEGEN_CLI_PROVIDER=${3:-$CODEGEN_CLI_PROVIDER_DEFAULT}

  cd "${dir}"/test_version
  local timestamp=$(date +%s)
  NEW_TEST_DIR="test_${CODEGEN_CLI_PROVIDER}_${CODEGEN_CLI_VERSION}_${timestamp}"
  cp -r version_specific_tests_dir/ $NEW_TEST_DIR

  sed \
    -e "s/\${codegen_cli_version}/$CODEGEN_CLI_VERSION/" \
    -e "s/\${codegen_cli_sha256}/$CODEGEN_CLI_SHA256/" \
    -e "s/\${codegen_cli_provider}/$CODEGEN_CLI_PROVIDER/" \
    WORKSPACE.template >> $NEW_TEST_DIR/WORKSPACE

  cd $NEW_TEST_DIR

  bazel build //...
  $(md5_util) bazel-bin/*.{srcjar,jar} > hash1
  bazel clean
  bazel build //...
  $(md5_util) bazel-bin/*.{srcjar,jar} > hash2
  cat hash1 hash2
  diff hash1 hash2

  RESPONSE_CODE=$?
  cd ..
  rm -rf $NEW_TEST_DIR
  exit $RESPONSE_CODE
}

dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

run_test bazel build test/...

run_test test_build_is_identical

run_test test_version \
  "2.4.16" \
  "154b5a37254a3021a8cb669a1c57af78b45bb97e89e0425e3f055b1c79f74a93" \
  "swagger"

run_test test_version \
  "3.0.0-rc1" \
  "867488b2df8c667c3f4b2b333eeee1fbcba76e92d6a29d300e01aedbfe34d6fe" \
  "swagger"

run_test test_version \
  "3.3.4" \
  "24cb04939110cffcdd7062d2f50c6f61159dc3e0ca3b8aecbae6ade53ad3dc8c" \
  "openapi"

run_test test_version \
  "4.3.1" \
  "f438cd16bc1db28d3363e314cefb59384f252361db9cb1a04a322e7eb5b331c1" \
  "openapi"

run_test test_version \
  "5.0.0" \
  "839fade01e54ce1eecf012b8c33adb1413cff0cf2e76e23bc8d7673f09626f8e" \
  "openapi"

run_test test_version \
  "3.0.43" \
  "5480e649661f132bdc547cd4ec3a7f334b9f57a33ee9b3e857af9c7b5f5be6c2" \
  "swaggerv3"