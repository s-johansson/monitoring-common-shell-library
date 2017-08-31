# Changes in monitoring-common-shell-library

## 1.6 (2017-08-31)

* add function (get|has)\_param\_default\_value()
* more consistent behaviour of (get|has)\_param\_\* functions in case
  of incomplete parameters provided to these functions. Improved also
  all the test-cases for these situations.

## 1.5.1 (2017-08-31)

* bugfix: allow add\_param() to handle optional arguments
  to parameters that are indicated by two colons (arg::).
  Before that got rejected, as only one colon was accepted.

## 1.5 (20170829)

* add has\_threshold()
* let eval\_results() work correctly if only a one-for-all
  warning or critical threshold has been specified.
* use 'Threshold' instead of 'Limit'. Threshold fits better
  in the monitoring cases.
  All function got renamed if they had 'limit' in their
  name and are now available by 'threshold'.
  Calls to the deprecated functions for now stil succeed -
  the right 'new' function gets called and a deprecation
  note is displayed.

## 1.4.4 (20170828)

* let is\_array() also correctly handled readonly arrays.
* add csl\_require\_libvers()

## 1.4.3 (20170828)

* add exit\_no\_data()

## 1.4.2 (20170827)

* let csl\_version\_compare() issue output instead of using return values.

## 1.4.1 (20170827)

* Add csl\_version\_compare() function to check.

## 1.4 (20170827)

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
* add reorder.sh to automatically adjust testfiles according to test\_seq.dat

## 1.3 (20170821)

* New functions introduced (see FUNCREF.md)
  * sanitize()
  * in\_array()
  * in\_array\_re()
  * is\_array()
* functions.sh linted by shellcheck.

## 1.2.1 (20170809)

* bugfix release
* fix typo in add\_param()

## 1.2 (20170809)

* Prefix all function that are not meant to be public with csl\_
* Mark most of the functions readonly to avoid, someone mix them up.
* set\_help\_text() now accepts the text either as first parameter or via
  received via STDIN.
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

## 1.1 (20170803)

* new functions
  * (set|get|has)\_help\_text()
  * add\_param(), (get|has)\_short\_params(), (get|has)\_long\_params()
  * is\_declared\_func()
  * is\_empty()
  * is\_dir()
  * create\_tmpdir()

## 1.0

* Initial release
