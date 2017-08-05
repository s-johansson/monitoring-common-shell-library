#!/bin/bash

. common.sh

unset -v CSL_EXIT_NO_DATA_IS_CRITICAL
assert_func csl_is_exit_on_no_data_critical $TEST_FALSE $TEST_EMPTY
CSL_EXIT_NO_DATA_IS_CRITICAL=1
assert_func csl_is_exit_on_no_data_critical $TEST_TRUE $TEST_EMPTY
unset -v CSL_EXIT_NO_DATA_IS_CRITICAL
