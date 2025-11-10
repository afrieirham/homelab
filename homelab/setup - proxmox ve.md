After installing and booting into proxmox via usb drive.

**1. Housekeeping**

Run this script to add/remove packages, source [here](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install).
```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/tools/pve/post-pve-install.sh)"
```

This script helps to remove enterprise features and stop subscriptions nag in the web ui.

**2. [guide - create non-root user in linux](guide%20-%20create%20non-root%20user%20in%20linux.md)**

**3. [guide - enable wake on lan](guide%20-%20enable%20wake%20on%20lan.md)**

