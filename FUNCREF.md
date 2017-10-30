# monitoring-common-shell-library Function Reference

| Tag | Value |
| - | - |
| Author | Andreas Unterkircher |
| Version | 1.8 |
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

Todo: to be removed by 2017-12-31

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

## 13. Function `is_empty_str`

returns 0, if the provided string has a length of zero. Otherwise it returns 1.

### 13a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $string |

### 13b. Returns

Type: `int`

0 on success, 1 on failure

## 14. Function `is_empty`

returns 0, if the provided string or array variable have a value of length
of zero.  Otherwise it returns 1.

### 14a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string|array | $string |

### 14b. Returns

Type: `int`

0 on success, 1 on failure

Todo: remove the call to is_empty_str() by 2017-12-31 and return an error
if undeclared instead.

## 15. Function `is_match`

invokes the Basic Calculator (bc) and provideѕ it the given $condition. If
the condition is met, bc returns '1' - in this is_match() returns 0. Otherwise
if the condition fails, bc will return '0', than is_match() returns 1.

### 15a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $condition |

### 15b. Returns

Type: `int`

0 on success, 1 on failure

## 16. Function `is_dir`

returns 0, if the given directory actually exists. Otherwise it returns 1.

### 16a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $path |

### 16b. Returns

Type: `int`

0 on success, 1 on failure

## 17. Function `eval_thresholds`

evaluates the given value $1 against WARNING ($2) and CRITICAL ($3) thresholds.

### 17a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $value |
| *$2* | string | $warning |
| *$3* | string | $critical |

*Outputs*: OK|WARNING|CRITICAL|UNKNOWN

### 17b. Returns

Type: `int`

0|1|2|3

## 18. Function `eval_limits`

Todo: to be removed by 2017-12-31

## 19. Function `eval_text`

evaluates the given text $1 against WARNING ($2) and CRITICAL ($3) thresholds.

### 19a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $value |
| *$2* | string | $warning |
| *$3* | string | $critical |

*Outputs*: OK|WARNING|CRITICAL|UNKNOWN

### 19b. Returns

Type: `int`

0|1|2|3

## 20. Function `csl_parse_parameters`

This function uses GNU getopt to parse the given command-line parameters.

### 20a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $params |

### 20b. Returns

Type: `int`

0 on success, 1 on failure

## 21. Function `is_range`

returns 0, if the argument given is in the form of an range. Otherwise it
returns 1.

### 21a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $range |

### 21b. Returns

Type: `int`

0 on success, 1 on failure

## 22. Function `is_integer`

returns 0, if the given argument is an integer number. it also accepts the
form :[0-9] (value lower than) and [0-9]: (value greater than). Otherwise
it returns 1.

### 22a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $integer |

### 22b. Returns

Type: `int`

0 on success, 1 on failure

## 23. Function `is_float`

returns 0, if the given argument is a floating point number. Otherwise it
returns 1.

### 23a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $float |

### 23b. Returns

Type: `int`

0 on success, 1 on failure

## 24. Function `is_valid_threshold`

performs the checks on the given warning and critical values and returns 0,
if they are. Otherwise it returns 1.

### 24a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $threshold |

### 24b. Returns

Type: `int`

0 on success, 1 on failure

## 25. Function `is_valid_limit`

Todo: to be removed by 2017-12-31

## 26. Function `is_cmd`

returns 0, if the provided external command exists. Otherwise it returns 1.

### 26a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $command |

### 26b. Returns

Type: `int`

0 on success, 1 on failure

## 27. Function `is_func`

returns 0, if the given function name refers an already declared
function. Otherwise it returns 1

### 27a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $funcname |

### 27b. Returns

Type: `int`

0 on success, 1 on failure

## 28. Function `csl_validate_parameters`

returns 0, if the given command-line parameters are valid. Otherwise it
returns 1.

### 28b. Returns

Type: `int`

0 on success, 1 on failure

## 29. Function `set_result_text`

accepts the plugin-result either as first parameter, or reads it from STDIN
(what allows heredoc usage for example). In case of STDIN, the read-timeout
is set to 1 seconds.

### 29a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $text |

### 29b. Returns

Type: `int`

0 on success, 1 on failure

## 30. Function `has_result_text`

returns 0, if the plugin-result has already been set. Otherwise it returns 1.

### 30b. Returns

