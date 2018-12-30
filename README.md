Automatic translation
=====================


Install
-------

1. Run `sh install.sh` to install the `hub` command.
2. Run `npm i` to install dependencies.


Running
=======

Getting a post from medium.
---------------------------

Run `sh get-medium-post.sh [URL] [OUTPUT FILE]`. This will run `mediumexporter` to get the
file from medium and save it locally. It will create a branch, and then a PR to be reivewed
on github so that someone can check the import worked correctly.