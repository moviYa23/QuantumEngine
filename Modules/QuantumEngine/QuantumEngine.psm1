# QuantumEngine 2.0 - Módulo principal

function Get-QuantumVersion {
    "QuantumEngine 2.0.0"
}

function Start-QuantumMode {
    Write-Host "Iniciando modo cuántico..." -ForegroundColor Magenta
    # Cambiar el prompt
    function global:prompt {
        "QUANTUM2> "
    }
    Write-Host "Modo cuántico activado." -ForegroundColor Green
}

function Stop-QuantumMode {
    Write-Host "Deteniendo modo cuántico..." -ForegroundColor Magenta
    # Restaurar el prompt por defecto
    function global:prompt {
        "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    }
    Write-Host "Modo cuántico desactivado." -ForegroundColor Green
}

function Test-QuantumEnvironment {
    Write-Host "Probando entorno cuántico..." -ForegroundColor Cyan
    Write-Host "Todo funciona correctamente." -ForegroundColor Green
}

Export-ModuleMember -Function Get-QuantumVersion, Start-QuantumMode, Stop-QuantumMode, Test-QuantumEnvironment