Type: `int`

0 on success, 1 on failure

## 31. Function `get_result_text`

outputs the plugin-result, if it has already been set - in this case it
returns 0. Otherwise it returns 1.

*Outputs*: string

### 31b. Returns

Type: `int`

0 on success, 1 on failure

## 32. Function `set_result_perfdata`

accepts the plugin-perfdata as first parameter. On success it returns 0,
otherwise 1.

### 32a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $perfdata |

### 32b. Returns

Type: `int`

0 on success, 1 on failure

## 33. Function `has_result_perfdata`

returns 0, if the plugin-perfdata has already been set. Otherwise it returns 1.

### 33b. Returns

Type: `int`

0 on success, 1 on failure

## 34. Function `get_result_perfdata`

outputs the plugin-perfdata, if it has already been set - in this case it
returns 0. Otherwise it returns 1.

*Outputs*: string

### 34b. Returns

Type: `int`

0 on success, 1 on failure

## 35. Function `set_result_code`

accepts the plugin-exit-code as first parameter. On success it returns 0,
otherwise 1.

### 35a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $exit_code |

### 35b. Returns

Type: `int`

0 on success, 1 on failure

## 36. Function `has_result_code`

returns 0, if the plugin-code has already been set. Otherwise it returns 1.

### 36b. Returns

Type: `int`

0 on success, 1 on failure

## 37. Function `get_result_code`

outputs the plugin-code, if it has already been set - in this case it returns
0. Otherwise it returns 1.

*Outputs*: string

### 37b. Returns

Type: `int`

0 on success, 1 on failure

## 38. Function `print_result`

outputs the final result as required for (c) Nagios, (c) Icinga, etc.

*Outputs*: plugin-result + plugin-perfdata

### 38b. Returns

Type: `int`

plugin-code

## 39. Function `show_help`

displays the help text.  If a plugin-specifc help-text has been set
via set_help_text(), that one is printed. Otherwise this libraries
$CSL_DEFAULT_HELP_TEXT is used.

*Outputs*: plugin-helptext

### 39b. Returns

Type: `int`

0 on success, 1 on failure

## 40. Function `csl_cleanup`

is a function, that would be called on soon as this script has finished. It
must be set upped by using setup_cleanup_trap ().

### 40a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | int | $exit_code |

### 40b. Returns

Type: `int`

0 on success, 1 on failure

## 41. Function `startup`

is the first library function, that any plugin should invoke.

### 41a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $cmdline_params |

*Outputs*: plugin-result + plugin-perfdata

### 41b. Returns

Type: `int`

0 on success, 1 on failure

## 42. Function `set_help_text`

accepts a plugin-specific help-text, that is returned when show_help()
is called.  The text can either be provided as first parameter or being read
from STDIN (what allows heredoc usage for example).

### 42a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $text |

### 42b. Returns

Type: `int`

0 on success, 1 on failure

## 43. Function `has_help_text`

returns 0, if a plugin-specific help-text has been set. Otherwise it returns 1.

### 43b. Returns

Type: `int`

0 on success, 1 on failure

## 44. Function `get_help_text`

outputs a plugin-specific help-text, if it has been previously set by
set_help_text(). In this case it returns 0, otherwise 1.

*Outputs*: plugin-helptext

### 44b. Returns

Type: `int`

0 on success, 1 on failure

## 45. Function `add_param`

registers an additional, plugin-specific command-line-parameter.

### 45a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $short_param set '' for no short-parameter |
| *$2* | string | $long_param set '' for no long-parameter |
| *$3* | string | $opt_var variable- or function-name to store/handle cmdline
arguments. |
| *$4* | string | $opt_default default value, optional |

### 45b. Returns

Type: `int`

0 on success, 1 on failure

## 46. Function `has_param`

returns 0, if the given parameter name actually is defined. Otherwise it
returns 1.

### 46a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 46b. Returns

Type: `int`

0 on success, 1 on failure

## 47. Function `has_param_value`

returns 0, if the given parameter has been defined and consists of a value
that is not empty. Otherwise it returns 1. It also considers a default-value
and returns true if that one is present.

### 47a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 47b. Returns

Type: `int`

0 on success, 1 on failure 

## 48. Function `has_param_custom_value`

returns 0, if the given parameter has been defined and consists of a
custom-value that is not empty. Otherwise it returns 1.

