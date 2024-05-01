#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #
# neovim
mkdir -p ~/downloads/neovim && cd ~/downloads/neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz


# lazyvim
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim

# remove the .git folder, so you can add it to your own repo later
rm -rf ~/.config/nvim/.git

# lazygit - you need to have go installed
cd ~/downloads
git clone https://github.com/jesseduffield/lazygit.git
cd lazygit
go install

source ~/.bashrc
} # this ensures the entire script is downloaded #