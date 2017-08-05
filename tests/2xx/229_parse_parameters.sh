#!/bin/bash

. common.sh

assert_func parse_parameters $TEST_OK "enable debugging" -h
assert_func parse_parameters $TEST_OK "enable debugging" --help
assert_func parse_parameters $TEST_OK "enable debugging" -h -v
assert_func parse_parameters $TEST_OK "enable debugging" --help -v
assert_func parse_parameters $TEST_OK "enable debugging" -h --verbose
assert_func parse_parameters $TEST_OK "enable debugging" --help --verbose

assert_func parse_parameters $TEST_OK "Debugging: enabled" -d
assert_func parse_parameters $TEST_OK "Debugging: enabled" --debug
assert_func parse_parameters $TEST_OK "Verbose output: enabled" -v
assert_func parse_parameters $TEST_OK "Verbose output: enabled" --verbose

assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning 5
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning 5:
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning :5
assert_func parse_parameters $TEST_OK $TEST_EMPTY --critical 10
assert_func parse_parameters $TEST_OK $TEST_EMPTY --critical 10:
assert_func parse_parameters $TEST_OK $TEST_EMPTY --critical :10
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning 5 --critical 10
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning :5 --critical 10
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning 5: --critical 10
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning 5 --critical :10
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning 5 --critical 10:
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning :5 --critical :10
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning :5 --critical 10:
assert_func parse_parameters $TEST_OK $TEST_EMPTY --warning 5: --critical 10:
assert_func parse_parameters $TEST_OK "Warning limit: 5" --warning 5 -d
assert_func parse_parameters $TEST_OK "Critical limit: 10" --critical 10 -d
assert_func parse_parameters $TEST_OK "Warning limit: 5" --warning 5 --critical 10 -d

assert_func parse_parameters $TEST_FAIL "Parameters required"
assert_func parse_parameters $TEST_FAIL "invalid option" -x
assert_func parse_parameters $TEST_FAIL "invalid option" -2
assert_func parse_parameters $TEST_FAIL "invalid option" -xxxxx
assert_func parse_parameters $TEST_FAIL "invalid option" -22222
assert_func parse_parameters $TEST_FAIL "unrecognized option" --x
assert_func parse_parameters $TEST_FAIL "unrecognized option" --2
assert_func parse_parameters $TEST_FAIL "unrecognized option" --xxxxx
assert_func parse_parameters $TEST_FAIL "unrecognized option" --22222

# using custom getopt-parameters
CSL_GETOPT_SHORT="mn:"
CSL_GETOPT_LONG="minimum,neutral:,"
declare -A CSL_USER_GETOPT_PARAMS=()
CSL_USER_GETOPT_PARAMS+=( [m]="minimum_test" )
CSL_USER_GETOPT_PARAMS+=( [minimum]="minimum_test" )
CSL_USER_GETOPT_PARAMS+=( [n]="neutral_test" )
CSL_USER_GETOPT_PARAMS+=( [neutral]="neutral_test" )
assert_func parse_parameters $TEST_OK $TEST_EMPTY --minimum --neutral 5

minimum_test ()
{
   return 5
}

neutral_test ()
{
   [ "x${1}" == "x5" ] || return 1
   return 5
}

assert_func parse_parameters $TEST_FAIL "Parameter function 'minimum_test' exited non-zero" --minimum --neutral 5
assert_func parse_parameters $TEST_FAIL "Parameter function 'neutral_test' exited non-zero" --neutral 4 --minimum

minimum_test ()
{
   return 0
}

neutral_test ()
{
   [ "x${1}" == "x5" ] || return 1
   return 0
}

assert_func parse_parameters $TEST_OK $TEST_EMPTY --minimum --neutral 5

unset -f minimum_test neutral_test
unset -v CSL_USER_GETOPT_PARAMS CSL_GETOPT_SHORT CSL_GETOPT_LONG
