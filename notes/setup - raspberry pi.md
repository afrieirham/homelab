**1. Update and Upgrade**

After ssh into raspberry pi, update and upgrade everything.

```bash
sudo apt update && sudo apt full-upgrade
```

**IMPORTANT:** use full-upgrade, read more [here](https://www.raspberrypi.com/documentation/computers/os.html#:~:text=apt%20full%2Dupgrade-,TIP,-Unlike%20Debian%2C%20Raspberry).

**2. Install essential tools**

**git**
```bash
sudo apt install fastfetch vim git
```

**vim**
[guide - install and setup minimal vim](guide%20-%20install%20and%20setup%20minimal%20vim.md)

**3. Network configuration**

**1. [guide - configure static ip on linux](guide%20-%20configure%20static%20ip%20on%20linux.md)**

**Disable ipv6**
```bash
# add into /etc/sysctl.d/99-disable-ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

**4. [guide - install and setup docker with auto prune](guide%20-%20install%20and%20setup%20docker%20with%20auto%20prune.md)**

**5. [guide - setup github ssh](guide%20-%20setup%20github%20ssh.md)**

**6. [guide - install cockpit in debian](guide%20-%20install%20cockpit%20in%20debian.md)**

**7. Run pi hole and portainer using docker [compose.yml](docker-compose/raspberrypi/compose.yml)**

> Special case for portainer on debian 13 https://github.com/portainer/portainer/issues/12925#issuecomment-3516549977

1. systemctl edit docker.service
2. Add this part above the line _### Lines below this comment will be discarded:_  
```
[Service]  
	Environment=DOCKER_MIN_API_VERSION=1.24
```

3. Save the file and exit
4. systemctl restart docker


