#!/bin/bash

# Detect the current operating system
unamestr=$(uname)
os=""

if [[ "$unamestr" == "Linux" ]]; then
  os="linux"
elif [[ "$unamestr" == "Darwin" ]]; then
  os="macos"
elif [[ "$unamestr" == "FreeBSD" || "$unamestr" == "OpenBSD" ]]; then
  os="bsd"
elif [[ "$unamestr" == "MINGW" || "$unamestr" == "MSYS" || "$unamestr" == "CYGWIN" ]]; then
  os="windows"
else
  echo "Unsupported operating system: $unamestr"
  exit 1
fi

# Step 1: Create the directory structure
mkdir docker-extension
cd docker-extension

# Step 2: Create the manifest.json file
cat << EOF > manifest.json
{
  "manifest_version": 3,
  "name": "Docker Extension",
  "version": "1.0",
  "description": "Installs Docker on your system.",
  "background": {
    "service_worker": "background.js"
  },
  "permissions": [
    "scripting"
  ]
}
EOF

# Step 3: Create the background.js file
cat << EOF > background.js
// Listen for installation completion
browser.runtime.onInstalled.addListener(() => {
  // Run the Docker installation script
  browser.scripting.executeScript({
    target: { tabId: -1 },
    files: ["docker-installation-script.sh"]
  });
});
EOF

# Step 4: Create the docker-installation-script.sh file
# Add the content of your Docker installation script here

# Step 5: Zip the directory to create the extension package
zip -r docker-extension.zip *

# Step 6: Install the extension in the respective browsers

if [[ "$os" == "linux" ]]; then
  # Linux
  firefox --install-extension docker-extension.zip
elif [[ "$os" == "macos" ]]; then
  # macOS
  open docker-extension.zip
elif [[ "$os" == "bsd" ]]; then
  # BSD
  echo "Unsupported operating system: BSD"
  exit 1
elif [[ "$os" == "windows" ]]; then
  # Windows
  powershell.exe -ExecutionPolicy Bypass -Command "& {Add-AppxPackage -Path $(Resolve-Path -Path 'docker-extension.zip')}"
fi

