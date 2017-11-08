# Introduction

The idea of the **monitoring-common-shell-library** is to have reoccurring code
like threshold-evaluation, unit tests, etc. to be shared between plugins.

This reduces the code-lines of a plugin a lot and allows to quick develop a new
*monitoring-plugin*.

Basically, **monitoring-common-shell-library** relies heavily on Bash 4. Only
a few external dependencies are used (see Requirements) which usually are
already present on a typical _Linux_ installation.

Some plugins that use the **monitoring-common-shell-library**:

* [https://netshadow.org/monitoring-plugins/check_lm_sensors2](check_lm_sensors2)
* [https://netshadow.org/monitoring-plugins/check_kerberos](check_kerberos)
* [https://netshadow.org/monitoring-plugins/check_icinga2](check_icinga2)
* [https://netshadow.org/monitoring-plugins/check_doveadm_replication](check_doveadm_replication)

## Requirements

* Bash 4
* getopt (from _util-linux_)
* cat (from _GNU core utilities_)
* mktemp (from _GNU core utilities_)
* GNU bc

On Debian and its derivatives, you can quickly fulfilling these requirements by:

    sudo apt-get install bash util-unix coreutils bc

## Package

**monitoring-common-shell-library** is also available as Debian package (.deb).

Checkout [https://apt.netshadow.net](https://apt.netshadow.net) to locate the
package and download it.

## Integration

Basically, _functions.sh_ is ready for use, the shipped Makefile in the libraries
root-directory is used for developers only.

### Including it

The easiest way, to include the libraries functionality into your monitoring
plugin, is to **source** functions.sh from your plugin. This can be done by

    source functions.sh

or even in a short form

    . functions.sh

If you have installed **monitoring-common-shell-library** as a software package
(eg. .deb), *functions.sh* is usually located in:
 _/usr/share/monitoring-common-shell-library/functions.sh_.

To include from there, write:

    source /usr/share/monitoring-common-shell-library/functions.sh

### Embedding it

Another way to integrate the library into your plugin, is to **concatenate** the
contents of `functions.sh` to your monitoring plugin.

But note: it might be harder to maintain your plugin if you want to update the
functions provided by this library. Your plugin will probably remain more slim,
portable and efficient if you choose the way "Including it".

## Functions List

See the automatically generated *function-reference* in [./FUNCREF.md](FUNCREF.md),
that is automatically generated from `functions.sh`.

## Development

If you want to extend the **monitoring-common-shell-library** and contribute your
changes to this project, please obey [./CODING.md](CODING.md).

## Automated Testing

The **monitoring-common-shell-library** has been written along with a test-suite,
that tries to lead the provided functions up the garden path.

It might not be that perfect, but at least ensures some code quality level to be
retained.

See [./README.md](README.md) in the _tests_ directory for more information.

## License

All files are licensed by **GNU Affero General Public License v3**.

See [./LICENSE](LICENSE) file for more information.

## Author

(c) 2017 Andreas Unterkircher <unki@netshadow.net>
