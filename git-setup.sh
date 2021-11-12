#!/usr/bin/env bash

GH_TOKEN=""

echo "Setup Git..."
git config --global alias.new '!git init && git symbolic-ref HEAD refs/heads/main'
git config --global user.email "devo.tox.89@gmail.com"
git config --global mergetool.keepBackup false
git config --global init.defaultBranch main
git config --global core.ignorecase false
git config --global user.name "Devonte"
git config --global pull.rebase false

echo "Downloading Personal Git Repos..."
mkdir -pv ~/Documents/Devonte && cd ~/Documents/Devonte
curl https://api.github.com/users/devotox/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

mkdir -pv ~/Documents/DTOX-Consulting && cd ~/Documents/DTOX-Consulting
curl https://api.github.com/orgs/dtox-consulting/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

echo "Downloading Work Git Reopos..."
mkdir -pv ~/Documents/Wathe && cd ~/Documents/Wathe
curl https://api.github.com/orgs/Wathe-Technology/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

mkdir -pv ~/Documents/Shares && cd ~/Documents/Shares
curl https://api.github.com/orgs/sh4res/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

mkdir -pv ~/Documents/Cabiri && cd ~/Documents/Cabiri
curl https://api.github.com/orgs/Boohoo-com/repos?per_page=200 \
    -H "Authorization: token ${GH_TOKEN}" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

echo "Cache GitHub credentials..."
gh auth login