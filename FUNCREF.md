# monitoring-common-shell-library Function Reference

| Tag | Value |
| - | - |
| Author | Andreas Unterkircher |
| Version | 1.9.1 |
| License | AGPLv3 |

<!-- if a table-of-contents gets actually rendered, depends on your markdown-viewer -->
[TOC]

## 1. Variable `CSL_VERSION`

### 1a. About

the library major and minor version number

## 2. Variable `CSL_TRUE`

## 3. Variable `CSL_FALSE`

## 4. Variable `CSL_EXIT_OK`

## 5. Variable `CSL_EXIT_WARNING`

## 6. Variable `CSL_EXIT_CRITICAL`

## 7. Variable `CSL_EXIT_UNKNOWN`

## 8. Variable `CSL_EXIT_NO_DATA_IS_CRITICAL`

### 8a. About

if set to true, no result-data being set until the end of the script
(actually until print_result() is invoked), will be treated as CRITICAL
instead of exiting with state UNKNOWN.

### 8b. Usage Example

```
CSL_EXIT_NO_DATA_IS_CRITICAL=true -> exits
CRITICAL
CSL_EXIT_NO_DATA_IS_CRITICAL=false -> exits UNKNOWN
```

## 9. Variable `CSL_DEBUG`

### 9a. About

if set to true, debugging output will be enabled.

### 9b. Usage Example

```
CSL_DEBUG=false -> debugging disabled
CSL_DEBUG=true -> debugging enabled
```

## 10. Variable `CSL_VERBOSE`

### 10a. About

if set to true, verbose console output will be enabled.

### 10b. Usage Example

```
CSL_VERBOSE=false -> verbose output disabled
CSL_VERBOSE=true -> verbose
output enabled
```

## 11. Variable `CSL_RESULT_CODE`

### 11a. About

this variable will held the final plugin-exit code.

## 12. Variable `CSL_RESULT_TEXT`

### 12a. About

this variable will held the final plugin-text output.

## 13. Variable `CSL_RESULT_PERFDATA`

### 13a. About

this variable will held the final plugin-performance data.

## 14. Variable `CSL_RESULT_VALUES`

### 14a. About

this associatative array will be filled by the plugin with the read measurement
values, and later be read to evaluate the plugins result.

## 15. Variable `CSL_GETOPT_SHORT`

### 15a. About

this variable gets filled with plugin-specific getopt short parameters.

## 16. Variable `CSL_GETOPT_LONG`

### 16a. About

this variable gets filled with plugin-specific getopt long parameters.

## 17. Variable `CSL_DEFAULT_GETOPT_SHORT`

### 17a. About

this variable contains the minimum set of getopt short parameters to be used
as command-line parameters.

## 18. Variable `CSL_DEFAULT_GETOPT_LONG`

### 18a. About

this variable contains the minimum set of getopt long parameters to be used
as command-line parameters.

## 19. Variable `CSL_DEFAULT_PREREQ`

### 19a. About

this variable helds the minimum set of external program dependencies, this
library requires. additional plugin-specific can be added by `add_prereq`. *
bc, for threshold evaluation. * getopt, for (advanced) command-line parameter
parsing. * mktemp, to create temporary directories.

## 20. Variable `CSL_WARNING_THRESHOLD`

### 20a. About

this associatative array helds the plugin-specific warning thresholds and
gets filled by the command-line parameter --warning (-w).

## 21. Variable `CSL_CRITICAL_THRESHOLD`

### 21a. About

this associatative array helds the plugin-specific critical thresholds and
gets filled by the command-line parameter --critical (-c).

## 22. Variable `CSL_USER_PREREQ`

### 22a. About

this index array helds the plugin-specific external dependencies. This variable
is best to be filled with `add_reqreq`. In the end, these requirements will
be merged with those specified in CSL_DEFAULT_PREREQ.

## 23. Variable `CSL_USER_PARAMS`

### 23a. About

this index array helds the plugin-specific getopt parameters. This variable
is best to be filled with `add_params` to register an additional parameter
with its short- and long-option.

## 24. Variable `CSL_USER_PARAMS_VALUES`

### 24a. About

this associatative array helds the values of plugin-specific getopt parameters
that have been specified on the command-line as arguments to getopt parameters.

## 25. Variable `CSL_USER_PARAMS_DEFAULT_VALUES`

### 25a. About

this associatative array helds the default-values of plugin- specific getopt
parameters that have been registered as getopt parameters. If no arguments
are given to a specific getopt parameter,

## 26. Variable `CSL_USER_GETOPT_PARAMS`

### 26a. About

