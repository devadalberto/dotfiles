#!/usr/bin/env bash
{ # this ensures the entire script is downloaded #
########
# script variables / constants
read -s -p "Enter Password for sudo: " sudoPW
OSVER="$(lsb_release -rs)"
DISTRO="$(lsb_release --id --short)"
LDISTRO="$(echo ${DISTRO} | tr '[:upper:]' '[:lower:]')"
########
# apt update
echo $sudoPW | apt-get update -y
sleep 25s
# basic stuff
echo $sudoPW | apt-get install -y gcc \
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

# python for the OS
case $OSVER in
  24.04)
  echo $sudoPW | apt-get install python3.12 python3.12-full python3.12-dev python3.12-venv python3-poetry -y
  ;;
  22.04)
  echo $sudoPW | apt-get install python3.11 python3.11-full python3.11-dev python3.11-venv python3-poetry -y
  ;;
  *)
  echo "This script is not compatible with: ${LDISTRO} ${OSVER}"
  ;;
esac



# some more tools and libs
echo $sudoPW | apt install -y build-essential \
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
	ncurses-* \
	ripgrep \
	vim-nox


# Nerdfonts
curl -o- https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash

# NVM - NodeJS Version Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

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
mkdir -p ${HOME}/downloads
cd ${HOME}/downloads/
GO_VER='1.22.2'
GO_INSTALLER=go${GO_VER}.linux-amd64.tar.gz
GO_FILE_URL=https://go.dev/dl/${GO_INSTALLER}
curl -sSL ${GO_FILE_URL} > ${GO_INSTALLER}
echo $sudoPW | tar -zxvf ${GO_INSTALLER} -C /usr/local/


# neovim
mkdir -p ${HOME}/downloads/neovim && cd ${HOME}/downloads/neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
echo $sudoPW | rm -rf /opt/nvim
echo $sudoPW | tar -C /opt -xzf nvim-linux64.tar.gz


# lazyvim
mv ${XDG_CONFIG_HOME}/nvim ${XDG_CONFIG_HOME}/nvim.bak

# optional but recommended
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak

git clone https://github.com/LazyVim/starter ${XDG_CONFIG_HOME}/nvim

# remove the .git folder, so you can add it to your own repo later
rm -rf ${XDG_CONFIG_HOME}/nvim/.git

# pyenv
curl -o- https://pyenv.run | bash

# oh my bash
# rm -rf ${HOME}/.oh-my-bash/
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

sleep 3s
# bashrc file
mv ${HOME}/.bashrc ${HOME}/bashrc.bak
mv ${HOME}/.bash_profile ${HOME}/.bash_profile.bak
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/bashrc > ${HOME}/.bashrc
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/bash_profile > ${HOME}/.bash_profile
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/tmuxconf > ${HOME}/.tmux.conf
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/inputrc > ${HOME}/.inputrc
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/config/files/alacritty.toml > ${XDG_CONFIG_HOME}/alacritty.toml
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/config/files/starship.toml > ${XDG_CONFIG_HOME}/starship.toml

# Symbolic links - 
# FUTURE: Configure this repo to run after the repo is cloned
# ln -s ./.amethyst.yml "$HOME"/.amethyst.yml
# ln -sf "$PWD/alacritty.toml" "$XDG_CONFIG_HOME"/alacritty/alacritty.toml
# ln -sf "$PWD/k9s/skin.yml" "$XDG_CONFIG_HOME"/k9s/skin.yml
# ln -sf "$PWD/.bash_profile" "$HOME"/.bash_profile
# ln -sf "$PWD/.bashrc" "$HOME"/.bashrc
# ln -sf "$PWD/.inputrc" "$HOME"/.inputrc
# ln -sf "$PWD/.tmux.conf" "$HOME"/.tmux.conf
# ln -sf "$PWD/nvim" "$XDG_CONFIG_HOME"/nvim
# ln -sf "$PWD/skhdrc" "$XDG_CONFIG_HOME"/skhd/skhdrc

# hashicorp / tf
cd ${HOME}/downloads/
curl -fsSL https://apt.releases.hashicorp.com/gpg | echo $sudoPW | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | echo $sudoPW | tee /etc/apt/sources.list.d/hashicorp.list

