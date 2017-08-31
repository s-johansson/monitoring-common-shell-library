# monitoring-common-shell-library Function Reference

| Tag | Value |
| - | - |
| Author | Andreas Unterkircher |
| Version | 1.6 |
| License | AGPLv3 |

## 1. Function `is_debug`

returns 0 if debugging is enabled, otherwise it returns 1.

### 1b. Returns

Type: `int`

0 or 1

## 2. Function `debug`

prints output only if --debug or -d parameters have been given. debug output is
sent to STDERR! The debug-output contains the function name from which debug()
has been called (if no function -> 'main'). Furthermore the line-number of
the line that triggered debug() is displayed.

### 2a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $debug_text |

### 2b. Returns

Type: `int`

## 3. Function `fail`

prints the fail-text as well as the function and code-line from which it
was called. The debug-output contains the function name from which debug()
has been called (if no function -> 'main'). Furthermore the line-number of
the line that triggered debug() is displayed.

### 3a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $fail_text |

### 3b. Returns

Type: `int`

## 4. Function `is_verbose`

returns 0 if verbose-logging is enabled, otherwise it returns 1.

### 4b. Returns

Type: `int`

0 on success, 1 on failure

## 5. Function `verbose`

prints output only if --verbose or -v parameters have been given. verbose
output is sent to STDERR!

### 5a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $log_text |

### 5b. Returns

Type: `int`

## 6. Function `csl_is_exit_on_no_data_critical`

returns 0, if it has been choosen, that no-data-is-available is a critical
error. otherwise it returns 1.

### 6b. Returns

Type: `int`

0 on success, 1 on failure

## 7. Function `csl_check_requirements`

tests for other required tools. It also invokes an possible plugin-specific
requirement-check function called plugin_prereq().

### 7b. Returns

Type: `int`

0 on success, 1 on failure

## 8. Function `csl_get_threshold_range`

returns the provided threshold as range in the form of 'MIN MAX'. In case
the provided value is a single value (either integer or float), then 'x MAX'
is returned.

### 8a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $threshold |

*Outputs*: string

### 8b. Returns

Type: `int`

0 on success, 1 on failure

## 9. Function `csl_get_limit_range`

## 10. Function `is_declared`

returns 0 if the provided variable has been declared (that does not mean,
that the variable actually has a value!), otherwise it returns 1.

### 10a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $var |

### 10b. Returns

Type: `int`

0 on success, 1 on failure

## 11. Function `is_declared_func`

returns 0 if the provided function name refers to an already declared
function. Otherwise it returns 1.

### 11a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $var |

### 11b. Returns

Type: `int`

0 on success, 1 on failure

## 12. Function `is_set`

returns 0, if all the provided values are set (non-empty string). specific
to this library, the value 'x' also signals emptiness.

### 12a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $val1 |
| *$2* | string | $val2 |
| *$3* | string | ... |

### 12b. Returns

Type: `int`

0 on success, 1 on failure

## 13. Function `is_empty`

returns 0, if the provided string has a zero length. Otherwise it returns 1.

### 13a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $string |

### 13b. Returns

Type: `int`

0 on success, 1 on failure

## 14. Function `is_match`

invokes the Basic Calculator (bc) and provideѕ it the given $condition. If
the condition is met, bc returns '1' - in this is_match() returns 0. Otherwise
if the condition fails, bc will return '0', than is_match() returns 1.

### 14a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $condition |

### 14b. Returns

Type: `int`

0 on success, 1 on failure

## 15. Function `is_dir`

returns 0, if the given directory actually exists. Otherwise it returns 1.

### 15a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $path |

### 15b. Returns

Type: `int`

0 on success, 1 on failure

## 16. Function `eval_thresholds`

evaluates the given value $1 against WARNING ($2) and CRITICAL ($3) thresholds.

### 16a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $value |
| *$2* | string | $warning |
| *$3* | string | $critical |

*Outputs*: OK|WARNING|CRITICAL|UNKNOWN

### 16b. Returns

Type: `int`

0|1|2|3

## 17. Function `eval_limits`

## 18. Function `csl_parse_parameters`

This function uses GNU getopt to parse the given command-line parameters.

### 18a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $params |

### 18b. Returns

Type: `int`

0 on success, 1 on failure

## 19. Function `is_range`

returns 0, if the argument given is in the form of an range. Otherwise it
returns 1.

### 19a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $range |

### 19b. Returns

Type: `int`

0 on success, 1 on failure

## 20. Function `is_integer`

returns 0, if the given argument is an integer number. it also accepts the
form :[0-9] (value lower than) and [0-9]: (value greater than). Otherwise
it returns 1.

