#!/bin/bash

# DevOps tools installation script
# This script installs Docker, Docker Compose, Python and Django
# It checks if each tool is already installed before installing

echo "Starting DevOps tools installation script..."
echo "=============================================="

# Update system packages first
echo "Updating system..."
sudo apt update -y

# Install basic dependencies
echo "Installing basic dependencies..."
sudo apt install -y curl wget apt-transport-https ca-certificates gnupg lsb-release

# Check if Docker is installed, if not install it properly
echo "Checking Docker..."
if command -v docker &> /dev/null; then
    echo "Docker already installed: $(docker --version)"
else
    echo "Installing Docker..."
    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    
    # Add Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index and install Docker
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    
    # Start and enable Docker service
    sudo systemctl start docker
    sudo systemctl enable docker
    
    # Add current user to docker group to run without sudo
    sudo usermod -aG docker $USER
    
    echo "Docker installed! Please logout and login again to use Docker without sudo."
fi

# Check if Docker Compose is working, if not install it properly
echo "Checking Docker Compose..."
if docker compose version &> /dev/null; then
    echo "Docker Compose already installed: $(docker compose version)"
elif command -v docker-compose &> /dev/null; then
    echo "Docker Compose (standalone) already installed: $(docker-compose --version)"
else
    echo "Installing Docker Compose..."
    # Install Docker Compose plugin (modern way)
    sudo apt install -y docker-compose-plugin
    
    # If that fails, install standalone version
    if ! docker compose version &> /dev/null; then
        echo "Installing standalone Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    echo "Docker Compose installed!"
fi

# Check if Python3 is installed, if not install it
echo "Checking Python..."
if command -v python3 &> /dev/null; then
    python_version=$(python3 --version)
    echo "Python already installed: $python_version"
else
    echo "Installing Python..."
    sudo apt install -y python3 python3-dev
    echo "Python installed!"
fi

# Check if pip3 is installed separately, if not install it
echo "Checking pip3..."
if command -v pip3 &> /dev/null; then
    pip_version=$(pip3 --version)
    echo "pip3 already installed: $pip_version"
else
    echo "Installing pip3..."
    sudo apt install -y python3-pip
    
    # If still not found, try alternative installation
    if ! command -v pip3 &> /dev/null; then
        echo "Installing pip3 using get-pip.py..."
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        python3 get-pip.py --user
        rm get-pip.py
    fi
    echo "pip3 installed!"
fi

# Check if Django is installed, if not install it
echo "Checking Django..."
if python3 -c "import django" &> /dev/null; then
    django_version=$(python3 -c "import django; print(django.get_version())")
    echo "Django already installed: Django $django_version"
else
    echo "Installing Django system-wide..."
    
    # First try system package manager
    echo "Trying system package installation..."
    sudo apt install -y python3-django
    
    # Check if Django installed via apt
    if python3 -c "import django" &> /dev/null; then
        echo "Django installed via system package manager!"
    else
        echo "System package not available, using pip with system override..."
        
        # Remove externally managed restriction temporarily
        PYTHON_VERSION=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
        EXTERNALLY_MANAGED_FILE="/usr/lib/python${PYTHON_VERSION}/EXTERNALLY-MANAGED"
        
        if [ -f "$EXTERNALLY_MANAGED_FILE" ]; then
            echo "Temporarily removing Python external management restriction..."
            sudo mv "$EXTERNALLY_MANAGED_FILE" "${EXTERNALLY_MANAGED_FILE}.backup"
        fi
        
        # Install Django system-wide
        pip3 install django
        
        # Restore the externally managed file
        if [ -f "${EXTERNALLY_MANAGED_FILE}.backup" ]; then
            sudo mv "${EXTERNALLY_MANAGED_FILE}.backup" "$EXTERNALLY_MANAGED_FILE"
        fi
        
        echo "Django installed system-wide!"
    fi
fi

echo "=============================================="
echo "All tools successfully checked/installed!"
echo "=============================================="

# Show final status of all installed tools with better error handling
echo "INSTALLED TOOLS:"
echo "Docker: $(docker --version 2>/dev/null || echo 'Not installed')"

# Check both docker compose versions
if docker compose version &> /dev/null; then
    echo "Docker Compose: $(docker compose version --short 2>/dev/null)"
elif command -v docker-compose &> /dev/null; then
    echo "Docker Compose: $(docker-compose --version 2>/dev/null)"
else
    echo "Docker Compose: Not installed"
fi

echo "Python: $(python3 --version 2>/dev/null || echo 'Not installed')"
echo "pip3: $(pip3 --version 2>/dev/null || echo 'Not installed')"
echo "Django: $(python3 -c "import django; print('Django', django.get_version())" 2>/dev/null || echo 'Django not installed')"

echo ""
echo "Note: If you installed Docker for the first time, please logout and login again"
echo "to use Docker commands without sudo."
