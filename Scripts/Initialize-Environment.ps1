# Script de inicialización para QuantumEngine 2.0
Write-Host "Inicializando QuantumEngine 2.0..." -ForegroundColor Cyan

# Verificar y cargar módulos requeridos
$requiredModules = @("PSReadLine", "Terminal-Icons")
foreach ($module in $requiredModules) {
    if (Get-Module -ListAvailable -Name $module) {
        Import-Module $module -Force
        Write-Host "Módulo $module cargado." -ForegroundColor Green
    } else {
        Write-Host "Módulo $module no encontrado." -ForegroundColor Yellow
    }
}

# Definir función para cargar QuantumEngine
function Load-QuantumEngine {
    $modulePath = "$env:USERPROFILE\Documents\PowerShell\QuantumEngine\Modules\QuantumEngine\QuantumEngine.psm1"
    if (Test-Path $modulePath) {
        Import-Module $modulePath -Force
        Write-Host "QuantumEngine 2.0 cargado." -ForegroundColor Green
    } else {
        Write-Host "No se encontró QuantumEngine en $modulePath" -ForegroundColor Red
    }
}

# Cargar QuantumEngine
Load-QuantumEngine
