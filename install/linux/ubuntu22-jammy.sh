#!/usr/bin/env bash
{ # this ensures the entire script is downloaded #
# apt update
sudo apt-get update -y

# basic stuff
sudo apt-get install -y gcc \
	g++ \
	make \
	universal-ctags \
	exuberant-ctags \
	cmake \
	perl \
	nmap \
    ca-certificates \
    git \
	lsb-release \
	software-properties-common \
	autoconf \
	automake \
	pkg-config \
	bash-completion \
	bison \
	telnet

# python3.11 for the OS
sudo apt-get install python3.11 python3.11-full python3.11-dev python3.11-venv -y

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
	neofetch \
	rust-all \
	unzip \
	ripgrep \
	cargo 


# Nerdfonts
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash

# create directories
export XDG_CONFIG_HOME=${HOME}/.config
cd ${XDG_CONFIG_HOME}
mkdir -p ${XDG_CONFIG_HOME}/bash
mkdir -p ${XDG_CONFIG_HOME}/alacritty
mkdir -p ${XDG_CONFIG_HOME}/alacritty/themes
mkdir -p ${XDG_CONFIG_HOME}/k9s
# mkdir -p "$XDG_CONFIG_HOME"/skhd
# mkdir -p "$XDG_CONFIG_HOME"/wezterm

git clone https://github.com/alacritty/alacritty-theme ${XDG_CONFIG_HOME}/alacritty/themes

# go (golang)
mkdir -p ~/downloads
cd ~/downloads/
GO_VER='1.22.2'
GO_INSTALLER=go${GO_VER}.linux-amd64.tar.gz
GO_FILE_URL=https://go.dev/dl/${GO_INSTALLER}
curl -sSL ${GO_FILE_URL} > ${GO_INSTALLER}
sudo tar -zxvf ${GO_INSTALLER} -C /usr/local/

# NVM - NodeJS Version Manager
curl -sSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

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

# pyenv
curl https://pyenv.run | bash

# oh my bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

# bashrc file
mv ~/.bashrc{,.bak}
mv ~/.bash_profile{,.bak}
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/bashrc > ${HOME}/.bashrc
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/bash_profile > ${HOME}/.bash_profile
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/tmuxconf > ${HOME}/.tmux.conf
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/inputrc > ${HOME}/.inputrc
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/config/files/alacritty.toml > ${XDG_CONFIG_HOME}/alacritty.toml
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/config/files/starship.toml > ${XDG_CONFIG_HOME}/starship.toml

# Symbolic links
# ln -s ./.amethyst.yml "$HOME"/.amethyst.yml
# ln -sf "$PWD/alacritty.toml" "$XDG_CONFIG_HOME"/alacritty/alacritty.toml
# ln -sf "$PWD/k9s/skin.yml" "$XDG_CONFIG_HOME"/k9s/skin.yml
# ln -sf "$PWD/.bash_profile" "$HOME"/.bash_profile
# ln -sf "$PWD/.bashrc" "$HOME"/.bashrc
# ln -sf "$PWD/.inputrc" "$HOME"/.inputrc
# ln -sf "$PWD/.tmux.conf" "$HOME"/.tmux.conf
# ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME"/nvim
# ln -sf "$PWD/skhdrc" "$XDG_CONFIG_HOME"/skhd/skhdrc

# reload your bashrc
bash -c "$(source ~/.bashrc)"

echo "================ SLEEPING ================================="
sleep 15s

echo "================ WAKING UP ...======================"
sleep 10s

# create some folders
# mkdir -p ${SCRIPTS}
# mkdir -p ${DOTNET_ROOT}

# lazygit - you need to have go installed
cd ~/downloads

git clone https://github.com/jesseduffield/lazygit.git
cd lazygit
go install



# install Node
nvm install --lts
nvm install-latest-npm

# install nerdfonts
getnf -i UbuntuMono

# pyenv install --list | grep 3.12
# below install command takes a while, be patient
pyenv install 3.12.2
# set the python version as global
pyenv global 3.12.2

# terraform
cd ~/downloads
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

## dotnet installation
OSVER="$(lsb_release -rs)"
LDISTRO="$(lsb_release --id --short)"
curl -LO https://packages.microsoft.com/config/${LDISTRO}/${OSVER}/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get update
sudo apt-get install -y dotnet-sdk-7.0
sudo apt-get install -y aspnetcore-runtime-7.0

sudo apt-get install -y dotnet-sdk-8.0
sudo apt-get install -y aspnetcore-runtime-8.0



curl -sS https://starship.rs/install.sh | sh

mkdir -p ${HOME}/.config
mv ${HOME}/.config/starship.toml{,.bak}
touch ${HOME}/.config/starship.toml
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/starship.toml >> ${HOME}/.config/starship.toml


# sudo su -
mkdir -p root/downloads && cd root/downloads
KLBASE=https://github.com/Azure/kubelogin/releases/download
KLVERSION=v0.1.0
KLFILE=kubelogin-linux-amd64.zip
KUBELOGIN_URL=${KLBASE}/${KLVERSION}/${KLFILE}
curl -LO ${KUBELOGIN_URL}
sudo unzip ${KLFILE}
# accept whatever this throws
rm -rf /usr/local/bin/
mv bin/linux_amd64/kubelogin /usr/local/bin/
chmod +x /usr/local/bin/kubelogin

# download and install tmux
mkdir -p ~/downloads/tmux && cd ~/downloads/tmux
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
sudo make install
clear

# # Not tested yet
# # docker
# # uninstall any current install
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# sudo install -m 0755 -d /etc/apt/keyrings

# #download the installer files
# mkdir -p ~/downloads
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg > ~/downloads/docker.asc
# sudo cp ~/downloads/docker.asc /etc/apt/keyrings/docker.asc 
# sudo chmod a+r /etc/apt/keyrings/docker.asc

# # Add the repository to Apt sources:
# echo \
#   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
#   $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
#   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update

# # install docker
# sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# # create docker group
# sudo groupadd docker

# # Add your user to the docker group
# sudo usermod -aG docker $USER

# # RU=$(basename $(eval echo "~$pwd"))

} # this ensures the entire script is downloaded #