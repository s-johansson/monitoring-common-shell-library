# Automated Testing Suite for monitoring-common-shell-library

## Test Organization

    * 1xx ... variable tests
    * 2xx ... internal function tests
    * 3xx ... public function tests

See also the test\_seq.dat file.

## Test Conditions

    * each test has to be atomic and not depend on another test

## Execution

### Simple Run

    make

### Verbose Run

    make v=1

### Debug Run

    make d=1
