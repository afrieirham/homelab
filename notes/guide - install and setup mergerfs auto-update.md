source: https://perfectmediaserver.com/02-tech-stack/mergerfs/

**1. install script (using perfectmediaserver script)**

```bash
curl -fsSL https://perfectmediaserver.com/scripts/install_mergerfs.sh | sh
```

**2. setup automated mergerfs update**

Create service at `/etc/systemd/system/pms-mergerfs-update.service`.
```bash
[Unit]
Description=Update mergerfs from GitHub

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'curl -fsSL https://perfectmediaserver.com/scripts/install_mergerfs.sh | sh -s -- --force'
```

Create timer at `/etc/systemd/system/pms-mergerfs-update.timer`.
```bash
[Unit]
Description=Run PMS mergerfs update monthly

[Timer]
OnCalendar=monthly
Persistent=true

[Install]
WantedBy=timers.target
```

Enable the timer
```bash
systemctl daemon-reload
systemctl enable --now pms-mergerfs-update.timer
```

**Expected result**
![Pasted image 20260910001716.png](attachments/Pasted%20image%2020260910001716.png)
