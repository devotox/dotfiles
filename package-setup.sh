#!/usr/bin/env bash

echo "Installing App Store Packages..."
APP_STORE_PACKAGES=(
    937984704 # Amphetamine
    1176895641 # Spark
    497799835 # XCode
)
mas install ${APP_STORE_PACKAGES[@]}

echo "Installing Python Packages..."
PYTHON_PACKAGES=(
    ipython
    virtualenv
    psutil
    virtualenvwrapper
)

python3 -m ensurepip
python3 -m pip install --upgrade pip
python3 -m pip install ${PYTHON_PACKAGES[@]}

echo "Installing Ruby Gems..."
RUBY_GEMS=(
    bundler
    cocoapods
    colorls
    filewatcher
    json
)
sudo gem install ${RUBY_GEMS[@]}

mkdir -p ~/.config/colorls
source $(dirname $(sudo gem which colorls))/tab_complete.sh
cp $(dirname $(sudo gem which colorls))/yaml/dark_colors.yaml ~/.config/colorls/dark_colors.yaml

echo "Installing Volta..."
curl https://get.volta.sh | bash

echo "Installing NPM Packages..."
NPM_PACKAGES=(
    firebase-tools
    git-cz
    ngrok
    node@12
    node@14
    node@16
    npm-check-updates
    release-it
    yarn
)
volta install ${NPM_PACKAGES[@]}