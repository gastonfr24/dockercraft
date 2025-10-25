# 📊 DockerCraft - Metrics API Documentation

Documentation for exporting server metrics in JSON format for external frontends/dashboards.

---

## 🎯 Overview

DockerCraft provides monitoring scripts that export metrics in JSON format, designed to be consumed by external applications (web dashboards, mobile apps, etc.).

**Note:** DockerCraft is a Docker template only. Web dashboards and APIs are separate projects.

---

## 📡 Exporting Metrics

### JSON Output

```bash
# Export current metrics to JSON
./scripts/monitor.sh --json > metrics.json

# Continuous monitoring with JSON output
./scripts/monitor.sh --json | tee metrics.json
```

### Example JSON Output

```json
{
  "container": "minecraft-server",
  "timestamp": "2025-10-25T22:45:00Z",
  "cpu_percent": 45.2,
  "memory": {
    "used": "3.2GiB",
    "total": "4GiB",
    "percent": 80.0
  },
  "disk": {
    "percent": "65",
    "usage": "15GB/50GB"
  },
  "network_io": "150MB / 80MB",
  "block_io": "2.1GB / 1.5GB",
  "uptime": "2d 14h 32m",
  "thresholds": {
    "cpu_warn": 80,
    "mem_warn": 80,
    "disk_warn": 85
  }
}
```

---

## 🔄 Real-time Metrics API

### HTTP Server (Simple Approach)

Serve metrics via HTTP for frontend consumption:

```bash
# Option 1: Python HTTP Server
cd /path/to/dockercraft
python3 -m http.server 8080

# Access metrics at:
# http://localhost:8080/metrics.json
```

### Automated Updates

Update metrics periodically:

```bash
# Cron job - update every minute
* * * * * cd /path/to/dockercraft && ./scripts/monitor.sh --json > metrics.json
```

### systemd Timer

```ini
# /etc/systemd/system/dockercraft-metrics.service
[Unit]
Description=DockerCraft Metrics Export

[Service]
Type=oneshot
WorkingDirectory=/path/to/dockercraft
ExecStart=/path/to/dockercraft/scripts/monitor.sh --json
StandardOutput=file:/path/to/dockercraft/metrics.json

# /etc/systemd/system/dockercraft-metrics.timer
[Unit]
Description=DockerCraft Metrics Timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min

[Install]
WantedBy=timers.target
```

Enable:
```bash
sudo systemctl enable --now dockercraft-metrics.timer
```

---

## 🌐 Integration with External Frontend

### Frontend Integration (Example)

Your external frontend can fetch metrics:

```javascript
// React/Vue/Angular example
async function fetchMetrics() {
  const response = await fetch('http://server-ip:8080/metrics.json');
  const data = await response.json();
  
  // Update dashboard with data
  updateCPU(data.cpu_percent);
  updateMemory(data.memory.percent);
  updateUptime(data.uptime);
}

// Poll every 30 seconds
setInterval(fetchMetrics, 30000);
```

### API Endpoints (If using REST API)

If you have a separate API project:

```
GET /api/servers/:id/metrics
Response:
{
  "server_id": "minecraft-1",
  "metrics": {
    "cpu_percent": 45.2,
    "memory_percent": 80.0,
    ...
  },
  "timestamp": "2025-10-25T22:45:00Z"
}
```

---

## 📈 Historical Metrics

### Store Historical Data

```bash
# Append to JSONL file (JSON Lines)
./scripts/monitor.sh --json >> metrics-history.jsonl

# Add timestamp
echo "$(date -Iseconds) $(./scripts/monitor.sh --json)" >> metrics-log.txt
```

### Example JSONL

```jsonl
{"timestamp":"2025-10-25T22:45:00Z","cpu_percent":45.2,"memory":{"percent":80}}
{"timestamp":"2025-10-25T22:46:00Z","cpu_percent":47.8,"memory":{"percent":82}}
{"timestamp":"2025-10-25T22:47:00Z","cpu_percent":43.1,"memory":{"percent":79}}
```

### Query Historical Data

```bash
# Last 10 entries
tail -n 10 metrics-history.jsonl | jq '.'

# Filter by CPU > 80%
jq 'select(.cpu_percent > 80)' metrics-history.jsonl

# Average CPU usage
jq -s 'map(.cpu_percent) | add / length' metrics-history.jsonl
```

