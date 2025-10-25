# API Integration Guide - DockerCraft

Guide for developers building external APIs to manage Minecraft servers.

---

## 🎯 Purpose

This document is for developers building a **separate API project** that will:
- Create Minecraft servers on-demand
- Manage server lifecycle (start, stop, restart)
- Configure servers dynamically
- Monitor server status

**Note:** DockerCraft is the **Docker template** only. The API is a separate project.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────┐
│       External API                  │
│   (Your separate project)           │
│                                     │
│  - REST endpoints                   │
│  - Database                         │
│  - Authentication                   │
│  - Server management                │
└──────────────┬──────────────────────┘
               │
               │ Docker API
               │
┌──────────────▼──────────────────────┐
│       Docker Host                   │
│                                     │
│  ┌─────────┐ ┌─────────┐ ┌────────┐│
│  │ Server 1│ │ Server 2│ │Server 3││
│  │DockerCra│ │DockerCra│ │DockerCr││
│  │ft Image │ │ft Image │ │ft Image││
│  └─────────┘ └─────────┘ └────────┘│
└─────────────────────────────────────┘
```

---

## 🚀 Quick Start

### 1. Docker Python SDK

```python
import docker

# Connect to Docker
client = docker.from_env()

# Create a Minecraft server
container = client.containers.run(
    image="dockercraft:latest",
    name="mc-server-1",
    ports={'25565/tcp': 25565},
    environment={
        "EULA": "TRUE",
        "TYPE": "PAPER",
        "VERSION": "LATEST",
        "MEMORY": "4G",
        "SERVER_NAME": "API-Managed Server"
    },
    volumes={
        'mc-server-1-data': {'bind': '/data', 'mode': 'rw'}
    },
    detach=True,
    tty=True,
    stdin_open=True
)

print(f"Server created: {container.name}")
```

### 2. Docker API (REST)

```bash
# Create server
curl -X POST http://localhost/v1.43/containers/create?name=mc-server-1 \
  -H "Content-Type: application/json" \
  -d '{
    "Image": "dockercraft:latest",
    "Env": [
      "EULA=TRUE",
      "TYPE=PAPER",
      "MEMORY=4G"
    ],
    "ExposedPorts": {
      "25565/tcp": {}
    },
    "HostConfig": {
      "PortBindings": {
        "25565/tcp": [{"HostPort": "25565"}]
      }
    }
  }'
```

---

## 🔧 Server Management

### Create Server

```python
def create_server(server_id: str, config: dict):
    """Create a new Minecraft server."""
    container = client.containers.run(
        image="dockercraft:latest",
        name=f"mc-server-{server_id}",
        ports={f'25565/tcp': config.get('port', 25565)},
        environment={
            "EULA": "TRUE",
            "TYPE": config.get('type', 'PAPER'),
            "VERSION": config.get('version', 'LATEST'),
            "MEMORY": config.get('memory', '4G'),
            "SERVER_NAME": config.get('name', f'Server {server_id}'),
            "DIFFICULTY": config.get('difficulty', 'normal'),
            "MODE": config.get('mode', 'survival'),
            "MAX_PLAYERS": config.get('max_players', 20),
            "ENABLE_RCON": "true",
            "RCON_PASSWORD": config.get('rcon_password', 'minecraft'),
        },
        volumes={
            f'mc-server-{server_id}-data': {'bind': '/data', 'mode': 'rw'}
        },
        network=config.get('network', 'minecraft-network'),
        detach=True,
        tty=True,
        stdin_open=True
    )
    
    return {
        "id": container.id,
        "name": container.name,
        "status": container.status
    }
```

### Start/Stop Server

```python
def start_server(server_id: str):
    """Start a server."""
    container = client.containers.get(f"mc-server-{server_id}")
    container.start()
    return {"status": "started"}

