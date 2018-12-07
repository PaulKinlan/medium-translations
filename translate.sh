#! /bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=../key.json

node index.js -s $1 -t hi,fr,es,ja,de,vi,ru,id  \;

