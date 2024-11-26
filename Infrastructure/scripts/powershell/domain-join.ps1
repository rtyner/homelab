Set-DnsClientServerAddress -InterfaceIndex 13 -ServerAddresses ("10.1.1.5","10.1.1.6")
Add-Computer -DomainName win.rtynerlabs.io -Restart