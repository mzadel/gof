#!/bin/bash

#
# gitonefile_commit.sh
#

#
# basic steps to create the commit:
#  BLOBHASH=$(git hash-object -w "$FILENAME")
#  TREEHASH=$(echo -e "100644 blob $BLOBHASH\t$FILENAME" | git mktree)
#  COMMITHASH=$(echo commitmsg | git commit-tree $TREEHASH -p master)
#  git update-ref refs/heads/master $COMMITHASH
#


FILENAME="$1"
if [[ -z $FILENAME ]] ; then echo please supply filename ; exit ; fi
export GIT_DIR="$FILENAME.git"

# bail if file doesn't exist
if [[ ! -e $FILENAME ]] ; then echo file $FILENAME does not exist ; exit ; fi

# if repo doesn't exist, create it
if [[ ! -e $GIT_DIR ]] ; then
    echo creating "$GIT_DIR"
    git init -q --bare
    INITIALCOMMIT=1
fi

# bail if the file's the same
if [[ ! $INITIALCOMMIT ]] ; then
    PREVFILEHASH=$( git ls-tree master "$FILENAME" | awk '{print $3}' )
    if [[ $(wc -c < "$FILENAME") -eq $(git cat-file -s $PREVFILEHASH) && $(git hash-object --stdin < "$FILENAME") == $PREVFILEHASH ]] ; then
        echo "$FILENAME identical to most recent version; exiting."
        exit
    fi
fi

# create the blob and tree
BLOBHASH=$(git hash-object -w "$FILENAME")
TREEHASH=$(echo -e "100644 blob $BLOBHASH\t$FILENAME" | git mktree)

# use subsequent args as commit message if present
if [[ $2 ]] ; then
    shift
    COMMITMSG="$*"
else
    COMMITMSG=commit
fi

# create the checkin object
# give it a parent if this isn't the first commit
if [[ $INITIALCOMMIT ]] ; then
    COMMITHASH=$(echo "$COMMITMSG" | git commit-tree $TREEHASH)
else
    COMMITHASH=$(echo "$COMMITMSG" | git commit-tree $TREEHASH -p master)
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
