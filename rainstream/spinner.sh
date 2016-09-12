#!/usr/bin/env bash

SPIN_DIR=~/spin/t
spinneret=$1

# This script stores a table at ~/.rain_spinnerets.md
if [ ! -f ~/.rain_spinnerets.md ]; then
	echo "No spinneret config table found, checking for template..."
	if [ ! -f $SPIN_DIR/rain_spinnerets.md ]; then
		echo "Error: no template" >&2
		exit 1
	fi
	echo "Template spinneret table found, copying to ~/.rain_spinnerets.md"
	cp $SPIN_DIR/rain_spinnerets.md ~/.rain_spinnerets.md
fi
SPIN_STATUS=$(grep "$spinneret" ~/.rain_spinnerets.md)

echo "$SPIN_STATUS"

if [ -z $spinneret ]; then
	echo "Please select an account" >&2
	exit 2
fi

spinneret_N=$(wc -l <<< "$SPIN_STATUS")

if [ "$spinneret_N" -gt 1 ]; then
       echo "Please select a single account" >&2
       exit 3
fi

if [ -z "$SPIN_STATUS" ]; then
	echo "Account '$spinneret' not registered in spinneret table"
	exit 4
fi

# If still running, script has a single account grepped from table

NEW_SPIN=$(cut -d\` -f 2 <<< "$SPIN_STATUS")

if [ "${SPIN_STATUS:3:1}" == 'x' ]; then
	# it is selected, no need to switch oauth
	echo "Using old oauth token"
	# proceed to use rainbowstream
elif [ "${SPIN_STATUS:3:1}" == ' ' ]; then
	# grep for x in file
	LAST_SPIN=$(grep '\[x\]' ~/.rain_spinnerets.md | cut -d\` -f 2)
	if [ -z "$LAST_SPIN" ]; then
		# must be freshly initialised, no previous selection, ignore and move on
		# Add the [x] mark to it this time (nothing to be removed)
		sed -i 's/\[ \] `'"$NEW_SPIN"'`/\[x\] `'"$NEW_SPIN"'`/'
	fi
	LAST_SPIN_N=$(wc -l <<< "$LAST_SPIN")
	if [ "$LAST_SPIN_N" -gt 1 ]; then
		echo "You messed up the table, go fix it" >&2
		exit 5
	fi
	if [ ! -d "$SPIN_DIR/$LAST_SPIN" ]; then
		echo "Folder $LAST_SPIN doesn't exist... You messed up the table and/or folders, go fix it" >&2
		exit 6
	fi

	# if x in file, then move the auth token to that folder
	if [ $NEW_SPIN != $LAST_SPIN ]; then
		# should not be able to happen [famous last words] because checked ${SPIN_STATUS:3:1} == "x" earlier
		# save the active oauth to file
		mv ~/.rainbow_oauth "$SPIN_DIR/$LAST_SPIN/"
		sed -i 's/\[x\] `'"$LAST_SPIN"'`/\[ \] `'"$LAST_SPIN"'`/'
	fi

	# now: move the right oauth file to home directory, then ready to roll
	if [ -f "$SPIN_DIR/$NEW_SPIN/.rainbow_oauth" ]; then
		# switch oauth from old [checked] to new [specified]
		cp "$SPIN_DIR/$NEW_SPIN/.rainbow_oauth" ~/.rainbow_oauth
		# copy it over regardless of if it was already there - better being sure, and the backup of old one already happened
	fi
fi

if [ ! -f "$SPIN_DIR/venv/bin/activate" ]; then
	cd "$SPIN_DIR"
	virtualenv -p /usr/bin/python3 venv
	source venv/bin/activate
	pip install rainbowstream
fi
# finally use rainbowstream...!

source "$SPIN_DIR/venv/bin/activate"
rainbowstream
