# Script para crear PR de Sprint 6 y cerrar issues
# DockerCraft - Sprint 6 Finalization

Write-Host ""
Write-Host "======================================" -ForegroundColor Cyan
Write-Host "  Sprint 6 - Finalization" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

# Verificar que gh esté instalado
$ghPath = Get-Command gh -ErrorAction SilentlyContinue
if (-not $ghPath) {
    Write-Host "ERROR: GitHub CLI (gh) no está instalado" -ForegroundColor Red
    Write-Host "Instala con: winget install GitHub.cli" -ForegroundColor Yellow
    exit 1
}

# Actualizar PATH si es necesario
if ($ghPath.Path -notlike "*GitHub CLI*") {
    $env:Path = "C:\Program Files\GitHub CLI\bin;" + $env:Path
}

Write-Host "1. Verificando autenticación..." -ForegroundColor Yellow
gh auth status
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: No estás autenticado con GitHub" -ForegroundColor Red
    Write-Host "Ejecuta: gh auth login" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "2. Creando Pull Request..." -ForegroundColor Yellow

$prBody = @"
## 🎯 Sprint 6 - Public Deployment & Organization

**Story Points:** 81 / 76 (106%)

### ✅ User Stories Completadas

- **US-26:** Configuración de Producción (8 pts)
- **US-27:** Networking y Firewall (13 pts)
- **US-28:** Sistema de Autorización (13 pts)
- **US-29:** Seguridad Avanzada (13 pts)
- **US-30:** Monitoring de Producción (8 pts)
- **US-31:** Cloudflare Tunnel Integration (13 pts) ⭐
- **US-32:** Scripts Reorganization (5 pts) ⭐
- **US-33:** Docs Reorganization (5 pts) ⭐
- **US-34:** Docker Reorganization (5 pts) ⭐

### 🎯 Highlights

**Cloudflare Tunnel:**
- Quick Tunnel (sin cuenta) - dominio temporal gratuito
- Tunnel Persistente (con cuenta) - dominio fijo gratuito
- Docker Compose integrado
- Documentación completa (691 líneas)

**Reorganización:**
- Scripts organizados en 7 categorías
- Docs organizados en 6 categorías
- Docker organizados en 5 categorías
- Índices completos y READMEs

**Production Ready:**
- Configuración de producción completa
- Seguridad robusta
- Monitoring y alertas
- Backups automatizados

### 📊 Métricas

- **Commits:** 7
- **Archivos Creados:** 30+
- **Archivos Reorganizados:** 70+
- **Líneas de Código:** +2,500
- **Líneas de Documentación:** +3,000

### 📝 Documentación

- [CLOUDFLARE_TUNNEL.md](docs/deployment/CLOUDFLARE_TUNNEL.md) - Guía completa
- [INDEX.md](docs/INDEX.md) - Índice de documentación
- [docker/README.md](docker/README.md) - Guía de Docker
- [scripts/README.md](scripts/README.md) - Guía de scripts

### 🔍 Testing

- ✅ Cloudflare Quick Tunnel testeado
- ✅ Docker Compose validado
- ✅ Scripts reorganizados y funcionales
- ✅ Documentación verificada

**Version:** v1.1.0
"@

# Crear PR
gh pr create `
  --base main `
  --head sprint/6 `
  --title "Sprint 6: Public Deployment, Cloudflare Tunnel & Project Reorganization" `
  --body $prBody

if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✅ Pull Request creado exitosamente" -ForegroundColor Green
} else {
    Write-Host "   ❌ Error al crear PR" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "3. Listando issues de Sprint 6..." -ForegroundColor Yellow

$issues = gh issue list --label "sprint-6" --json number,title,state --jq '.[] | select(.state=="OPEN")'

if ($issues) {
    Write-Host "   Issues abiertos encontrados:" -ForegroundColor Yellow
    gh issue list --label "sprint-6"
    
    Write-Host ""
    $response = Read-Host "¿Quieres cerrar estos issues automáticamente? (y/N)"
    
    if ($response -eq "y") {
        Write-Host ""
        Write-Host "4. Cerrando issues..." -ForegroundColor Yellow
        
        $issueNumbers = gh issue list --label "sprint-6" --json number --jq '.[].number'
        
        foreach ($issueNum in $issueNumbers) {
            Write-Host "   Cerrando issue #$issueNum..." -ForegroundColor White
            gh issue close $issueNum --comment "Completado en Sprint 6. Ver commits: 6c6573e, e98902f, c9dc66a, 55cef13"
            Write-Host "   ✅ Issue #$issueNum cerrado" -ForegroundColor Green
        }
    } else {
        Write-Host "   Issues no cerrados. Ciérralos manualmente cuando estés listo." -ForegroundColor Yellow
    }
} else {
    Write-Host "   No hay issues abiertos con label sprint-6" -ForegroundColor Green
}

Write-Host ""
Write-Host "======================================" -ForegroundColor Green
Write-Host "  ✅ Proceso completado" -ForegroundColor Green
Write-Host "======================================" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos pasos:" -ForegroundColor Cyan
Write-Host "  1. Revisa el PR en GitHub" -ForegroundColor White
Write-Host "  2. Aprueba y mergea cuando estés listo" -ForegroundColor White
Write-Host "  3. Crea tag v1.1.0 después del merge" -ForegroundColor White
Write-Host ""

