#!/bin/bash

. common.sh

WARNING=5
CRITICAL=10
assert_func validate_parameters $TEST_OK $TEST_EMPTY

WARNING=x
CRITICAL=5
assert_func validate_parameters $TEST_FAIL "warning parameter contains an invalid value"

WARNING=5
CRITICAL=x
assert_func validate_parameters $TEST_FAIL "critical parameter contains an invalid value"

unset -v WARNING CRITICAL
assert_func validate_parameters $TEST_FAIL "are mandatory"

