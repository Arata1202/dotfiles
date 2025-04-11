## Getting Started

### Install on macOS

```bash

# Move to the home directory
cd ~

# Clone repository
git clone git@github.com:Arata1202/dotfiles.git
cd dotfiles

# Install
make chmod
make all

```

### About Makefile

```bash

# Grant execute permission to all shell scripts in the .bin directory
make chmod

# Run the full setup
make all

# Create symbolic links from dotfiles to the home directory and VSCode config path
make link

# Install dependencies listed in .Brewfile via Homebrew
make brew

# Install zsh via Homebrew and set it as the default shell
make zsh

# Update the .Brewfile based on currently installed Homebrew packages
make update

```
