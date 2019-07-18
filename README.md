# .dotfiles

## About

There are my configuration files.

## How to use

```bash
$ git clone git@github.com:ofk/dotfiles.git ~/.dotfiles
$ ~/.dotfiles/setup
```

### Prepare on Linux

1. Install git, emacs and recently bash

   `sudo apt install -y git emacs bash bash-completion`

1. Install [Cask](https://github.com/cask/cask)

### Prepare on Mac

1. Install Command Line Tools for Xcode

   `xcode-select --install`

1. Install [Homebrew](http://brew.sh/)

1. Install git, emacs and recently bash

   `brew install git emacs cask bash bash-completion`

1. Install other applications

   `brew install nodebrew pyenv pyenv-virtualenv rbenv ruby-build`

   `nodebrew install-binary lts-version && nodebrew use lts-version && npm update -g npm`

   `brew install yarn --ignore-dependencies`

   `brew cask install alfred cmd-eikana docker keepingyouawake safari-technology-preview google-chrome google-chrome-canary firefox firefox-developer-edition`
