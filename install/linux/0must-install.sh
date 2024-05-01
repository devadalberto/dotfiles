#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #
# basic stuff
sudo apt-get install -y gcc \
	make \
	universal-ctags \
	exuberant-ctags \
	cmake \
	perl \
	nmap \
    curl \
    ca-certificates \
    git \
	telnet

# some more stuff
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

# Nerdfonts
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash

# NVM - NodeJS Version Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# python3.12 for the OS
sudo apt-get install python3.12 python3.12-full python3.12-dev python3.12-venv -y

# go (golang) - go.dev
mkdir -p $HOME/downloads
cd ${HOME}/downloads/
GO_VER='1.22.2'
GO_INSTALLER=go${GO_VER}.linux-amd64.tar.gz
GO_FILE_URL=https://go.dev/dl/${GO_INSTALLER}
curl -sSL ${GO_FILE_URL} > ${GO_INSTALLER}
sudo tar -zxvf ${GO_INSTALLER} -C /usr/local/


# reload your bashrc
source ~/.bashrc

# install Node
nvm install --lts
nvm install-latest-npm

# install nerdfonts
getnf -i UbuntuMono

} # this ensures the entire script is downloaded #