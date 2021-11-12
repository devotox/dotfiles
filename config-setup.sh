#!/usr/bin/env bash

echo "Copy Config..."
cp -Rf ~/Dropbox/Apps/Config/Home/. ~/
cp -Rf ~/Dropbox/Apps/Config/VSCode/settings.json ~/Library/Application\ Support/Code/User/

echo "Finalize Brew Paths..."
source ~/.config/fish/config.fish
addpaths /opt/homebrew/bin
addpaths /usr/local/lib/ruby/gems/2.7.0/bin

echo "Setup SSH..."
# cp -Rfv ~/Dropbox/Apps/Config/Mac/SSH Keys ~/.ssh/
chmod u=rw,go= ~/.ssh/*
ssh-add ~/.ssh/id_rsa

echo "Fix Bash Globs"
bash -c "shopt -s nullglob dotglob globstar"