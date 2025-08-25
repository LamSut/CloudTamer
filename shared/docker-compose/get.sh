#!/bin/bash
set -e

# Clone the repository if not already cloned
echo "Checking if the repository is already cloned..."
if [[ ! -d "containerize-full-stack-app-MERN-with-docker-compose" ]]; then
    git clone https://github.com/LamSut/PizzaGout.git repo
    echo "Repository cloned successfully."
else
    echo "Repository already cloned."
fi
