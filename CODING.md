# Developer information

## Coding Style

* All variables have to use upper-case alphabetic characters only (underscores are allowed too)
* All functino names have to use lower-case alphabetic characters only (underscores are allowed too)

* A tab indent are three (3) spaces.

```bash
if [ "${1}" == "x" ]; then
   echo "It was an X!"
fi
```

* Variables used only within a function have to be defined with `local`.

```bash
bla ()
{
   local FOO="BAR"
}
```

## Coding Rules

* use `shellcheck` to analyse and lint the code (eg. via `make check`).

* Functions that are only to be used library-internal, have to be prefixed by **\_csl_**

```bash
_csl_cleanup ()
{
}
```
