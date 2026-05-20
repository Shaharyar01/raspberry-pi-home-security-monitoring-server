#!/bin/bash

echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y

echo "System update complete."