# Script para crear Pull Requests automáticamente
# Requiere: GitHub CLI autenticado (gh auth login)

Write-Host "`n╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Creación Automática de Pull Requests              ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Verificar autenticación
$authStatus = gh auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ ERROR: No estás autenticado en GitHub CLI" -ForegroundColor Red
    Write-Host "`nEjecuta: gh auth login`n" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Autenticado correctamente`n" -ForegroundColor Green

# Obtener Issues existentes
Write-Host "📋 Obteniendo Issues..." -ForegroundColor Cyan
$issues = gh issue list --repo gastonfr24/dockercraft --state open --json number,title,labels --limit 20 | ConvertFrom-Json

if ($issues.Count -eq 0) {
    Write-Host "⚠️  No hay Issues abiertos" -ForegroundColor Yellow
    exit 0
}

Write-Host "Encontrados $($issues.Count) Issues abiertos:`n" -ForegroundColor Green
$issues | ForEach-Object {
    Write-Host "  #$($_.number): $($_.title)" -ForegroundColor White
}

# Branches a procesar
$branches = @(
    @{
        name = "feature/multi-version-support"
        issue = "US-14"
        title = "feat: Multi-Version Minecraft Support (US-14)"
        base = "dev"
    },
    @{
        name = "feature/modpack-support"
        issue = "US-15"
        title = "feat: Comprehensive Modpack Support (US-15)"
        base = "dev"
    },
    @{
        name = "feature/advanced-networking"
        issue = "US-16"
        title = "feat: Advanced Networking & Multi-Server Support (US-16)"
        base = "dev"
    },
    @{
        name = "feature/advanced-env-vars"
        issue = "US-17"
        title = "feat: Advanced Environment Variables Configuration (US-17)"
        base = "dev"
    },
    @{
        name = "feature/advanced-docs"
        issue = "US-18"
        title = "docs: Comprehensive Documentation Suite (US-18)"
        base = "dev"
    }
)

Write-Host "`n🔍 Buscando Issues correspondientes...`n" -ForegroundColor Cyan

$prCreated = 0
$prSkipped = 0

foreach ($branch in $branches) {
    # Buscar Issue correspondiente
    $matchingIssue = $issues | Where-Object { 
        $_.title -match $branch.issue -or 
        $_.labels.name -contains "us-$($branch.issue.ToLower().Replace('us-',''))"
    }
    
    if (-not $matchingIssue) {
        Write-Host "⚠️  No se encontró Issue para $($branch.name)" -ForegroundColor Yellow
        Write-Host "   Buscando: $($branch.issue)" -ForegroundColor Gray
        $prSkipped++
        continue
    }
    
    $issueNumber = $matchingIssue.number
    
    Write-Host "📌 Procesando: $($branch.name)" -ForegroundColor Cyan
    Write-Host "   Issue: #$issueNumber - $($matchingIssue.title)" -ForegroundColor Gray
    
    # Verificar si ya existe PR
    $existingPR = gh pr list --repo gastonfr24/dockercraft --head $branch.name --json number 2>&1 | ConvertFrom-Json
    
    if ($existingPR -and $existingPR.Count -gt 0) {
        Write-Host "   ⏭️  PR ya existe: #$($existingPR[0].number)" -ForegroundColor Yellow
        $prSkipped++
        continue
    }
    
    # Crear PR body - IMPORTANTE: "Closes #X" debe estar al inicio
    $prBody = @"
Closes #$issueNumber

## 📋 Descripción

Esta PR implementa **$($matchingIssue.title)** como parte del Sprint 3.

## ✨ Cambios Principales

Ver commits individuales para detalles completos de implementación.

## ✅ Checklist

- [x] Código implementado
- [x] Commits con mensajes descriptivos
- [x] Documentación actualizada
- [x] Issue #$issueNumber vinculado en Development section

## 📊 Sprint Info

- **Sprint:** Sprint 3
- **User Story:** $($branch.issue)
- **Story Points:** Ver issue
- **Tipo:** Feature

---

**Note:** Este PR cerrará automáticamente el Issue #$issueNumber al ser mergeado.
"@
    
    # Crear PR
    try {
        Write-Host "   📤 Creando Pull Request..." -ForegroundColor Yellow
        
        $prResult = gh pr create `
            --repo gastonfr24/dockercraft `
            --base $branch.base `
            --head $branch.name `
            --title "$($branch.title)" `
            --body $prBody `
            2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✅ PR creado exitosamente!" -ForegroundColor Green
            Write-Host "   🔗 $prResult`n" -ForegroundColor Cyan
            $prCreated++
        } else {
            Write-Host "   ❌ Error creando PR: $prResult" -ForegroundColor Red
            $prSkipped++
        }
    }
    catch {
        Write-Host "   ❌ Excepción: $($_.Exception.Message)" -ForegroundColor Red
        $prSkipped++
    }
    
    Start-Sleep -Seconds 1
}

# Resumen
Write-Host "`n╔════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  RESUMEN                                           ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "✅ PRs creados: $prCreated" -ForegroundColor Green
Write-Host "⏭️  PRs omitidos: $prSkipped`n" -ForegroundColor Yellow

if ($prCreated -gt 0) {
    Write-Host "🎉 Pull Requests creados exitosamente!" -ForegroundColor Green
    Write-Host "📝 Revísalos en: https://github.com/gastonfr24/dockercraft/pulls`n" -ForegroundColor Cyan
}

