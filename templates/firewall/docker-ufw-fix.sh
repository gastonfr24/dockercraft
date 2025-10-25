#!/bin/bash
# DockerCraft - Docker UFW Compatibility Fix
#
# Docker bypasses UFW by default. This script fixes that issue.
# Usage: sudo bash docker-ufw-fix.sh

echo "Fixing Docker + UFW compatibility..."

# Backup existing daemon.json
if [ -f /etc/docker/daemon.json ]; then
    cp /etc/docker/daemon.json /etc/docker/daemon.json.backup
    echo "Backed up existing daemon.json"
fi

# Create or update daemon.json
cat > /etc/docker/daemon.json <<EOF
{
  "iptables": true,
  "ip-forward": true,
  "ip-masq": true
}
EOF

# Update UFW configuration
echo "# Docker + UFW compatibility" >> /etc/ufw/after.rules
echo "*filter" >> /etc/ufw/after.rules
echo ":DOCKER-USER - [0:0]" >> /etc/ufw/after.rules
echo "-A DOCKER-USER -j RETURN -s 10.0.0.0/8" >> /etc/ufw/after.rules
echo "-A DOCKER-USER -j RETURN -s 172.16.0.0/12" >> /etc/ufw/after.rules
echo "-A DOCKER-USER -j RETURN -s 192.168.0.0/16" >> /etc/ufw/after.rules
echo "COMMIT" >> /etc/ufw/after.rules

# Restart services
systemctl restart docker
ufw reload

echo "Docker + UFW compatibility fixed!"
echo "Note: Restart your containers for changes to take effect"

