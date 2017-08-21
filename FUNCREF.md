# shell-docs-gen.sh Function Reference

## Function `is_debug`

returns 0 if debugging is enabled, otherwise it returns 1.

***Returns***

Type: `int`
0 or 1


## Function `debug`

prints output only if --debug or -d parameters have been given. debug output is sent to STDERR!

***Parameters***

| ID | Type | Description |
| - | - | - |
| *$1* | string | $debug_text |

***Returns***

Type: `int`


## Function `fail`

prints the fail-text as well as the function and code-line from which it was called.

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

invokes the Basic Calculator (bc) and provideѕ it the given $condition. If the condition is met in bc, that one returns '1' - in this is_match() returns 0. Otherwise bc will return '0', than is_match() returns 1....

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

evaluates the given value against the given WARNING ($2) and CRITICAL ($3) thresholds.

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

uses GNU getopt to parse the given command-line parameters.

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
| *$1* | string | $perfdata |

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

[^1]: Created by shell-docs-gen.sh v1.1 on Mon Aug 21 17:21:40 CEST 2017.
