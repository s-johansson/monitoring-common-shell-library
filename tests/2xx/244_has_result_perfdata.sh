#!/bin/bash

. common.sh

assert_func has_result_perfdata $TEST_FAIL $TEST_EMPTY
CSL_RESULT_PERFDATA="FOOBAR"
assert_func has_result_perfdata $TEST_OK $TEST_EMPTY
unset -v CSL_RESULT_PERFDATA
