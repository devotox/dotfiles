#!/usr/bin/env bash

# Check for Homebrew, install if we don't have it or update if we do
if test ! $(which brew); then
    echo "Installing Homebrew..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    eval $(/opt/homebrew/bin/brew shellenv)
fi

echo "Updating Homebrew..."
brew update
brew upgrade

export HOMEBREW_NO_AUTO_UPDATE=1

echo "Installing Brew Packages from Bundle..."

if test ! -f "Brewfile"; then
    curl https://raw.githubusercontent.com/devotox/dotfiles/HEAD/Brewfile -o Brewfile
fi

if test -f "Brewfile"; then
    brew bundle
    return 0 2> /dev/null || exit 0
fi

echo "Installing Brew Packages..."
BREW=(
    ack
    adr-tools
    autoconf
    automake
    awscli
    aws-okta
    bash
    bpytop
    coreutils
    direnv
    docker
    elixir
    ffmpeg
    findutils
    fish
    fluxctl
    gettext
    gh
    gifsicle
    git
    gnu-indent
    gnu-sed
    gnu-tar
    gnu-which
    graphviz
    grep
    golang
    hub
    imagemagick
    jq
    kubectl
    libjpeg
    libmemcached
    lynx
    markdown
    mas
    memcached
    minikube
    neofetch
    openssl
    osx-cpu-temp
    pkg-config
    postgresql
    pyenv
    python3
    rbenv
    rename
    ruby
    rust
    starship
    ssh-copy-id
    terminal-notifier
    the_silver_searcher
    tfenv
    tmux
    trash
    tree
    warrensbox/tap/tfswitch
    watch
    watchman
    wget
    wireguard-tools
)
brew install ${BREW[@]} --force

echo "Installing Brew Cask Apps..."
CASKS=(
    1password
    alfred
    altair-graphql-client
    airserver
    android-file-transfer
    android-ndk
    android-sdk
    android-studio
    authy
    aws-vault
    bettertouchtool
    bitbar
    brave-browser
    dash
    docker
    dropbox
    expressvpn
    forklift
    flipper
    google-cloud-sdk
    google-drive
    github
    iterm2
    java
    kaleidoscope
    keka
    notion
    numi
    parallels
    postman
    resolutionator
    shift
    spectacle
    sublime-text
    teamviewer
    transmit
    tunnelblick
    unified-remote
    visual-studio-code
    virtualbox
    wine-stable
    xquartz
    zoomus
)
brew install ${CASKS[@]} --cask --force --no-quarantine

echo "Installing Fonts..."
FONTS=(
    font-roboto
    font-fira-code
    font-fira-mono
    font-clear-sans
    font-inconsolata
    font-hack-nerd-font
)
brew tap homebrew/cask-fonts
brew install ${FONTS[@]} --cask --force --no-quarantine

echo "Setup Sublime..."
sudo ln -sfn "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime

echo "Cleaning up..."
brew cleanup
brew config