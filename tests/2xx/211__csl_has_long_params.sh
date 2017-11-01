#!/bin/bash

. common.sh

assert_func _csl_has_long_params $TEST_FAIL $TEST_EMPTY
CSL_GETOPT_LONG="anton,berta:,cesar"
assert_func _csl_has_long_params $TEST_OK $TEST_EMPTY
unset -v CSL_GETOPT_LONG
assert_func _csl_has_long_params $TEST_FAIL $TEST_EMPTY
