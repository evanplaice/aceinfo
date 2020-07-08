 
# http://stackoverflow.com/a/9949105
$ErrorActionPreference = "Stop"

echo "Disabling password complexity requirement..."

secedit /export /cfg c:\secpol.cfg
(gc C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
rm -force c:\secpol.cfg -confirm:$false

echo "Configuring TCP port"

# http://technet.microsoft.com/en-us/library/dd206997(v=sql.105).aspx
# Load assemblies
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.Smo")
[reflection.assembly]::LoadWithPartialName("Microsoft.SqlServer.SqlWmiManagement")

# http://www.dbi-services.com/index.php/blog/entry/sql-server-2012-configuring-your-tcp-port-via-powershell
# Set the port

$wmi = new-object ('Microsoft.SqlServer.Management.Smo.Wmi.ManagedComputer')

# List the object properties, including the instance names.
$wmi

$uri = "ManagedComputer[@Name='" + (get-item env:\computername).Value + "']/ServerInstance[@Name='MSSQLSERVER']/ServerProtocol[@Name='Tcp']"
$tcp = $wmi.GetSmoObject($uri)
$wmi.GetSmoObject($uri + "/IPAddress[@Name='IPAll']").IPAddressProperties[1].Value="1433"
$Tcp.IsEnabled = $true
$tcp.alter()

echo "DONE!"

echo "Restarting service..."
# Restart service so that configurations are applied
restart-service -f "SQL Server (MSSQLSERVER)"
echo "DONE!"