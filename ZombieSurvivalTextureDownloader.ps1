# Variables #
$downloadLink = "https://www.dropbox.com/s/t5osw2vjah42kzv/CSS%20Content%20Addon.zip?dl=1"
$is64Bit = $false
$garrysModInstall = $false
$garrysModRegKey32Bit = "hklm:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 4000"
$garrysModRegKey64Bit = "hklm:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 4000"
$garrysModInstallDir = ""
#############

# Check sytem Architecture #
$systemType = Get-WmiObject Win32_ComputerSystem | Select-Object systemtype -ExpandProperty systemtype

if ($systemType -eq "x64-based PC")
    {
        $is64Bit = $true
    }
#############

# Check GarrysMod install dir #
if ($is64Bit -eq $false) 
    {
        $garrysModInstall = Test-Path $garrysModRegKey32Bit
    }

if ($is64Bit -eq $true)
    {
        $garrysModInstall = Test-Path $garrysModRegKey64Bit
    }

if ($garrysModInstall -eq $false)
    {
        Write-Host "ERROR: GarrysMod doesn't seem to be installed" -ForegroundColor Red
        Write-Host "Press any key to exit" -ForegroundColor Red
        Read-Host
        Exit
    }

if ($is64Bit -eq $false)
    {
        $garrysModInstallDir = Get-ItemProperty $garrysModRegKey32Bit | Select-Object InstallLocation -ExpandProperty InstallLocation
    }

if ($is64Bit -eq $true)
    {
        $garrysModInstallDir = Get-ItemProperty $garrysModRegKey64Bit | Select-Object InstallLocation -ExpandProperty InstallLocation
    }

$garrysModTempDir = $garrysModInstallDir + "\garrysmod\addons\temp.zip"
#############

# Download Textures #
Write-Host "Please note that the next step will take some time to complete, the time it takes is dependant on your internet connection. The file (textures) will be downloading in the background, please do not close this window." -ForegroundColor Yellow
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$client = new-object System.Net.WebClient
$client.DownloadFile( $downloadLink, $garrysModTempDir)
Write-Host "Download complete" -ForegroundColor Green
#############

# Unzip textures #
Write-Host "Please note that the script is now extracting the downloaded textures, this may take some time." -ForegroundColor Yellow
[System.Reflection.Assembly]::LoadWithPartialName("System.IO.Compression.FileSystem") | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($garrysModTempDir, $garrysModInstallDir + "\garrysmod\addons")
Write-Host "Textures extracted" -ForegroundColor Green
#############

# Remove download #
Remove-Item -Path $garrysModTempDir
Write-Host "Downloaded file deleted" -ForegroundColor Green
#############

# Confirmation message #
Write-Host "Textures install complete!" -ForegroundColor Green
Write-Host "If you have GarrysMod open please restart it for the changes to come into effect" -ForegroundColor Green
Write-Host "Press any key to close.."
Read-Host
#############