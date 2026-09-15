### pre-requisite
- [guide - create non-root user in linux](guide%20-%20create%20non-root%20user%20in%20linux.md)

### setup code server

**1. install code server**
```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

**2. restart code server on reboot**
```bash
sudo systemctl enable --now code-server@$USER
```

### setup tailscale

**1. install tailscale**
```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

**2. change bind address to tailscale ip and remove password**
```bash
sudo vim ~/.config/code-server/config.yaml
```

change to this
```yaml
bind-addr: <100.x.y.z address>:8080
auth: none
cert: false
```

restart code server
```bash
sudo systemctl restart code-server@$USER
```

you can now access it at `http://100.x.y.z:8080/`

### setup https with caddy

**1. run this to get machine name**
```bash
tailscale cert

# output
Usage: tailscale cert [flags] <domain>
For domain, use "machine-name.tailnet-name.ts.net"
```

**2. generate https cert with tailscale**
```bash
sudo tailscale cert machine-name.tailnet-name.ts.net
```

it might take a while but should output this
```
Wrote public cert to machine-name.tailnet-name.ts.net.crt
Wrote private key to machine-name.tailnet-name.ts.net.key
```

**3. install caddy**
```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo chmod o+r /usr/share/keyrings/caddy-stable-archive-keyring.gpg
sudo chmod o+r /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy
```

**4. update caddyfile**
```Caddyfile
machine-name.tailnet-name.ts.net {
  reverse_proxy 10.x.y.z:8080
}
```

**5. allow the `caddy` user access to fetch certificates**

add this at the end of line in `/etc/default/tailscaled`
```
TS_PERMIT_CERT_UID=caddy
```

**6. reload tailscaled and caddy**
```bash
sudo systemctl reload tailscaled
sudo systemctl reload caddy
```
