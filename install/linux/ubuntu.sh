#!/usr/bin/env bash
{ # this ensures the entire script is downloaded #
########
read -p "Enter Password for sudo: " sudoPW

#region variables / constants
OSVER="$(lsb_release -rs)"
DISTRO="$(lsb_release --id --short)"
LDISTRO="$(echo ${DISTRO} | tr '[:upper:]' '[:lower:]')"
DREL="$(lsb_release -cs)"
# KRPATH="/etc/apt/keyrings"
KRPATH="/usr/share/keyrings"
USRLIB="/usr/lib"
#endregion variables / constants

#region functions
function do_housekeeping() {
	echo $sudoPW | sudo su -; rm -rf ${HOME}/downloads/*;
	echo $sudoPW | sudo su -; apt autoremove -y;
	echo $sudoPW | sudo su -; apt autoclean -y;
}

function install_docker() {
	read -p "Do you wish to install docker desktop? (y/n)" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		break
	elif [[ $REPLY =~ ^[Nn]$ ]]; then
		echo $sudoPW | sudo su -; do_housekeeping ; exit
	else
		echo "Please answer yes or no."; install_docker();
	fi
}
#end region functions

# apt update
echo $sudoPW | sudo apt-get update -y

# basic stuff
echo $sudoPW | sudo apt-get install -y gcc \
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
  echo $sudoPW | sudo apt-get install python3.12 python3.12-full python3.12-dev python3.12-venv python3-poetry -y
  ;;
  22.04)
  echo $sudoPW | sudo apt-get install python3.11 python3.11-full python3.11-dev python3.11-venv python3-poetry -y
  ;;
  *)
  echo "This script is not compatible with: ${LDISTRO} ${OSVER}, skipping python install..."; break
  ;;
esac

# some more tools and libs
echo $sudoPW | sudo apt install -y build-essential \
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

git clone https://github.com/alacritty/alacritty-theme ${XDG_CONFIG_HOME}/alacritty/themes

# go (golang)
echo $sudoPW | sudo su -;
mkdir -p ${HOME}/downloads
cd ${HOME}/downloads/
GO_VER='1.22.2'
GO_INSTALLER=go${GO_VER}.linux-amd64.tar.gz
GO_FILE_URL=https://go.dev/dl/${GO_INSTALLER}
curl -sSL ${GO_FILE_URL} > ${GO_INSTALLER}
sudo tar -zxvf ${GO_INSTALLER} -C /usr/local/

# neovim
sudo su -;
mkdir -p ${HOME}/downloads/neovim && cd ${HOME}/downloads/neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo su -; rm -rf /opt/nvim
sudo su -; sudo tar -C /opt -xzf nvim-linux64.tar.gz

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
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

sleep 2s
# bashrc file
mv ${HOME}/.bashrc ${HOME}/bashrc.bak
mv ${HOME}/.bash_profile ${HOME}/.bash_profile.bak
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/bashrc > ${HOME}/.bashrc
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/bash_profile > ${HOME}/.bash_profile
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/tmuxconf > ${HOME}/.tmux.conf
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/inputrc > ${HOME}/.inputrc
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/config/files/alacritty.toml > ${XDG_CONFIG_HOME}/alacritty.toml
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/config/files/starship.toml > ${XDG_CONFIG_HOME}/starship.toml

# hashicorp / tf
echo $sudoPW | sudo su -;
cd ${HOME}/downloads/
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Kubernetes - k8s
KSYMVER=$(curl -L -s https://dl.k8s.io/release/stable.txt)
KVER=$(echo ${KSYMVER} | cut -f1-2 -d\.)
echo "installing for k8s SymVer: ${KSYMVER}"
echo "installing for k8s MajorVer: ${KVER}"

echo $sudoPW | sudo su -;
sudo mkdir -p /usr/share/keyrings && cd /usr/share/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/${KVER}/deb/Release.key | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-apt-keyring.gpg
# allow unprivileged APT programs to read this keyring
sudo chmod 644 /usr/share/keyrings/kubernetes-apt-keyring.gpg
echo $sudoPW | sudo su -;
echo "deb [signed-by=/usr/share/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${KVER}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

echo $sudoPW | sudo su -; sudo apt-get update -y;

case $OSVER in
  24.04)
  echo $sudoPW | sudo su -; sudo apt-get install -y terraform; cd ${HOME}/downloads; curl -LO "https://dl.k8s.io/release/${KSYMVER}/bin/linux/amd64/kubectl"; sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  ;;
  22.04)
  echo $sudoPW | sudo su -; sudo apt-get install -y terraform kubectl
  ;;
  *)
  echo "This script is not compatible with: ${LDISTRO} - ${OSVER}"
  echo "Make sure to check ksite to install on your System"
  echo "skipping k8s and terraform installs..."; break
  ;;
esac

# Install Kubelogin
# mkdir -p root/downloads && cd root/downloads
echo $sudoPW | sudo su -;
cd ${HOME}/downloads
KLBASE=https://github.com/Azure/kubelogin/releases/download
KLVERSION=v0.1.3
KLFILE=kubelogin-linux-amd64.zip
KUBELOGIN_URL=${KLBASE}/${KLVERSION}/${KLFILE}
curl -LO ${KUBELOGIN_URL}
echo $sudoPW | sudo su -;
sudo unzip ${KLFILE}
# accept whatever this throws
sudo rm -f /usr/local/bin/kubelogin
sudo mv bin/linux_amd64/kubelogin /usr/local/bin/
sudo chmod +x /usr/local/bin/kubelogin

# download and install tmux
mkdir -p ${HOME}/downloads/tmux && cd ${HOME}/downloads/tmux
git clone https://github.com/tmux/tmux.git
cd tmux
echo $sudoPW | sudo su -;
sh autogen.sh
./configure && make
sudo make install
clear

# reload your bashrc
echo "================ Reloading RC file =================="
sleep 2s
eval "$(cat ~/.bashrc | tail -n +10 )"


# lazygit - you need to have go(lang) installed
echo "================ Installing lazygit =================="
sleep 2s
cd ${HOME}/downloads
git clone https://github.com/jesseduffield/lazygit.git
cd lazygit
go install

# install Node
echo "================ installing node with NVM ...======================"
sleep 2s
nvm install --lts
nvm install-latest-npm


# install nerdfonts
echo "================ Installing UbuntuMono NerdFont ...======================"
sleep 2s
getnf -i UbuntuMono

echo "================ Installing pyenv Python  ...======================"
echo ":::::::::::::::::::::::::::: below install command takes a while, be patient ::::::::::::::::::::::::::::"
sleep 2s
pyenv install 3.12.2
# set the python version as global
pyenv global 3.12.2

# tmux pre-req
echo "================ Installing tmux pre-req: libevent-2.1.12  ...======================"
sleep 2s
echo $sudoPW | sudo su -;
cd ${HOME}/downloads
curl -fsSL https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz
echo $sudoPW | sudo su -;
sudo tar -C ${USRLIB} -xzf libevent-2.1.12-stable.tar.gz
cd libevent-2.1.12-stable
./configure
make
echo $sudoPW | sudo su -;
make verify   # (optional)
echo $sudoPW | sudo su -;
sudo make install

## dotnet installation
echo "================ installing dotnet sdk and aspnetcore-runtime 8 ...======================"
sleep 2s
echo $sudoPW | sudo su -;
cd ${HOME}/downloads
curl -LO https://packages.microsoft.com/config/${LDISTRO}/${OSVER}/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

echo $sudoPW | sudo su -; sudo apt-get update

echo $sudoPW | sudo su -; sudo apt-get install -y dotnet-sdk-8.0 aspnetcore-runtime-8.0
echo "================ DONE! installing dotnet sdk and aspnetcore-runtime 8 ...======================"
echo

echo "================ installing starship ...======================"
sleep 2s
mkdir -p ${HOME}/.config
curl -sS https://starship.rs/install.sh | sh -s -- -y
mv ${HOME}/.config/starship.toml ${HOME}/.config/starship.toml.bak
curl -fsSL https://raw.githubusercontent.com/devadalberto/dotfiles/main/dotfiles/starship.toml > ${HOME}/.config/starship.toml
echo "================ DONE! installing starship ...======================"

# docker
install_docker()

# uninstall any current install
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

#download the installer files
cd ${HOME}/downloads
echo $sudoPW | sudo su -; sudo install -m 0755 -d ${KRPATH}
echo $sudoPW | sudo su -; sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg; echo "$(cat gpg)" | sudo gpg --armor -o ${KRPATH}/docker.asc
echo $sudoPW | sudo su -; sudo chmod a+r ${KRPATH}/docker.asc

# Add the repository to Apt sources:
echo $sudoPW | sudo su -; echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=${KRPATH}/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
echo $sudoPW | sudo su -; sudo apt-get update

# install docker
echo $sudoPW | sudo su -; sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# create docker group
echo $sudoPW | sudo su -; sudo groupadd docker

# Add your user to the docker group
echo $sudoPW | sudo su -; sudo usermod -aG docker $USER

# reload your bashrc
echo $sudoPW | sudo su -; eval "$(cat ~/.bashrc | tail -n +10)";

# apt update
echo $sudoPW | sudo su -; apt-get update -y;

# some housekeeping
echo $sudoPW | sudo su -; do_housekeeping

echo "========================================================================================================="
echo "script finished, close all your terminal windows and relaunch your terminal"
echo ""
echo "if you want to get rid of the temporal files in case the cleanup didn't work run:"
echo ""
echo "sudo apt autoremove -y; sudo apt autoclean -y; rm -rf ${HOME}/downloads/*"
echo ""
echo "Cheers!"
echo "========================================================================================================="
} # this ensures the entire script is downloaded #
