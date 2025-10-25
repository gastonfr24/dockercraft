# 🔒 DockerCraft - Security Guide

Comprehensive security guide for DockerCraft Minecraft server deployment.

---

## 🎯 Quick Security Checklist

Before deploying to production:

- [ ] Change default RCON password
- [ ] Use non-root user in containers
- [ ] Enable firewall (UFW/firewalld)
- [ ] Keep Docker and images updated
- [ ] Use secrets for sensitive data
- [ ] Enable Docker Content Trust
- [ ] Regular backups configured
- [ ] Monitor logs for suspicious activity
- [ ] Limit container resources
- [ ] Use private networks

---

## 🔐 Authentication & Passwords

### RCON Password

**Critical:** Always change the default RCON password!

```bash
# .env
RCON_PASSWORD="your-strong-password-here"
```

**Best Practices:**
- Use 16+ characters
- Mix uppercase, lowercase, numbers, symbols
- Don't reuse passwords
- Store in password manager
- Rotate regularly

### Minecraft Operator Passwords

If using authentication plugins:

```bash
# Use strong passwords for ops
/op player password:strong-password-123
```

---

## 🐳 Docker Security

### 1. Run as Non-Root User

The itzg/minecraft-server image already runs as non-root (UID 1000), but ensure this in your own builds:

```dockerfile
# Dockerfile
USER minecraft:minecraft
```

### 2. Read-Only Root Filesystem

```yaml
# docker-compose.yml
services:
  minecraft:
    read_only: true
    tmpfs:
      - /tmp
      - /run
```

### 3. Resource Limits

Prevent DoS attacks:

```yaml
services:
  minecraft:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          cpus: '1'
          memory: 2G
```

### 4. Network Isolation

```yaml
networks:
  minecraft:
    driver: bridge
    internal: false  # Set to true for backend services
```

### 5. Secrets Management

Never store secrets in compose files:

```bash
# Use Docker secrets
docker secret create rcon_password ./rcon_pass.txt

# docker-compose.yml
services:
  minecraft:
    secrets:
      - rcon_password
```

---

## 🔥 Firewall Configuration

### UFW (Ubuntu/Debian)

```bash
# Allow Minecraft port
sudo ufw allow 25565/tcp comment "Minecraft"

# Allow RCON (only from trusted IPs!)
sudo ufw allow from 192.168.1.0/24 to any port 25575

# Enable firewall
sudo ufw enable
```

### firewalld (CentOS/RHEL)

```bash
# Allow Minecraft
sudo firewall-cmd --permanent --add-port=25565/tcp
sudo firewall-cmd --permanent --add-service=minecraft

# RCON restricted
sudo firewall-cmd --permanent --add-rich-rule='
  rule family="ipv4" 
  source address="192.168.1.0/24" 
  port protocol="tcp" port="25575" accept'

# Reload
sudo firewall-cmd --reload
```

### iptables

```bash
# Allow Minecraft
iptables -A INPUT -p tcp --dport 25565 -j ACCEPT

# RCON restricted
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 25575 -j ACCEPT
iptables -A INPUT -p tcp --dport 25575 -j DROP
```

---

## 🌐 Network Security

### Port Exposure

Only expose necessary ports:

```yaml
services:
  minecraft:
    ports:
      - "25565:25565"  # Game port
      # DO NOT expose RCON publicly:
      # - "25575:25575"  # ❌ DANGEROUS
```

### Reverse Proxy (Recommended for Web Panels)

Use nginx/Caddy for web interfaces:

```nginx
# nginx.conf
server {
    listen 443 ssl;
    server_name mc.example.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Fail2Ban Integration

Protect against brute force:

```ini
# /etc/fail2ban/jail.local
[minecraft]
enabled = true
port = 25565
filter = minecraft
logpath = /var/log/minecraft/server.log
maxretry = 5
bantime = 3600
```

---

## 🛡️ Host System Hardening

### 1. Keep System Updated

```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade -y

# CentOS/RHEL
sudo yum update -y
```

### 2. Disable Unnecessary Services

```bash
# List services
systemctl list-unit-files --type=service

# Disable unneeded
sudo systemctl disable SERVICE_NAME
```

### 3. SSH Hardening

```bash
# /etc/ssh/sshd_config
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 2222  # Non-standard port
```

### 4. Automatic Security Updates

```bash
# Ubuntu/Debian
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

---

## 📦 Container Image Security

### 1. Use Official Images

Always use official itzg/minecraft-server image:

```yaml
services:
  minecraft:
    image: itzg/minecraft-server:java21-alpine  # Alpine = smaller attack surface
```

### 2. Pin Image Versions

```yaml
services:
  minecraft:
    image: itzg/minecraft-server:java21-alpine@sha256:abc123...
```

### 3. Scan for Vulnerabilities

```bash
# Using Trivy
docker run aquasec/trivy image itzg/minecraft-server:latest

# Using Docker Scout
docker scout cves itzg/minecraft-server:latest
```

### 4. Enable Docker Content Trust

```bash
export DOCKER_CONTENT_TRUST=1
docker pull itzg/minecraft-server:latest
```

---

## 🔍 Monitoring & Logging

### Centralized Logging

```yaml
services:
  minecraft:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### Security Monitoring

Monitor for:
- Failed login attempts
- Unusual resource spikes
- Unexpected network connections
- File system changes

```bash
# Check logs
docker logs minecraft-server | grep -i "error\|fail\|attack"
```

---

## 🔄 Backup & Recovery

### Automated Backups

```bash
# Cron job
0 2 * * * /path/to/dockercraft/scripts/backup.sh
```

### Backup Encryption

```bash
# Encrypt backups
tar czf - /data | gpg --encrypt --recipient your@email.com > backup.tar.gz.gpg
```

### Off-site Backups

```bash
# rsync to remote server
rsync -avz --delete /backups/ user@backup-server:/minecraft-backups/
```

---

## 🚨 Incident Response

### If Compromised

1. **Immediately:**
   - Stop all containers: `docker compose down`
   - Isolate server from network
   - Take snapshot/backup for forensics

2. **Investigate:**
   - Check logs: `docker logs minecraft-server`
   - Review recent changes
   - Check for unknown users/files

3. **Remediate:**
   - Change all passwords
   - Update all systems
   - Restore from known-good backup
   - Review and apply security hardening

4. **Prevent:**
   - Apply lessons learned
   - Update security policies
   - Implement additional monitoring

---

## 📋 Security Audit Checklist

### Monthly

- [ ] Review access logs
- [ ] Check for unauthorized changes
- [ ] Verify backup integrity
- [ ] Update systems and images
- [ ] Review user permissions

### Quarterly

- [ ] Penetration testing
- [ ] Security policy review
- [ ] Staff security training
- [ ] Disaster recovery drill

### Annually

- [ ] Full security audit
- [ ] Policy updates
- [ ] Certificate rotation
- [ ] Hardware assessment

---

## 🔗 Additional Resources

- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker)
- [OWASP Container Security](https://owasp.org/www-project-docker-top-10/)
- [Minecraft Server Security Guide](https://minecraft.fandom.com/wiki/Tutorials/Server_startup_script)

---

## 📞 Reporting Security Issues

Found a security vulnerability?

**DO NOT** open a public GitHub issue.

Instead, email: security@example.com (replace with your email)

Include:
- Description of vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

We aim to respond within 48 hours.

---

**Last Updated:** 2025-10-25  
**Version:** 1.0.0

