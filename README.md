# Introduction

**monitoring-common-shell-library** offers some universal functions that can
be used for quickly developing a **monitoring plugin**.

## Requirements

* Bash 4
* getopt (from util-linux)
* cat (GNU core utilities)
* mktemp (GNU core utilities)
* GNU bc

On Debian and its derivatives you quickly fulfill those requirements with:

    sudo apt-get install bash util-unix coreutils bc

## Package

This **monitoring-common-shell-library** is also available as Debian package
(.deb). Checkout [https://apt.netshadow.net](https://apt.netshadow.net) to
locate the package.

## Integration

### Including it

The easiest way, to include the libraries functionality into your monitoring
plugin, is to **source** functions.sh from your plugin. This can be done by

    source functions.sh

or even in a short form

    . functions.sh

If you have installed **monitoring-common-shell-library** as a software package
(eg. .deb), *functions.sh* is usually located in

    /usr/share/monitoring-common-shell-library/functions.sh

### Embedding it

Another way to integrate the library into your plugin, is to **concatenate** the
contents of `functions.sh` to your monitoring plugin.

But note: it might be harder to maintain your plugin if you want to update the
functions provided by this library. Your plugin will probably remain more slim
and efficient, if you choose the way "Including it".

## Functions List

See the automatically generated *function-reference* in `FUNCREF.md`, that is
automatically generated from `functions.sh`.

## Automated Testing

The **monitoring-common-shell-library** has been bundled with a built-in test-
suite that tries to lead the provided functions up the garden path. It might
not be that perfect, but at least ensures some quality level of the library's
code is retained.

See `README.md` in the `tests` directory for more information.

## License

All files are licensed by **GNU Affero General Public License v3**.
See `LICENSE` file for more information.

## Author

(c) 2017 Andreas Unterkircher <unki@netshadow.net>
