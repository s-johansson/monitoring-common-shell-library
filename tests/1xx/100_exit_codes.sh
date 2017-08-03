#!/bin/bash

. common.sh

assert_equals ${CSL_EXIT_OK} 0
assert_equals ${CSL_EXIT_WARNING} 1
assert_equals ${CSL_EXIT_CRITICAL} 2
