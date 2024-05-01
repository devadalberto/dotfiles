#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #

# pre-requisites and needed packages
sudo apt-get install -y autoconf automake pkg-config bash-completion bison
sudo apt install -y ncurses-*
cd ~/downloads
curl -LO https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
sudo tar -C ~/downloads -xzf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
./configure
make
make verify   # (optional)
sudo make install

# download and install tmux
mkdir -p ~/downloads/tmux && cd ~/downloads/tmux
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
sudo make install


} # this ensures the entire script is downloaded #
