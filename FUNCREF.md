# monitoring-common-shell-library Function Reference

| Tag | Value |
| - | - |
| Author | Andreas Unterkircher |
| Version | 1.3 |
| License | AGPLv3 |


## Function `is_debug`

returns 0 if debugging is enabled, otherwise it returns 1.

***Returns***

Type: `int`

0 or 1


## Function `debug`

prints output only if --debug or -d parameters have been given. debug output is sent to STDERR! The debug-output contains the function name from which debug() has been called (if no function -> 'main'). Furthermore the line-number of the line that triggered debug() is displayed.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $debug_text |

***Returns***

Type: `int`


## Function `fail`

prints the fail-text as well as the function and code-line from which it was called. The debug-output contains the function name from which debug() has been called (if no function -> 'main'). Furthermore the line-number of the line that triggered debug() is displayed.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $fail_text |

***Returns***

Type: `int`


## Function `is_verbose`

returns 0 if verbose-logging is enabled, otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `verbose`

prints output only if --verbose or -v parameters have been given. verbose output is sent to STDERR!

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $log_text |

***Returns***

Type: `int`


## Function `csl_is_exit_on_no_data_critical`

returns 0, if it has been choosen, that no-data-is-available is a critical error. otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `csl_check_requirements`

tests for other required tools. It also invokes an possible plugin-specific requirement-check function called plugin_prereq().

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `csl_get_limit_range`

returns the provided threshold as range in the form of 'MIN MAX'. In case the provided value is a single value (either integer or float), then 'x MAX' is returned.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $limit |

*Outputs*: string

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_declared`

returns 0 if the provided variable has been declared (that does not mean, that the variable actually has a value!), otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $var |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_declared_func`

returns 0 if the provided function name refers to an already declared function. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $var |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_set`

returns 0, if all the provided values are set (non-empty string). specific to this library, the value 'x' also signals emptiness.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $val1 |
| *$2* | string | $val2 |
| *$3* | string | ... |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_empty`

returns 0, if the provided string has a zero length. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $string |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_match`

invokes the Basic Calculator (bc) and provideѕ it the given $condition. If the condition is met, bc returns '1' - in this is_match() returns 0. Otherwise if the condition fails, bc will return '0', than is_match() returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $condition |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_dir`

returns 0, if the given directory actually exists. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $path |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `eval_limits`

evaluates the given value $1 against WARNING ($2) and CRITICAL ($3) thresholds.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $value |
| *$2* | string | $warning |
| *$3* | string | $critical |

*Outputs*: OK|WARNING|CRITICAL|UNKNOWN

***Returns***

Type: `int`

0|1|2|3


## Function `csl_parse_parameters`

This function uses GNU getopt to parse the given command-line parameters.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $params |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_range`

returns 0, if the argument given is in the form of an range. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $range |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_integer`

returns 0, if the given argument is an integer number. it also accepts the form :[0-9] (value lower than) and [0-9]: (value greater than). Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $integer |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_float`

returns 0, if the given argument is a floating point number. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $float |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_valid_limit`

