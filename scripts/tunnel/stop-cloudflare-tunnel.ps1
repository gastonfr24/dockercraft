# Script para detener Cloudflare Tunnel
# DockerCraft - Stop Tunnel

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Deteniendo Cloudflare Tunnel" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Buscar proceso de cloudflared
$cloudflaredProcess = Get-Process -Name "cloudflared" -ErrorAction SilentlyContinue

if (-not $cloudflaredProcess) {
    Write-Host "No hay tunnels de Cloudflare corriendo" -ForegroundColor Yellow
    exit 0
}

Write-Host "Tunnel(s) encontrado(s):" -ForegroundColor Yellow
$cloudflaredProcess | Format-Table Id, ProcessName, CPU, StartTime -AutoSize

Write-Host ""
Write-Host "Deteniendo tunnel(s)..." -ForegroundColor Green

try {
    $cloudflaredProcess | Stop-Process -Force
    Write-Host "Tunnel(s) detenido(s) exitosamente" -ForegroundColor Green
} catch {
    Write-Host "Error al detener tunnel(s): $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  Tunnel detenido" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green

