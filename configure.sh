#!/bin/bash

# Activate lock service

sudo cp ~/.config/qtile/i3lock.service /etc/systemd/system/i3lock.service


# Configure Neovim

# Install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

## Inside vim -> :PackerSync

sudo apt install xclip

rsync -a dot-config/ .config/
