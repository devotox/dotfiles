#!/usr/bin/env bash

echo "Set Bash Globs..."
bash -c "shopt -s nullglob dotglob globstar"

echo "Copy Config..."
cp -Rf ~/Dropbox/Apps/Config/Home/. ~/
cp -Rf ~/Dropbox/Apps/Config/VSCode/settings.json ~/Library/Application\ Support/Code/User/
cp -Rf ~/Dropbox/Apps/Config/Postico/* ~/Library/Containers/at.eggerapps.Postico/Data/Library/Application\ Support/Postico/

echo "Setup SSH..."
cp -Rf ~/Dropbox/Apps/Config/Mac/SSH Keys ~/.ssh/
chmod u=rw,go= ~/.ssh/*
ssh-add ~/.ssh/id_rsa