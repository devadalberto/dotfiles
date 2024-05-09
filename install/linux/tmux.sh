#!/usr/bin/env bash
{ # this ensures the entire script is downloaded #

read -p "Enter Password for sudo: " sudoPW

#region variables / constants
USRLIB="/usr/lib"
#endregion variables / constants

#region functions
function do_housekeeping() {
	sudo apt autoremove -y; sudo apt autoclean -y; sudo apt autopurge -y; sudo chown -R $USER $HOME/downloads; rm -rf ${HOME}/downloads/*
}

#end region functions

clear

# tmux pre-req
echo "================ Installing tmux pre-req: libevent-2.1.12  ...======================"
sleep 2s
echo $sudoPW | sudo su -;
cd ${HOME}/downloads
curl -LO https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
echo $sudoPW | sudo su -;
sudo tar -C ${USRLIB} -xzf libevent-2.1.12-stable.tar.gz
cd ${USRLIB}/libevent-2.1.12-stable
./configure && make
sudo make install

# download and install tmux
mkdir -p ${HOME}/downloads/tmux && cd ${HOME}/downloads/tmux
git clone https://github.com/tmux/tmux.git
cd tmux
echo $sudoPW | sudo su -;
sh autogen.sh
./configure && make
sudo make install

# reload your bashrc
eval "$(cat ~/.bashrc | tail -n +10)";

# apt update
echo $sudoPW | sudo su -; sudo apt-get update -y;

# some housekeeping
do_housekeeping

echo "========================================================================================================="
echo "script finished, close all your terminal windows and relaunch your terminal"
echo ""
echo "if you want to get rid of the temporal files in case the cleanup didn't work run:"
echo ""
echo "sudo apt autoremove -y; sudo apt autoclean -y; sudo chown -R $USER $HOME/downloads; rm -rf ${HOME}/downloads/*"
echo ""
echo "+++++++++++++++++++++++++++++++++++++"
echo "tmux"
echo "+++++++++++++++++++++++++++++++++++++"
echo "========================================================================================================="
} # this ensures the entire script is downloaded #
