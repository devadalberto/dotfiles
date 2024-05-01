#!/usr/bin/env bash

{ # this ensures the entire script is downloaded #
# pyenv
curl https://pyenv.run | bash
pyenv install --list | grep 3.12
# below install command takes a while, be patient
pyenv install 3.12.2
# set the python version as global
pyenv global 3.12.2
} # this ensures the entire script is downloaded #