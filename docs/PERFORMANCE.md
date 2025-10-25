# ⚡ DockerCraft - Performance Optimization Guide

Complete guide to optimize Minecraft server performance in Docker.

---

## 🎯 Quick Wins

Apply these immediately for best performance:

```bash
# .env
MEMORY=4G
USE_AIKAR_FLAGS=true
ENABLE_ROLLING_LOGS=true
MAX_TICK_TIME=60000
VIEW_DISTANCE=8
```

**Result:** 30-50% performance improvement

---

## 🔧 JVM Optimization

### Aikar's Flags (Recommended)

Already enabled in DockerCraft by default:

```bash
USE_AIKAR_FLAGS=true
```

These flags optimize:
- Garbage collection
- Memory allocation
- CPU utilization

### Custom JVM Flags

For advanced users:

```bash
JVM_OPTS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"
```

---

## 💾 Memory Configuration

### Sizing Guidelines

| Players | Recommended RAM | Minimum RAM |
|---------|-----------------|-------------|
| 1-10    | 2-3 GB          | 1 GB        |
| 10-20   | 3-4 GB          | 2 GB        |
| 20-50   | 4-6 GB          | 3 GB        |
| 50-100  | 6-8 GB          | 4 GB        |
| 100+    | 8-16 GB         | 6 GB        |

**Note:** Add 1-2 GB for mods/plugins

### Memory Settings

```bash
# .env
MEMORY=4G           # Total memory allocation
INIT_MEMORY=1G      # Initial memory (optional)
MAX_MEMORY=4G       # Maximum memory
```

### Monitoring Memory

```bash
# Real-time monitoring
docker stats minecraft-server

# Detailed stats
./scripts/monitor.sh -c minecraft-server
```

---

## 🌍 Server Properties Optimization

### Render Distance

Balance performance vs. player experience:

```properties
# server.properties
view-distance=8          # Default: 10 (Lower = Better performance)
simulation-distance=6     # Default: 10 (Affects mob spawning)
```

**Impact:**
- `view-distance=6`: ~40% less RAM, best performance
- `view-distance=8`: ~25% less RAM, good balance
- `view-distance=10`: Default, more RAM usage

### Entity Management

```properties
max-entities-per-chunk=100
spawn-limits.monsters=70
spawn-limits.animals=15
spawn-limits.water-animals=5
spawn-limits.ambient=15
```

### Tick Settings

```properties
max-tick-time=60000     # Prevent watchdog crashes
```

---

## 🐳 Docker Optimization

### Resource Limits

Prevent resource contention:

```yaml
# docker-compose.yml
services:
  minecraft:
    deploy:
      resources:
        limits:
          cpus: '4'        # Max CPU cores
          memory: 6G       # Max memory
        reservations:
          cpus: '2'        # Minimum guaranteed
          memory: 4G
```

### CPU Affinity

Pin to specific cores for consistency:

```yaml
services:
  minecraft:
    cpuset: "0-3"  # Use cores 0, 1, 2, 3
```

### Storage Performance

Use volumes for better I/O:

```yaml
volumes:
  minecraft_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /mnt/fast-ssd/minecraft  # SSD recommended
```

---

## 📊 Performance Monitoring

### Built-in Monitoring

```bash
# Monitor all containers
./scripts/monitor.sh

# Monitor specific container
./scripts/monitor.sh -c minecraft-server

# JSON output for metrics
./scripts/monitor.sh --json > metrics.json
```

### Metrics Dashboard

View real-time metrics:

```bash
# Start monitoring dashboard (if implemented)
docker compose -f docker-compose.monitoring.yml up -d
```

### Timings Analysis

Use Paper's `/timings` command:

```
/timings on
# Play for 5-10 minutes
/timings paste
```

Analyze at: https://timings.aikar.co/

---

## 🚀 Paper Server Optimizations

### Enable Paper Optimizations

Paper is already the default in DockerCraft:

```bash
TYPE=PAPER
```

### Paper Configuration

```yaml
# paper-global.yml
chunk-loading:
  autoconfig-send-distance: true
  enable-frustum-priority: true
  
async-chunks:
  threads: 4

tick-rates:
  sensor:
    villager:
      secondarypoisensor: 80
```

### Spigot Configuration

```yaml
# spigot.yml
world-settings:
  default:
    mob-spawn-range: 6
    entity-activation-range:
      animals: 32
      monsters: 32
      misc: 16
    merge-radius:
      item: 4.0
      exp: 6.0
    view-distance: 8
```

---

## 🔌 Plugin Optimization

### Essential Performance Plugins

