if ($null -eq $ENV:pw) {
    Write-Error "Missing share credentials for creating shares on host. Run script\host\set-credentials.ps1"
    Exit 1
}
