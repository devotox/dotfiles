#!/usr/bin/env bash

echo "Setup Git..."
git config --global alias.new '!git init && git symbolic-ref HEAD refs/heads/main'
git config --global user.email "devo.tox.89@gmail.com"
git config --global mergetool.keepBackup false
git config --global init.defaultBranch main
git config --global core.ignorecase false
git config --global user.name "Devonte"
git config --global pull.rebase false

echo "Creating Git Directories..."
mkdir -pv ~/Documents/Wathe
mkdir -pv ~/Documents/Shares
mkdir -pv ~/Documents/Cabiri
mkdir -pv ~/Documents/Devonte
mkdir -pv ~/Documents/DTOX-Consulting

echo "Downloading Git Repos..."
cd ~/Documents/Wathe
curl https://api.github.com/users/wathe/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

cd ~/Documents/Shares
curl https://api.github.com/orgs/sh4res/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

cd ~/Documents/Cabiri
curl https://api.github.com/orgs/Boohoo-com/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

cd ~/Documents/Devonte
curl https://api.github.com/users/devotox/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

cd ~/Documents/DTOX-Consulting
curl https://api.github.com/orgs/dtox-consulting/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'