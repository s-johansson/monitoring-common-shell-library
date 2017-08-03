#!/bin/bash

. common.sh

assert_func get_short_params $TEST_FAIL $TEST_EMPTY
CSL_GETOPT_SHORT="ab:c,"
assert_func get_short_params $TEST_OK "ab:c"
CSL_GETOPT_SHORT=
assert_func get_short_params $TEST_FAIL $TEST_EMPTY
