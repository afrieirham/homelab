# Install Podman and Podman Compose
sudo apt update
sudo apt upgrade
sudo apt install podman podman-compose

# Set Docker Hub as default search registry
sudo mkdir -p /etc/containers/registries.conf.d
echo 'unqualified-search-registries = ["docker.io"]' | sudo tee /etc/containers/registries.conf.d/99-docker-hub.conf

# Verify
podman --version
podman-compose --version

# Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Login tailscale and setup ssh
sudo tailscale login
sudo tailscale up --ssh
