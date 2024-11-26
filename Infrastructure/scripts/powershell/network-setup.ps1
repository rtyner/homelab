$hostname = "rt-dc-02"
$ip_address = 10.1.1.6
$mask = 24
$dns = 
$creds = "win\rt-admin"

Set-NetIPAddress -InterfaceIndex 12 -IPAddress $ip_address -PrefixLength $mask
Set-DnsClientServerAddress -InterfaceIndex 13 -ServerAddresses ("10.1.1.5","10.1.1.6")
Rename-Computer -NewName $hostname -DomainCredential $creds -Restart