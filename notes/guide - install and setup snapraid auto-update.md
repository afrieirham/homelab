source: https://perfectmediaserver.com/02-tech-stack/snapraid/

**1. install script (using perfectmediaserver script)**

```bash
curl -fsSL https://perfectmediaserver.com/scripts/install_snapraid.sh | sh
```

**2. setup automated update**

Create service at `/etc/systemd/system/pms-snapraid-update.service`.
```bash
[Unit]
Description=Update SnapRAID and SnapRAID Daemon from GitHub

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'curl -fsSL https://perfectmediaserver.com/scripts/install_snapraid.sh | sh -s -- --force'
```

Create timer at `/etc/systemd/system/pms-snapraid-update.timer`.
```bash
[Unit]
Description=Run PMS SnapRAID update monthly

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=timers.target
```

Enable the timer
```bash
systemctl daemon-reload
systemctl enable --now pms-snapraid-update.timer
```

**Expected result**
![Pasted image 20260910014042.png](attachments/Pasted%20image%2020260910014042.png)
