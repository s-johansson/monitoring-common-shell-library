# Changes in monitoring-common-shell-library

# 1.2
* new functions
 * is_cmd()
 * is_func()
 * add_prereq()
 * (has|get)_param()
 * (has|get)_param_value()
* set_help_text() now accepts the text either as first parameter or via received
  via STDIN.
* New plugin hooks
 * plugin_startup()
 * plugin_cleanup()
 * plugin_params_validate()

# 1.1

* new functions
 * (set|get|has)_help_text()
 * add_param(), (get|has)_short_params(), (get|has)_long_params()
 * is_declared_func()
 * is_empty()
 * is_dir()
 * create_tmpdir()

# 1.0

* Initial release
