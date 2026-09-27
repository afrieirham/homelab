
This document records the exact terminal configuration steps applied to the Intel i3-12100 and ASRock H610M development server (afrie@homelab). It tracks the hardware adjustments, kernel changes, and the final verified power states.

---

## 1. Operating System Power Management Tuning

Automated motherboard controller tuning uses PowerTOP to force peripheral chips, internal USB headers, and unused SATA slots into low-power states.

### Step 1: Install PowerTOP
```bash
sudo apt update
sudo apt install powertop
```

### Step 2: Test Automated Power Adjustments
```bash
sudo powertop --auto-tune
```

### Step 3: Create a Permanent systemd Background Service
To make sure the power-saving tweaks survive system reboots, create a custom startup service.

```bash
sudo nano /etc/systemd/system/powertop.service
```

**File Contents (/etc/systemd/system/powertop.service):**
```ini
[Unit]
Description=PowerTOP Automated Power Tunings
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/powertop --auto-tune
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

### Step 4: Register and Enable the Service
```bash
sudo systemctl daemon-reload
sudo systemctl enable powertop.service
sudo systemctl start powertop.service
```

### Step 5: Verify Service Execution Status
```bash
sudo systemctl status powertop.service
```
The success state shows a green line stating `Active: active (exited)`.

---

## 2. Kernel Level PCIe and NVMe Storage Optimization

Configurations are applied directly to the primary Linux kernel boot flags to enforce Active State Power Management (ASPM) across PCIe lanes and override internal NVMe power transitions.

### Step 1: Update GRUB Bootloader Configuration
```bash
sudo nano /etc/default/grub
```

**Target Line Modification:**
Locate the `GRUB_CMDLINE_LINUX_DEFAULT` string and add the PCIe power saving and NVMe driver parameters inside the quotation marks:
```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet pcie_aspm=force nvme_core.default_ps_max_latency_us=0"
```

### Step 2: Compile Bootloader Map Changes
```bash
sudo update-grub
```

### Step 3: Execute a System Reboot
```bash
sudo reboot
```

---

## 3. Post-Boot Optimization Verification

These evaluation parameters verify that the host kernel uses the target low-power profiles:

### Verify NVMe Driver State (Target Return = 0)
```bash
cat /sys/module/nvme_core/parameters/default_ps_max_latency_us
```

### Verify Running RAM Footprint Boundaries
```bash
free -h
```

### Verify System Core Sleep Profiles
```bash
sudo powertop
```
*   **Target CPU Indicators:** Individual threads inside the CPU(OS) matrix should reflect around 90% or more time spent in the deep C10 sleep state.
*   **Target GPU Indicators:** Integrated graphic arrays under the GPU sector should reflect around 95% or more time spent resting inside the RC6 power-saving tier.

---

## 4. Physical Hardware Matrix

| Component             | Before State (Unoptimized)                                                            | After State (Optimized)                                                                  |
| :-------------------- | :------------------------------------------------------------------------------------ | :--------------------------------------------------------------------------------------- |
| Memory Configuration  | Two sticks (mismatched)<br>• Slot A1: 8GB DDR4 2133MHz<br>• Slot B1: 8GB DDR4 3200MHz | One stick (unified profile)<br>• Slot A1: 8GB DDR4 3200MHz (Samsung)<br>• Slot B1: Empty |
| RAM Operating Speed   | Forced to 2133MHz fallback floor                                                      | Running at full native 3200MHz                                                           |

---

## 5. PowerTOP Power State Diagnostics

This data records the real-time behavior of the chip architecture when sitting idle.

### Before Optimization (Mismatched RAM and Unoptimized Storage Driver)
*   **CPU Core Threads:** Individual cores were quiet and successfully reached C10 states.
*   **The Hardware Trap:** The C3 (pc3) state was locked at 56.7%. The mixed RAM frequencies and sub-timings forced the CPU's internal memory controller to work overtime to sync the data streams. This signaling noise trapped the global motherboard Pkg(HW) sleep row at 0.0% across deep tiers (C6 to C10).
*   **Storage Behavior:** The 1TB NVMe boot drive ran at full voltage because PCIe power management (ASPM) was left at factory Linux defaults.
*   **Estimated Wall Footprint:** Around 25W to 35W continuous draw because the memory controller and storage lanes stayed wide awake.

### After Optimization (Single Stick, ASPM Enabled and NVMe Driver Patched)
*   **CPU Core Threads:** Backends are silent, resting in C10 up to 97.2% of the time.
*   **The Power Resolution:** The C3 (pc3) state dropped to 0.0%. Removing the slow 2133MHz stick wiped out the memory signaling noise. 
*   **Storage Resolution:** Forcing `pcie_aspm=force` and capping NVMe latency to 0 allows the storage bus to drop its voltages whenever you are not actively compiling code.
*   **Estimated Wall Footprint:** Power draw dropped to around 15W to 18W at the wall, cutting your ongoing idle server electricity costs by nearly half.
