try
{
    # Get servername
    $ip = $Context.GetProperty("Address");
    $DnsEntry = [System.Net.DNS]::GetHostByAddress($ip)
    $DnsName = [string]$DnsEntry.HostName;
 
    # Get the Windows credentials
    $WinUser = $Context.GetProperty("CredWindows:DomainAndUserid");
    $WinPass = $Context.GetProperty("CredWindows:Password");
    $pwd = convertto-securestring $WinPass -asplaintext -force
    $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $WinUser,$pwd
    Invoke-Command -ComputerName $DnsName -Credential $cred -ScriptBlock {Restart-Computer -Force}
 
    # Set the result
    $Context.SetResult(0, "successfully rebooted!")
}
Catch [System.Exception]
{
    # Set the result if it goes wrong
    $Context.SetResult(1, "$_.exception.gettype().fullname")
}
