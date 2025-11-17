
**1. List out disks connected to machine**

```bash
ls -l /dev/disk/by-id
```

Sample output
![Pasted image 20251117200820.png](attachments/Pasted%20image%2020251117200820.png)

> If your disk doesn't have the `-part1/2/3`, it means your drive currently has no partition.

**2. Using `fdisk` on selected drive**

Enter drive with `fdisk`, in this case disk `ata-WDC_WDS240G2G0A-00JH30_200724805153`.
```bash
sudo fdisk /dev/disk/by-id/ata-WDC_WDS240G2G0A-00JH30_200724805153
```


**3. Prepping disk for nas storage**

Type `m` for helpful command.
<img src="attachments/Pasted%20image%2020251117201505.png" width="400px" />

- Delete all partition with `d`.
- Create new large partition with `n`.
- Apply changes with `w`

**IMPORTANT**: make sure you are in the correct disk because this is a destructive action.


**4. Create filesystem to partition (formatting the drive)**
```bash
sudo mkfs.ext4 /dev/sdb1
```
