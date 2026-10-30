# Install Podman and Podman Compose
sudo apt update
sudo apt upgrade
sudo apt install podman podman-compose

# Set Docker Hub as default search registry
sudo mkdir -p /etc/containers/registries.conf.d
echo 'unqualified-search-registries = ["docker.io", "ghcr.io"]' | sudo tee /etc/containers/registries.conf.d/99-docker-hub.conf

# Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh
