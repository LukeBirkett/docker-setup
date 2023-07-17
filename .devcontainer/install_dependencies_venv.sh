#!/bin/bash

VENV_NAME=$1
PYTHON_VER=$2

# Installing prerequisites
apt-get update && \
    apt-get install -y \
    python3-launchpadlib \
    vim \
    && apt update 

# Set environment
. /root/.bashrc \
    && python3 -m venv venv

echo "source /venv/bin/activate" >> ~/.bashrc

source /venv/bin/activate

# Install the Python packages
pip3 install -r requirements/requirements.txt