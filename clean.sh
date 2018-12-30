#! /bin/bash

git branch | grep -v "master" | grep -v ^* | xargs git branch -D
