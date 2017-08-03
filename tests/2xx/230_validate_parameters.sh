#!/bin/bash

. common.sh

CSL_WARNING_LIMIT=5
CSL_CRITICAL_LIMIT=10
assert_func validate_parameters $TEST_OK $TEST_EMPTY

CSL_WARNING_LIMIT=x
CSL_CRITICAL_LIMIT=5
assert_func validate_parameters $TEST_FAIL "warning parameter contains an invalid value"

CSL_WARNING_LIMIT=5
CSL_CRITICAL_LIMIT=x
assert_func validate_parameters $TEST_FAIL "critical parameter contains an invalid value"

unset -v CSL_WARNING_LIMIT CSL_CRITICAL_LIMIT
assert_func validate_parameters $TEST_FAIL "are mandatory"
