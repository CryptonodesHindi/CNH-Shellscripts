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
echo -e "${YELLOW} Script is made by CRYTONODEHINDI${NC}"
echo -e "-------------------------------------"

# Large ASCII Text with BANNER color
echo -e "${BANNER}  CCCCC  RRRRR   Y   Y  PPPP   TTTTT  OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"
echo -e "${BANNER} C       R   R    Y Y   P  P     T   O   O     NN  N  O   O  D   D E          H   H   I   NN  N  D   D   I ${NC}"
echo -e "${BANNER} C       RRRRR     Y    PPPP     T   O   O     N N N  O   O  D   D EEEE       HHHHH   I   N N N  D   D   I ${NC}"
echo -e "${BANNER} C       R   R     Y    P        T   O   O     N  NN  O   O  D   D E          H   H   I   N  NN  D   D   I ${NC}"
echo -e "${BANNER}  CCCCC  R    R    Y    P        T    OOO      N   N   OOO   DDDD  EEEEE      H   H  III  N   N  DDDD   III${NC}"

echo "============================================"

# Use different colors for each link to make them pop out more
echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${BLUE}https://medium.com/@cryptonodehindi${NC}"

echo "============================================="

# Update and install required packages
echo -e "${INFO}Updating package list...${NC}"
sudo apt update

# Enabling the necessary ports
echo -e "${INFO}Allowing necessary ports through the firewall...${NC}"
sudo ufw allow 22 comment 'Allow SSH'
sudo ufw allow 3389 comment 'Allow RDP'
sudo ufw reload

# XFCE setup
echo -e "${INFO}Installing XFCE Desktop for lower resource usage...${NC}"
sudo apt update
sudo apt install -y xfce4 xfce4-goodies

# Lightdm set-up 
echo -e "${INFO}Installing Lightdm setup...${NC}"
sudo apt install lightdm -y
if [ $? -eq 0 ]; then
    echo -e "${INFO}LightDM was successfully installed.${NC}"
else
    echo -e "${RED}Failed to install LightDM. Retrying the script...${NC}"
    exit 1
fi

# Enabling and starting LightDM
sudo systemctl enable lightdm
sudo systemctl start lightdm

# Installing XRDP for remote desktop access
echo -e "${INFO}Installing XRDP for remote desktop...${NC}"
sudo apt install -y xrdp

# Configuring XRDP to use XFCE
echo "xfce4-session" > ~/.xsession

echo -e "${INFO}Restarting XRDP service...${NC}"
sudo systemctl restart xrdp

echo -e "${INFO}Enabling XRDP service at startup...${NC}"
sudo systemctl enable xrdp

echo -e "${INFO}Adding the xrdp user...${NC}"
sudo adduser xrdp ssl-cert

# Checking XRDP status
echo "XRDP Status:"
sudo systemctl status xrdp --no-pager

# Display firewall status
echo -e "${INFO}Displaying firewall status...${NC}"
sudo ufw status verbose

# Docker setup: Removing old versions and installing Docker
echo -e "${INFO}Removing old Docker versions...${NC}"
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do 
    sudo apt-get remove -y $pkg
done

echo -e "${INFO}Installing Docker...${NC}"
sudo apt-get update
sudo apt-get install -y ca-certificates curl

sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# OpenLedger installation
echo -e "${INFO}Downloading and installing OpenLedger...${NC}"
wget https://cdn.openledger.xyz/openledger-node-1.0.0-linux.zip
sudo apt install unzip -y
unzip openledger-node-1.0.0-linux.zip
sudo dpkg -i openledger-node-1.0.0.deb

# Get the server IP address
IP_ADDR=$(hostname -I | awk '{print $1}')

# Final message
echo -e "${GREEN}RDP Installation completed.${NC}"
echo -e "${INFO}You can now connect via Remote Desktop with the following details:${NC}"
echo -e "${INFO}IP ADDRESS: ${GREEN}$IP_ADDR${NC}"

# Display thank you message
echo "==================================="
echo -e "${BANNER}           CryptonodeHindi       ${NC}"
echo "==================================="
echo -e "${GREEN}    Thanks for using this script!${NC}"
echo "==================================="
