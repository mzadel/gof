#!/bin/bash

#
# checkinonefile.sh
#

FILENAME=$1
export GIT_DIR=$FILENAME.gitrepo

# if repo doesn't exist, create it
if [[ ! -e $GIT_DIR ]] ; then git init ; fi

# create the blob, tree, checkin object





# vim:sw=4:et:ai:ic
