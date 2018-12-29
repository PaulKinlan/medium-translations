#! /bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=../key.json
langs=( "ja" "ko" "zh" )

for language in "${langs[@]}"
do
  echo "Starting translation for $language"
  echo "Starting translation for $language"
  git checkout -b "$language-$1"
  node index.js -s $1 -t "$language" \;
  git commit -m "Addding $language translation for $1"
  git checkout master
  git push origin "$language-$1"
done