---

## 🔌 Webhook Integration

### Send Metrics to External API

```bash
#!/bin/bash
# send-metrics-webhook.sh

METRICS=$(./scripts/monitor.sh --json)
API_ENDPOINT="https://your-api.com/metrics"

curl -X POST "$API_ENDPOINT" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d "$METRICS"
```

### Cron Integration

```bash
# Send metrics every 5 minutes
*/5 * * * * /path/to/send-metrics-webhook.sh
```

---

## 📊 Metrics Available

| Metric | Type | Description |
|--------|------|-------------|
| `container` | string | Container name |
| `timestamp` | ISO 8601 | Metric timestamp |
| `cpu_percent` | float | CPU usage percentage |
| `memory.used` | string | Memory used (human readable) |
| `memory.total` | string | Total memory |
| `memory.percent` | float | Memory usage percentage |
| `disk.percent` | string | Disk usage percentage |
| `disk.usage` | string | Disk usage (human readable) |
| `network_io` | string | Network I/O (RX / TX) |
| `block_io` | string | Block I/O (Read / Write) |
| `uptime` | string | Container uptime |
| `thresholds` | object | Warning thresholds |

---

## 🔐 Security Considerations

### Protect Metrics Endpoint

```nginx
# nginx example
location /metrics.json {
    # Require authentication
    auth_basic "Metrics";
    auth_basic_user_file /etc/nginx/.htpasswd;
    
    # Or IP whitelist
    allow 192.168.1.0/24;
    deny all;
}
```

### API Token

```bash
# Add authentication to webhook
curl -X POST "$API_ENDPOINT" \
  -H "Authorization: Bearer $API_TOKEN" \
  -d "$METRICS"
```

---

## 📝 Example Integration Architectures

### Architecture 1: Direct HTTP Access

```
Frontend App ──HTTP GET──> metrics.json (served by simple HTTP server)
```

### Architecture 2: Via REST API

```
Docker Server ──cron──> send metrics ──webhook──> REST API ──> Database
                                                        │
Frontend App ──HTTP GET──> REST API ────────────────────┘
```

### Architecture 3: Real-time with WebSocket

```
Docker Server ──> Metrics collector ──> WebSocket server ──> Frontend App
```

---

## 🛠️ Tools & Libraries

### Frontend Frameworks
- **React**: recharts, victory, chart.js
- **Vue**: vue-chartjs, apexcharts
- **Angular**: ng2-charts, plotly

### Backend APIs
- **Node.js**: Express + Socket.io
- **Python**: FastAPI + WebSockets
- **Go**: Gin + Gorilla WebSocket

### Data Storage
- **Time-series**: InfluxDB, Prometheus, TimescaleDB
- **NoSQL**: MongoDB, Redis
- **SQL**: PostgreSQL with TimescaleDB extension

---

## 📚 Related Documentation

- [Monitoring Guide](MONITORING.md)
- [Alerts Guide](ALERTS.md)
- [Performance Guide](PERFORMANCE.md)
- [API Integration Guide](API_INTEGRATION.md)

---

## 💡 Example: Complete Integration

### 1. Server Side (DockerCraft)

```bash
# Export metrics every minute
* * * * * /opt/dockercraft/scripts/monitor.sh --json > /var/www/html/metrics.json
```

### 2. API Server (Separate Project)

```javascript
// Express API endpoint
app.get('/api/servers/:id/metrics', async (req, res) => {
  const metrics = await fetchMetricsFromServer(req.params.id);
  res.json(metrics);
});
```

### 3. Frontend Dashboard (Separate Project)

```javascript
// React component
function MetricsDashboard() {
  const [metrics, setMetrics] = useState(null);
  
  useEffect(() => {
    const fetchData = async () => {
      const response = await fetch('/api/servers/1/metrics');
      const data = await response.json();
      setMetrics(data);
    };
    
    fetchData();
    const interval = setInterval(fetchData, 30000);
    return () => clearInterval(interval);
  }, []);
  
  return (
    <div>
      <CPUChart data={metrics?.cpu_percent} />
      <MemoryChart data={metrics?.memory.percent} />
    </div>
  );
}
```

---

**Last Updated:** 2025-10-25  
**Version:** 1.0.0

