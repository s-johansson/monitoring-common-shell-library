#!/bin/bash

. common.sh

CSL_DEBUG=false
assert_func is_debug "${TEST_FALSE}" "${TEST_EMPTY}"
CSL_DEBUG=true
assert_func is_debug "${TEST_TRUE}" "${TEST_EMPTY}"
CSL_DEBUG=false
assert_func is_debug "${TEST_FALSE}" "${TEST_EMPTY}"
