# Changes in monitoring-common-shell-library

# 1.2.1 (20170809)

* bugfix release
* fix typo in add_param()

# 1.2 (20170809)

* Prefix all function that are not meant to be public with csl\_
* Mark most of the functions readonly to avoid, someone mix them up.
* set_help_text() now accepts the text either as first parameter or via received via STDIN.
* New functions introduced (see README.md)
    * is_cmd() is_func()
    * add_prereq()
    * (has|get)_param()
    * (has|get)_param_value()
    * (set|has|get)_result_text()
    * (set|has|get)_result_code()
    * (set|has|get)_result_perfdata()
* New plugin hooks introduced (see README.md)
    * plugin_startup()
    * plugin_cleanup()
    * plugin_params_validate()
    * plugin_prereq()

# 1.1 (20170803)

* new functions
    * (set|get|has)_help_text()
    * add_param(), (get|has)_short_params(), (get|has)_long_params()
    * is_declared_func()
    * is_empty()
    * is_dir()
    * create_tmpdir()

# 1.0

* Initial release