### 20a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $integer |

### 20b. Returns

Type: `int`

0 on success, 1 on failure

## 21. Function `is_float`

returns 0, if the given argument is a floating point number. Otherwise it
returns 1.

### 21a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $float |

### 21b. Returns

Type: `int`

0 on success, 1 on failure

## 22. Function `is_valid_threshold`

performs the checks on the given warning and critical values and returns 0,
if they are. Otherwise it returns 1.

### 22a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $threshold |

### 22b. Returns

Type: `int`

0 on success, 1 on failure

## 23. Function `is_valid_limit`

## 24. Function `is_cmd`

returns 0, if the provided external command exists. Otherwise it returns 1.

### 24a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $command |

### 24b. Returns

Type: `int`

0 on success, 1 on failure

## 25. Function `is_func`

returns 0, if the given function name refers an already declared
function. Otherwise it returns 1

### 25a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $funcname |

### 25b. Returns

Type: `int`

0 on success, 1 on failure

## 26. Function `csl_validate_parameters`

returns 0, if the given command-line parameters are valid. Otherwise it
returns 1.

### 26b. Returns

Type: `int`

0 on success, 1 on failure

## 27. Function `set_result_text`

accepts the plugin-result either as first parameter, or reads it from STDIN
(what allows heredoc usage for example). In case of STDIN, the read-timeout
is set to 1 seconds.

### 27a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $text |

### 27b. Returns

Type: `int`

0 on success, 1 on failure

## 28. Function `has_result_text`

returns 0, if the plugin-result has already been set. Otherwise it returns 1.

### 28b. Returns

Type: `int`

0 on success, 1 on failure

## 29. Function `get_result_text`

outputs the plugin-result, if it has already been set - in this case it
returns 0. Otherwise it returns 1.

*Outputs*: string

### 29b. Returns

Type: `int`

0 on success, 1 on failure

## 30. Function `set_result_perfdata`

accepts the plugin-perfdata as first parameter. On success it returns 0,
otherwise 1.

### 30a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $perfdata |

### 30b. Returns

Type: `int`

0 on success, 1 on failure

## 31. Function `has_result_perfdata`

returns 0, if the plugin-perfdata has already been set. Otherwise it returns 1.

### 31b. Returns

Type: `int`

0 on success, 1 on failure

## 32. Function `get_result_perfdata`

outputs the plugin-perfdata, if it has already been set - in this case it
returns 0. Otherwise it returns 1.

*Outputs*: string

### 32b. Returns

Type: `int`

0 on success, 1 on failure

## 33. Function `set_result_code`

accepts the plugin-exit-code as first parameter. On success it returns 0,
otherwise 1.

### 33a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $exit_code |

### 33b. Returns

Type: `int`

0 on success, 1 on failure

## 34. Function `has_result_code`

returns 0, if the plugin-code has already been set. Otherwise it returns 1.

### 34b. Returns

Type: `int`

0 on success, 1 on failure

## 35. Function `get_result_code`

outputs the plugin-code, if it has already been set - in this case it returns
0. Otherwise it returns 1.

*Outputs*: string

### 35b. Returns

Type: `int`

0 on success, 1 on failure

## 36. Function `print_result`

outputs the final result as required for (c) Nagios, (c) Icinga, etc.

*Outputs*: plugin-result + plugin-perfdata

### 36b. Returns

Type: `int`

plugin-code

## 37. Function `show_help`

displays the help text.  If a plugin-specifc help-text has been set
via set_help_text(), that one is printed. Otherwise the libraries
$CSL_DEFAULT_HELP_TEXT is used.

*Outputs*: plugin-helptext

### 37b. Returns

Type: `int`

0 on success, 1 on failure

## 38. Function `csl_cleanup`

is a function, that would be called on soon as this script has finished. It
must be set upped by using setup_cleanup_trap ().

### 38a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | int | $exit_code |

### 38b. Returns

Type: `int`

0 on success, 1 on failure

## 39. Function `startup`

is the first library function, that any plugin should invoke.

### 39a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $cmdline_params |

*Outputs*: plugin-result + plugin-perfdata

### 39b. Returns

Type: `int`

0 on success, 1 on failure

## 40. Function `set_help_text`

accepts a plugin-specific help-text, that is returned when show_help()
is called.  The text can either be provided as first parameter or being read
from STDIN (what allows heredoc usage for example).

### 40a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $text |

### 40b. Returns

Type: `int`

0 on success, 1 on failure

## 41. Function `has_help_text`

returns 0, if a plugin-specific help-text has been set. Otherwise it returns 1.

