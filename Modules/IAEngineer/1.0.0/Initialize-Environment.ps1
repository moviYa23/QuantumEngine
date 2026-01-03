# Crear Initialize-Environment.ps1
$initScript = @'
# ============================================
# INITIALIZE-ENVIRONMENT.PS1
# Script de inicialización del entorno QuantumEngine
# ============================================

param(
    [switch]$Force,
    [switch]$Silent
)

function Write-QuantumLog {
    param(
        [string]$Message,
        [ValidateSet('Info','Warning','Error','Success')]
        [string]$Level = 'Info'
    )
    
    $colors = @{
        'Info'    = 'Cyan'
        'Warning' = 'Yellow'
        'Error'   = 'Red'
        'Success' = 'Green'
    }
    
    $symbols = @{
        'Info'    = 'ℹ️'
        'Warning' = '⚠️'
        'Error'   = '❌'
        'Success' = '✅'
    }
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $formattedMsg = "[$timestamp] [$Level] $Message"
    
    # Guardar en log
    $logPath = "$env:USERPROFILE\Documents\PowerShell\QuantumEngine\Logs\setup_$(Get-Date -Format 'yyyyMMdd').log"
    Add-Content -Path $logPath -Value $formattedMsg -Encoding UTF8
    
    # Mostrar en consola si no es modo silencioso
    if (-not $Silent) {
        Write-Host "$($symbols[$Level]) $Message" -ForegroundColor $colors[$Level]
    }
}

Write-QuantumLog "Iniciando configuración de QuantumEngine..." -Level Info

# 1. VERIFICAR REQUISITOS DEL SISTEMA
Write-QuantumLog "Verificando requisitos del sistema..." -Level Info

$requirements = @{
    PowerShellVersion = $PSVersionTable.PSVersion.Major -ge 5
    ExecutionPolicy   = (Get-ExecutionPolicy) -in @("RemoteSigned", "Unrestricted", "Bypass")
    AdminRights       = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
}

foreach ($req in $requirements.Keys) {
    if ($requirements[$req]) {
        Write-QuantumLog "$req: CUMPLIDO" -Level Success
    } else {
        Write-QuantumLog "$req: FALLIDO" -Level Warning
    }
}

# 2. INSTALAR MÓDULOS REQUERIDOS
Write-QuantumLog "Instalando módulos requeridos..." -Level Info

$requiredModules = @(
    @{Name = "PSReadLine"; Optional = $false},
    @{Name = "Terminal-Icons"; Optional = $false},
    @{Name = "posh-git"; Optional = $true},
    @{Name = "PowerShellGet"; Optional = $false}
)

foreach ($module in $requiredModules) {
    try {
        if (-not (Get-Module -ListAvailable -Name $module.Name)) {
            Write-QuantumLog "Instalando $($module.Name)..." -Level Info
            Install-Module -Name $module.Name -Scope CurrentUser -Force -AllowClobber
            Write-QuantumLog "$($module.Name) instalado correctamente" -Level Success
        } else {
            Write-QuantumLog "$($module.Name) ya está instalado" -Level Info
        }
    } catch {
        if ($module.Optional) {
            Write-QuantumLog "No se pudo instalar $($module.Name) (opcional): $_" -Level Warning
        } else {
            Write-QuantumLog "ERROR instalando $($module.Name): $_" -Level Error
        }
    }
}

# 3. CONFIGURAR VARIABLES DE ENTORNO
Write-QuantumLog "Configurando variables de entorno..." -Level Info

$envVars = @{
    "QUANTUM_ENGINE_ROOT" = "$env:USERPROFILE\Documents\PowerShell\QuantumEngine"
    "QUANTUM_LOG_LEVEL"   = "INFO"
    "QUANTUM_AUTO_START"  = "true"
}

foreach ($var in $envVars.Keys) {
    [Environment]::SetEnvironmentVariable($var, $envVars[$var], "User")
    Write-QuantumLog "Variable $var = $($envVars[$var])" -Level Info
}

# 4. CONFIGURAR PERFIL DE POWERSHELL
Write-QuantumLog "Configurando perfil de PowerShell..." -Level Info

$profileContent = @'
# ============================================
# QUANTUM ENGINE - CONFIGURACIÓN AUTOMÁTICA
# ============================================

# Cargar módulos esenciales
Import-Module PSReadLine
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# Configuración de PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -Colors @{
    Command            = "Green"
    Parameter          = "Cyan"
    Operator           = "Magenta"
    Variable           = "Yellow"
    String             = "DarkCyan"
    Number             = "Blue"
    Type               = "Gray"
    Comment            = "DarkGray"
    Keyword            = "DarkGreen"
}

# Cargar QuantumEngine si existe
$quantumModule = "$env:USERPROFILE\Documents\PowerShell\QuantumEngine\Modules\QuantumEngine\QuantumEngine.psm1"
if (Test-Path $quantumModule) {
    Import-Module $quantumModule -Force
    Write-Host "QuantumEngine v1.0.0 cargado" -ForegroundColor Cyan
} else {
    Write-Host "QuantumEngine no encontrado. Ejecuta Initialize-Environment.ps1" -ForegroundColor Yellow
}

# Alias útiles
function prompt {
    "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}

# Función para recargar perfil
function Reload-Profile {
    . $PROFILE
    Write-Host "Perfil recargado" -ForegroundColor Green
}

Set-Alias -Name rp -Value Reload-Profile
'@

$profileContent | Out-File -FilePath $PROFILE -Encoding UTF8 -Force
Write-QuantumLog "Perfil configurado en: $PROFILE" -Level Success

# 5. CREAR ARCHIVO DE CONFIGURACIÓN POR DEFECTO
Write-QuantumLog "Creando configuración por defecto..." -Level Info

$config = @{
    Version = "1.0.0"
    AutoStart = $true
    LogLevel = "INFO"
    DefaultMode = "Standard"
    QuantumProviders = @("LocalSimulator")
    AI_Enabled = $true
    Theme = "Dark"
    UpdateCheck = $true
    Modules = @{
        PSReadLine = $true
        TerminalIcons = $true
        PoshGit = $false
    }
}

$configPath = "$baseDir\Config\quantum_config.json"
$config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -Encoding UTF8
Write-QuantumLog "Configuración guardada en: $configPath" -Level Success

# 6. MENSAJE FINAL
Write-QuantumLog "=" * 50 -Level Info
Write-QuantumLog "CONFIGURACIÓN COMPLETADA EXITOSAMENTE" -Level Success
Write-QuantumLog "=" * 50 -Level Info
Write-QuantumLog "" -Level Info
Write-QuantumLog "Pasos siguientes:" -Level Info
Write-QuantumLog "1. Cierra y vuelve a abrir PowerShell" -Level Info
Write-QuantumLog "2. Ejecuta 'Reload-Profile' o 'rp'" -Level Info
Write-QuantumLog "3. Usa 'Get-QuantumHelp' para ver comandos disponibles" -Level Info
Write-QuantumLog "" -Level Info
Write-QuantumLog "Para problemas, revisa los logs en:" -Level Info
Write-QuantumLog "$baseDir\Logs\" -Level Info

return $true
'@

$initScript | Out-File -FilePath "$baseDir\Scripts\Initialize-Environment.ps1" -Encoding UTF8
Write-Host "✅ Script Initialize-Environment.ps1 creado" -ForegroundColor Green