# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Create the website directory
$websitePath = "C:\inetpub\wwwroot\ServerInfo"
New-Item -Path $websitePath -ItemType Directory -Force

# Get the hostname and IP address
$hostname = [System.Net.Dns]::GetHostName()
$ipAddress = ([System.Net.Dns]::GetHostAddresses($hostname) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -First 1).IPAddressToString

# Create the HTML file
$indexPath = "$websitePath\index.html"
$indexContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Server Info</title>
    <script>
    </script>
</head>
<body onload="getServerInfo()">
    <h1>Server Information</h1>
    <p>Hostname: <span id="hostname">$hostname</span></p>
    <p>IP Address: <span id="ip">$ipAddress</span></p>
</body>
</html>
"@
Set-Content -Path $indexPath -Value $indexContent

# Create a new IIS website
Import-Module WebAdministration
New-Website -Name "ServerInfo" -Port 80 -PhysicalPath $websitePath -ApplicationPool "DefaultAppPool"

# Set permissions for the website directory
$acl = Get-Acl $websitePath
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS","FullControl","ContainerInherit,ObjectInherit","None","Allow")
$acl.SetAccessRule($rule)
Set-Acl $websitePath $acl

# Restart IIS to apply changes
Restart-Service -Name "W3SVC"
