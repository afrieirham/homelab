
**1. Using nmcli (if available)**

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

**2. Using /etc/network/interfaces**

**Backup original config file**
```shell
mv /etc/network/interfaces /etc/network/interfaces.backup
```

**Get network interface**
```shell
ip a
```

Result
![Pasted image 20251110202430.png](attachments/Pasted%20image%2020251110202430.png)

**Create new config file with this template**
```shell
auto <interface_code>
iface <interface_code> inet static
    address 192.168.2.249
    netmask 255.255.255.0
    gateway 192.168.2.254
	dns-nameservers 192.168.2.254 8.8.8.8
```

**Restart networking service**
```shell
sudo systemctl restart networking.service
```