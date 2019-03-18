if ($null -eq $ENV:PW) {
    $c = Get-Credential -UserName "$ENV:USERDOMAIN\$ENV:USERNAME" -Message "Storing you username/pw in this session for saving vagrant from prompting for it on every UP."

    #Set-Variable -Name  "ENV:PW" -Value $c.GetNetworkCredential().Password #-Scope 1

    $ENV:UN = "$ENV:USERDOMAIN\$ENV:USERNAME"
    $ENV:PW = $c.GetNetworkCredential().Password
}