### 48a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 48b. Returns

Type: `int`

0 on success, 1 on failure

## 49. Function `has_param_default_value`

returns 0, if the given parameter has been defined and consists of a
default-value that is not empty. Otherwise it returns 1.

### 49a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 49b. Returns

Type: `int`

0 on success, 1 on failure

## 50. Function `get_param_value`

outputs the value of a given parameter, if it has been set already - in this
case it returns 0. Otherwise it returns 1.

### 50a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 50b. Returns

Type: `int`

0 on success, 1 on failure

## 51. Function `get_param_custom_value`

outputs the value of a given parameter, if it has been set already - in this
case it returns 0. Otherwise it returns 1.

### 51a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 51b. Returns

Type: `int`

0 on success, 1 on failure

## 52. Function `get_param_default_value`

outputs the default value of a given parameter, if it has been set already -
in this case it returns 0. Otherwise it returns 1.

### 52a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 52b. Returns

Type: `int`

0 on success, 1 on failure

## 53. Function `get_param`

works similar as get_param_value(), but it also accepts the short- (eg. -w)
and long-parameters (eg. --warning) as indirect lookup keys. On success,
the value is printed and the function returns 0. Otherwise it returns 1.

### 53a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

*Outputs*: param-value

### 53b. Returns

Type: `int`

0 on success, 1 on failure

## 54. Function `add_prereq`

registers a new plugin-requesit. Those are then handled in
csl_check_requirements(). On success the function returns 0, otherwise it
returns 1.  Multiple requesits can be registered in one step.

### 54a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $prereq1 $prereq2 etc. |

### 54b. Returns

Type: `int`

0 on success, 1 on failure

## 55. Function `csl_has_short_params`

returns 0, if parameters in short form (-d -w 5...) have been given on the
command line. Otherwise it returns 1.

### 55b. Returns

Type: `int`

0 on success, 1 on failure

## 56. Function `csl_has_long_params`

returns 0, if parameters in long form (--debug --warning 5...) have been
given on the command line. Otherwise it returns 1.

### 56b. Returns

Type: `int`

0 on success, 1 on failure

## 57. Function `csl_get_short_params`

outputs the registered short command-line-parameters in the form as required
by GNU getopt.

*Outputs*: short-params

### 57b. Returns

Type: `int`

0 on success, 1 on failure

## 58. Function `csl_get_long_params`

outputs the registered long command-line-parameters in the form as required
by GNU getopt.

*Outputs*: long-params

### 58b. Returns

Type: `int`

0 on success, 1 on failure

## 59. Function `create_tmpdir`

creates and tests for a temporary directory being created by
mktemp. Furthermore it registers the temp-directory in the variable
CSL_TEMP_DIRS[] that is eval'ed in case by csl_cleanup(), to remove plugin
residues. there is a hard-coded threshold for max. 10 temp-directories.

*Outputs*: temp-directory

### 59b. Returns

Type: `int`

0 on success, 1 on failure

## 60. Function `setup_cleanup_trap`

### 60b. Returns

Type: `int`

0 on success, 1 on failure

## 61. Function `sanitize`

This function tries to sanitize the provided string and removes all characters
from the string that are not matching the provided pattern mask.

### 61a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | text |

*Outputs*: string

### 61b. Returns

Type: `int`

## 62. Function `in_array`

searches the array $1 for the value given in $2. $2 may even contain a
regular expression pattern. On success, it returns 0. Otherwise 1 is returned.

### 62a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 62b. Returns

Type: `int`

## 63. Function `in_array_re`

This function works similar as in_array(), but uses the patterns that have
been stored in the array $1 against the fixed string provided with $2. On
success, it returns 0. Otherwise 1 is returned.

### 63a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 63b. Returns

Type: `int`

## 64. Function `key_in_array`

searches the associatative array $1 for the key given in $2. $2 may even
contain a regular expression pattern. On success, it returns 0. Otherwise
1 is returned.

### 64a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 64b. Returns

Type: `int`

## 65. Function `key_in_array_re`

This function works similar as key_in_array(), but uses the patterns that
have been stored in the array $1 against the fixed string provided with
$2. On success, it returns 0. Otherwise 1 is returned.

### 65a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 65b. Returns

Type: `int`

## 66. Function `is_array`

