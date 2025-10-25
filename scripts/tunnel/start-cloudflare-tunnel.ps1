# Script para iniciar Cloudflare Tunnel
# DockerCraft - Start Tunnel

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Iniciando Cloudflare Tunnel" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$cloudflared = "C:\cloudflared\cloudflared.exe"
$configPath = "C:\cloudflared\config.yml"

# Verificar instalacion
if (-not (Test-Path $cloudflared)) {
    Write-Host "ERROR: cloudflared no instalado" -ForegroundColor Red
    Write-Host "Ejecuta: .\scripts\install-cloudflared.ps1" -ForegroundColor Yellow
    exit 1
}

# Verificar config
if (-not (Test-Path $configPath)) {
    Write-Host "ERROR: No hay configuracion" -ForegroundColor Red
    Write-Host "Ejecuta: .\scripts\setup-cloudflare-tunnel.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Verificando que el servidor de Minecraft este corriendo..." -ForegroundColor Yellow
$container = docker ps --filter "name=mc-server" --format "{{.Names}}" 2>$null

if (-not $container) {
    Write-Host ""
    Write-Host "ADVERTENCIA: No hay servidor de Minecraft corriendo" -ForegroundColor Yellow
    Write-Host "Inicia el servidor primero con:" -ForegroundColor White
    Write-Host "   docker compose up -d" -ForegroundColor Cyan
    Write-Host ""
    $response = Read-Host "Continuar de todas formas? (y/N)"
    if ($response -ne "y") {
        exit 0
    }
}

Write-Host ""
Write-Host "Iniciando tunnel..." -ForegroundColor Green
Write-Host "Presiona Ctrl+C para detener" -ForegroundColor Yellow
Write-Host ""

# Iniciar tunnel
& $cloudflared tunnel --config $configPath run

Write-Host ""
Write-Host "Tunnel detenido" -ForegroundColor Yellow

