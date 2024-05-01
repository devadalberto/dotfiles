#!/usr/bin/env bash
{ # this ensures the entire script is downloaded #
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

} # this ensures the entire script is downloaded #