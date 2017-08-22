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
	@echo "Thank you for invoking the Makefile of the monitoring-ommon-shell-library.
	@echo
	@echo "The following make targets are available:"
	@echo
	@echo "make clean --- cleanup any residues that were left"
	@echo "make docs  --- generate the function-reference by using the shell-docs-generator"
	@echo "make test  --- startup the automated testing suite."
	@echo "make check --- perform syntax validation by Bash and shellcheck."

docs: clean FUNCREF.md

%.md:
	shell-docs-gen.sh -i functions.sh -o $@

clean:
	@rm -f FUNCREF.md

test:
	$(MAKE) -C tests

check:
	@echo ">>> Performing syntax validation..."
	bash -n functions.sh
	@echo ">>> Now analysing and linting..."
	shellcheck -s bash functions.sh
	@echo ">>> This looks like a success!"
