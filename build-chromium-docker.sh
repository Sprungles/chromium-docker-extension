#!/bin/bash

# Function to install Docker on Linux
install_docker_linux() {
    # Check if Docker is already installed
    if command -v docker &> /dev/null; then
        echo "Docker is already installed."
        return
    fi

    # Install Docker dependencies
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
    rm get-docker.sh
    echo "Docker installed successfully."
}

# Function to install Docker on macOS
install_docker_macos() {
    # Check if Docker is already installed
    if command -v docker &> /dev/null; then
        echo "Docker is already installed."
        return
    fi

    # Install Homebrew if not installed
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    # Install Docker dependencies
    brew install --cask docker

    # Start Docker
    open /Applications/Docker.app
    echo "Docker installed successfully."
}

# Function to install Docker on Windows
install_docker_windows() {
    # Check if Docker is already installed
    if command -v docker &> /dev/null; then
        echo "Docker is already installed."
        return
    fi

    # Install Chocolatey if not installed
    if ! command -v choco &> /dev/null; then
        powershell.exe -ExecutionPolicy Bypass -NoLogo -NonInteractive -NoProfile -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
        refreshenv
    fi

    # Install Docker Desktop
    choco install docker-desktop -y

    # Start Docker Desktop
    echo "Please start Docker Desktop manually."
    echo "Once Docker Desktop is running, press Enter to continue."
    read -r
    echo "Docker installed successfully."
}

# Function to install Docker on BSD
install_docker_bsd() {
    # Check if Docker is already installed
    if command -v docker &> /dev/null; then
        echo "Docker is already installed."
        return
    fi

    # Install Docker dependencies
    pkg install -y curl

    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    echo "Docker installed successfully."
}

# Check the operating system
os=$(uname -s)

if [[ "$os" == "Linux" ]]; then
    echo "Detected Linux operating system."
    install_docker_linux
elif [[ "$os" == "Darwin" ]]; then
    echo "Detected macOS operating system."
    install_docker_macos
elif [[ "$os" == "Windows" ]]; then
    echo "Detected Windows operating system."
    install_docker_windows
elif [[ "$os" == "FreeBSD" ]] || [[ "$os" == "OpenBSD" ]]; then
    echo "Detected BSD operating system."
    install_docker_bsd
else
    echo "Unsupported operating system: $os"
    exit 1
fi

# Run the Chromium Docker extension
docker run -it --rm -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY chromium-docker

