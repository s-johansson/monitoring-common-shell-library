#!/bin/bash

. common.sh

assert_func sanitize $TEST_FAIL $TEST_EMPTY
assert_func sanitize $TEST_FAIL $TEST_EMPTY bla bla
assert_func sanitize $TEST_OK bla bla
assert_func sanitize $TEST_OK bla bla\n
assert_func sanitize $TEST_OK bla 'bla\n'
assert_func sanitize $TEST_OK bla "bla\n"
