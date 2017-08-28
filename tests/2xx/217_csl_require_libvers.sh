#!/bin/bash

. common.sh

assert_func csl_require_libvers "${TEST_FAIL}" "Invalid[[:blank:]]parameters"
assert_func csl_require_libvers "${TEST_FAIL}" "Invalid[[:blank:]]parameters" foo bar
assert_func csl_require_libvers "${TEST_FAIL}" "Invalid[[:blank:]]parameters" fo 
assert_func csl_require_libvers "${TEST_FAIL}" "Invalid[[:blank:]]parameters" "1.0.0.0.0.0.0.0.x.0.0"
assert_func csl_require_libvers "${TEST_OK}" "eq" "${CSL_VERSION}"
assert_func csl_require_libvers "${TEST_OK}" "lt" "99.99.99"
assert_func csl_require_libvers "${TEST_OK}" "gt" "1.0.0.0.0.0.0.0.0.0.0"
