Following Rami Krispin's Python x VSCode x Docker guide
[[Repo Link](https://github.com/RamiKrispin/vscode-python)]

# Setting Up a Python Environment with Dev Containers
First install the `Dev Containers` extension in VSCode and Set up a `.devcontainer` folder with the following structure
```
.devcontainer
├── Dockerfile
├── devcontainer.env
├── devcontainer.json
├── install_dependencies.sh
└── requirements.txt
```

It is good practice to set up some environment variables be used in the scripts
`~/.zshrc`
```
# Setting env variables for VScode
export ENV_NAME=python_tutorial
export PYTHON_VER=3.10
export CSV_PATH=$HOME/Desktop/CSV
export MY_VAR=some_var
```

## Dockerfile
- Rami recommends using a bash helper script (`install_dependencies.sh`) to keep the actual Dockerfile as concisde as possible. In this example, the script handles installs the base dependancies, sets up a virtual environment and imports the requirements.txt.
- This Dockerfile uses the offical python image which is useful as saves time and comes with most dependancies, though we dont have to use this.
- We are picking up the env variables we set above and passing them to the bash script
- A requirements folder is set up in the root of container to hold dependancy stuff

`.devcontainer/Dockerfile`
```
FROM python:3.10

# Arguments
ARG PYTHON_VER
ARG ENV_NAME

# Environment variables
ENV ENV_NAME=$ENV_NAME
ENV PYTHON_VER=$PYTHON_VER

# Copy files
RUN mkdir requirements
COPY requirements.txt requirements/
COPY install_dependencies.sh requirements/

# Install dependencies
RUN bash requirements/install_dependencies.sh $ENV_NAME $PYTHON_VER
```

## Install Dependancies and Setting Virtual Environment
- The tutorial Rami installs Conda for their package management but I would prefer to use `venv` for this so I adapted the script, though I have hardcoded the env name meaning the passing in of arguments in the Dockerfile is no longer necessary.

`.devcontainer/install_dependencies.sh`
```
#!/bin/bash

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
```

## Setting Reqs
`.devcontainer/requirements.txt`
```
wheel==0.40.0
pandas==2.0.3
plotly==5.15.0
plotly-express==0.4.1
```

## Setting devcontainer.json 
- The `devcontainer.json` holds the container build settings.
- This can be split into two sections: image settings (docker build) and project settings (extensions and commands)
- It contains enviroment variables throughout
- The build is set by the `dockerfile`, `args`, and `context`
- `settings` labels the default python location within the container
- `vscode` outlines the extensions
- `mount` gives us the ability to link another folder outside of the current folder to be accessed within the container
- `remoteEnv` is a way of grabbing any enviroment variables we have set on our local system and importing them into the container
- `runArgs` + `---env-file` is an alternative way of setting env variable into the container. In this example it would read from `devcontainer.env` which we have set up in the folder structure
- `postCreateCommand` triggers a script we have created

`.devcontainer/devcontainer.json`
```
{
    "name": "${localEnv:ENV_NAME}",
    "build": {
        "dockerfile": "Dockerfile",
        "args": {"ENV_NAME": "${localEnv:ENV_NAME}",
                 "PYTHON_VER": "${localEnv:PYTHON_VER}"}, 
        "context": "."
    },
    "customizations": {
        "settings": {
            "python.defaultInterpreterPath": "/venv/bin/python"
        },
        "vscode": {
            "extensions": [
                "quarto.quarto",
                "ms-azuretools.vscode-docker",
                "ms-python.python",
                "ms-vscode-remote.remote-containers",
                "yzhang.markdown-all-in-one",
                "redhat.vscode-yaml",
                "ms-toolsai.jupyter"
            ]
        }
    },

    "mounts": [
            "source=${localEnv:CSV_PATH},target=/home/csv,type=bind,consistency=cache"
    ],
    "remoteEnv": {
        "MY_VAR": "${localEnv:MY_VAR}"
    },
    "runArgs": ["--env-file",".devcontainer/devcontainer.env"],
    "postCreateCommand": "python3 tests/test1.py"
}
```

## Executable script
```
tests/test1.py

import pandas as pd
import plotly as py
import plotly.express as px

print("Hello World!")
```
