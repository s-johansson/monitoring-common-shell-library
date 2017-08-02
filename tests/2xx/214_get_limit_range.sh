#!/bin/bash

. common.sh

# integer range
assert_func get_limit_range $TEST_OK "25 35" 25:35
assert_func get_limit_range $TEST_OK "35 25" 35:25
assert_func get_limit_range $TEST_OK "35 35" 35:35
assert_func get_limit_range $TEST_OK "0 35" 0:35
assert_func get_limit_range $TEST_OK "35 0" 35:0
assert_func get_limit_range $TEST_OK "0 35" 0:35
assert_func get_limit_range $TEST_OK "0 0" 0:0
assert_func get_limit_range $TEST_OK "-1 2" -1:2
assert_func get_limit_range $TEST_OK "2 -1" 2:-1
assert_func get_limit_range $TEST_OK "-1 -1" -1:-1

# float range
assert_func get_limit_range $TEST_OK "25.7 35.2" 25.7:35.2
assert_func get_limit_range $TEST_OK "35.2 25.7" 35.2:25.7
assert_func get_limit_range $TEST_OK "35.2 35.2" 35.2:35.2
assert_func get_limit_range $TEST_OK "0.00 35.2" 0.00:35.2
assert_func get_limit_range $TEST_OK "35.2 0.00" 35.2:0.00
assert_func get_limit_range $TEST_OK "0.00 0.00" 0.00:0.00
assert_func get_limit_range $TEST_OK "-0.00 -0.00" -0.00:-0.00
assert_func get_limit_range $TEST_OK "-1.12342135 -5.123412421" -1.12342135:-5.123412421
assert_func get_limit_range $TEST_OK "-5.123412421 -1.12342135" -5.123412421:-1.12342135
assert_func get_limit_range $TEST_OK "-5.123412421 -5.123412421" -5.123412421:-5.123412421

# single integer value
assert_func get_limit_range $TEST_OK "x 5" 5
assert_func get_limit_range $TEST_OK "x 5" :5
assert_func get_limit_range $TEST_OK "5 x" 5:
assert_func get_limit_range $TEST_OK "x -5" -5
assert_func get_limit_range $TEST_OK "x -5" :-5
assert_func get_limit_range $TEST_OK "-5 x" -5:
assert_func get_limit_range $TEST_OK "x 0" 0
assert_func get_limit_range $TEST_OK "x 0" :0
assert_func get_limit_range $TEST_OK "0 x" 0:
assert_func get_limit_range $TEST_OK "x -0" -0
assert_func get_limit_range $TEST_OK "x -0" :-0
assert_func get_limit_range $TEST_OK "-0 x" -0:

# single float value
assert_func get_limit_range $TEST_OK "x 5.1234" 5.1234
assert_func get_limit_range $TEST_OK "x 5.1234" :5.1234
assert_func get_limit_range $TEST_OK "5.1234 x" 5.1234:
assert_func get_limit_range $TEST_OK "x -5.1234" -5.1234
assert_func get_limit_range $TEST_OK "x -5.1234" :-5.1234
assert_func get_limit_range $TEST_OK "-5.1234 x" -5.1234:
assert_func get_limit_range $TEST_OK "x 0.00" 0.00
assert_func get_limit_range $TEST_OK "x 0.00" :0.00
assert_func get_limit_range $TEST_OK "0.00 x" 0.00:
assert_func get_limit_range $TEST_OK "x -0.00" -0.00
assert_func get_limit_range $TEST_OK "x -0.00" :-0.00
assert_func get_limit_range $TEST_OK "-0.00 x" -0.00:
