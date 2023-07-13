# Following Rami Krispin's Python x VSCode x Docker guide

[Link to Rami's Repo](https://github.com/RamiKrispin/vscode-python)

🚧 ***WIP: bullet pointed notes waiting to be formed into something coherent***

### Intro docker run
`docker run docker/whalesay cowsay Hello Python Users! 👋 🐍`

### Build an image from a Dockerfile and name (tag) it
`docker build . -f ./examples/ex-1/Dockerfile -t rkrispin/vscode-python:ex1`

### View your docker images
`docker images`

### Inspect the images metadata and use jq to extract the layers (the things that the docker image builds)
`docker inspect rkrispin/vscode-python:ex1 | jq '.[] | .RootFS'`

### Use progress=plain to get a more detailed build output
`docker build . -f ./examples/ex-2/Dockerfile -t rkrispin/vscode-python:ex2 --progress=plain`

### Run python in docker (doesn't do anything)
`docker run python:3.10`

### Run a dockerized python session which is interactive (does something)
`docker run --interactive --tty python:3.10`

### Setting up the folders and files needed to run containers in VSCode
`set up .devcontainer folders and devcontainer.json`

### The option needed to run the container in VSCode
`reopen in container`
