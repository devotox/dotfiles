# Bootstrap script for setting up a new OSX machine

 This should be idempotent so it can be run multiple times.

 Some apps don't have a cask and so still need to be installed by hand. These
 include:

 Notes:

 - If installing full Xcode, it's better to install that first from the app
   store before running the bootstrap script. Otherwise, Homebrew can't access
   the Xcode libraries as the agreement hasn't been accepted yet.

 Reading:

 - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
 - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
 - https://news.ycombinator.com/item?id=8402079
 - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

  To Run

 ```
 mkdir -p tmp \
 	&& cd tmp \
 	&& curl -L -O https://github.com/devotox/dotfiles/archive/main.zip \
 	&& unzip main.zip \
 	&& rm -rf main.zip \
 	&& cd dotfiles-main \
 	&& chmod +x *.sh \
 	&& bash setup.sh
```