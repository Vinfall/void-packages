#!/bin/bash
#
# xlint.sh

EXITCODE=0
read base tip < /tmp/revisions

/bin/echo -e "\x1b[34mLinting commits...\x1b[0m"
common/scripts/lint-commits $base $tip || EXITCODE=$?

for t in $(awk '{ print "srcpkgs/" $0 "/template" }' /tmp/templates); do
	/bin/echo -e "\x1b[34mLinting $t...\x1b[0m"
	xlint "$t" > /tmp/xlint_out || EXITCODE=$?
	common/scripts/lint-version-change "$t" $base $tip > /tmp/vlint_out || EXITCODE=$?
	awk -f common/scripts/lint2annotations.awk /tmp/xlint_out /tmp/vlint_out
done
exit $EXITCODE