####################################################333
# Kubernetes - k8s
KSYMVER=$(curl -L -s https://dl.k8s.io/release/stable.txt) # v1.30.0
KVER=$(echo ${KSYMVER} | cut -f1-2 -d\.)  # v1.30 -> for curl/web downloads
echo "installing for k8s SymVer: ${KSYMVER}"
echo "installing for k8s MajorVer: ${KVER}"

mkdir -p /usr/share/keyrings

cd ${HOME}/downloads
curl -fsSL https://pkgs.k8s.io/core:/stable:/${KVER}/deb/Release.key | echo $sudoPW | gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg
# allow unprivileged APT programs to read this keyring
echo $sudoPW | chmod 644 /usr/share/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KVER}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo $sudoPW | apt-get update -y
echo $sudoPW | apt-get install -y terraform kubectl

# Install Kubelogin
# sudo su -
# mkdir -p root/downloads && cd root/downloads
cd ${HOME}/downloads
KLBASE=https://github.com/Azure/kubelogin/releases/download
KLVERSION=v0.1.3
KLFILE=kubelogin-linux-amd64.zip
KUBELOGIN_URL=${KLBASE}/${KLVERSION}/${KLFILE}
curl -LO ${KUBELOGIN_URL}
unzip ${KLFILE}
# accept whatever this throws
echo $sudoPW | rm -rf /usr/local/bin/kubelogin
echo $sudoPW | mv bin/linux_amd64/kubelogin /usr/local/bin/
echo $sudoPW | chmod +x /usr/local/bin/kubelogin

# download and install tmux
mkdir -p ${HOME}/downloads/tmux && cd ${HOME}/downloads/tmux
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
echo $sudoPW | make install
clear


echo "================ Reloading RC file =================="

# reload your bashrc
# echo "source ${HOME}/.bashrc" | bash
eval "$(cat ~/.bashrc | tail -n +10)"
sleep 5s

# lazygit - you need to have go(lang) installed
cd ${HOME}/downloads
git clone https://github.com/jesseduffield/lazygit.git
cd lazygit
go install

# install Node
clear
echo "================ installing node with NVM ...======================"
nvm install --lts
nvm install-latest-npm

echo "================ finished node installer ...======================"
sleep 3s

# install nerdfonts
getnf -i UbuntuMono
sleep 3s

# pyenv install --list | grep 3.12
# below install command takes a while, be patient
echo ":::::::::::::::::::::::::::: below install command takes a while, be patient ::::::::::::::::::::::::::::"
pyenv install 3.12.2
# set the python version as global
pyenv global 3.12.2
sleep 3s

# tmux
# libevent (pre-req)
# sudo apt-get install -y autoconf automake pkg-config bash-completion bison
# sudo apt install -y ncurses-*
cd ${HOME}/downloads
curl -LO https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
echo $sudoPW | tar -C ${HOME}/downloads -xzf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
./configure
make
make verify   # (optional)
echo $sudoPW | make install

## dotnet installation
cd ${HOME}/downloads
curl -LO https://packages.microsoft.com/config/${LDISTRO}/${OSVER}/packages-microsoft-prod.deb
echo $sudoPW | dpkg -i packages-microsoft-prod.deb
# rm packages-microsoft-prod.deb

echo $sudoPW | apt-get update
echo "================ installing dotnet sdk and aspnetcore-runtime 7 & 8 ...======================"
echo $sudoPW | apt-get install -y dotnet-sdk-7.0
echo $sudoPW | apt-get install -y aspnetcore-runtime-7.0
echo $sudoPW | apt-get install -y dotnet-sdk-8.0
echo $sudoPW | apt-get install -y aspnetcore-runtime-8.0
echo "================ DONE! installing dotnet sdk and aspnetcore-runtime 7 & 8 ...======================"
sleep 3s
echo "================ installing starship ...======================"
curl -sS https://starship.rs/install.sh | sh
mkdir -p ${HOME}/.config
mv ${HOME}/.config/starship.toml ${HOME}/.config/starship.toml.bak
touch ${HOME}/.config/starship.toml
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/starship.toml > ${HOME}/.config/starship.toml
echo "================ DONE! installing starship ...======================"

# # Not tested yet
# # docker
# # uninstall any current install
# for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# sudo install -m 0755 -d /etc/apt/keyrings

# #download the installer files
# mkdir -p ${HOME}/downloads
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg > ${HOME}/downloads/docker.asc
# sudo cp ${HOME}/downloads/docker.asc /etc/apt/keyrings/docker.asc 
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

# some housekeeping
rm -rf ${HOME}/downloads/*

# reload your bashrc
eval "$(cat ~/.bashrc | tail -n +10)"

# apt update
echo $sudoPW | apt-get update -y

# reload your bashrc one last time
eval "$(cat ~/.bashrc | tail -n +10)"
echo "========================================================================================================="
echo "script finished, close all your terminal windows and relaunch your terminal"
echo "========================================================================================================="
} # this ensures the entire script is downloaded #