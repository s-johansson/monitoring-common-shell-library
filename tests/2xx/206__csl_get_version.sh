#!/bin/bash

. common.sh

assert_func _csl_get_version "${TEST_OK}" "${CSL_VERSION}"
