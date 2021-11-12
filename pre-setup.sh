#!/usr/bin/env bash

USER=$(whoami)
echo "Hello ${USER}! Let's get you set up."
echo

echo "Starting bootstrapping"
set -euo pipefail
shopt -s nullglob dotglob

echo "Setting up Bash Profile"
touch ~/.zshrc
touch ~/.inputrc
touch ~/.zprofile
touch ~/.bash_profile

echo export EDITOR=nano > ~/.bash_profile
echo export VISUAL=nano >> ~/.bash_profile
echo export PATH="/usr/local/opt/ruby/bin:$PATH" >> ~/.bash_profile

echo export EDITOR=nano > ~/.zprofile
echo export VISUAL=nano >> ~/.zprofile
echo export PATH="/usr/local/opt/ruby/bin:$PATH" >> ~/.zprofile

echo "set completion-ignore-case On" >> ~/.inputrc
source ~/.bash_profile
cat ~/.bash_profile

echo "Setup Sudoers"
SUDOERS_LINE="${USER}      ALL=(ALL) NOPASSWD: ALL"
sudo grep -qxF "${SUDOERS_LINE}" /etc/sudoers || echo -e "\n${SUDOERS_LINE}" | sudo tee -a /etc/sudoers > /dev/null
sudo cat /etc/sudoers | grep ${USER}

echo "Setup XCode..."

if test ! $(which xcodebuild); then
    xcode-select --install
fi

xcode-select -p
sudo xcode-select --reset
sudo xcodebuild -license accept

echo "Setup Rosetta..."
sudo softwareupdate --install-rosetta --agree-to-license