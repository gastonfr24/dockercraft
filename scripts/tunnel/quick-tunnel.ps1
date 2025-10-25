# Quick Cloudflare Tunnel - Sin necesidad de cuenta
# Genera un dominio temporal GRATIS

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║           🌐 Cloudflare Quick Tunnel (GRATIS)             ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "✨ Características:" -ForegroundColor Yellow
Write-Host "  ✅ Dominio temporal GRATIS" -ForegroundColor Green
Write-Host "  ✅ NO necesitas cuenta" -ForegroundColor Green
Write-Host "  ✅ NO necesitas dominio propio" -ForegroundColor Green
Write-Host "  ✅ Cloudflare te asigna uno automáticamente" -ForegroundColor Green
Write-Host ""
Write-Host "⚠️  Nota: El dominio cambia cada vez que reinicias" -ForegroundColor Yellow
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

Write-Host "🚀 Iniciando tunnel..." -ForegroundColor Green
Write-Host "⏳ Conectando a Cloudflare network..." -ForegroundColor Yellow
Write-Host ""
Write-Host "────────────────────────────────────────────────────────────" -ForegroundColor Cyan
Write-Host ""

# Capturar output del tunnel
$tunnelStartTime = Get-Date

Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 📡 Estableciendo conexión..." -ForegroundColor White

# Crear archivo temporal para logs
$logFile = "$env:TEMP\cloudflared-tunnel.log"

# Iniciar proceso y capturar output
$process = Start-Process -FilePath $cloudflared `
    -ArgumentList "tunnel", "--url", "tcp://localhost:25565" `
    -NoNewWindow `
    -PassThru `
    -RedirectStandardOutput $logFile `
    -RedirectStandardError $logFile

# Esperar a que el tunnel esté listo y extraer URL
$maxWaitSeconds = 30
$waitedSeconds = 0
$tunnelUrl = $null

Write-Host "[$(Get-Date -Format 'HH:mm:ss')] ⏳ Esperando asignación de dominio..." -ForegroundColor Yellow

while ($waitedSeconds -lt $maxWaitSeconds -and -not $tunnelUrl) {
    Start-Sleep -Seconds 1
    $waitedSeconds++
    
    if (Test-Path $logFile) {
        $content = Get-Content $logFile -Raw
        
        # Buscar URL en logs
        if ($content -match 'https://([a-zA-Z0-9\-]+\.trycloudflare\.com)') {
            $tunnelUrl = $matches[1]
            break
        }
    }
    
    # Mostrar progreso
    if ($waitedSeconds % 5 -eq 0) {
        Write-Host "[$(Get-Date -Format 'HH:mm:ss')] ⏳ Aún conectando... ($waitedSeconds/$maxWaitSeconds segundos)" -ForegroundColor Gray
    }
}

$tunnelStartDuration = ((Get-Date) - $tunnelStartTime).TotalSeconds

if ($tunnelUrl) {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                  ✅ TUNNEL ESTABLECIDO                     ║" -ForegroundColor Green
    Write-Host "╠════════════════════════════════════════════════════════════╣" -ForegroundColor Green
    Write-Host "║                                                            ║" -ForegroundColor Green
    Write-Host "║  🌐 Tu servidor está PÚBLICO en:                          ║" -ForegroundColor Green
    Write-Host "║                                                            ║" -ForegroundColor Green
    Write-Host "║     $($tunnelUrl.PadRight(50))     ║" -ForegroundColor White -BackgroundColor DarkGreen
    Write-Host "║                                                            ║" -ForegroundColor Green
    Write-Host "║  📋 Comparte esta URL con tus amigos                      ║" -ForegroundColor Green
    Write-Host "║  🎮 Conéctate desde Minecraft: Direct Connect             ║" -ForegroundColor Green
    Write-Host "║                                                            ║" -ForegroundColor Green
    Write-Host "╠════════════════════════════════════════════════════════════╣" -ForegroundColor Green
    Write-Host "║  📊 Estado:                                                ║" -ForegroundColor Green
    Write-Host "║     • Conexión: ACTIVA ✅                                 ║" -ForegroundColor Green
    Write-Host "║     • Tiempo de inicio: $([math]::Round($tunnelStartDuration, 1))s                              ║" -ForegroundColor Green
    Write-Host "║     • Seguridad: IP oculta 🔒                             ║" -ForegroundColor Green
    Write-Host "║     • Latencia: ~10-30ms adicionales                      ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  Mantén esta ventana abierta mientras juegas" -ForegroundColor Yellow
    Write-Host "🛑 Presiona Ctrl+C para detener el tunnel" -ForegroundColor Red
    Write-Host ""
    
    # Monitorear el proceso
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] 📡 Tunnel activo - Monitoreando conexión..." -ForegroundColor Cyan
    Write-Host ""
    
    try {
        # Esperar a que el proceso termine
        $process.WaitForExit()
    }
    catch {
        Write-Host ""
        Write-Host "⚠️  Tunnel interrumpido por el usuario" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Red
    Write-Host "║                  ❌ ERROR AL CONECTAR                      ║" -ForegroundColor Red
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Red
    Write-Host ""
    Write-Host "No se pudo establecer el tunnel después de $maxWaitSeconds segundos" -ForegroundColor Red
    Write-Host ""
    Write-Host "Posibles causas:" -ForegroundColor Yellow
    Write-Host "  • Firewall bloqueando cloudflared" -ForegroundColor White
    Write-Host "  • Sin conexión a internet" -ForegroundColor White
    Write-Host "  • Servidor de Minecraft no está corriendo" -ForegroundColor White
    Write-Host ""
    Write-Host "Logs guardados en: $logFile" -ForegroundColor Gray
    
    # Matar proceso si está corriendo
    if (-not $process.HasExited) {
        $process.Kill()
    }
    
    exit 1
}

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "║                  🛑 TUNNEL DETENIDO                        ║" -ForegroundColor Yellow
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""
Write-Host "El tunnel ha sido cerrado correctamente" -ForegroundColor Gray
Write-Host ""

