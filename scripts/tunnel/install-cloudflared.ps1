# Script para instalar cloudflared en Windows
# DockerCraft - Cloudflare Tunnel Setup

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Cloudflare Tunnel - Instalación" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Crear directorio
$installPath = "C:\cloudflared"
Write-Host "1. Creando directorio en $installPath..." -ForegroundColor Yellow
if (-not (Test-Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath -Force | Out-Null
}

# Descargar cloudflared
Write-Host "2. Descargando cloudflared..." -ForegroundColor Yellow
$downloadUrl = "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-windows-amd64.exe"
$outputPath = "$installPath\cloudflared.exe"

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath -UseBasicParsing
    Write-Host "   ✅ Descargado exitosamente" -ForegroundColor Green
} catch {
    Write-Host "   ❌ Error al descargar: $_" -ForegroundColor Red
    exit 1
}

# Verificar instalación
Write-Host "3. Verificando instalación..." -ForegroundColor Yellow
& $outputPath --version
Write-Host "   ✅ cloudflared instalado correctamente" -ForegroundColor Green

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  Instalacion completada" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Proximo paso:" -ForegroundColor Cyan
Write-Host "   C:\cloudflared\cloudflared.exe tunnel login" -ForegroundColor White
Write-Host ""