this associatative array acts as fast lookup table from a specific getopt
parameter (long or short), to the actually defined CSL_USER_PARAMS.

## 27. Variable `CSL_TEMP_DIRS`

### 27a. About

this index array will be filled on any on any invocation of `create_tmpdir`,
as that one will push the name of the created temp-directory to this
variable. Later, `_csl_cleanup` will read this variable to take care of
removing the previously created temporary directories, when the script
terminates.

## 28. Variable `CSL_HELP_TEXT`

### 28a. About

this variable helds the plugin-specific help-text that can be set using
`set_help_text` and overrules the libraries own help-text defined in
CSL_DEFAULT_HELP_TEXT.

## 29. Variable `CSL_DEFAULT_HELP_TEXT`

### 29a. About

this variable helds the libraries own default help-text. It can be overwritten
by `set_help_text`.

## 30. Function `is_debug`

### 30a. About

returns 0 if debugging is enabled, otherwise it returns 1.

### 30b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 or 1 |

## 31. Function `debug`

### 31a. About

prints output only if --debug or -d parameters have been given. debug output is
sent to STDERR! The debug-output contains the function name from which debug()
has been called (if no function -> 'main'). Furthermore the line-number of
the line that triggered debug() is displayed.

### 31b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $debug_text |

### 31c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 32. Function `fail`

### 32a. About

prints the fail-text as well as the function and code-line from which it
was called. The debug-output contains the function name from which debug()
has been called (if no function -> 'main'). Furthermore the line-number of
the line that triggered debug() is displayed.

### 32b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $fail_text |

### 32c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 33. Function `is_verbose`

### 33a. About

returns 0 if verbose-logging is enabled, otherwise it returns 1.

### 33b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 34. Function `verbose`

### 34a. About

prints output only if --verbose or -v parameters have been given. verbose
output is sent to STDERR!

### 34b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $log_text |

### 34c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 35. Function `is_declared`

### 35a. About

returns 0 if the provided variable has been declared (that does not mean,
that the variable actually has a value!), otherwise it returns 1.

### 35b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $var |

### 35c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 36. Function `is_declared_func`

### 36a. About

returns 0 if the provided function name refers to an already declared
function. Otherwise it returns 1.

### 36b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $var |

### 36c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 37. Function `is_set`

### 37a. About

returns 0, if all the provided values are set (non-empty string). specific
to this library, the value 'x' also signals emptiness.

### 37b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $val1 |
| *$2* | string | $val2 |
| *$3* | string | ... |

### 37c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 38. Function `is_empty_str`

### 38a. About

returns 0, if the provided string has a length of zero. Otherwise it returns 1.

### 38b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $string |

### 38c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 39. Function `is_empty`

### 39a. About

returns 0, if the provided string or array variable have a value of length
of zero.  Otherwise it returns 1.

### 39b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string|array | $string |

### 39c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 40. Function `is_match`

### 40a. About

invokes the Basic Calculator (bc) and provides it the given $condition. If
the condition is met, bc returns '1' - in this is_match() returns 0. Otherwise
if the condition fails, bc will return '0', than is_match() returns 1.

### 40b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $condition |

### 40c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 41. Function `is_dir`

### 41a. About

returns 0, if the given directory actually exists. Otherwise it returns 1.

### 41b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $path |

### 41c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 42. Function `eval_thresholds`

### 42a. About

evaluates the given value $1 against WARNING ($2) and CRITICAL ($3) thresholds.

### 42b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $value |
| *$2* | string | $warning |
| *$3* | string | $critical |

### 42c. Output Example

`OK|WARNING|CRITICAL|UNKNOWN`

### 42d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0|1|2|3 |

## 43. Function `eval_text`

### 43a. About

evaluates the given text $1 against WARNING ($2) and CRITICAL ($3) thresholds.

### 43b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $value |
| *$2* | string | $warning |
| *$3* | string | $critical |

### 43c. Output Example

`OK|WARNING|CRITICAL|UNKNOWN`

### 43d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0|1|2|3 |

## 44. Function `is_range`

### 44a. About

returns 0, if the argument given is in the form of an range. Otherwise it
returns 1.

### 44b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $range |

### 44c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 45. Function `is_integer`

### 45a. About

returns 0, if the given argument is an integer number. it also accepts the
form :[0-9] (value lower than) and [0-9]: (value greater than). Otherwise
it returns 1.

### 45b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $integer |

### 45c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 46. Function `is_float`

### 46a. About

returns 0, if the given argument is a floating point number. Otherwise it
returns 1.

### 46b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $float |

### 46c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 47. Function `is_valid_threshold`

### 47a. About

