#! /bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=../key.json
langs=( ja,ko,zh )

for lang in "${langs[@]}"
do
  echo 'Starting translation for $lang'
  node index.js -s $1 -t $lang \;
done