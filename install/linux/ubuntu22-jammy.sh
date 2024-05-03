#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #
# apt update
sudo apt-get update -y

# basic stuff
sudo apt-get install -y gcc \
	make \
	universal-ctags \
	exuberant-ctags \
	cmake \
	perl \
	nmap \
    ca-certificates \
    git \
	lsb-release \
	telnet

# python3.12 for the OS
sudo apt-get install python3.12 python3.12-full python3.12-dev python3.12-venv -y

# some more tools and libs
sudo apt install -y build-essential \
	zlib1g-dev \
	libncurses5-dev \
	libgdbm-dev \
	libnss3-dev \
	libssl-dev \
	libreadline-dev \
	libffi-dev \
	libsqlite3-dev \
	libbz2-dev \
	llvm \
	libncursesw5-dev \
	xz-utils \
	tk-dev \
	liblzma-dev \
	dnsutils \
	neofetch

# a starting bashrc file
mv ~/.bashrc{,.bak}
curl -sSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/bashrc -o ~/.bashrc
source ~/.bashrc

echo "testing ended, make sure to break out of this prompt with CTRL+C"
sleep 4d 4h
echo "try period ended, adding time to break out of this window"
sleep 4d 4h
echo "try period ended, adding time to break out of this window"

# Nerdfonts
curl -sSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash

# NVM - NodeJS Version Manager
curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash



# go (golang)
mkdir -p $HOME/downloads
cd ${HOME}/downloads/
GO_VER='1.22.2'
GO_INSTALLER=go${GO_VER}.linux-amd64.tar.gz
GO_FILE_URL=https://go.dev/dl/${GO_INSTALLER}
curl -sSL ${GO_FILE_URL} > ${GO_INSTALLER}
sudo tar -zxvf ${GO_INSTALLER} -C /usr/local/

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


# reload your bashrc
source ~/.bashrc

# install Node
nvm install --lts
nvm install-latest-npm

# install nerdfonts
getnf -i UbuntuMono

# pyenv
curl https://pyenv.run | bash
# pyenv install --list | grep 3.12
# below install command takes a while, be patient
pyenv install 3.12.2
# set the python version as global
pyenv global 3.12.2

# docker
# uninstall any current install
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo install -m 0755 -d /etc/apt/keyrings

#download the installer files
mkdir -p ~/downloads
curl -fsSL https://download.docker.com/linux/ubuntu/gpg > ~/downloads/docker.asc
sudo cp ~/downloads/docker.asc /etc/apt/keyrings/docker.asc 
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# create docker group
sudo groupadd docker

# Add your user to the docker group
sudo usermod -aG docker $USER

# terraform
sudo apt-get install -y gpg unzip software-properties-common gnupg2 lsb-release
cd ~/downloads
# wget -O-
curl -LO  https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt-get -y update
sudo apt-get install terraform

# tmux
# libevent (pre-req)
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

clear

RU=$(basename $(eval echo "~$pwd"))

} # this ensures the entire script is downloaded #