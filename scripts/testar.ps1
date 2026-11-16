$ErrorActionPreference = 'Stop'
$taskRoot = Split-Path -Parent $PSScriptRoot
foreach ($module in @('terrabyte', 'terrabyte-ia', 'servidor-eureka')) {
    Push-Location (Join-Path $taskRoot $module)
    try {
        & .\mvnw.cmd verify
        if ($LASTEXITCODE -ne 0) { throw "Falha na verificacao de $module" }
    } finally {
        Pop-Location
    }
}