This function tests if the provided array $1 is either an indexed- or an
associative-array. If so, the function returns 0, otherwise 1.

### 66a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |

### 66b. Returns

Type: `int`

## 67. Function `is_word`

This function tests if the provided string contains only alpha-numeric
characters.

## 68. Function `csl_get_version`

This function returns this library's version number as defined in the
$CSL_VERSION. Just in case, it also performs some validation on the version
number, to ensure not getting fooled.

*Outputs*: string version-number

### 68b. Returns

Type: `int`

0 on success, 1 on failure

## 69. Function `csl_add_threshold`

With this function, warning- and critical-thresholds for certain 'keys'
are registered. A key is the text the matches a given input value.

### 69a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | Either 'WARNING' or 'CRITICAL' |
| *$2* | string | key name |

### 69b. Returns

Type: `int`

## 70. Function `csl_add_limit`

Todo: to be removed by 2017-12-31

## 71. Function `has_threshold`

This function checks, if a threshold has been registered for the provided key
($1)

### 71a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key |

### 71b. Returns

Type: `int`

0 on success, 1 on failure

## 72. Function `has_limit`

Todo: to be removed by 2017-12-31

## 73. Function `get_threshold_for_key`

This function look up the declared warning- or critical-thresholds ($1)
for the specified key ($2).

### 73a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | Either 'WARNING' or 'CRITICAL' |
| *$2* | string | key name |

*Outputs*: text threshold

### 73b. Returns

Type: `int`

0 on success, 1 on failure

## 74. Function `get_limit_for_key`

Todo: to be removed by 2017-12-31

## 75. Function `add_result`

This function registers a result value ($2) for the given key ($1). The
function does not allow to overrule an already set value with the same key.

### 75a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key name |
| *$2* | string | value |

### 75b. Returns

Type: `int`

0 on success, 1 on failure

## 76. Function `has_results`

This function performs a quick check, if actually result values have been
recorded.

### 76b. Returns

Type: `int`

0 on success, 1 on failure

## 77. Function `has_result`

This function tests if a result has been recorded for the given key ($1).

### 77b. Returns

Type: `int`

0 on success, 1 on failure

## 78. Function `get_result`

This function returns the result that has been recorded for the given key ($1).

### 78a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key name |

*Outputs*: string value

### 78b. Returns

Type: `int`

0 on success, 1 on failure

## 79. Function `eval_results`

This function iterates over all the recorded results and evaluate
their values with eval_thresholds(). Finally, the function uses
set_result_(text|code|perfdata) to set the plugins final results.  To perform
your own evaluations, you may override this function by specifying an
user_eval_results() function in your plugin. Than plugin_worker() will _not_
call eval_results(), but invokes user_eval_results() instead.

### 79b. Returns

Type: `0`

on success, 1 on failure

## 80. Function `csl_compare_version`

This function compares to version strings. Credits to original author Dennis
Williamson @ stackoverflow (see link).

### 80a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | version1 |
| *$2* | string | version2 |

*Outputs*: string eq = equal,lt = less than,gt = greater than

### 80b. Returns

Type: `0`

on success, 1 on failure

Link: https://stackoverflow.com/a/4025065

## 81. Function `csl_require_libvers`

This function checks if the current library version number is matching the
requiremented version as specified in $1.

*Outputs*: string lt (less-than), eq (equal), gt (greater-than)

### 81b. Returns

Type: `int`

0 on success, 1 on failure

## 82. Function `exit_no_data`

This function can be called to exit with the correct exit-code, in case
no plugin data is available. The function outputs CSL_EXIT_CRITICAL if
CSL_EXIT_NO_DATA_IS_CRITICAL is set, otherwise it returns CSL_EXIT_UNKNOWN

*Outputs*: int CSL_EXIT_CRITICAL or CSL_EXIT_UNKNOWN

### 82b. Returns

Type: `int`

0 on success

```
exit "$(exit_no_data)"
```

## 83. Function `deprecate_func`

This function can be used to output a message when a deprecated function has
been called. It issues the message, then invokes the replacement function given
in $1 with all the further parameters the deprecated function was called with.

### 83a. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | replacement-function |

### 83b. Returns

Type: `int`

the replacement-functions exit-code

[^1]: Created by shell-docs-gen.sh v1.4 on Mon Okt 30 19:37:48 CET 2017.