performs the checks on the given warning and critical values and returns 0,
if they are. Otherwise it returns 1.

### 47b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $threshold |

### 47c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 48. Function `is_cmd`

### 48a. About

returns 0, if the provided external command exists. Otherwise it returns 1.

### 48b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $command |

### 48c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 49. Function `is_func`

### 49a. About

returns 0, if the given function name refers an already declared
function. Otherwise it returns 1

### 49b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $funcname |

### 49c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 50. Function `set_result_text`

### 50a. About

accepts the plugin-result either as first parameter, or reads it from STDIN
(what allows heredoc usage for example). In case of STDIN, the read-timeout
is set to 1 seconds.

### 50b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $text |

### 50c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 51. Function `has_result_text`

### 51a. About

returns 0, if the plugin-result has already been set. Otherwise it returns 1.

### 51b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 52. Function `get_result_text`

### 52a. About

outputs the plugin-result, if it has already been set - in this case it
returns 0. Otherwise it returns 1.

### 52b. Output Example

`string`

### 52c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 53. Function `set_result_perfdata`

### 53a. About

accepts the plugin-perfdata as first parameter. On success it returns 0,
otherwise 1.

### 53b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $perfdata |

### 53c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 54. Function `has_result_perfdata`

### 54a. About

returns 0, if the plugin-perfdata has already been set. Otherwise it returns 1.

### 54b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 55. Function `get_result_perfdata`

### 55a. About

outputs the plugin-perfdata, if it has already been set - in this case it
returns 0. Otherwise it returns 1.

### 55b. Output Example

`string`

### 55c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 56. Function `set_result_code`

### 56a. About

accepts the plugin-exit-code as first parameter. On success it returns 0,
otherwise 1.

### 56b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $exit_code |

### 56c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 57. Function `has_result_code`

### 57a. About

returns 0, if the plugin-code has already been set. Otherwise it returns 1.

### 57b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 58. Function `get_result_code`

### 58a. About

outputs the plugin-code, if it has already been set - in this case it returns
0. Otherwise it returns 1.

### 58b. Output Example

`string`

### 58c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 59. Function `print_result`

### 59a. About

outputs the final result as required for (c) Nagios, (c) Icinga, etc.

### 59b. Output Example

`plugin-result + plugin-perfdata`

### 59c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | plugin-code |

## 60. Function `show_help`

### 60a. About

displays the help text.  If a plugin-specifc help-text has been set
via set_help_text(), that one is printed. Otherwise this libraries
$CSL_DEFAULT_HELP_TEXT is used.

### 60b. Output Example

`plugin-helptext`

### 60c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 61. Function `startup`

### 61a. About

is the first library function, that a this library consuming plugin should
invoke.

### 61b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $cmdline_params |

### 61c. Output Example

`plugin-result + plugin-perfdata`

### 61d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 62. Function `set_help_text`

### 62a. About

accepts a plugin-specific help-text, that is returned when show_help()
is called.  The text can either be provided as first parameter or being read
from STDIN (what allows heredoc usage for example).

### 62b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $text |

### 62c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 63. Function `has_help_text`

### 63a. About

returns 0, if a plugin-specific help-text has been set. Otherwise it returns 1.

### 63b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 64. Function `get_help_text`

### 64a. About

outputs a plugin-specific help-text, if it has been previously set by
set_help_text(). In this case it returns 0, otherwise 1.

### 64b. Output Example

`plugin-helptext`

### 64c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 65. Function `add_param`

### 65a. About

registers an additional, plugin-specific command-line-parameter.

### 65b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $short_param set '' for no short-parameter |
| *$2* | string | $long_param set '' for no long-parameter |
| *$3* | string | $opt_var variable- or function-name to store/handle cmdline
arguments. |
| *$4* | string | $opt_default default value, optional |

### 65c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 66. Function `has_param`

### 66a. About

returns 0, if the given parameter name actually is defined. Otherwise it
returns 1.

### 66b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 66c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 67. Function `has_param_value`

### 67a. About

returns 0, if the given parameter has been defined and consists of a value
that is not empty. Otherwise it returns 1. It also considers a default-value
and returns true if that one is present.

### 67b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 67c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure  |

## 68. Function `has_param_custom_value`

### 68a. About

returns 0, if the given parameter has been defined and consists of a
custom-value that is not empty. Otherwise it returns 1.

### 68b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 68c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 69. Function `has_param_default_value`

### 69a. About

returns 0, if the given parameter has been defined and consists of a
default-value that is not empty. Otherwise it returns 1.

### 69b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 69c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 70. Function `get_param_value`

### 70a. About

