Source: https://pimylifeup.com/raspberry-pi-cockpit/

**1. Populate Current Terminal Session**
```bash
. /etc/os-release
```

Output Sample
```bash
afrieirham@raspberrypi:~ $ cat /etc/os-release
PRETTY_NAME="Debian GNU/Linux 13 (trixie)"
NAME="Debian GNU/Linux"
VERSION_ID="13"
VERSION="13 (trixie)"
VERSION_CODENAME=trixie
DEBIAN_VERSION_FULL=13.1
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"
```

**2. Add backport repository**
```bash
echo "deb http://deb.debian.org/debian ${VERSION_CODENAME}-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
```

**3. Update apt package after adding new repository**
```bash
sudo apt update
```

**4. Install cockpit**
```bash
sudo apt install -t ${VERSION_CODENAME}-backports cockpit
```

> `-t` is needed to tell apt to download cockpit from backport repository.

**5. (Optional) Allow http connection**

Add this to `/etc/cockpit/cockpit.conf`
```ini
[WebService]
AllowUnencrypted=true
```

Then restart cockpit
```bash
systemctl restart cockpit
```

> this is needed if you want to use nginx domain proxy but in http

**6. Done**

You can now access cockpit web ui on port 9090 or <localdomain>.
