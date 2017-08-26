#!/bin/bash

. common.sh

assert_func csl_has_short_params $TEST_FAIL $TEST_EMPTY
CSL_GETOPT_SHORT="ab:c"
assert_func csl_has_short_params $TEST_OK $TEST_EMPTY
unset -v CSL_GETOPT_SHORT
assert_func csl_has_short_params $TEST_FAIL $TEST_EMPTY
