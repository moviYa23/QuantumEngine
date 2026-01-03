function Start-IAESession {
    param([string]$Mode="Standard")
    Write-Host "🌌 IAEngineer - $Mode Mode" -ForegroundColor Cyan
    Write-Host "Comandos: qstatus, qsim, qmon, qopt" -ForegroundColor Yellow
}
function Get-IAEStatus { Write-Host "✅ Sistema funcionando" -ForegroundColor Green }
function Start-QuantumSimulation { Write-Host "🌌 Simulación cuántica iniciada" -ForegroundColor Magenta }
function Invoke-IAEAnalysis { Write-Host "🔍 Analizando datos..." -ForegroundColor Cyan }
function Get-IAEHelp { Write-Host "📚 Ayuda: Usa qstatus, qsim, qmon, qopt" -ForegroundColor Green }

# Aliases
Set-Alias iae-start Start-IAESession
Set-Alias iae-status Get-IAEStatus
Set-Alias iae-quantum Start-QuantumSimulation
Set-Alias iae-analyze Invoke-IAEAnalysis
Set-Alias qstatus Get-IAEStatus
Set-Alias qsim Start-QuantumSimulation
Set-Alias qmon { Get-Process | Select-Object -First 5 }
Set-Alias qopt Invoke-IAEAnalysis

Export-ModuleMember -Function * -Alias *
