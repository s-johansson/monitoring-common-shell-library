#!/bin/bash

. common.sh

assert_func csl_get_version "${TEST_OK}" "${CSL_VERSION}"
