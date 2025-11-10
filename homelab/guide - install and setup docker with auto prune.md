
**1. Install docker**
https://docs.docker.com/engine/install/debian/#install-using-the-repository

**2. Setup auto prune**

One liner script
```bash
sudo bash -c 'echo "docker system prune -af --filter \"until=\$((30*24))h\"" > /usr/local/bin/docker-prune.sh'
```

Add script manually

1. Create docker prune script
```bash
vim /usr/local/bin/docker-prune.sh
```

2. Paste docker prune script
```bash
docker system prune -af --filter "until=$((30*24))h"
```


**3. Give +x permission**
```bash
chmod +x /usr/local/bin/docker-prune.sh
```

**4. Add cron job at 3am**
```bash
0 3 * * * /usr/local/bin/docker-prune.sh >> /var/log/docker-prune.log 2>&1
```