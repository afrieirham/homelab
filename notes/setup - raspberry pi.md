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

**vim config**
```
# ~/.vimrc
set number
set relativenumber
set nowrap
syntax on
```


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
