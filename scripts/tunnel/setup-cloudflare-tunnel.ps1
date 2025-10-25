# Script para configurar Cloudflare Tunnel para Minecraft
# DockerCraft - Cloudflare Tunnel Setup

param(
    [string]$TunnelName = "dockercraft-minecraft"
)

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Cloudflare Tunnel - Setup" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

$cloudflared = "C:\cloudflared\cloudflared.exe"

# Verificar que cloudflared este instalado
if (-not (Test-Path $cloudflared)) {
    Write-Host "ERROR: cloudflared no esta instalado" -ForegroundColor Red
    Write-Host "Ejecuta primero: .\scripts\install-cloudflared.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "1. Autenticando con Cloudflare..." -ForegroundColor Yellow
Write-Host "   Se abrira tu navegador para autorizar" -ForegroundColor White
Write-Host "   Si no tienes cuenta, crea una gratis en: https://dash.cloudflare.com/sign-up" -ForegroundColor White
Write-Host ""
Write-Host "   Presiona ENTER cuando hayas completado la autorizacion en el navegador..." -ForegroundColor Cyan
$null = Read-Host

# Ejecutar login
& $cloudflared tunnel login

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: No se pudo autenticar" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "2. Creando tunnel '$TunnelName'..." -ForegroundColor Yellow

# Crear tunnel
& $cloudflared tunnel create $TunnelName

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: No se pudo crear el tunnel" -ForegroundColor Red
    Write-Host "Es posible que ya exista. Lista tus tunnels con:" -ForegroundColor Yellow
    Write-Host "   $cloudflared tunnel list" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "3. Obteniendo informacion del tunnel..." -ForegroundColor Yellow

# Obtener UUID del tunnel
$tunnelInfo = & $cloudflared tunnel list --output json | ConvertFrom-Json
$tunnel = $tunnelInfo | Where-Object { $_.name -eq $TunnelName } | Select-Object -First 1

if (-not $tunnel) {
    Write-Host "ERROR: No se pudo encontrar el tunnel creado" -ForegroundColor Red
    exit 1
}

$tunnelId = $tunnel.id
Write-Host "   Tunnel ID: $tunnelId" -ForegroundColor Green

# Encontrar archivo de credenciales
$credFile = "$env:USERPROFILE\.cloudflared\$tunnelId.json"

if (-not (Test-Path $credFile)) {
    Write-Host "ERROR: No se encontro el archivo de credenciales" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "4. Creando archivo de configuracion..." -ForegroundColor Yellow

# Crear directorio de config si no existe
$configDir = "C:\cloudflared"
if (-not (Test-Path $configDir)) {
    New-Item -ItemType Directory -Path $configDir -Force | Out-Null
}

# Crear config.yml
$configPath = "$configDir\config.yml"
$configContent = @"
tunnel: $tunnelId
credentials-file: $credFile

ingress:
  - service: tcp://localhost:25565
"@

$configContent | Out-File -FilePath $configPath -Encoding UTF8

Write-Host "   Config creado en: $configPath" -ForegroundColor Green

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  Setup completado!" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Tu dominio de Cloudflare:" -ForegroundColor Cyan
Write-Host "   $tunnelId.cfargotunnel.com" -ForegroundColor Green -BackgroundColor Black
Write-Host ""
Write-Host "Para iniciar el tunnel:" -ForegroundColor Yellow
Write-Host "   C:\cloudflared\cloudflared.exe tunnel run $TunnelName" -ForegroundColor White
Write-Host ""
Write-Host "O ejecutar el script automatico:" -ForegroundColor Yellow
Write-Host "   .\scripts\start-cloudflare-tunnel.ps1" -ForegroundColor White
Write-Host ""

