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

echo -e "\n\n"
echo -e "${BLUE}"
echo " ██████╗██████╗ ██╗   ██╗██████╗ ████████╗ ██████╗     ███╗   ██╗ ██████╗ ██████╗ ███████╗    ██╗  ██╗██╗███╗   ██╗██████╗ ██╗"
echo "██╔════╝██╔══██╗╚██╗ ██╔╝██╔══██╗╚══██╔══╝██╔═══██╗    ████╗  ██║██╔═══██╗██╔══██╗██╔════╝    ██║  ██║██║████╗  ██║██╔══██╗██║"
echo "██║     ██████╔╝ ╚████╔╝ ██████╔╝   ██║   ██║   ██║    ██╔██╗ ██║██║   ██║██║  ██║█████╗      ███████║██║██╔██╗ ██║██║  ██║██║"
echo "██║     ██╔══██╗  ╚██╔╝  ██╔═══╝    ██║   ██║   ██║    ██║╚██╗██║██║   ██║██║  ██║██╔══╝      ██╔══██║██║██║╚██╗██║██║  ██║██║"
echo "╚██████╗██║  ██║   ██║   ██║        ██║   ╚██████╔╝    ██║ ╚████║╚██████╔╝██████╔╝███████╗    ██║  ██║██║██║ ╚████║██████╔╝██║"
echo " ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝        ╚═╝    ╚═════╝     ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝     ╚═╝    ╚═╝  ╚═╝╚═╚═╝   ╚═══╝╚═════╝ ╚═╝"

echo "======================================================="

echo -e "${YELLOW}Telegram: ${GREEN}https://t.me/cryptonodehindi${NC}"
echo -e "${YELLOW}Twitter: ${GREEN}@CryptonodeHindi${NC}"
echo -e "${YELLOW}YouTube: ${GREEN}https://www.youtube.com/@CryptonodesHindi${NC}"
echo -e "${YELLOW}Medium: ${INFO}https://medium.com/@cryptonodehindi${NC}"
echo "======================================================="

set -e  # Exit immediately if a command exits with a non-zero status

# Define AIOS CLI command
AIOS_CLI="aios-cli"

# Functions

# Print a success message
success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }

# Print an error message and exit
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Print a warning message
warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

# Function to add a model
add_model() {
    echo -e "${YELLOW}Do you want to add the default model? (y/n): ${NC}"
    read choice
    case "$choice" in
        [Yy]*)
            default_model="hf:TheBloke/Mistral-7B-Instruct-v0.1-GGUF:mistral-7b-instruct-v0.1.Q4_K_S.gguf"
            success "Adding default model: $default_model"
            if $AIOS_CLI models add "$default_model"; then
                success "Default model added successfully."
            else
                warning "Failed to add default model."
            fi
            ;;
        [Nn]*)
            echo -e "${YELLOW}Enter the model to install: ${NC}"
            read model_name
            if [[ -z "$model_name" ]]; then
                warning "Model name cannot be empty."
                return
            fi
            if $AIOS_CLI models add "$model_name"; then
                success "Model $model_name added successfully."
            else
                warning "Failed to add model: $model_name."
            fi
            ;;
        *)
            warning "Invalid choice. Please enter 'y' or 'n'."
            add_model
            ;;
    esac
}

# Function to setup Hive (Import keys and connect)
setup_hive() {
    success "Configuring Hive..."
    echo -e "${YELLOW}Do you have a private key? (y/n): ${NC}"
    read choice
    case "$choice" in
        [Yy]*)
            echo -e "${YELLOW}Paste your private key: ${NC}"
            read -s private_key
            echo ""  # New line for better formatting
            if [[ -z "$private_key" ]]; then
                warning "Private key cannot be empty."
                return
            fi
            echo "$private_key" > ./my.pem
            chmod 600 ./my.pem
            success "Private key saved successfully to ./my.pem"
            if $AIOS_CLI hive import-keys ./my.pem; then
                success "Private key imported successfully."
            else
                warning "Failed to import private key."
            fi
            ;;
        [Nn]*)
            if $AIOS_CLI hive import-keys ./my.pem; then
                success "Default private key imported successfully."
            else
                warning "Failed to import default private key."
            fi
            ;;
        *)
            warning "Invalid choice. Please enter 'y' or 'n'."
            setup_hive
            ;;
    esac
}

# Function to login to Hive
login_hive() {
    success "Logging into Hive..."
    if $AIOS_CLI hive login; then
        success "Hive login successful."
    else
        warning "Failed to login to Hive."
        return
    fi
    if $AIOS_CLI hive connect; then
        success "Connected to Hive network successfully."
    else
        warning "Failed to connect to Hive network."
    fi
}

# Function to select GPU Tier
select_tier() {
    echo -e "\n${YELLOW}Select GPU Memory Tier:${NC}"
    echo "1 : 30GB"
    echo "2 : 20GB"
    echo "3 : 8GB"
    echo "4 : 4GB"
    echo "5 : 2GB"
    echo -e "${YELLOW}Enter your choice (1-5): ${NC}"
    read gpu_choice
    TIER=${gpu_choice:-5}  # Default to Tier 5 if input is empty
    if $AIOS_CLI hive select-tier $TIER; then
        success "Tier $TIER selected successfully."
    else
        warning "Failed to select Tier $TIER."
    fi
}

### **Execute Functions in Order**
add_model
setup_hive
login_hive
select_tier
success "All steps completed successfully!"

# Display thank you message
echo "========================================"
echo -e "${YELLOW} Thanks for using the script${NC}"
echo -e "-------------------------------------"
