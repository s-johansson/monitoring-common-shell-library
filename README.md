# Introduction

**monitoring-common-shell-library** offers some universal functions that can be used for quickly developing a **monitoring plugin**.

# Requirements

* Bash 4
* GNU getopt (sudo apt-get install util-unix)
* GNU cat (sudo apt-get install coreutils)
* GNU bc (sudo apt-get install bc)

On Debian and its derivates you quickly fulfil it with:

    sudo apt-get install bash util-unix coreutil bc

# Integration

## Including

The easiest way to include the functionality into your monitoring plugin, **source** functions.sh.

    source functions.sh

or in the short form

    . functions.sh

If you have installed check-library-functions by package, functions.sh might be placed in */usr/share/monitoring-common-shell-library/functions.sh*.

## Embedding

If you do not want to carry an extra file, just **concatenate** the contents of *functions.sh* to your monitoring plugin.

But note: it might be harder to maintain your plugin if you want to update the functions provided by this library.

## Replacing or Overriding Functions

You may override any of the functions provided by using the included **rename_func()**.

    rename_func show_help show_help_old
    rename_func show_help_new show_help

    show_help;      # now calls your new show_help() function
    show_help_old;	# allows to access to old show_help() function

# Functions List

See the function reference in `FUNCREF.md` that is automatically generated from *functions.sh*.

# Automated Testing

monitoring-common-shell-library has been equipped with an built-in test-suite that tries to lead the provided functions up the garden path. It has been made quiet easy to start the test procedure:

    cd tests/
    make

In case you like it more verbose, call the test-suite with *v=1*:

    make v=1

Even more curious folks may enable debugging by adding *d=1* (that also enables *verbose*):

    make d=1

# License

GNU Affero General Public License v3. See LICENSE file for more information.

# Author

(c) 2017 Andreas Unterkircher <unki@netshadow.net>
