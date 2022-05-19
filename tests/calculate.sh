#!/bin/bash
set -euo pipefail

#enter the workflow's final output directory ($1)
cd $1

#find all bed, bedpe, and pdf files, return their md5sums to std out, list all file types
find . -name *.bed -xtype f -exec sh -c "cat {} | grep -v ^# | md5sum" \;
find . -name *.bedpe -xtype f -exec sh -c "cat {} | grep -v ^# |md5sum" \;
find . -name *.pdf -xtype f -exec sh -c "cat {} |md5sum" \;
ls | sed 's/.*\.//' | sort | uniq -c
