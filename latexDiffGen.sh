#!/bin/bash

# LaTeX Diff Gen for Git: generate PDFs of LaTeX papers stored in Git
# where differences between commits are highlighted

#   Copyright 2012 Matt Conway

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# I use this to store my papers in Git, and when I show a revised version to my
# professor, I have a note (either in .latexdiffgen or just reconstructed from git log)
# of what she saw last, so I can generate a custom PDF with the additions and removals.

# Usage: latexDiffGen.sh input.tex output.tex [from-object] [to-object]
# If to-object is omitted, the current HEAD is used (not the current working
# file!)
# If from-object is omitted, we try to find it in .latexdiffgen, or throw an
# error

INPUT=$1
OUTPUT=$2

# http://stackoverflow.com/questions/1291941
if [ $# -ge 3 ]; then
    FROM=$3

else
    if [ -e .latexdiffgen ]; then
        FROM=`cat .latexdiffgen`
    else
        echo .latexdiffgen not found, please specify a from commit manually
        exit 1
    fi
fi

if [ $# -eq 4 ]; then
    TO=$4
else
    TO="HEAD"
fi

# Normalize the diff stats to hashes
# http://stackoverflow.com/questions/424071
FROM=`git show --format=format:"%H" --name-only $FROM | head -n 1`
TO=`git show --format=format:"%H" --name-only $TO | head -n 1`

echo Generating diff from $FROM to $TO, using file $INPUT and writing to $OUTPUT.

# Allocate temp files
OLDFILE=`mktemp`
NEWFILE=`mktemp`

# store the relevant files
# http://stackoverflow.com/questions/888414
git show ${FROM}:${INPUT} > ${OLDFILE}
git show ${TO}:${INPUT} > ${NEWFILE}

# generate the diff
latexdiff $OLDFILE $NEWFILE > $OUTPUT

# clean up
rm $OLDFILE
rm $NEWFILE

# store the to, so it can be automatically used as the base for the next from
echo $TO > .latexdiffgen