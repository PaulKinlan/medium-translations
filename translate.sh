#! /usr/bin/bash
export GOOGLE_APPLICATION_CREDENTIALS=../key.json

node translate.js -s $1 -t hi,fr,es,ja,de,vi,ru,id  \;

