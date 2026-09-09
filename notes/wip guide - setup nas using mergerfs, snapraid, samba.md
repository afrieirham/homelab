
TLDR
- mergerfs - pool multiple disk into 1
- snapraid - snapshot parity
- samba - network share

### 1. prepare disk

wipe and partition disk to any filesystem (ext4/xfs should work)
- [guide - how to create disk partition and format with filesystem](guide%20-%20how%20to%20create%20disk%20partition%20and%20format%20with%20filesystem.md)

mount all disk in `/etc/fstab`
- [guide - how to mount or unmount drives in linux](guide%20-%20how%20to%20mount%20or%20unmount%20drives%20in%20linux.md)

### 2. setup mergerfs to pool multiple disks

install mergerfs
- [guide - install and setup mergerfs auto-update](guide%20-%20install%20and%20setup%20mergerfs%20auto-update.md)

create `/mnt/storage` and add this in `/etc/fstab`
```
/mnt/disk* /mnt/storage mergerfs cache.files=off,category.create=pfrd,func.getattr=newest,dropcacheonclose=false,minfreespace=200G,branches-mount-timeout=30,branches-mount-timeout-fail=true,x-systemd.mount-timeout=45s,fsname=mergerfs 0 0
```

this will pool all data disks `/mnt/disk*` into 1 mount point `/mnt/storage`

**2. Setup snapraid**

install snapraid
- [guide - install and setup snapraid auto-update](guide%20-%20install%20and%20setup%20snapraid%20auto-update.md)

configure snapraid
...

**3. Setup samba**
https://www.linuxserver.io/blog/2017-06-24-the-perfect-media-server-2017#setting-up-the-drives-using-mergerfs

