**Portainer issue as of 12th November 2025**

> As of this writing, there's a weird issue where you can't connect to local docker environment if you're on debian 13. 
> 
> Here's how to fix → https://github.com/portainer/portainer/issues/12925#issuecomment-3516549977


Edit docker service
```bash
systemctl edit docker.service
```

Add this part above the line `### Lines below this comment will be discarded`
```ini
[Service]  
	Environment=DOCKER_MIN_API_VERSION=1.24
```

Restart docker
```bash
systemctl restart docker
```