### 41b. Returns

Type: `int`

0 on success, 1 on failure

## 42. Function `get_help_text`

outputs a plugin-specific help-text, if it has been previously set by
set_help_text(). In this case it returns 0, otherwise 1.

*Outputs*: plugin-helptext

### 42b. Returns

Type: `int`

0 on success, 1 on failure

## 43. Function `add_param`

registers an additional, plugin-specific command-line-parameter.

### 43a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $short_param set '' for no short-parameter |
| *$2* | string | $long_param set '' for no long-parameter |
| *$3* | string | $opt_var variable- or function-name to store/handle cmdline
arguments. |
| *$4* | string | $opt_default default value, optional |

### 43b. Returns

Type: `int`

0 on success, 1 on failure

## 44. Function `has_param`

returns 0, if the given parameter name actually is defined. Otherwise it
returns 1.

### 44a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 44b. Returns

Type: `int`

0 on success, 1 on failure

## 45. Function `has_param_value`

returns 0, if the given parameter has been defined and consists of a value
that is not empty. Otherwise it returns 1.

### 45a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 45b. Returns

Type: `int`

0 on success, 1 on failure 

## 46. Function `has_param_default_value`

returns 0, if the given parameter has been defined and consists of a
default-value that is not empty. Otherwise it returns 1.

### 46a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 46b. Returns

Type: `int`

0 on success, 1 on failure

## 47. Function `get_param_value`

outputs the value of a given parameter, if it has been set already - in this
case it returns 0. Otherwise it returns 1.

### 47a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 47b. Returns

Type: `int`

0 on success, 1 on failure

## 48. Function `get_param_default_value`

outputs the default value of a given parameter, if it has been set already -
in this case it returns 0. Otherwise it returns 1.

### 48a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 48b. Returns

Type: `int`

0 on success, 1 on failure

## 49. Function `get_param`

works similar as get_param_value(), but it also accepts the short- (eg. -w)
and long-parameters (eg. --warning) as indirect lookup keys. On success,
the value is printed and the function returns 0. Otherwise it returns 1.

### 49a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

*Outputs*: param-value

### 49b. Returns

Type: `int`

0 on success, 1 on failure

## 50. Function `add_prereq`

registers a new plugin-requesit. Those are then handled in
csl_check_requirements(). On success the function returns 0, otherwise it
returns 1.  Multiple requesits can be registered in one step.

### 50a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $prereq1 $prereq2 etc. |

### 50b. Returns

Type: `int`

0 on success, 1 on failure

## 51. Function `csl_has_short_params`

returns 0, if parameters in short form (-d -w 5...) have been given on the
command line. Otherwise it returns 1.

### 51b. Returns

Type: `int`

0 on success, 1 on failure

## 52. Function `csl_has_long_params`

returns 0, if parameters in long form (--debug --warning 5...) have been
given on the command line. Otherwise it returns 1.

### 52b. Returns

Type: `int`

0 on success, 1 on failure

## 53. Function `csl_get_short_params`

outputs the registered short command-line-parameters in the form as required
by GNU getopt.

*Outputs*: short-params

### 53b. Returns

Type: `int`

0 on success, 1 on failure

## 54. Function `csl_get_long_params`

outputs the registered long command-line-parameters in the form as required
by GNU getopt.

*Outputs*: long-params

### 54b. Returns

Type: `int`

0 on success, 1 on failure

## 55. Function `create_tmpdir`

creates and tests for a temporary directory being created by
mktemp. Furthermore it registers the temp-directory in the variable
CSL_TEMP_DIRS[] that is eval'ed in case by csl_cleanup(), to remove plugin
residues. there is a hard-coded threshold for max. 10 temp-directories.

*Outputs*: temp-directory

### 55b. Returns

Type: `int`

0 on success, 1 on failure

## 56. Function `setup_cleanup_trap`

### 56b. Returns

Type: `int`

0 on success, 1 on failure

## 57. Function `sanitize`

This function tries to sanitize the provided string and removes all characters
from the string that are not matching the provided pattern mask.

### 57a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | text |

*Outputs*: string

### 57b. Returns

Type: `int`

## 58. Function `in_array`

searches the array $1 for the value given in $2. $2 may even contain a
regular expression pattern. On success, it returns 0. Otherwise 1 is returned.

### 58a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 58b. Returns

Type: `int`

## 59. Function `in_array_re`

This function works similar as in_array(), but uses the patterns that have
been stored in the array $1 against the fixed string provided with $2. On
success, it returns 0. Otherwise 1 is returned.

### 59a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 59b. Returns

Type: `int`

## 60. Function `key_in_array`

