# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Create the website directory
$websitePath = "C:\inetpub\wwwroot\ServerInfo"
New-Item -Path $websitePath -ItemType Directory -Force

# Create the HTML file
$indexPath = "$websitePath\index.html"
$indexContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Server Info</title>
    <script>
        function getServerInfo() {
            document.getElementById("hostname").innerText = window.location.hostname;
            document.getElementById("ip").innerText = window.location.host;
            document.getElementById("time").innerText = new Date().toLocaleString();
        }
    </script>
</head>
<body onload="getServerInfo()">
    <h1>Server Information</h1>
    <p>Hostname: <span id="hostname"></span></p>
    <p>IP Address: <span id="ip"></span></p>
    <p>Current Time: <span id="time"></span></p>
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