def stop_server(server_id: str):
    """Stop a server gracefully."""
    container = client.containers.get(f"mc-server-{server_id}")
    # Send stop command via RCON first
    exec_result = container.exec_run("rcon-cli stop")
    # Wait for graceful shutdown
    container.wait(timeout=60)
    return {"status": "stopped"}

def restart_server(server_id: str):
    """Restart a server."""
    container = client.containers.get(f"mc-server-{server_id}")
    container.restart(timeout=60)
    return {"status": "restarted"}
```

### Delete Server

```python
def delete_server(server_id: str, delete_data: bool = False):
    """Delete a server."""
    container = client.containers.get(f"mc-server-{server_id}")
    container.stop(timeout=60)
    container.remove()
    
    if delete_data:
        volume = client.volumes.get(f"mc-server-{server_id}-data")
        volume.remove()
    
    return {"status": "deleted"}
```

---

## 📊 Server Monitoring

### Get Server Status

```python
def get_server_status(server_id: str):
    """Get server status and stats."""
    container = client.containers.get(f"mc-server-{server_id}")
    stats = container.stats(stream=False)
    
    return {
        "id": container.id,
        "name": container.name,
        "status": container.status,
        "cpu_usage": calculate_cpu_percent(stats),
        "memory_usage": stats['memory_stats']['usage'],
        "memory_limit": stats['memory_stats']['limit'],
        "network_rx": stats['networks']['eth0']['rx_bytes'],
        "network_tx": stats['networks']['eth0']['tx_bytes']
    }

def calculate_cpu_percent(stats):
    """Calculate CPU percentage from Docker stats."""
    cpu_delta = stats['cpu_stats']['cpu_usage']['total_usage'] - \
                stats['precpu_stats']['cpu_usage']['total_usage']
    system_delta = stats['cpu_stats']['system_cpu_usage'] - \
                   stats['precpu_stats']['system_cpu_usage']
    cpu_count = stats['cpu_stats']['online_cpus']
    return (cpu_delta / system_delta) * cpu_count * 100.0
```

### Get Server Logs

```python
def get_server_logs(server_id: str, tail: int = 100):
    """Get server logs."""
    container = client.containers.get(f"mc-server-{server_id}")
    logs = container.logs(tail=tail, timestamps=True)
    return logs.decode('utf-8')
```

### Execute Commands (RCON)

```python
def execute_command(server_id: str, command: str):
    """Execute command via RCON."""
    container = client.containers.get(f"mc-server-{server_id}")
    result = container.exec_run(f"rcon-cli {command}")
    return {
        "exit_code": result.exit_code,
        "output": result.output.decode('utf-8')
    }

# Examples
execute_command("server-1", "list")  # List players
execute_command("server-1", "give @a diamond 64")  # Give items
execute_command("server-1", "time set day")  # Set time
```

---

## 🌐 Multi-Server Setup

### Create with Proxy

```python
def create_network_setup():
    """Create multi-server setup with proxy."""
    
    # Create Docker network
    network = client.networks.create(
        "minecraft-network",
        driver="bridge"
    )
    
    # Create proxy
    proxy = client.containers.run(
        image="itzg/bungeecord:java17",
        name="mc-proxy",
        ports={'25577/tcp': 25565},
        environment={
            "TYPE": "VELOCITY",
            "MEMORY": "512M",
            "VELOCITY_SECRET": generate_secret()
        },
        network="minecraft-network",
        detach=True
    )
    
    # Create backend servers
    servers = []
    for i, server_type in enumerate(['hub', 'survival', 'creative']):
        server = create_server(
            server_id=f"{server_type}-1",
            config={
                'type': 'PAPER',
                'memory': '4G',
                'proxy_mode': 'VELOCITY',
                'velocity_secret': velocity_secret,
                'online_mode': False,
                'network': 'minecraft-network'
            }
        )
        servers.append(server)
    
    return {
        "proxy": proxy.id,
        "servers": servers
    }