outputs the value of a given parameter, if it has been set already - in this
case it returns 0. Otherwise it returns 1.

### 70b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 70c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 71. Function `get_param_custom_value`

### 71a. About

outputs the value of a given parameter, if it has been set already - in this
case it returns 0. Otherwise it returns 1.

### 71b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 71c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 72. Function `get_param_default_value`

### 72a. About

outputs the default value of a given parameter, if it has been set already -
in this case it returns 0. Otherwise it returns 1.

### 72b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 72c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 73. Function `get_param`

### 73a. About

works similar as get_param_value(), but it also accepts the short- (eg. -w)
and long-parameters (eg. --warning) as indirect lookup keys. On success,
the value is printed and the function returns 0. Otherwise it returns 1.

### 73b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

### 73c. Output Example

`param-value`

### 73d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 74. Function `add_prereq`

### 74a. About

registers a new plugin-requesit. Those are then handled in
_csl_check_requirements(). On success the function returns 0, otherwise it
returns 1.  Multiple requesits can be registered in one step.

### 74b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $prereq1 $prereq2 etc. |

### 74c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 75. Function `create_tmpdir`

### 75a. About

creates and tests for a temporary directory being created by
mktemp. Furthermore it registers the temp-directory in the variable
CSL_TEMP_DIRS[] that is eval'ed in case by _csl_cleanup(), to remove plugin
residues. there is a hard-coded threshold for max. 10 temp-directories.

### 75b. Output Example

`temp-directory`

### 75c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 76. Function `setup_cleanup_trap`

### 76a. About

registers a signal-trap for certain signals like EXIT and INT, to call
the _csl_cleanup() function on program-termination (irrespectivly of
success or failure).  Note that the cleanup trap must be installed from the
plugin. As mostly these libraries functions will be called within a subshell
(eg. $(create_tmpdir)), the trap would only life within the context of this
subshell and would immediately be fired as soon as create_tmpdir() terminates.

### 76b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 77. Function `sanitize`

### 77a. About

This function tries to sanitize the provided string and removes all characters
from the string that are not matching the provided pattern mask.

### 77b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | text |

### 77c. Output Example

`string`

### 77d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 78. Function `in_array`

### 78a. About

searches the array $1 for the value given in $2. $2 may even contain a
regular expression pattern. On success, it returns 0. Otherwise 1 is returned.

### 78b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 78c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 79. Function `in_array_re`

### 79a. About

This function works similar as in_array(), but uses the patterns that have
been stored in the array $1 against the fixed string provided with $2. On
success, it returns 0. Otherwise 1 is returned.

### 79b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 79c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 80. Function `key_in_array`

### 80a. About

searches the associatative array $1 for the key given in $2. $2 may even
contain a regular expression pattern. On success, it returns 0. Otherwise
1 is returned.

### 80b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 80c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 81. Function `key_in_array_re`

### 81a. About

This function works similar as key_in_array(), but uses the patterns that
have been stored in the array $1 against the fixed string provided with
$2. On success, it returns 0. Otherwise 1 is returned.

### 81b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

### 81c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 82. Function `is_array`

### 82a. About

This function tests if the provided array $1 is either an indexed- or an
associative-array. If so, the function returns 0, otherwise 1.

### 82b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |

### 82c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 83. Function `is_word`

### 83a. About

This function tests if the provided string contains only alpha-numeric
characters.

## 84. Function `has_threshold`

### 84a. About

This function checks, if a threshold has been registered for the provided key
($1)

### 84b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key |

### 84c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 85. Function `get_threshold_for_key`

### 85a. About

This function look up the declared warning- or critical-thresholds ($1)
for the specified key ($2).

### 85b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | Either 'WARNING' or 'CRITICAL' |
| *$2* | string | key name |

### 85c. Output Example

`text threshold`

### 85d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 86. Function `add_result`

### 86a. About

This function registers a result value ($2) for the given key ($1). The
function does not allow to overrule an already set value with the same key.

### 86b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key name |
| *$2* | string | value |

### 86c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 87. Function `has_results`

### 87a. About

This function performs a quick check, if actually result values have been
recorded.

### 87b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 88. Function `has_result`

### 88a. About

This function tests if a result has been recorded for the given key ($1).

### 88b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 89. Function `get_result`

### 89a. About

This function returns the result that has been recorded for the given key ($1).

### 89b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | key name |

### 89c. Output Example

`string value`

### 89d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 90. Function `eval_results`

### 90a. About