performs the checks on the given warning and critical values and returns 0, if they are. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $limit |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_cmd`

returns 0, if the provided external command exists. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $command |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `is_func`

returns 0, if the given function name refers an already declared function. Otherwise it returns 1

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $funcname |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `csl_validate_parameters`

returns 0, if the given command-line parameters are valid. Otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `set_result_text`

accepts the plugin-result either as first parameter, or reads it from STDIN (what allows heredoc usage for example). In case of STDIN, the read-timeout is set to 1 seconds.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $text |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `has_result_text`

returns 0, if the plugin-result has already been set. Otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `get_result_text`

outputs the plugin-result, if it has already been set - in this case it returns 0. Otherwise it returns 1.

*Outputs*: string

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `set_result_perfdata`

accepts the plugin-perfdata as first parameter. On success it returns 0, otherwise 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $perfdata |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `has_result_perfdata`

returns 0, if the plugin-perfdata has already been set. Otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `get_result_perfdata`

outputs the plugin-perfdata, if it has already been set - in this case it returns 0. Otherwise it returns 1.

*Outputs*: string

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `set_result_code`

accepts the plugin-exit-code as first parameter. On success it returns 0, otherwise 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $exit_code |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `has_result_code`

returns 0, if the plugin-code has already been set. Otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `get_result_code`

outputs the plugin-code, if it has already been set - in this case it returns 0. Otherwise it returns 1.

*Outputs*: string

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `print_result`

outputs the final result as required for (c) Nagios, (c) Icinga, etc.

*Outputs*: plugin-result + plugin-perfdata

***Returns***

Type: `int`

plugin-code


## Function `show_help`

displays the help text.  If a plugin-specifc help-text has been set via set_help_text(), that one is printed. Otherwise the libraries $CSL_DEFAULT_HELP_TEXT is used.

*Outputs*: plugin-helptext

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `cleanup`

is a function, that would be called on soon as this script has finished. It must be set upped by using setup_cleanup_trap ().

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | int | $exit_code |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `startup`

is the first library function, that any plugin should invoke.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $cmdline_params |

*Outputs*: plugin-result + plugin-perfdata

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `set_help_text`

accepts a plugin-specific help-text, that is returned when show_help() is called.  The text can either be provided as first parameter or being read from STDIN (what allows heredoc usage for example).

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $text |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `has_help_text`

returns 0, if a plugin-specific help-text has been set. Otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `get_help_text`

outputs a plugin-specific help-text, if it has been previously set by set_help_text(). In this case it returns 0, otherwise 1.

*Outputs*: plugin-helptext

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `add_param`

registers an additional, plugin-specific command-line-parameter.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $short_param set '' for no short-parameter |
| *$2* | string | $long_param set '' for no long-parameter |
| *$3* | string | $opt_var variable- or function-name to store/handle cmdline arguments. |
| *$4* | string | $opt_default default value, optional |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `has_param`

returns 0, if the given parameter name actually is defined. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `has_param_value`

returns 0, if the given parameter has been defined and consists of a value that is not empty. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

***Returns***

Type: `int`

0 on success, 1 on failure 


## Function `get_param_value`

outputs the value of a given parameter, if it has been set already - in this case it returns 0. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `get_param`

works similar as get_param_value(), but it also accepts the short- (eg. -w) and long-parameters (eg. --warning) as indirect lookup keys. On success, the value is printed and the function returns 0. Otherwise it returns 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $param |

*Outputs*: param-value

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `add_prereq`

registers a new plugin-requesit. Those are then handled in csl_check_requirements(). On success the function returns 0, otherwise it returns 1.  Multiple requesits can be registered in one step. 

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $prereq1 $prereq2 etc. |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `csl_has_short_params`

returns 0, if parameters in short form (-d -w 5...) have been given on the command line. Otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `csl_has_long_params`

returns 0, if parameters in long form (--debug --warning 5...) have been given on the command line. Otherwise it returns 1.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `csl_get_short_params`

outputs the registered short command-line-parameters in the form as required by GNU getopt.

*Outputs*: short-params

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `csl_get_long_params`

outputs the registered long command-line-parameters in the form as required by GNU getopt.

*Outputs*: long-params

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `create_tmpdir`

creates and tests for a temporary directory being created by mktemp. Furthermore it registers the temp-directory in the variable CSL_TEMP_DIRS[] that is eval'ed in case by cleanup(), to remove plugin residues. there is a hard-coded limit for max. 10 temp-directories.

*Outputs*: temp-directory

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `setup_cleanup_trap`

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `sanitize`

This function tries to sanitize the provided string and removes all characters from the string that are not matching the provided pattern mask.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | text |

*Outputs*: string

***Returns***

Type: `int`


## Function `in_array`

searches the array $1 for the value given in $2. $2 may even contain a regular expression pattern. On success, it returns 0. Otherwise 1 is returned.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

***Returns***

Type: `int`


## Function `in_array_re`

This function works similar as in_array(), but uses the patterns that have been stored in the array $1 against the fixed string provided with $2. On success, it returns 0. Otherwise 1 is returned.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

***Returns***

Type: `int`


## Function `key_in_array`

searches the associatative array $1 for the key given in $2. $2 may even contain a regular expression pattern. On success, it returns 0. Otherwise 1 is returned.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

***Returns***

Type: `int`


## Function `key_in_array_re`

This function works similar as key_in_array(), but uses the patterns that have been stored in the array $1 against the fixed string provided with $2. On success, it returns 0. Otherwise 1 is returned.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |
| *$2* | string | needle |

***Returns***

Type: `int`


## Function `is_array`

This function tests if the provided array $1 is either an indexed- or an associative-array. If so, the function returns 0, otherwise 1.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | array-name |

***Returns***

Type: `int`


## Function `csl_get_version`

This function returns the library version number as defined in the variable $CSL_VERSION. Just in case, it also performs some validation on the version number to ensure, not getting fooled.

*Outputs*: string version-number

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `csl_add_limit`

With this function, warning- and critical-limits for certain 'keys' are registered. A key is the text the matches a given input value.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | Either 'WARNING' or 'CRITICAL' |
| *$2* | string | key name |

***Returns***

Type: `int`


## Function `get_limit_for_key`

This function look up the declared warning- or critical-limits ($1) for the specified key ($2).

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | Either 'WARNING' or 'CRITICAL' |
| *$2* | string | key name |

*Outputs*: text threshold

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `add_result`

This function registers a result value ($2) for the given key ($1). The function does not allow to overrule an already set value with the same key.

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | key name |
| *$2* | string | value |

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `has_results`

This function performs a quick check, if actually result values have been recorded.

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `has_result`

This function tests if a result has been recorded for the given key ($1).

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `get_result`

This function returns the result that has been recorded for the given key ($1).

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | key name |

*Outputs*: string value

***Returns***

Type: `int`

0 on success, 1 on failure


## Function `eval_results`

This function iterates over all the recorded results and evaluate their values with eval_limits(). Finally, the function uses set_result_(text|code|perfdata) to set the scripts final results.  To perform your own evaluations, you may override this function by specifying an user_eval_results() function in your plugin. Than plugin_worker() will _not_ call eval_results(), but invokes user_eval_results() instead.

***Returns***

Type: `0`

on success, 1 on failure

[^1]: Created by shell-docs-gen.sh v1.2 on Sam Aug 26 12:09:04 CEST 2017.
