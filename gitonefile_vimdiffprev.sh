#!/bin/bash

#
# gitonefile_vimdiffprev.sh
#

TEMPFILENAME=/var/tmp/gitonefile_vimdiffprev.temp

FILENAME="$1"
if [[ -z $FILENAME ]] ; then echo please supply filename ; exit ; fi
export GIT_DIR="$FILENAME.git"

# if repo doesn't exist, bail
if [[ ! -e $GIT_DIR ]] ; then
    echo "$GIT_DIR" does not exist.  exiting.
    exit
fi

git show master:"$FILENAME" > $TEMPFILENAME
vimdiff "$FILENAME" $TEMPFILENAME
rm $TEMPFILENAME

# vim:sw=4:et:ai:ic