```

---

## 🔐 Security Considerations

### Environment Variables

**Never hardcode secrets:**

```python
# ❌ BAD
RCON_PASSWORD = "minecraft"

# ✅ GOOD
import secrets
RCON_PASSWORD = secrets.token_urlsafe(32)
```

### Network Isolation

```python
# Create isolated network per customer
network = client.networks.create(
    f"customer-{customer_id}-network",
    driver="bridge",
    internal=True  # No external access
)
```

### Resource Limits

```python
container = client.containers.run(
    image="dockercraft:latest",
    # ... other config ...
    mem_limit="4g",
    cpu_quota=200000,  # 2 CPUs
    restart_policy={"Name": "unless-stopped"}
)
```

---

## 📦 Port Management

### Dynamic Port Allocation

```python
import random

def find_available_port(start=25565, end=25665):
    """Find available port in range."""
    used_ports = get_used_ports()
    
    for port in range(start, end):
        if port not in used_ports:
            return port
    
    raise Exception("No available ports")

def get_used_ports():
    """Get all ports in use."""
    containers = client.containers.list()
    used_ports = set()
    
    for container in containers:
        ports = container.ports
        if '25565/tcp' in ports:
            for binding in ports['25565/tcp']:
                used_ports.add(int(binding['HostPort']))
    
    return used_ports
```

---

## 💾 Backup Management

### Create Backup

```python
def create_backup(server_id: str):
    """Create server backup."""
    container = client.containers.get(f"mc-server-{server_id}")
    
    # Run backup script
    result = container.exec_run(
        "bash /scripts/backup.sh mc-server /backups"
    )
    
    # Copy backup from container
    backup_path = f"/backups/mc-server-{server_id}-{datetime.now()}.tar.gz"
    bits, stat = container.get_archive('/backups/')
    
    with open(f"./backups/{server_id}.tar.gz", 'wb') as f:
        for chunk in bits:
            f.write(chunk)
    
    return {"backup_path": backup_path}
```

---

## 📊 Example FastAPI Implementation

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import docker

app = FastAPI()
client = docker.from_env()

class ServerCreate(BaseModel):
    type: str = "PAPER"
    version: str = "LATEST"
    memory: str = "4G"
    max_players: int = 20

@app.post("/servers")
async def create_server_endpoint(config: ServerCreate):
    try:
        server = create_server(
            server_id=generate_id(),
            config=config.dict()
        )
        return server
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/servers/{server_id}/status")
async def get_status(server_id: str):
    try:
        return get_server_status(server_id)
    except docker.errors.NotFound:
        raise HTTPException(status_code=404, detail="Server not found")

@app.post("/servers/{server_id}/start")
async def start(server_id: str):
    return start_server(server_id)

@app.post("/servers/{server_id}/stop")
async def stop(server_id: str):
    return stop_server(server_id)

@app.delete("/servers/{server_id}")
async def delete(server_id: str):
    return delete_server(server_id)
```

---

## 🔍 Testing

```python
import pytest

def test_create_server():
    server = create_server("test-1", {"memory": "2G"})
    assert server["status"] == "created"
    
    # Cleanup
    delete_server("test-1", delete_data=True)

def test_server_lifecycle():
    # Create
    server = create_server("test-2", {})
    
    # Start
    start_server("test-2")
    assert get_server_status("test-2")["status"] == "running"
    
    # Stop
    stop_server("test-2")
    assert get_server_status("test-2")["status"] == "exited"
    
    # Delete
    delete_server("test-2", delete_data=True)
```

---

## 📚 Resources

- **Docker SDK for Python:** https://docker-py.readthedocs.io/
- **Docker Engine API:** https://docs.docker.com/engine/api/
- **FastAPI:** https://fastapi.tiangolo.com/
- **itzg/minecraft-server:** https://github.com/itzg/docker-minecraft-server

---

**Last Updated:** 2025-10-24
**DockerCraft Version:** v0.4.0 (Sprint 3)

