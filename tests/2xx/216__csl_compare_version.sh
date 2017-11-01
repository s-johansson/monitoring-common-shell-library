#!/bin/bash

. common.sh

assert_func _csl_compare_version 1 "Parameter[[:blank:]]1[[:blank:]]does[[:blank:]]not[[:blank:]]look[[:blank:]]like" x 1
assert_func _csl_compare_version 1 "Parameter[[:blank:]]2[[:blank:]]does[[:blank:]]not[[:blank:]]look[[:blank:]]like" 1 x
assert_func _csl_compare_version 1 "Parameter[[:blank:]]1[[:blank:]]does[[:blank:]]not[[:blank:]]look[[:blank:]]like" x x
assert_func _csl_compare_version 1 "Parameter[[:blank:]]1[[:blank:]]does[[:blank:]]not[[:blank:]]look[[:blank:]]like" 1..0 1.0
assert_func _csl_compare_version 1 "Parameter[[:blank:]]2[[:blank:]]does[[:blank:]]not[[:blank:]]look[[:blank:]]like" 1.0 1..0

# equality
assert_func _csl_compare_version 0 "eq" 1 1
assert_func _csl_compare_version 0 "eq" 1 1
assert_func _csl_compare_version 0 "eq" 5.6.7 5.6.7
assert_func _csl_compare_version 0 "eq" 1.01.1 1.1.1
assert_func _csl_compare_version 0 "eq" 1.1.1 1.01.1
assert_func _csl_compare_version 0 "eq" 1 1.0
assert_func _csl_compare_version 0 "eq" 1.0 1
assert_func _csl_compare_version 0 "eq" 1.0.2.0 1.0.2

# minima
assert_func _csl_compare_version 0 "lt" 2.1 2.2
assert_func _csl_compare_version 0 "lt" 4.08 4.08.01
assert_func _csl_compare_version 0 "lt" 3.2 3.2.1.9.8144
assert_func _csl_compare_version 0 "lt" 1.2 2.1

# maxima
assert_func _csl_compare_version 0 "gt" 3.0.4.10 3.0.4.2
assert_func _csl_compare_version 0 "gt" 3.2.1.9.8144 3.2
assert_func _csl_compare_version 0 "gt" 2.1 1.2
