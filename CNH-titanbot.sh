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

echo -e "${YELLOW}Updating and upgrading system packages...${NC}"
sudo apt update -y

if command -v screen &> /dev/null; then
    echo -e "${YELLOW}Screen is already installed, skipping installation.${NC}"
else
    echo -e "${YELLOW}Installing Screen...${NC}"
    sudo apt install -y screen
fi

if command -v docker &> /dev/null; then
    echo -e "${YELLOW}Docker is already installed, skipping Docker installation.${NC}"
else
    echo -e "${YELLOW}Installing Docker...${NC}"
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common lsb-release gnupg2
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io
fi

if command -v docker-compose &> /dev/null; then
    echo -e "${YELLOW}Docker Compose is already installed, skipping installation.${NC}"
else
    echo -e "${YELLOW}Installing Docker Compose...${NC}"
    VER=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
    curl -L "https://github.com/docker/compose/releases/download/$VER/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

if ! groups $USER | grep -q '\bdocker\b'; then
    echo "Adding user to Docker group..."
    sudo groupadd docker
    sudo usermod -aG docker $USER
fi

# Remove existing containers using the image
existing_containers=$(docker ps -a --filter "ancestor=nezha123/titan-edge" --format "{{.ID}}")
if [ -n "$existing_containers" ]; then
    echo -e "${YELLOW}\nStopping and removing existing containers using the image nezha123/titan-edge...${NC}"
    docker stop $existing_containers
    docker rm $existing_containers
else
    echo -e "${RED}\nNo existing containers found for the image nezha123/titan-edge.${NC}"
fi

read -p "$(echo -e "${YELLOW}Enter your identity code: ${NC}")" id
read -p "$(echo -e "${YELLOW}Please enter the number of nodes you want to create (maximum of 5 nodes per IP): ${NC}")" container_count
read -p "$(echo -e "${YELLOW}Please enter the hard disk size limit for each node (in GB, e.g., 1 for 1GB): ${NC}")" disk_size_gb

# Default storage directory
volume_dir="/mnt/docker_volumes"
mkdir -p $volume_dir

docker pull nezha123/titan-edge

for i in $(seq 1 $container_count); do
    disk_size_mb=$((disk_size_gb * 1024))
    volume_path="$volume_dir/volume_$i.img"
    sudo dd if=/dev/zero of=$volume_path bs=1M count=$disk_size_mb
    sudo mkfs.ext4 $volume_path
    mount_point="/mnt/my_volume_$i"
    mkdir -p $mount_point
    sudo mount -o loop $volume_path $mount_point
    echo -e "${YELLOW}$volume_path $mount_point ext4 loop,defaults 0 0${NC}" | sudo tee -a /etc/fstab
    container_id=$(docker run -d --restart always -v $mount_point:/root/.titanedge/storage --name "titan$i" nezha123/titan-edge)
    echo -e "${YELLOW}Titan node $i has started with container ID $container_id${NC}"
    sleep 30
    docker exec -it $container_id bash -c "titan-edge bind --hash=$id https://api-test1.container1.titannet.io/api/v2/device/binding"
done

echo -e "${YELLOW}You have successfully created 5 containers. To check the container status, use the command below:${NC}"
echo -e "${GREEN}docker ps -a${NC}"


# Display thank you message
echo "==================================="
echo -e "${BANNER}           CryptonodeHindi       ${NC}"
echo "==================================="
echo -e "${GREEN}    Thanks for using this script!${NC}"
echo "==================================="
