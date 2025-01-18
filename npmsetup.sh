#!/bin/bash

# Define color codes
INFO='\033[0;36m'  # Cyan
BANNER='\033[0;35m' # Magenta
YELLOW='\033[0;33m' # Yellow
RED='\033[0;31m'    # Red
GREEN='\033[0;32m'  # Green
BLUE='\033[0;34m'   # Blue
NC='\033[0m'        # No Color

# Display social details and channel information in large letters manually
echo "========================================"
echo -e "${YELLOW} Script is made by CRYPTONODEHINDI${NC}"
echo -e "-------------------------------------"

echo -e ""
echo -e ""
echo -e '\e[34m'
echo " ██████╗██████╗ ██╗   ██╗██████╗ ████████╗ ██████╗     ███╗   ██╗ ██████╗ ██████╗ ███████╗    ██╗  ██╗██╗███╗   ██╗██████╗ ██╗"
echo "██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██╔═══██╗    ████╗  ██║██╔═══██╗██╔══██╗██╔════╝    ██║  ██║██║████╗  ██║██╔══██╗██║"
echo "██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║    ██╔██╗ ██║██║   ██║██║  ██║█████╗      ███████║██║██╔██╗ ██║██║  ██║██║"
echo "██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║    ██║╚██╗██║██║   ██║██║  ██║██╔══╝      ██╔══██║██║██║╚██╗██║██║  ██║██║"
echo "╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝    ██║ ╚████║╚██████╔╝██████╔╝███████╗    ██║  ██║██║██║ ╚████║██████╔╝██║"
echo " ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝     ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝     ╚═╝    ╚═╝  ╚═╝╚═╚═╝   ╚═══╝╚═════╝ ╚═╝"
echo -e '\e[0m'
echo "======================================================="

echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${CYAN}https://medium.com/@cryptonodehindi${NC}"
echo "======================================================="

# Update and upgrade the system
apt update -y

# Check if curl is installed, if not, install it
if ! command -v curl &> /dev/null; then
    echo -e "${INFO}curl is not installed. Installing...${NC}"
    apt install -y curl
else
    echo -e "${INFO}curl is already installed.${NC}"
fi

# Check if git is installed, if not, install it
if ! command -v git &> /dev/null; then
    echo -e "${INFO}git is not installed. Installing...${NC}"
    apt install -y git
else
    echo -e "${INFO}git is already installed.${NC}"
fi

# Check if screen is installed, if not, install it
if ! command -v screen &> /dev/null; then
    echo -e "${INFO}screen is not installed. Installing...${NC}"
    apt install -y screen
else
    echo -e "${INFO}screen is already installed.${NC}"
fi

# Check if NPM is installed, if not, install it
if ! command -v npm &> /dev/null; then
    echo -e "${INFO}NPM is not installed. Installing...${NC}"
    apt install npm -y
else
    echo -e "${INFO}NPM is already installed.${NC}"
fi

# Check if NVM is installed, if not, install it
if ! command -v nvm &> /dev/null; then
    echo -e "${INFO}NVM is not installed. Installing...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    # Source the shell configuration file to load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    echo -e "${INFO}Installing Node.js using NVM...${NC}"
    nvm install node
    nvm install 20
    nvm use 20
else
    echo -e "${INFO}NVM is already installed. Skipping Node.js setup.${NC}"
fi

# Install project dependencies
echo -e "${INFO}Installing project dependencies...${NC}"
 sudo npm install

# Display thank you message
echo "==================================="
echo -e "${BANNER}           CryptonodeHindi       ${NC}"
echo "==================================="
echo -e "${GREEN}    Thanks for using this script!${NC}"
echo "==================================="
