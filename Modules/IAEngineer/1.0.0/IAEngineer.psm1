# Agregar al archivo IAEngineer.psm1 (asegúrate de estar en la carpeta 1.0.0)
$modulePath = Join-Path -Path $PWD -ChildPath "IAEngineer.psm1"

# Si el archivo no existe, crearlo
if (-not (Test-Path $modulePath)) {
    Write-Host "Creando el archivo del módulo..." -ForegroundColor Yellow
    New-Item -ItemType File -Path $modulePath
}

# Agregar las nuevas funciones al módulo
Add-Content -Path $modulePath -Value @'

function Initialize-LoggingSystem {
    <#
    .SYNOPSIS
        Inicializa el sistema de logging para IAEngineer.
    #>
    Write-Host "Inicializando sistema de logging..." -ForegroundColor Green

    # Configurar el sistema de logging
    $logPath = Join-Path -Path $env:IAEngineer_Root -ChildPath "Logs\iaengineer.log"
    
    # Crear un logger simple
    $global:IAEngineer_Logger = [PSCustomObject]@{
        LogPath = $logPath
        Log = function Write-Log {
            param(
                [string]$Message,
                [string]$Level = "INFO"
            )
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $logEntry = "$timestamp [$Level] $Message"
            Add-Content -Path $logPath -Value $logEntry
        }
    }

    Write-Host "Sistema de logging listo en: $logPath" -ForegroundColor Green
}

function Test-FullWorkflow {
    <#
    .SYNOPSIS
        Prueba el flujo completo de IAEngineer.
    #>
    Write-Host "Probando flujo completo..." -ForegroundColor Cyan

    # Paso 1: Inicializar entorno
    Write-Host "Paso 1: Inicializando entorno..." -ForegroundColor Yellow
    .\Scripts\Initialize-Environment.ps1

    # Paso 2: Inicializar logging
    Write-Host "Paso 2: Inicializando logging..." -ForegroundColor Yellow
    Initialize-LoggingSystem

    # Paso 3: Ejecutar algunas pruebas
    Write-Host "Paso 3: Ejecutando pruebas..." -ForegroundColor Yellow

    # Prueba de comandos básicos
    $commands = @("ia help", "ia quantum test", "ia analyze .")
    foreach ($cmd in $commands) {
        Write-Host "Ejecutando: $cmd" -ForegroundColor Gray
        Invoke-Expression $cmd
    }

    Write-Host "Flujo de prueba completado." -ForegroundColor Green
}
'@ -Encoding UTF8