searches the associatative array $1 for the key given in $2. $2 may even
contain a regular expression pattern. On success, it returns 0. Otherwise
1 is returned.

### 60a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 60b. Returns

Type: `int`

## 61. Function `key_in_array_re`

This function works similar as key_in_array(), but uses the patterns that
have been stored in the array $1 against the fixed string provided with
$2. On success, it returns 0. Otherwise 1 is returned.

### 61a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 61b. Returns

Type: `int`

## 62. Function `is_array`

This function tests if the provided array $1 is either an indexed- or an
associative-array. If so, the function returns 0, otherwise 1.

### 62a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |

### 62b. Returns

Type: `int`

## 63. Function `csl_get_version`

This function returns the library version number as defined in the variable
$CSL_VERSION. Just in case, it also performs some validation on the version
number to ensure, not getting fooled.

*Outputs*: string version-number

### 63b. Returns

Type: `int`

0 on success, 1 on failure

## 64. Function `csl_add_threshold`

With this function, warning- and critical-thresholds for certain 'keys'
are registered. A key is the text the matches a given input value.

### 64a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | Either 'WARNING' or 'CRITICAL' |
| *$2* | string | key name |

### 64b. Returns

Type: `int`

## 65. Function `csl_add_limit`

## 66. Function `has_threshold`

This function checks, if a threshold has been registered for the provided key
($1)

### 66a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key |

### 66b. Returns

Type: `int`

0 on success, 1 on failure

## 67. Function `has_limit`

## 68. Function `get_threshold_for_key`

This function look up the declared warning- or critical-thresholds ($1)
for the specified key ($2).

### 68a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | Either 'WARNING' or 'CRITICAL' |
| *$2* | string | key name |

*Outputs*: text threshold

### 68b. Returns

Type: `int`

0 on success, 1 on failure

## 69. Function `get_limit_for_key`

## 70. Function `add_result`

This function registers a result value ($2) for the given key ($1). The
function does not allow to overrule an already set value with the same key.

### 70a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key name |
| *$2* | string | value |

### 70b. Returns

Type: `int`

0 on success, 1 on failure

## 71. Function `has_results`

This function performs a quick check, if actually result values have been
recorded.

### 71b. Returns

Type: `int`

0 on success, 1 on failure

## 72. Function `has_result`

This function tests if a result has been recorded for the given key ($1).

### 72b. Returns

Type: `int`

0 on success, 1 on failure

## 73. Function `get_result`

This function returns the result that has been recorded for the given key ($1).

### 73a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key name |

*Outputs*: string value

### 73b. Returns

Type: `int`

0 on success, 1 on failure

## 74. Function `eval_results`

This function iterates over all the recorded results and evaluate
their values with eval_thresholds(). Finally, the function uses
set_result_(text|code|perfdata) to set the scripts final results.  To perform
your own evaluations, you may override this function by specifying an
user_eval_results() function in your plugin. Than plugin_worker() will _not_
call eval_results(), but invokes user_eval_results() instead.

### 74b. Returns

Type: `0`

on success, 1 on failure

## 75. Function `csl_compare_version`

This function compares to version strings. Credits to original author Dennis
Williamson @ stackoverflow (see link).

### 75a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | version1 |
| *$2* | string | version2 |

*Outputs*: string eq = equal,lt = less than,gt = greater than

### 75b. Returns

Type: `0`

on success, 1 on failure

Link: https://stackoverflow.com/a/4025065

## 76. Function `csl_require_libvers`

This function checks if the current library version number is matching the
requiremented version as specified in $1.

*Outputs*: string lt (less-than), eq (equal), gt (greater-than)

### 76b. Returns

Type: `int`

0 on success, 1 on failure

## 77. Function `exit_no_data`

This function can be called to exit with the correct exit-code, in case
no plugin data is available. The function outputs CSL_EXIT_CRITICAL if
CSL_EXIT_NO_DATA_IS_CRITICAL is set, otherwise it returns CSL_EXIT_UNKNOWN

*Outputs*: int CSL_EXIT_CRITICAL or CSL_EXIT_UNKNOWN

### 77b. Returns

Type: `int`

0 on success

```
exit "$(exit_no_data)"
```

## 78. Function `deprecate_func`

This function can be used to output a message when a deprecated function has
been called. It issues the message, then invokes the replacement function given
in $1 with all the further parameters the deprecated function was called with.

### 78a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | replacement-function |

### 78b. Returns

Type: `int`

the replacement-functions exit-code

[^1]: Created by shell-docs-gen.sh v1.3.1 on Don Aug 31 10:35:58 CEST 2017.
