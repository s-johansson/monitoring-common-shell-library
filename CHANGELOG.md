# Changes in monitoring-common-shell-library

# 1.4 (unreleased)

* Introduced CSL\_VERSION variable, to indicate the version number of the
  library. It can be queried by the function csl\_get\_version().
* Allow multiple, comma-separated thresholds to be specified as command-line
  arguments (see --help).
* New functions introduced (see FUNCREF.md)
    * key\_in\_array()
    * key\_in\_array\_re()
    * csl\_add\_limit()
    * get\_limit\_for\_key()
    * add\_result()
    * has\_result()
    * get\_result()
    * has\_results()
    * eval\_results()

# 1.3 (20170821)

* New functions introduced (see FUNCREF.md)
    * sanitize()
    * in\_array()
    * in\_array\_re()
    * is\_array()
* functions.sh linted by shellcheck.

# 1.2.1 (20170809)

* bugfix release
* fix typo in add\_param()

# 1.2 (20170809)

* Prefix all function that are not meant to be public with csl\_
* Mark most of the functions readonly to avoid, someone mix them up.
* set\_help\_text() now accepts the text either as first parameter or via received via STDIN.
* New functions introduced (see README.md)
    * is\_cmd() is\_func()
    * add\_prereq()
    * (has|get)\_param()
    * (has|get)\_param\_value()
    * (set|has|get)\_result\_text()
    * (set|has|get)\_result\_code()
    * (set|has|get)\_result\_perfdata()
* New plugin hooks introduced (see README.md)
    * plugin\_startup()
    * plugin\_cleanup()
    * plugin\_params\_validate()
    * plugin\_prereq()

# 1.1 (20170803)

* new functions
    * (set|get|has)\_help\_text()
    * add\_param(), (get|has)\_short\_params(), (get|has)\_long\_params()
    * is\_declared\_func()
    * is\_empty()
    * is\_dir()
    * create\_tmpdir()

# 1.0

* Initial release
