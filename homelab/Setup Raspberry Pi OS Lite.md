### 1. Update and Upgrade

After ssh into raspberry pi, update and upgrade everything.

```bash
sudo apt update && sudo apt full-upgrade
```

**IMPORTANT:** use full-upgrade, read more [here](https://www.raspberrypi.com/documentation/computers/os.html#:~:text=apt%20full%2Dupgrade-,TIP,-Unlike%20Debian%2C%20Raspberry).

### 2. Install essential tools

**git**
```bash
sudo apt install fastfetch vim git
```

**vim config**
```
# ~/.vimrc
set number
set relativenumber
set nowrap
syntax on
```


### 3. Network configuration

**Set static IP**
```bash
# get connection name
nmcli connection show --active

# configure
sudo nmcli connection modify "CONNECTION_NAME" ipv4.method manual
sudo nmcli connection modify "CONNECTION_NAME" ipv4.addresses 192.168.100.200/24
sudo nmcli connection modify "CONNECTION_NAME" ipv4.gateway 192.168.100.1
```

**Disable ipv6**
```bash
# add into /etc/sysctl.d/99-disable-ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

### 4. Docker Setup

#### Install docker
https://docs.docker.com/engine/install/debian/#install-using-the-repository

#### Setup auto prune

**1.1.a Create docker prune script**
```bash
vim /usr/local/bin/docker-prune.sh
```

**1.1.b Paste docker prune script**
```bash
docker system prune -af --filter "until=$((30*24))h"
```

**1.2 One liner version**
```bash
sudo bash -c 'echo "docker system prune -af --filter \"until=\$((30*24))h\"" > /usr/local/bin/docker-prune.sh'
```

**2. Give +x permission**
```bash
chmod +x /usr/local/bin/docker-prune.sh
```

**3. Add cron job at 3am**
```bash
0 3 * * * /usr/local/bin/docker-prune.sh >> /var/log/docker-prune.log 2>&1
```

#### 5. [[Setup GitHub SSH]]
