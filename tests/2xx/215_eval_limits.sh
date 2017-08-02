#!/bin/bash

. common.sh

#
# assert-to-ok tests
#

# Test 1
assert_limits $TEST_OK 30.5 35 35         # max, warn >=35, crit >=35
# Test 2
assert_limits $TEST_OK 30.5 :35 :35       # max, warn >=35, crit >=35
# Test 3
assert_limits $TEST_OK 30.5 35 40         # max, warn >=35, crit >=40
# Test 4
assert_limits $TEST_OK 30.5 :35 :40       # max, warn >=35, crit >=40
# Test 5
assert_limits $TEST_OK 30.5 25: 25:       # min, warn <=25, crit <=25
# Test 6
assert_limits $TEST_OK 30.5 25: 20:       # min, warn <=25, crit <=20
# Test 7
assert_limits $TEST_OK 30.5 35:35 36:36   # inside
# Test 8
assert_limits $TEST_OK 30.5 34:35 36:36   # inside
# Test 9
assert_limits $TEST_OK 30.5 35:35 36:37   # inside
# Test 10
assert_limits $TEST_OK 30.5 31:35 36:40   # inside
# Test 11
assert_limits $TEST_OK 30.5 10:20 14:16   # inside
# Test 12
assert_limits $TEST_OK 30.5 36:24 38:22   # outside

#
# assert-to-warning tests
#

# Test 13
assert_limits $TEST_WARNING 30.5 29 40    # max, warn >=30, crit >=40
# Test 14
assert_limits $TEST_WARNING 30.5 :30 :40  # max, warn >=30, crit >=40
# Test 15
assert_limits $TEST_WARNING 30.5 31: 20:  # min, warn <=30, crit <=20
# Test 16
assert_limits $TEST_WARNING 30.5 30.5:30.5 15:45 # inside
# Test 17
assert_limits $TEST_WARNING 30.5 30:31 45:45 # inside
# Test 18
assert_limits $TEST_WARNING 30.5 25:35 15:45 # inside
# Test 19
assert_limits $TEST_WARNING 30.5 36:34 38:28 # outside

#
# assert-to-critical tests
#

# Test 20
assert_limits $TEST_CRITICAL 30.5 30 30    # max, warn >=30, crit >=30
# Test 21
assert_limits $TEST_CRITICAL 30.5 :30 :30    # max, warn >=30, crit >=30
# Test 22
assert_limits $TEST_CRITICAL 30.5 20 25    # max, warn >=20, crit >=25
# Test 23
assert_limits $TEST_CRITICAL 30.5 :20 :25  # max, warn >=20, crit >=25
# Test 24
assert_limits $TEST_CRITICAL 30.5 35: 31:  # min, warn <=35, crit <=31
# Test 25
assert_limits $TEST_CRITICAL 30.5 35: 30.5:  # min, warn <=35, crit <=30
# Test 26
assert_limits $TEST_CRITICAL 30.5 34:34 25:40 # inside
# Test 27
assert_limits $TEST_CRITICAL 30.5 31:36 25:40 # inside
# Test 28
assert_limits $TEST_CRITICAL 30.5 25:29 30.5:30.5 # inside
# Test 29
assert_limits $TEST_CRITICAL 30.5 36:34 38:32 # outside
# Test 30
assert_limits $TEST_CRITICAL 30.5 36:36 38:32 # outside
# Test 31
assert_limits $TEST_CRITICAL 30.5 36:34 30.5:30.5 # outside
