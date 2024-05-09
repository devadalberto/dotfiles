#!/usr/bin/env bash
{ # this ensures the entire script is downloaded #

read -p "Enter Password for sudo: " sudoPW

#region variables / constants

#endregion variables / constants

#region functions
function do_housekeeping() {
	sudo apt autoremove -y; sudo apt autoclean -y; sudo apt autopurge -y; sudo chown -R $USER $HOME/downloads; rm -rf ${HOME}/downloads/*
}

#end region functions

clear

# uninstall any docker traces
echo $sudoPW | sudo su -; for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# podman
echo "================ installing podman ======================"
echo $sudoPW | sudo su -; sudo apt-get install -y podman podman-docker podman-toolbox
echo "================ DONE! installing podman ...======================"

# reload your bashrc
eval "$(cat ~/.bashrc | tail -n +10)"

# apt update
echo $sudoPW | sudo su -; sudo apt-get update -y

# reload your bashrc
eval "$(cat ~/.bashrc | tail -n +10)"

# apt update
echo $sudoPW | sudo su -; sudo apt-get update -y

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
echo "podman"
echo "+++++++++++++++++++++++++++++++++++++"
echo "========================================================================================================="
} # this ensures the entire script is downloaded #
