#! /bin/bash

# To run: ./get-medium-post.sh [url] [title.markdown]

timestamp="$(date +%s)"

echo "Exporting $1 to markdown"
git checkout -b "new-medium-post-$timestamp"

npx mediumexporter $1 > ./docs/$2

git add .
git commit -m "Addding a new medium post as markdown from $1"
$hub pull-request -p -m "Addding a new medium post as markdown frmo $1" -l 'New Original Post'
git checkout master