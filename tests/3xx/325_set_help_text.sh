#!/bin/bash

. common.sh

assert_func set_help_text $TEST_OK $TEST_EMPTY "bla"
assert_func set_help_text $TEST_OK $TEST_EMPTY <<EOF
blabla
EOF
