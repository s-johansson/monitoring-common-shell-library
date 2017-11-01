#!/bin/bash

. common.sh

assert_func _csl_get_short_params $TEST_FAIL $TEST_EMPTY
CSL_GETOPT_SHORT="ab:c,"
assert_func _csl_get_short_params $TEST_OK "ab:c"
CSL_GETOPT_SHORT=
assert_func _csl_get_short_params $TEST_FAIL $TEST_EMPTY
