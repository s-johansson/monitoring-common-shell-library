#!/bin/bash

. common.sh

assert_func create_tmpdir $TEST_OK '/tmp/csl\.[[:alnum:]]{6}$'
