# Makefile for check_icinga2.sh automated tests.

###############################################################################

# This file is part of the monitoring-common-shell-library.
#
# monitoring-common-shell-library, a library of shell functions used for
# monitoring plugins like used with (c) Nagios, (c) Icinga, etc.
#
# Copyright (C) 2017, Andreas Unterkircher <unki@netshadow.net>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

###############################################################################

.PHONY: all clean docs test
all:
	@echo "Possible make targets:"
	@echo
	@echo "make docs  --- generate function-reference by using the shell-docs-generator"
	@echo "make clean --- cleanup"
	@echo "make test  --- startup the automated testing suite."

docs: clean FUNCREF.md

%.md:
	shell-docs-gen.sh -i functions.sh -o $@

clean:
	@rm -f FUNCREF.md

test:
	$(MAKE) -C tests

check:
	shellcheck -s bash functions.sh
