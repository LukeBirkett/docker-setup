docker run docker/whalesay cowsay Hello Python Users! 👋 🐍

docker build . -f ./examples/ex-1/Dockerfile -t rkrispin/vscode-python:ex1 

docker images

docker inspect rkrispin/vscode-python:ex1 | jq '.[] | .RootFS'

docker build . -f ./examples/ex-2/Dockerfile -t rkrispin/vscode-python:ex2 --progress=plain

docker run python:3.10 

docker run --interactive --tty python:3.10

set up .devcontainer folders and devcontainer.json

reopen in container