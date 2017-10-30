#!/bin/bash

. common.sh

assert_func get_result_perfdata $TEST_FAIL $TEST_EMPTY
CSL_RESULT_PERFDATA="FOOBAR"
assert_func get_result_perfdata $TEST_OK "FOOBAR"
unset -v CSL_RESULT_PERFDATA
