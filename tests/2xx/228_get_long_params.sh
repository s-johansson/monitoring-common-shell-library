#!/bin/bash

. common.sh

assert_func csl_get_long_params $TEST_FAIL $TEST_EMPTY
CSL_GETOPT_LONG="anton,berta:,cesar,"
assert_func csl_get_long_params $TEST_OK "anton,berta:,cesar"
CSL_GETOPT_LONG=
assert_func csl_get_long_params $TEST_FAIL $TEST_EMPTY
