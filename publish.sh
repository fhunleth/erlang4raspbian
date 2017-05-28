#!/bin/sh

# This script assumes that a .s3cmd has been made with the access key

if [ ! -d repo/conf ]; then
	echo "Run from the directory with the root index.html"
	exit 1
fi

# Uncomment to do a dry run
#DRYRUN=--dry-run

s3cmd sync $DRYRUN -P -r -v --reduced-redundancy --delete-removed \
    --no-mime-magic --guess-mime-type \
    repo/ s3://apt.troodon-software.com/

