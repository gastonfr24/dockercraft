# 🚨 DockerCraft - Alert Notifications

This guide explains how to configure and use alert notifications for DockerCraft server monitoring.

---

## 📋 Overview

DockerCraft includes integration with **Discord** and **Slack** webhooks to send real-time alerts when server resources exceed configured thresholds.

### Features

- ✅ Discord webhook integration
- ✅ Slack webhook integration
- ✅ Configurable thresholds (CPU, Memory, Disk)
- ✅ Multiple alert levels (info, warning, error)
- ✅ Automatic or manual alert triggering
- ✅ Rich formatting with metrics and emojis

---

## 🚀 Quick Start

### 1. Get Webhook URLs

#### Discord

1. Open Discord Server Settings
2. Go to **Integrations** > **Webhooks**
3. Click **New Webhook**
4. Copy the webhook URL

Example: `https://discord.com/api/webhooks/123456789/abcdefg...`

#### Slack

1. Visit https://api.slack.com/messaging/webhooks
2. Create a new Slack App for your workspace
3. Enable **Incoming Webhooks**
4. Create webhook for desired channel
5. Copy the webhook URL

Example: `https://hooks.slack.com/services/T00000000/B00000000/XXX...`

### 2. Configure Environment Variables

Create `.env.alerts` file (this file is git-ignored for security):

```bash
# Copy from example
cp .env.alerts.example .env.alerts

# Edit with your URLs
nano .env.alerts
```

Example `.env.alerts`:

```bash
# Discord webhook URL
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_WEBHOOK_ID/YOUR_WEBHOOK_TOKEN"

# Slack webhook URL
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"

# Thresholds (optional)
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_MEMORY=80
ALERT_THRESHOLD_DISK=85

# Alert type: discord, slack, or both
ALERT_TYPE="both"
```

### 3. Test Alerts

Send a test alert:

```bash
source .env.alerts

./scripts/send-alert.sh \
    -c "minecraft-server" \
    -m "Test alert from DockerCraft" \
    --cpu 85 \
    --memory 75 \
    --disk 60 \
    -l info
```

---

## 📚 Usage Guides

### Manual Alerts

Send alerts manually with `send-alert.sh`:

```bash
# Basic alert
./scripts/send-alert.sh -m "Server is experiencing issues"

# Alert with metrics
./scripts/send-alert.sh \
    -c "minecraft-server" \
    -m "High resource usage detected" \
    --cpu 92 \
    --memory 85 \
    --disk 78 \
    -l warning

# Discord only
./scripts/send-alert.sh \
    -t discord \
    -m "Server backup completed" \
    -l info

# Slack only
./scripts/send-alert.sh \
    -t slack \
    -m "Server crashed" \
    -l error
```

### Automatic Monitoring with Alerts

Use the integrated monitoring script:

```bash
# Source environment variables
source .env.alerts

# Run monitoring with automatic alerts
./scripts/monitor-with-alerts.sh
```

This script will:
1. Monitor all Minecraft containers
2. Check resource usage against thresholds
3. Automatically send alerts if thresholds exceeded
4. Log everything to `logs/monitor.log`

---

## ⏰ Automated Monitoring

### Using Cron

Add to crontab (`crontab -e`):

```bash
# Monitor every 5 minutes
*/5 * * * * cd /path/to/dockercraft && source .env.alerts && ./scripts/monitor-with-alerts.sh >> logs/cron.log 2>&1

# Monitor every 15 minutes
*/15 * * * * cd /path/to/dockercraft && source .env.alerts && ./scripts/monitor-with-alerts.sh >> logs/cron.log 2>&1

# Monitor hourly
0 * * * * cd /path/to/dockercraft && source .env.alerts && ./scripts/monitor-with-alerts.sh >> logs/cron.log 2>&1
```

### Using systemd Timer

Create service file `/etc/systemd/system/dockercraft-monitor.service`:

```ini
[Unit]
Description=DockerCraft Server Monitoring
After=docker.service

[Service]
Type=oneshot
WorkingDirectory=/path/to/dockercraft
EnvironmentFile=/path/to/dockercraft/.env.alerts
ExecStart=/path/to/dockercraft/scripts/monitor-with-alerts.sh

[Install]
WantedBy=multi-user.target
```

Create timer file `/etc/systemd/system/dockercraft-monitor.timer`:

```ini
[Unit]
Description=DockerCraft Monitoring Timer
Requires=dockercraft-monitor.service

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min

[Install]
WantedBy=timers.target
```

Enable and start:

```bash
sudo systemctl enable --now dockercraft-monitor.timer
sudo systemctl status dockercraft-monitor.timer
```

---

## 🎨 Alert Formats