1. **Spark** - Performance profiler
2. **ClearLag** - Remove entities
3. **FarmControl** - Optimize farms
4. **EntityTrackerFixer** - Fix entity lag

### Install via Environment

```bash
SPIGET_RESOURCES=57242,68271  # Plugin IDs from Spigot
```

### Plugin Configuration

Optimize heavy plugins:

```yaml
# clearlag/config.yml
auto-removal:
  enabled: true
  interval: 300  # 5 minutes
  
remove-items:
  enabled: true
  radius: 64
```

---

## 💽 Disk I/O Optimization

### Use SSD Storage

**Impact:** 2-5x faster world loading

```yaml
volumes:
  minecraft_data:
    driver: local
    driver_opts:
      device: /mnt/ssd/minecraft
```

### Optimize World Files

```bash
# Reduce world size
/minecraft-world-downloader --optimize

# Prune unused chunks
/chunky trim
```

### Backup Strategy

Don't backup during peak hours:

```bash
# Crontab - backup at 3 AM
0 3 * * * /path/to/backup.sh
```

---

## 🌐 Network Optimization

### Connection Settings

```properties
# server.properties
network-compression-threshold=256  # Compress packets > 256 bytes
max-players=100                    # Limit connections
```

### Rate Limiting

Prevent DDoS:

```yaml
# docker-compose.yml
services:
  minecraft:
    sysctls:
      - net.core.somaxconn=1024
      - net.ipv4.tcp_max_syn_backlog=2048
```

### Latency Optimization

```properties
# spigot.yml
settings:
  netty-threads: 4
  timeout-time: 60
```

---

## 📈 Benchmarking

### Server Benchmark

```bash
# Run benchmark
docker exec minecraft-server /minecraft/benchmark.sh

# Compare configurations
./scripts/benchmark-compare.sh config1 config2
```

### TPS (Ticks Per Second)

Target: **20 TPS** (perfect)

```
/tps
```

- **20 TPS**: Perfect
- **18-19 TPS**: Good
- **15-17 TPS**: Acceptable
- **<15 TPS**: Need optimization

---

## 🔍 Performance Troubleshooting

### Issue: Low TPS

**Causes:**
1. Too many entities
2. Complex redstone
3. Chunk loading
4. Plugin lag

**Solutions:**
```bash
# Check timings
/timings paste

# Reduce entities
/clearlag

# Limit hoppers
/paper settings hopper-check: 8
```

### Issue: High Memory Usage

**Causes:**
1. Memory leaks
2. Too many loaded chunks
3. Large world

**Solutions:**
```bash
# Reduce view distance
view-distance=6

# Unload empty chunks faster
chunk-gc.period-in-ticks=400

# Restart server regularly
```

### Issue: High CPU Usage

**Causes:**
1. Mob spawning
2. Redstone contraptions
3. Entity AI

**Solutions:**
```properties
# Reduce mob spawn rates
spawn-limits.monsters=50

# Disable expensive AI
paper-global.yml:
  entities:
    behavior:
      pillager-patrols:
        spawn-chance: 0.05
```

---

## 🎮 Player-Specific Optimization

### Client-Side Optimization

Recommend to players:
1. **Sodium** (Fabric)
2. **OptiFine** (Forge)
3. **Faster rendering**
4. **Reduced particles**

### Server-Side Anti-Lag

```bash
# Install anti-lag plugins
SPIGET_RESOURCES=68271  # ClearLag

# Configure
max-entities-per-chunk=50
```

---

## 📊 Performance Metrics

### Target Metrics

| Metric | Target | Acceptable | Poor |
|--------|--------|------------|------|
| TPS | 20 | 18-19 | <17 |
| RAM Usage | <80% | 80-90% | >90% |
| CPU Usage | <60% | 60-80% | >80% |
| Disk I/O | <100 MB/s | 100-200 MB/s | >200 MB/s |
| Network | <10 Mbps | 10-50 Mbps | >50 Mbps |

### Monitoring Command

```bash
# Comprehensive monitoring
./scripts/monitor.sh -v

# Export metrics
./scripts/monitor.sh --json > metrics-$(date +%Y%m%d).json
```

---

## 🔗 Additional Resources

- [Aikar's Flags Explanation](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/)
- [Paper Performance Guide](https://paper.readthedocs.io/en/latest/server/configuration.html)
- [Minecraft Optimization Guide](https://www.spigotmc.org/threads/guide-server-optimization⚡.283181/)
- [Timings Analyzer](https://timings.aikar.co/)

---

**Last Updated:** 2025-10-25  
**Version:** 1.0.0

