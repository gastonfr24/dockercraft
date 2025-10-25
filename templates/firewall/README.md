# 🔥 Firewall Templates

Pre-configured firewall rules for DockerCraft deployment.

---

## 📋 Quick Start

### Ubuntu/Debian (UFW)

```bash
sudo bash templates/firewall/ufw.rules
```

### CentOS/RHEL/Fedora (firewalld)

```bash
sudo bash templates/firewall/firewalld.rules
```

### Generic (iptables)

```bash
sudo bash templates/firewall/iptables.rules
```

---

## 🐳 Docker + UFW Fix

Docker bypasses UFW by default. Fix this:

```bash
sudo bash templates/firewall/docker-ufw-fix.sh
```

---

## ⚙️ Configuration

### Adjust Network

Edit the scripts to match your network:

```bash
# Change this line in the templates:
192.168.1.0/24  # Your local network
```

### Allow Additional Ports

```bash
# UFW
sudo ufw allow PORT/tcp comment "Description"

# firewalld
sudo firewall-cmd --permanent --add-port=PORT/tcp
sudo firewall-cmd --reload

# iptables
sudo iptables -A INPUT -p tcp --dport PORT -j ACCEPT
```

---

## 🔒 Security Best Practices

1. **Never expose RCON publicly**
   - Only allow from trusted networks
   - Use VPN for remote access

2. **Keep firewall updated**
   ```bash
   sudo apt update && sudo apt upgrade  # UFW
   sudo yum update firewalld           # firewalld
   ```

3. **Monitor logs**
   ```bash
   sudo tail -f /var/log/ufw.log       # UFW
   sudo journalctl -u firewalld -f     # firewalld
   ```

4. **Test firewall rules**
   ```bash
   # Test from another machine
   telnet YOUR_SERVER_IP 25565  # Should connect
   telnet YOUR_SERVER_IP 25575  # Should timeout (if not local)
   ```

---

## 🧪 Verification

### Check Firewall Status

```bash
# UFW
sudo ufw status verbose

# firewalld
sudo firewall-cmd --list-all

# iptables
sudo iptables -L -n -v
```

### Test Connectivity

```bash
# Minecraft port (should work)
nc -zv YOUR_SERVER_IP 25565

# RCON port (should only work from local network)
nc -zv YOUR_SERVER_IP 25575
```

---

## 📚 Related Documentation

- [Security Guide](../../docs/SECURITY.md)
- [Docker Documentation](https://docs.docker.com/network/iptables/)
- [UFW Documentation](https://help.ubuntu.com/community/UFW)
- [firewalld Documentation](https://firewalld.org/documentation/)

