#!/bin/bash

#
# checkinonefile.sh
#

FILENAME=$1
export GIT_DIR=$FILENAME.gitrepo

# if repo doesn't exist, create it
if [[ ! -e $GIT_DIR ]] ; then git init --bare ; INITIALCOMMIT=1 ; fi

# FIXME bail if the file's the same

# create the blob and tree
BLOBHASH=$(git hash-object -w "$FILENAME")
TREEHASH=$(echo -e "100644 blob $BLOBHASH\t$FILENAME" | git mktree)

# create the checkin object
# give it a parent if this isn't the first commit
if [[ $INITIALCOMMIT ]] ; then
    COMMITHASH=$(echo my commit | git commit-tree $TREEHASH)
else
    COMMITHASH=$(echo my commit | git commit-tree $TREEHASH -p master)
fi

# update master branch
git update-ref refs/heads/master $COMMITHASH



# consider setting these env variables
#GIT_AUTHOR_NAME
#GIT_AUTHOR_EMAIL
#GIT_AUTHOR_DATE
#GIT_COMMITTER_NAME
#GIT_COMMITTER_EMAIL
#GIT_COMMITTER_DATE


# other strategy is to create a temp non-existent index file with
# GIT_INDEX_FILE or equivalent option, then
# git update-index --add --cacheinfo 100644 83baae61804e65cc73a7201a7252750c76066a30 test.txt
# then git write-tree ; then git commit-tree



# vim:sw=4:et:ai:ic
