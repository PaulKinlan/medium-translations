#! /bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=../key.json

node index.js -s $1 -t ko,ja,zh  \;