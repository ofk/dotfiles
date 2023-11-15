# dotfiles

There are my configuration files.

## How to use

```bash
$ git clone git@github.com:ofk/dotfiles.git ~/.dotfiles
$ ~/.dotfiles/setup deps
$ ~/.dotfiles/setup
```

### Prepare

1. [Generate SSH key](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/connecting-to-github-with-ssh) and [add to your Github account](https://github.com/settings/keys)
   - `ssh-keygen -t ed25519 -C $(whoami)@$(hostname)`
1. Install git
   - Use apt
     1. `sudo apt install -y git`
   - Use Homebrew
     1. Install [Homebrew](http://brew.sh/)
     1. `brew install git`
