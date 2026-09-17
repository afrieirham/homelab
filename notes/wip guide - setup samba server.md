https://www.youtube.com/watch?v=7Q0mnAT1MRg

**1. install samba**
```bash
sudo apt install samba
```

**2. create samba group**
```bash
sudo groupadd samba
```

**3. add user to group**
```bash
sudo usermod -aG samba <user>
```

### Preparing samba directory

**1. make samba directory owned by samba group**
```bash
chown -R :samba /path/to/directory
```

**2. make sure user and group has read/write access, others only read**
```bash
chmod -R u+rwX,g+rwX,o+rX /path/to/directory
```

**3. make sure new files/folders created, samba group will be the owner**
```bash
find /path/to/directory -type d -exec chmod g+s {} ;
```

### Configure samba

**1. backup existing samba config**
```bash
mv /etc/samba/smb.conf /etc/samba/smb.conf.backup
```

