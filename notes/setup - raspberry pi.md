### **1. update and upgrade**

After ssh into raspberry pi, update and upgrade everything.
```bash
sudo apt update && sudo apt full-upgrade
```

**IMPORTANT:** use full-upgrade, read more [here](https://www.raspberrypi.com/documentation/computers/os.html#:~:text=apt%20full%2Dupgrade-,TIP,-Unlike%20Debian%2C%20Raspberry).

### **2. install git, vim, fastfetch**

Install script
```bash
sudo apt install fastfetch vim git
```

**git**
- [guide - setup github ssh](guide%20-%20setup%20github%20ssh.md)

**vim**
- [guide - install and setup minimal vim](guide%20-%20install%20and%20setup%20minimal%20vim.md)

### **3. network configuration**

- [guide - configure static ip on linux](guide%20-%20configure%20static%20ip%20on%20linux.md)

Disable ipv6
```bash
# add into /etc/sysctl.d/99-disable-ipv6.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```

### **4. install docker and cockpit**
- [guide - install and setup docker with auto prune](guide%20-%20install%20and%20setup%20docker%20with%20auto%20prune.md)
- [guide - install cockpit in debian](guide%20-%20install%20cockpit%20in%20debian.md)

### **final: running docker compose**

- Config file in [config/raspberrypi/compose.yml](config/raspberrypi/compose.yml)
- [hotfix - fix portainer cannot connect to local environment](hotfix%20-%20fix%20portainer%20cannot%20connect%20to%20local%20environment.md)




