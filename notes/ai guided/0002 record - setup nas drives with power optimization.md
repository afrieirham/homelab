
# Server Upgrade and Optimization Log

## 1. System Baseline and Hardware Profile
* **Host OS:** Debian 13 (Trixie), Linux kernel `6.12.107+-amd64`
* **CPU:** Intel Core i3-12100 (4 Cores, 8 Threads) with Integrated UHD Graphics 730
* **Motherboard:** ASRock H610M-HDV/M.2
* **Storage Environment:** 
  * 1 x 1TB NVMe SSD (Host Boot Drive, Incus Container Root Substrate)
  * 3 x 1TB Seagate IronWolf 3.5" Mechanical HDDs (`ST1000VN002`, 5900 RPM)
* **Memory Configuration:**
  * **Before:** Mismatched 16GB dual-channel array (8GB 2133MHz + 8GB 3200MHz modules).
  * **After:** Single **32GB Kingston ValueRAM DDR4 3200MHz** desktop long-DIMM module (`KVR32N22D8/32`). Running natively at JEDEC 1.2V specifications with CL22 timings in physical slot `DDR4_A1`. No XMP profile configuration required.

---

## 2. Kernel Boot Parametrization
To bypass default power constraints and enforce advanced link savings on the PCIe and NVMe transport channels, the following persistent modifications are active within the system boot configuration (`/proc/cmdline`):
* `pcie_aspm=force` - Overrides local motherboard table flags to mandate Active State Power Management across all hardware slots.
* `nvme_core.default_ps_max_latency_us=0` - Configures the NVMe controller interface engine to employ aggressive autonomous power state transitions without introducing controller timeout errors.

---

## 3. Storage Array Architecture: MergerFS & SnapRAID
The three mechanical hard drives are set up in a hybrid configuration optimized for low power. This layout avoids the resource overhead of striped software matrices by isolating operations to single storage units.
* **Array Capacity Map:** 2 x 1TB Data Storage Drives + 1 x 1TB Dedicated Parity Protection Drive (yielding 2TB of protected storage).

### File System Layout
All three individual mechanical hard drives are formatted with the **ext4 file system**, using custom block configuration boundaries to match large media libraries (e.g., Immich photo repositories) and minimize file structural logging writes:
```bash
sudo mkfs.ext4 -m 1 -T largefile /dev/sdX1
```

### Persistent Mount Structures (`/etc/fstab`)
Physical disk descriptors map to the file system using long-form, unalterable hardware markers (`/dev/disk/by-id/`). Caching behaviors are heavily restricted to allow disk controllers to remain undisturbed by system metadata reads:

```text
# Physical Data Drive 1 Mapping
/dev/disk/by-id/ata-ST1000VN002-2EY102_Z9CAA2EY-part1 /mnt/disk1 ext4 defaults,noatime,nodiratime,lazytime 0 2

# Physical Data Drive 2 Mapping
/dev/disk/by-id/ata-ST1000VN002-2EY102_Z9CAB3EQ-part1 /mnt/disk2 ext4 defaults,noatime,nodiratime,lazytime 0 2

# Physical Parity Drive Mapping
/dev/disk/by-id/ata-ST1000VN002-2EY102_Z9CAV5XM-part1 /mnt/parity1 ext4 defaults,noatime,nodiratime,lazytime 0 2

# Low-Power MergerFS Virtual Pool Configuration
/mnt/disk* /mnt/storage mergerfs defaults,nonempty,allow_other,use_ino,cache.files=off,dropcacheonclose=true,category.create=epmfs,minfreespace=20G,fsname=mergerfs 0 0
```
* `noatime,nodiratime,lazytime` - Eliminates persistent timestamp generation overhead during file read actions.
* `cache.files=off` & `dropcacheonclose=true` - Closes system file handles cleanly, removing background caching activity.
* `category.create=epmfs` - Directs fresh storage entries to existing folder pathways first, maximizing the sleep window of the remaining inactive data drives.

### Automated Spin-Down Configuration (`/etc/default/hd-idle`)
Power management relies on the `hd-idle` service daemon, which tracks actual bus activity patterns inside `/proc/diskstats`. It bypasses global tracking to protect the NVMe boot drive while enforcing an autonomous **15-minute shutdown timer** across the hard drive cluster using persistent device IDs:

```text
START_HD_IDLE=true
HD_IDLE_OPTS="-i 0 -a /dev/disk/by-id/ata-ST1000VN002-2EY102_Z9CAV5XM -i 900 -a /dev/disk/by-id/ata-ST1000VN002-2EY102_Z9CAA2EY -i 900 -a /dev/disk/by-id/ata-ST1000VN002-2EY102_Z9CAB3EQ -i 900"
```

### Snapshot Parity Maintenance (`crontab`)
SnapRAID parity data updates are isolated to an automated background routine that fires once daily during off-peak windows, keeping the array protected without causing persistent disk wake-up events:
```text
0 3 * * * /usr/bin/snapraid sync
```

---

## 4. Motherboard Firmware Configuration (ASRock UEFI)
Following a hard CMOS clear sequence to erase old hardware mapping profiles, the motherboard firmware parameters were manually adjusted to unblock deep system sleep windows:

* **CPU Configuration Menu:**
  * `CPU C States Support` → **Enabled**
  * `CPU C6 State Support` → **Enabled**
  * `CPU C7 State Support` → **Enabled**
  * `Package C State Support` → **Enabled** (Locks down target limits to C10 execution lanes)
  * `C6DRAM` → **Disabled** (Maintains network socket interface reliability across containers)
  * `CFG Lock` → **Disabled** (Grants the Linux kernel direct management rights over processor register power attributes)
* **Chipset Configuration Menu:**
  * `PCIE ASPM Support` → **L0sL1**
  * `DMI ASPM Support` → **Enabled**
  * `PCH PCIE ASPM Support` → **L1**
  * `PCH DMI ASPM Support` → **Enabled**
  * `Onboard HD Audio` → **Disabled** (Powers off unused audio silicon components)
  * `Restore on AC/Power Loss` → **Power On** (Ensures full headless recovery during electrical utility service interruptions)
* **ACPI Configuration Menu:**
  * `Deep Sleep` → **Enabled in S4-S5** (Reduces system standby overhead below 1W during full shutdowns, while keeping the physical chassis power indicator LED completely lit when the server is operational in the S0 working state)
* **Storage Configuration Menu:**
  * `SATA Aggressive Link Power Management (ALPM)` → **Enabled**

---

## 5. Verification Metrics and Operational State
The core development environments—including the `ai` container, OpenCode workspace states, and terminal processes—survived the physical components swap cleanly with zero loss of persistent code data. 

Real-time power diagnostics verify the following metrics:
* **Core Power State:** Individual CPU execution threads enter the deep **C10** hardware sleep state up to 95.7% of the time during server idle windows.
* **GPU Power State:** Onboard Intel UHD 730 graphics core drops down to the low-voltage **RC6** power ceiling 98.6% of the time.
* **Chipset Package State:** The global platform link management interface enters the **pc3** sleep state over 49% of the time, unblocking the physical ASRock logic layers.
* **Storage Power State:** Disk arrays maintain file mounts via `noatime` rules, successfully entering absolute **STANDBY mode** after 15 minutes of inactivity.
* **System Power Draw:** Total estimated server idle consumption drops from a baseline of ~35W+ down to a highly optimized **15W–18W range**, reducing the permanent monthly power footprint by over 52%.