### Discord

Discord alerts use **embeds** with color coding:

- 🔵 **Blue** (info): General information
- 🟡 **Yellow** (warning): Resource thresholds exceeded
- 🔴 **Red** (error): Critical errors

Example:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⚠️ DockerCraft Alert

Resource threshold exceeded for container 'minecraft-server'

Container:    minecraft-server
CPU Usage:    92%
Memory Usage: 85%
Disk Usage:   78%

Alert Level: WARNING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Slack

Slack alerts use **attachments** with sidebar color:

- Blue (info)
- Yellow (warning)
- Red (error)

---

## 🔧 Configuration Reference

### send-alert.sh Options

| Option | Description | Default |
|--------|-------------|---------|
| `-t, --type` | Alert type: discord, slack, both | both |
| `-l, --level` | Alert level: info, warning, error | warning |
| `-c, --container` | Container name | - |
| `-m, --message` | Alert message (required) | - |
| `--cpu` | CPU usage percentage | - |
| `--memory` | Memory usage percentage | - |
| `--disk` | Disk usage percentage | - |
| `-d, --discord-url` | Discord webhook URL | $DISCORD_WEBHOOK_URL |
| `-s, --slack-url` | Slack webhook URL | $SLACK_WEBHOOK_URL |
| `-q, --quiet` | Quiet mode | false |
| `-h, --help` | Show help | - |

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `DISCORD_WEBHOOK_URL` | Discord webhook URL | - |
| `SLACK_WEBHOOK_URL` | Slack webhook URL | - |
| `ALERT_THRESHOLD_CPU` | CPU warning threshold (%) | 80 |
| `ALERT_THRESHOLD_MEMORY` | Memory warning threshold (%) | 80 |
| `ALERT_THRESHOLD_DISK` | Disk warning threshold (%) | 85 |
| `ALERT_TYPE` | Default alert type | both |
| `ALERT_LEVEL` | Default alert level | warning |

---

## 🛠️ Troubleshooting

### "curl: command not found"

Install curl:

```bash
# Ubuntu/Debian
sudo apt install curl

# CentOS/RHEL
sudo yum install curl

# macOS
brew install curl
```

### "jq: command not found"

Install jq:

```bash
# Ubuntu/Debian
sudo apt install jq

# CentOS/RHEL
sudo yum install jq

# macOS
brew install jq
```

### Webhook URLs not working

1. Verify URLs are correct and not expired
2. Check webhook permissions in Discord/Slack
3. Test with curl directly:

```bash
# Discord test
curl -X POST "$DISCORD_WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d '{"content": "Test message"}'

# Slack test
curl -X POST "$SLACK_WEBHOOK_URL" \
    -H "Content-Type: application/json" \
    -d '{"text": "Test message"}'
```

### Alerts not sending automatically

1. Check `.env.alerts` exists and is sourced
2. Verify webhook URLs are set in environment
3. Check cron/systemd timer is running:

```bash
# Cron
crontab -l

# systemd
systemctl status dockercraft-monitor.timer
```

4. Check logs:

```bash
# Monitoring logs
tail -f logs/monitor.log

# Cron logs
tail -f logs/cron.log

# systemd logs
journalctl -u dockercraft-monitor.service -f
```

---

## 🔐 Security Best Practices

1. ✅ Never commit `.env.alerts` to version control
2. ✅ Treat webhook URLs as secrets
3. ✅ Rotate webhook URLs if compromised
4. ✅ Use file permissions to protect `.env.alerts`:

```bash
chmod 600 .env.alerts
```

5. ✅ Use separate webhooks for dev/staging/prod environments

---

## 📖 Examples

### Example 1: High CPU Alert

```bash
./scripts/send-alert.sh \
    -c "minecraft-lobby" \
    -m "CPU usage critically high" \
    --cpu 95 \
    -l error
```

### Example 2: Memory Warning

```bash
./scripts/send-alert.sh \
    -c "minecraft-survival" \
    -m "Memory usage above threshold" \
    --memory 88 \
    -l warning
```

### Example 3: Disk Space Low

```bash
./scripts/send-alert.sh \
    -c "minecraft-creative" \
    -m "Disk space running low" \
    --disk 90 \
    -l warning
```

### Example 4: Server Status Update

```bash
./scripts/send-alert.sh \
    -c "minecraft-server" \
    -m "Server backup completed successfully" \
    -l info \
    -t discord
```

---

## 📚 Related Documentation

- [Monitoring Guide](MONITORING.md) - Complete monitoring documentation
- [Performance Guide](PERFORMANCE.md) - Performance optimization tips
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues and solutions

---

**Last Updated:** 2025-10-25  
**Version:** 1.0.0

