#! /bin/bash

export GOOGLE_APPLICATION_CREDENTIALS=../key.json
langs=( "ja" "ko" "zh" )
hub="binaries/linux-64/hub-linux-amd64-2.7.0/bin/hub"

for language in "${langs[@]}"
do
  echo "Starting translation for $language"
  git checkout -b "$language-$1"
  node index.js -s $1 -t "$language" \;
  git add .
  git commit -m "Addding $language translation for $1"
  git push origin "$language-$1"
  $hub pull-request -m "Addding $language translation for $1"
  git checkout master
done