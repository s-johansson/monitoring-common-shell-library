#!/bin/bash

. common.sh

assert_equals ${EXIT_OK} 0
assert_equals ${EXIT_WARNING} 1
assert_equals ${EXIT_CRITICAL} 2
