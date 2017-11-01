#!/bin/bash

. common.sh

assert_func exit_no_data "${TEST_OK}" "3"
CSL_EXIT_NO_DATA_IS_CRITICAL=true
assert_func exit_no_data "${TEST_OK}" "2"
unset -v CSL_EXIT_NO_DATA_IS_CRITICAL
assert_func exit_no_data "${TEST_OK}" "3"
