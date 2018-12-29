#! /bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=../key.json
langs=( ja,ko,zh )

for lang in "${langs[@]}"
do
  echo 'Starting translation for $lang'
  git checkout -b "$lang-$1"
  node index.js -s $1 -t "$lang" \;
  git commit -m 'Addding $lang translation for $1'
  git checkout master
  git push origin "$lang-$1"
done