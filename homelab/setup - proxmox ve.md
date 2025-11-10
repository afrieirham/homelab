After installing and booting into proxmox via usb drive.

**1. Housekeeping**

Run this script to add/remove packages, source [here](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install).
```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
```

This script helps to remove enterprise features and stop subscriptions nag in the web ui.

**2. [[guide - create non-root user in linux]]**

**3. [[guide - enable wake on lan]]**

