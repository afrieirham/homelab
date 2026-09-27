# Samba Configuration & Troubleshooting Record

## 1. System Environment
* **Host OS:** Debian 13 (Trixie)
* **Storage Mount:** Unified `mergerfs` storage pool located at `/mnt/storage`
* **Storage hardware:** Three 1TB Seagate IronWolf HDDs managed by `hd-idle` (15-minute spin-down threshold) and `SnapRAID`.
* **Samba Daemons:** `smbd` and `nmbd`

---

## 2. Issues Encountered & Resolution

### Symptom 1: Samba Daemons Skipped on Startup
* **Log Error:** `Condition check resulted in smbd.service - Samba SMB Daemon being skipped.` / Services marked as `inactive (dead)`.
* **Cause:** Debian systemd unit files utilize an initial configuration check script (`/usr/share/samba/is-configured-samba`). Because the `/etc/samba/smb.conf` file was either empty or missing required local structural layout syntax, systemd skipped initialization.
* **Resolution:** Wrote a streamlined, valid `/etc/samba/smb.conf` configuration file and ran `sudo systemctl enable --now smbd nmbd` to initialize and force start the daemons.

### Symptom 2: Missing `/run/samba` Warnings during `testparm`
* **Log Error:** `WARNING: lock directory /run/samba does not exist` and `WARNING: pid directory /run/samba does not exist`.
* **Cause:** `testparm` was executed before the actual `smbd`/`nmbd` processes were initialized. Debian mounts `/run` as a volatile, in-memory RAM-disk (`tmpfs`). The directory did not exist in RAM until the services were officially started by systemd.
* **Resolution:** No action needed. Starting the service generated the paths natively inside volatile system memory. Subsequent `testparm` checks inside `/run/samba` returned zero errors.

### Symptom 3: Cannot `cd` into `/mnt/storage` locally
* **Terminal Error:** Permission denied error when attempting to traverse or read `/mnt/storage` using local user profile `afrie`.
* **Cause:** Running `sudo chown -R nasuser:nasuser` shifted user and group ownership exclusively to the Samba service account. Combined with strict `770` permissions, any account outside the `nasuser` group was locked out.
* **Resolution:** Added the standard user profile to the storage group and refreshed the current terminal context:
  ```bash
  sudo usermod -aG nasuser afrie
  newgrp nasuser
  ```

---

## 3. Production Configuration Blueprint
File path: `/etc/samba/smb.conf`

```ini
[global]
   workgroup = WORKGROUP
   server string = Homelab NAS
   server role = standalone server
   log file = /var/log/samba/log.%m
   max log size = 1000
   logging = file

   # --- Security & Protocol ---
   smb ports = 445
   min protocol = SMB3
   server min protocol = SMB3
   ea support = no
   store dos attributes = no

   # --- Power Saving Tweaks (Spin-down Friendly) ---
   # Disables continuous polling loop signals that break drive standby cycles
   change notify = no
   kernel change notify = no
   getwd cache = yes
   map to guest = Bad User

# --- The MergerFS Storage Share ---
[Storage]
   comment = Unified MergerFS Storage Pool
   path = /mnt/storage
   browseable = yes
   read only = no
   guest ok = no
   valid users = nasuser
   create mask = 0660
   directory mask = 0770
   force user = nasuser
   force group = nasuser
   
   # macOS specific caching and metadata exclusions
   vfs objects = catia fruit streams_xattr
   fruit:metadata = stream
   fruit:model = Macmini
   veto files = /._*/.DS_Store/.Trashes/.TemporaryItems/
   delete veto files = yes
```

---

## 4. User Access Infrastructure
A dedicated, non-login system credential controls network access to block standard shell execution paths:
* **System User:** `nasuser`
* **Samba Backend Command Sequence:**
  ```bash
  sudo adduser --system --no-create-home --disabled-password --group nasuser
  sudo smbpasswd -a nasuser
  sudo smbpasswd -e nasuser
  ```

---

## 5. Client Connection Protocol (macOS)
1. In Finder, invoke connection wizard via **`Cmd + K`**.
2. Mount Target Address: `smb://<SERVER_IP>`
3. Input configured Samba database credentials (`nasuser` + password).
4. Run client-side environment terminal tweak on the Mac to block hidden metadata writes to network stores:
   ```bash
   defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
   ```
