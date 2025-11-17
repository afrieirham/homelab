
**Why?**
Mounting drives let you "see" the contents of the drive.

**Pre-requisite**
1. All drives has filesystem formatted. [Learn more](guide%20-%20how%20to%20create%20disk%20partition%20and%20format%20with%20filesystem.md)

**1. Create a mount point**

This is just a directory.
```shell
mkdir /mnt/disk1
```

**2.a. Simple temporary approach**

Mount the drive partition.
```shell
mount /dev/sda1 /mnt/disk1
```

**IMPORTANT**: it's important to use drive partition instead of the actual drive. `sda1` not `sda`

**2.b. Auto mount on boot (permanent approach)**

Get disk id of the disks you want to mount automatically.
```bash
ls -l /dev/disk/by-id
```

![Pasted image 20251117211801.png](attachments/Pasted%20image%2020251117211801.png)

> You can you `by-id`, `by-uuid`, `by-partuuid`, etc. But IMO `by-id` is the best since you can also see the actual serial number and disk type.

Edit `/etc/fstab` file and add the mount config in this format.

```
/path/to/disk/by-id /path/to/mount-point <filesystem> defaults 0 0
```

> There's different settings you can use for the `defaults 0 0` part but for most cases the defaults is the way to go. Watch more here.

**IMPORTANT:** please make sure to only add your config at the bottom. do not edit any existing config or your pc might not boot up.

This is my final config file.
![Pasted image 20251117212304.png](attachments/Pasted%20image%2020251117212304.png)

**3. Verify disks are mounted**

Before we mount the disk, we can run this command to check what drive is currently mounted.
```bash
df -h
```

As you can see, we have no disk mounted on `/mnt/disk1` directory we created before.
![Pasted image 20251117212452.png](attachments/Pasted%20image%2020251117212452.png)

To mount disk, you can use this command.
```
mount -a
```

![Pasted image 20251117212618.png](attachments/Pasted%20image%2020251117212618.png)

To verify, use the `df -h` command again.
![Pasted image 20251117212707.png](attachments/Pasted%20image%2020251117212707.png)

Now you can see we have 3 new disks mounted. 

You can reboot you machine and run the command again to make sure it is mounted on boot.

