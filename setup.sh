#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine
#
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

# Run without downloading:
# curl https://raw.githubusercontent.com/devotox/dotfiles/HEAD/setup.sh | bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Devonte's Customizations                                                       #
###############################################################################

echo "Hello $(whoami)! Let's get you set up."

echo "Starting bootstrapping"
set -euo pipefail
shopt -s nullglob dotglob globstar

echo "Setting up Bash Profile"
touch ~/.zshrc
touch ~/.inputrc
touch ~/.bash_profile

echo export EDITOR=nano > ~/.bash_profile
echo export VISUAL=nano >> ~/.bash_profile
echo export PATH="/usr/local/opt/ruby/bin:$PATH" >> ~/.bash_profile

echo "set completion-ignore-case On" >> ~/.inputrc
source ~/.bash_profile
cat ~/.bash_profile

echo "Setup Sudoers"
echo -e "\n${USER} ALL=(ALL) NOPASSWD: ALL" | sudo EDITOR="tee -a" visudo

echo "Fix Applications"
sudo chown -R $(whoami):staff /Applications/*

echo "Setup XCode..."
xcode-select -p
xcode-select --install
sudo xcode-select --reset
sudo xcodebuild -license accept

# Check for Homebrew, install if we don't have it or update if we do
if test ! $(which brew); then
    echo "Installing Homebrew..."
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "Updating Homebrew..."
    brew update
fi

export HOMEBREW_NO_AUTO_UPDATE=1

echo "Installing Brew Packages from Bundle..."
curl https://raw.githubusercontent.com/devotox/dotfiles/HEAD/Brewfile -o Brewfile
brew bundle

echo "Installing Brew Packages..."
BREW=(
    ack
    adr-tools
    autoconf
    automake
    awscli
    aws-okta
    bash
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
    osx-cpu-temp
    pkg-config
    postgresql
    pyenv
    python
    python3
    pypy
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
brew cask install ${FONTS[@]} --force --no-quarantine

echo "Installing App Store Packages..."
APP_STORE_PACKAGES=(
    937984704 # Amphetamine
    441258766 # Magnet
    497799835 # XCode
    1176895641 # Spark
)
mas install ${APP_STORE_PACKAGES[@]}

echo "Installing Python Packages..."
PYTHON_PACKAGES=(
    ipython
    virtualenv
    psutil
    virtualenvwrapper
)
sudo easy_install pip
sudo pip install ${PYTHON_PACKAGES[@]}
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
    artillery
    ember-cli
    ember-cli-update
    fastify-cli
    firebase-tools
    git-cz
    hotel
    netlify-cli
    ngrok
    node@12
    node@14
    node@16
    npm-check
    npm-check-updates
    pm2
    release-it
    serverless
    spaceship-prompt
    vercel
    yarn
)
volta install ${NPM_PACKAGES[@]}

echo "Setup Sublime..."
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/sublime

echo "Setup Git..."
git config --global alias.new '!git init && git symbolic-ref HEAD refs/heads/main'
git config --global user.email "devo.tox.89@gmail.com"
git config --global mergetool.keepBackup false
git config --global init.defaultBranch main
git config --global core.ignorecase false
git config --global user.name "Devonte"
git config --global pull.rebase false

echo "Setup Bpytop"
git clone https://github.com/aristocratos/bpytop.git
cd bpytop && sudo make install
cd .. && rm -rf bpytop

echo "Configuring Shell..."
curl -L https://get.oh-my.fish | fish
sudo echo /usr/local/bin/fish | sudo tee -a /etc/shells

echo "Configuring OSX..."
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable the crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 1

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 12
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable rearrange
defaults write com.apple.dock tilesize -int 48 
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock showhidden -bool yes
defaults write com.apple.dock single-app -bool false
defaults write com.apple.dock mineffect -string suck
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock autohide-delay -float 0.5
defaults write com.apple.dock position-immutable -bool yes
defaults write com.apple.dock autohide-time-modifier -float 0.5
defaults write com.apple.dock mouse-over-hilite-stack -bool yes

# Add empty space tiles to dock
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'

# Ask for password after screensaver
defaults write com.apple.lock askForPassword -int 1
defaults write com.apple.screensaver askForPassword -int 1

# Enable tap-to-click
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Disable DS_Store
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Show Hidden Files
defaults write com.apple.finder QuitMenuItem -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Visualize CPU usage in the Activity Monitor Dock icon
# defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
# defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Disallow the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool false

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

echo "Cleaning up..."
killall -KILL Finder
killall -KILL Dock
brew cleanup
brew config

echo "Bootstrapping complete!"

echo "Changing Shells..."
sudo chsh -s /usr/local/bin/fish
chsh -s /usr/local/bin/fish
