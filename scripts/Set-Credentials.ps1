if ($null -eq $env:UN) {
    $c = Get-Credential -UserName "$ENV:USERDOMAIN\$ENV:USERNAME" -Message "Storing you username/pw in this session for saving vagrant from prompting for it on every UP."
    $ENV:UN = "$ENV:USERDOMAIN\$ENV:USERNAME"
    $ENV:PW = $c.GetNetworkCredential().Password
}
