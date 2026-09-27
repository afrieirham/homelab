
# Wake-on-LAN & PowerTOP Configuration Record

## 1. Problem Statement
The server failed to retain Wake-on-LAN (WoL) functionality after a reboot (`Wake-on: d`). 
*   **Root Cause 1 (Hardware):** ASRock motherboard "Deep Sleep" state cuts power to the PCIe NIC in S5 shutdown.
*   **Root Cause 2 (Software):** `powertop --auto-tune` runs at boot and aggressively sets the network adapter's runtime power management to `auto`, which inadvertently disables the wake-on-lan flag.

---

## 2. Hardware/UEFI Configuration
**Target:** ASRock H610M UEFI
**Menu:** Advanced \> ACPI Configuration

| Setting | Value | Reason |
| :--- | :--- | :--- |
| **PCIE Devices Power On** | `Enabled` | Allows the NIC to trigger a system wake event. |
| **Deep Sleep** | **`Disabled`** | **Critical.** "Enabled in S4/S5" kills standby power to the ethernet port. Disabling it ensures the NIC stays powered to listen for magic packets. |

---

## 3. The Software Fix (Systemd Override)
We abandoned separate `wol.service` scripts and `udev` rules because they created race conditions against the PowerTOP auto-tune process. 

The stable solution chains the override command directly to the `powertop.service` execution, ensuring it runs *after* optimizations are applied.

**File:** `/etc/systemd/system/powertop.service`

```ini
[Unit]
Description=PowerTOP Automated Power Tunings
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/powertop --auto-tune

# --- Fix for Wake-on-LAN ---
# 1. Force the kernel to keep the NIC power control 'on' (prevents sleep reset)
ExecStartPost=/bin/sh -c "echo 'on' > /sys/class/net/enp2s0/device/power/control"
# 2. Re-assert the Magic Packet flag explicitly
ExecStartPost=/usr/sbin/ethtool -s enp2s0 wol g

RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

**Commands to Apply:**
```bash
sudo systemctl daemon-reload
sudo systemctl restart powertop.service
```

---

## 4. Verification
**Check 1: Service Status**
Ensure the service ran both the main tune and the post-scripts successfully.
```bash
systemctl status powertop.service
```

**Check 2: Interface Flags**
Verify the interface is accepting magic packets (`g`).
```bash
sudo ethtool enp2s0 | grep Wake-on
# Output must be: Wake-on: g
```

**Check 3: Runtime Power Control**
Verify the kernel is respecting the `on` override.
```bash
cat /sys/class/net/enp2s0/device/power/control
# Output must be: on
```
