#!/bin/bash

. common.sh

assert_func show_help $TEST_OK "help"
CSL_HELP_TEXT="bla"
assert_func show_help $TEST_OK "bla"
