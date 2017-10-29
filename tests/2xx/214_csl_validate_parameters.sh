#!/bin/bash

. common.sh

CSL_WARNING_THRESHOLD=5
CSL_CRITICAL_THRESHOLD=10
assert_func csl_validate_parameters $TEST_OK $TEST_EMPTY

#CSL_WARNING_THRESHOLD=x
#CSL_CRITICAL_THRESHOLD=5
#assert_func csl_validate_parameters $TEST_FAIL "warning parameter contains an invalid value"

#CSL_WARNING_THRESHOLD=5
#CSL_CRITICAL_THRESHOLD=x
#assert_func csl_validate_parameters $TEST_FAIL "critical parameter contains an invalid value"

CSL_WARNING_THRESHOLD='/^downstream.*_power/=-1:1,/^downstream.*snr/=35:,/^upstream.*_power/=30:'
CSL_CRITICAL_THRESHOLD='/^downstream.*_power/=-0.5:0.5,/^downstream.*snr/=35:,/^upstream.*_power/=35:'
assert_func csl_validate_parameters $TEST_OK $TEST_EMPTY

unset -v CSL_WARNING_THRESHOLD CSL_CRITICAL_THRESHOLD
assert_func csl_validate_parameters $TEST_FAIL "are mandatory"
