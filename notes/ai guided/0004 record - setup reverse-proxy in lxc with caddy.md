# Cockpit Reverse Proxy Configuration Record

## 1. System Topology
* **Host Engine:** Debian 13 (Trixie) running Cockpit on physical port `9090`.
* **Proxy Substrate:** Isolated Incus system container (`reverse-proxy`) sitting on the private `incusbr0` NAT subnet.
* **Internal Routing Target:** Host virtual interface gateway address (`10.204.123.1`).
* **Container IP:** `10.204.123.82` (Managed internally by Incus DHCP).

---

## 2. Ingress Traffic Mapping (Host to Container)
Because the proxy container uses a private `10.x.x.x` network segment invisible to the physical local area network (LAN), standard web ingress ports (80 and 443) are bound directly to the host machine interface and shunted into the container payload space:

```bash
# Bind Host TCP port 80 to Container TCP port 80
incus config device add reverse-proxy proxy80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80

# Bind Host TCP port 443 to Container TCP port 443
incus config device add reverse-proxy proxy443 proxy listen=tcp:0.0.0.0:443 connect=tcp:127.0.0.1:443
```

---

## 3. Reverse Proxy Configuration (Caddyfile)
File location inside `reverse-proxy` container: `/etc/caddy/Caddyfile`

The configuration uses explicit unencrypted HTTP routing to bypass local browser TLS handshake errors (`ERR_SSL_PROTOCOL_ERROR`) across internal development domains. Caddy securely transports traffic to the host over local memory layers, skipping upstream certificate verification boundaries to trust Cockpit’s native self-signed engine:

```caddy
http://cockpit.deb {
    reverse_proxy https://10.204.123.1:9090 {
        transport http {
            tls_insecure_skip_verify
        }
    }
}
```

---

## 4. Host Security & CSRF Access Adjustments
By default, Cockpit actively blocks incoming connections that originate from unexpected proxy host headers via cross-site forgery mitigation rules. The host was adjusted to explicitly authorize the local domain.

File location on the Debian host: `/etc/cockpit/cockpit.conf`

```ini
[WebService]
Origins = https://cockpit.deb http://cockpit.deb
ProtocolHeader = X-Forwarded-Proto
```

### Apply Service Refresh Sequence (Executed on Host):
```bash
sudo systemctl restart cockpit
```

---

## 5. Local DNS Architecture Mapping
To access the panel without entering port descriptors, local network name resolution layers (e.g., Pi-hole, AdGuard Home, or local DNS server entries) route queries as follows:

*   **Target DNS Domain:** `cockpit.deb`
*   **Target IP Address:** Your **Physical Server Host LAN IP** (e.g., `192.168.1.50`). 

*Note: Do not point the DNS record to the internal container IP (`10.204.123.82`). Traffic must hit the physical server interface first so Incus can shunk it over ports 80/443 directly into Caddy.*
