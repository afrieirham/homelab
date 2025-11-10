
**Why?**
Mounting drives let you "see" the contents of the drive.

**Pre-requisite**
1. All drives has filesystem formatted. [Learn more](guide%20-%20how%20to%20create%20disk%20partition%20and%20format%20with%20filesystem.md)

**1. Simple temporary approach**

Create mount point, basically a directory
```shell
mkdir /mnt/disk1
```

Mount the drive partition.
```shell
mount /dev/sda1 /mnt/disk1
```

**IMPORTANT**: it's important to use drive partition instead of the actual drive

**2. Auto mount on boot (permanent approach)**

