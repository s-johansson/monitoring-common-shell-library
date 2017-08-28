#!/bin/bash

. common.sh

add_param -t --test FOO BAR
assert_func get_param $TEST_OK "BAR" FOO
assert_func get_param $TEST_FAIL $TEST_EMPTY BAR

unset -f cesar_test
