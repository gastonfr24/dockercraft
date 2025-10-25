# Quick Cloudflare Tunnel - Sin necesidad de cuenta
# Genera un dominio temporal GRATIS

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Cloudflare Quick Tunnel (GRATIS)" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Caracteristicas:" -ForegroundColor Yellow
Write-Host "  - Dominio temporal GRATIS" -ForegroundColor White
Write-Host "  - NO necesitas cuenta" -ForegroundColor White
Write-Host "  - NO necesitas dominio propio" -ForegroundColor White
Write-Host "  - Cloudflare te asigna uno automaticamente" -ForegroundColor White
Write-Host ""
Write-Host "Nota: El dominio cambia cada vez que reinicias" -ForegroundColor Yellow
Write-Host ""

# Verificar que cloudflared este instalado
$cloudflared = "C:\cloudflared\cloudflared.exe"
if (-not (Test-Path $cloudflared)) {
    Write-Host "ERROR: cloudflared no instalado" -ForegroundColor Red
    Write-Host "Ejecuta: .\scripts\tunnel\install-cloudflared.ps1" -ForegroundColor Yellow
    exit 1
}

# Verificar que el servidor de Minecraft este corriendo
$container = docker ps --filter "name=mc-server" --format "{{.Names}}" 2>$null
if (-not $container) {
    Write-Host "ADVERTENCIA: No hay servidor de Minecraft corriendo" -ForegroundColor Yellow
    Write-Host "Inicia el servidor con: docker compose up -d" -ForegroundColor White
    Write-Host ""
}

Write-Host "Iniciando tunnel..." -ForegroundColor Green
Write-Host "Espera unos segundos..." -ForegroundColor Yellow
Write-Host ""
Write-Host "----------------------------------------------------" -ForegroundColor Cyan
Write-Host ""

# Iniciar tunnel
& $cloudflared tunnel --url tcp://localhost:25565

Write-Host ""
Write-Host "Tunnel detenido" -ForegroundColor Yellow

