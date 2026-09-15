**1. stop all docker apps**
```bash
docker compose down
```

**2. stop docker service**
```bash
sudo systemctl stop docker docker.socket containerd
```

**3. uninstall docker and its dependencies**
```bash
sudo apt purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

# clean up leftover dependencies
 sudo apt autoremove --purge
```

**4. stop docker auto prune cron**
```bash
crontab -e
```
comment out previous cron from [guide - install and setup docker with auto prune](notes/guide - install and setup docker with auto prune)

**5. remove docker-related files**
```bash
# Remove Docker and Containerd data directories (Deletes all images/volumes)
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -rf /etc/docker

# Remove the GPG key and the APT repository configuration added during setup
sudo rm -f /etc/apt/keyrings/docker.asc
sudo rm -f /etc/apt/sources.list.d/docker.sources

# Remove user-level CLI configurations
rm -rf ~/.docker
```

**6. remove docker group**
```bash
# remove user from docker group
sudo gpasswd -d username docker

# remove docker group
sudo groupdel docker
```


