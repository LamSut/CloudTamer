#!/bin/bash
set -e

echo "Checking if the repository is already cloned..."
if [[ ! -d "repo" ]]; then
    git clone https://github.com/LamSut/PizzaGout.git repo
    echo "Repository cloned successfully."
else
    echo "Repository already cloned. Pulling latest changes..."
    cd repo
    git pull
    cd ..
fi