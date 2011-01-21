
# gof

Mark Zadel, 2009

## Description

`gof` ("git one file") is a small bit of bash shell code that allows RCS-style
single-file version control through git.  It's oriented mostly toward quick,
in-place versioning of a file you've already started, without requiring you to
move the file into a new directory or do any other acrobatics.

## Installation

Put `gofci` somewhere in your path.

Include the following functions in your .bashrc:

    function goflog { GIT_DIR="$1".git git log ; }
    function gofcat { GIT_DIR="$1".git git show master:"$1" ; }
    function gofdiff { GIT_DIR="$1".git git diff master:"$1" "$1"; }

## Usage

    gofci <thefile> [commit message]

Check in the file.  You can supply an optional commit message (which may be in
quotes if you want).  The first time `gofci` is run, it creates a repository
for your file and then commits the file.  (The default commit message is just
"commit".)  So I usually just use it as

    gofci myfile.txt

which creates `myfile.txt.git` the first time you run it.


    goflog <thefile>

will show the commit log for the file.

    gofcat <thefile>

will dump the most recent version of the file to stdout.

    gofdiff <thefile>

will diff the current working version of the file with the most recent version
from the repo.

## Remarks

The repository is a regular bare git repo, so you can do whatever other gitty
stuff you want to it.  If you want to get the file in its own directory or add
other files or whatever, just clone the repo.

If you want to cat out a specific version of `file.txt`, you can do this:

	(cd file.txt.git ; git show abd12c:file.txt) > destfile.txt

