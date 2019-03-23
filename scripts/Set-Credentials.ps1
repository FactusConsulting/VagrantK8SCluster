if ($null -eq $ENV:PW) {
    $ENV:UN = "$ENV:USERDOMAIN\$ENV:USERNAME"
    $c = Get-Credential -UserName $ENV:UN -Message "Storing you username/pw in this session for saving vagrant from prompting for it on every UP."
    $ENV:PW = $c.GetNetworkCredential().Password
}
