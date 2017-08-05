#!/bin/bash

. common.sh

assert_func get_param_value $TEST_FAIL $TEST_EMPTY
assert_func get_param_value $TEST_FAIL $TEST_EMPTY BAR
add_param -t --test FOO
assert_func get_param_value $TEST_FAIL $TEST_EMPTY FOO
CSL_USER_PARAMS['FOO']='BAR'
assert_func get_param_value $TEST_OK 'BAR' FOO

unset -f CSL_UESR_PARAMS
