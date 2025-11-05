After installing and booting into proxmox via usb drive.

**1. Housekeeping**

Run this script to add/remove packages, source [here](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install).
```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
```

This script helps to remove enterprise features and stop subscriptions nag in the web ui.

**2. Create non-root user**

1. Login as root

2. Create new user
```shell
# -m create home directory
# -s /bin/bash assign shell
adduser -m -s /bin/bash newuser
```

3. Create password for user
```shell
passwd newuser
```

4. Install sudo if not installed yet.
```shell
apt install sudo
```

5. Add to user to sudo group
```shell
usermod -aG sudo newuser
```

6. Disable root and/or password login in `/etc/ssh/sshd_config`
```
PasswordAuthentication no
PermitRootLogin no
```