This function iterates over all the recorded results and evaluate
their values with eval_thresholds(). Finally, the function uses
set_result_(text|code|perfdata) to set the plugins final results.  To perform
your own evaluations, you may override this function by specifying an
user_eval_results() function in your plugin. Than plugin_worker() will _not_
call eval_results(), but invokes user_eval_results() instead.

### 90b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `0` |
| Value | on success, 1 on failure |

## 91. Function `exit_no_data`

### 91a. About

This function can be called to exit with the correct exit-code, in case
no plugin data is available. The function outputs CSL_EXIT_CRITICAL if
CSL_EXIT_NO_DATA_IS_CRITICAL is set, otherwise it returns CSL_EXIT_UNKNOWN

### 91b. Output Example

`int CSL_EXIT_CRITICAL or CSL_EXIT_UNKNOWN`

### 91c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success |

### 91d. Usage Example

```
exit "$(exit_no_data)"
```

## 92. Function `_csl_is_exit_on_no_data_critical`

### 92a. About

returns 0, if it has been choosen, that no-data-is-available is a critical
error. otherwise it returns 1.

### 92b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 93. Function `_csl_check_requirements`

### 93a. About

tests for other required tools. It also invokes an possible plugin-specific
requirement-check function called plugin_prereq().

### 93b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 94. Function `_csl_get_threshold_range`

### 94a. About

returns the provided threshold as range in the form of 'MIN MAX'. In case
the provided value is a single value (either integer or float), then 'x MAX'
is returned.

### 94b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $threshold |

### 94c. Output Example

`string`

### 94d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 95. Function `_csl_parse_parameters`

### 95a. About

This function uses GNU getopt to parse the given command-line parameters.

### 95b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | $params |

### 95c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 96. Function `_csl_validate_parameters`

### 96a. About

returns 0, if the given command-line parameters are valid. Otherwise it
returns 1.

### 96b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 97. Function `_csl_cleanup`

### 97a. About

is a function, that would be called on soon as this script has terminated. It
must be set upped by using setup_cleanup_trap ().

### 97b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | int | $exit_code |

### 97c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 98. Function `_csl_has_short_params`

### 98a. About

returns 0, if parameters in short form (-d -w 5...) have been given on the
command line. Otherwise it returns 1.

### 98b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 99. Function `_csl_has_long_params`

### 99a. About

returns 0, if parameters in long form (--debug --warning 5...) have been
given on the command line. Otherwise it returns 1.

### 99b. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 100. Function `_csl_get_short_params`

### 100a. About

outputs the registered short command-line-parameters in the form as required
by GNU getopt.

### 100b. Output Example

`short-params`

### 100c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 101. Function `_csl_get_long_params`

### 101a. About

outputs the registered long command-line-parameters in the form as required
by GNU getopt.

### 101b. Output Example

`long-params`

### 101c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 102. Function `_csl_get_version`

### 102a. About

This function returns this library's version number as defined in the
$CSL_VERSION. Just in case, it also performs some validation on the version
number, to ensure not getting fooled.

### 102b. Output Example

`string version-number`

### 102c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 103. Function `_csl_add_threshold`

### 103a. About

With this function, warning- and critical-thresholds for certain 'keys'
are registered. A key is the text the matches a given input value.

### 103b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | Either 'WARNING' or 'CRITICAL' |
| *$2* | string | key name |

### 103c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |

## 104. Function `_csl_compare_version`

### 104a. About

This function compares to version strings. Credits to original author Dennis
Williamson @ stackoverflow (see link).

### 104b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | version1 |
| *$2* | string | version2 |

### 104c. Output Example

`string eq = equal,lt = less than,gt = greater than`

### 104d. Return-Code Example

| Desc | Value |
| - | - |
| Type | `0` |
| Value | on success, 1 on failure |

### 104e. Additional Information

Link: <https://stackoverflow.com/a/4025065>

## 105. Function `_csl_require_libvers`

### 105a. About

This function checks if the current library version number is matching the
requiremented version as specified in $1.

### 105b. Output Example

`string lt (less-than), eq (equal), gt (greater-than)`

### 105c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | 0 on success, 1 on failure |

## 106. Function `_csl_deprecate_func`

### 106a. About

This function can be used to output a message when a deprecated function has
been called. It issues the message, then invokes the replacement function given
in $1 with all the further parameters the deprecated function was called with.

### 106b. Parameters

| ID | Type | Description |
| - | - | - |
| *$1* | string | replacement-function |

### 106c. Return-Code Example

| Desc | Value |
| - | - |
| Type | `int` |
| Value | the replacement-functions exit-code |

[^1]: Created by _shell-docs-gen.sh_ _v1.6.3_ on Mon Feb 18 20:20:52 UTC 2019.
