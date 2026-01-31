param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath,
    
    [Parameter(Mandatory=$true)]
    [string]$Content
)

# Ensure directory exists
$DirPath = Split-Path $FilePath -Parent
if (-not (Test-Path $DirPath)) {
    New-Item -ItemType Directory -Path $DirPath -Force | Out-Null
}

# Write file content
try {
    Set-Content -Path $FilePath -Value $Content -Force -NoNewline
    Write-Host "SUCCESS: File written to $FilePath" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to write file - $_" -ForegroundColor Red
    exit 1
}
