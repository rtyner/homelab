$ous = "Production Servers", "Dev Servers", "Workstations", "Service Accounts"

foreach ($ou in $ous) {New-ADOrganizationalUnit -Name $ou -Path "DC=WIN,DC=LAB"}