#! /usr/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS=../key.json
find content -iname "2018-10-2**[^.]??.markdown" |
while read filename
do 
  node translate.js -s $filename -t hi,fr,es,ja,de,vi,ru,id  \;
done

