#!/usr/bin/env bash

echo "Configuring Shell..."

if test ! $(which omf); then
    curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
    sudo echo /opt/homebrey/bin/fish | sudo tee -a /etc/shells
fi

echo "Changing Shells..."
sudo chsh -s /opt/homebrey/bin/fish
chsh -s /opt/homebrey/bin/fish