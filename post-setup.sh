#!/usr/bin/env bash

# Install DisplayLink
# https://www.displaylink.com/downloads/macos

# Install PlayonMac
# https://www.playonmac.com/en/

# Install Wine

# Install Xtrafinder
# https://www.trankynam.com/xtrafinder/
# https://www.macworld.co.uk/how-to/mac/how-turn-off-mac-os-x-system-integrity-protection-rootless-3638975/
# Turn of mac
# Cmd + R as you turn on
# Utilites > Terminal
# csrutil disable
# Reboot
# Install & setup Xtrafinder
# Repeat above procedure but with enable now
# csrutil enable [--without fs] (only needed if just enable does not work)

# Run only after setting up Dropbox

echo "Copy Config..."
cp -Rfv ~/Dropbox/Apps/Config/Home/. ~/
cp -Rfv ~/Dropbox/Apps/Config/VSCode/settings.json ~/Library/Application\ Support/Code/User/

echo "Finalize Brew Paths..."
addpaths /usr/local/lib/ruby/gems/2.7.0/bin

echo "Setup SSH..."
# cp -Rfv ~/Dropbox/Apps/Config/Mac/SSH Keys ~/.ssh/
chmod u=rw,go= ~/.ssh/*
ssh-add ~/.ssh/id_rsa

echo "Fix Applications"
sudo chown -R $(whoami):staff /Applications/*

echo "GIT Download"
mkdir -pv ~/Documents/Wathe
mkdir -pv ~/Documents/Shares
mkdir -pv ~/Documents/Devonte
mkdir -pv ~/Documents/DTOX-Consulting

cd ~/Documents/Wathe
curl https://api.github.com/users/wathe/repos?per_page=200 \
    -H "Authorization: token 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" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

cd ~/Documents/Shares
curl https://api.github.com/orgs/sh4res/repos?per_page=200 \
    -H "Authorization: token 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" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

cd ~/Documents/Devonte
curl https://api.github.com/users/devotox/repos?per_page=200 \
    -H "Authorization: token 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" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

cd ~/Documents/DTOX-Consulting
curl https://api.github.com/orgs/dtox-consulting/repos?per_page=200 \
    -H "Authorization: token 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" \
    | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git clone #{repo["ssh_url"]} ]}'

ls -lha ~/Documents/*