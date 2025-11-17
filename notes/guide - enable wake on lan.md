### Server

**1. Install ethtool**
```shell
sudo apt install ethtool
```

**2. Check network interface to enable on**
```shell
ip addr
```

In this case, we want to enable it on `enp1s0`
![Pasted image 20251102032111.png](attachments/Pasted%20image%2020251102032111.png)

**3. Check if WoL is enable on the interface**
```shell
ethtool <interface_name>
```

If you see `Supports Wake-on: pumbg`, that mean it's supported.

If you see `Wake-on: g`, that mean it's enabled. In this case it's not.

![Pasted image 20251102032310.png](attachments/Pasted%20image%2020251102032310.png)

**4. Enable WoL**

1. Create this config file
```shell
vim /etc/systemd/system/wol.service
```

2. Paste this
```
[Unit]
Description=Enable Wake-on-LAN
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -s <interface_name> wol g

[Install]
WantedBy=multi-user.target
```

3. Enable and start service
```shell
sudo systemctl enable wol.service
sudo systemctl start wol.service
```

### Waker

**1. Install wakeonlan**
```shell
sudo apt install wakeonlan
```

**2. Add alias**
```
alias wake-<machine>="wakeonlan <mac_address>
```
