Try {
    # Download Notepad++ Sources
    Write-Host "Downloading Firefox..."
    Invoke-WebRequest -Uri 'https://stkandyavd.blob.core.windows.net/apps/FirefoxSetup.exe' -OutFile 'c:\windows\temp\firefoxsetup.exe'
    # Wait 10s
    Start-Sleep -Seconds 10
    # Install VSCode silently
    Write-Host "Installing Firefox now..."
    Start-Process -FilePath 'c:\windows\temp\firefoxsetup.exe' -Args '/S /PreventRebootRequired=true' -Wait -PassThru
    Write-Host "Successfully installed Firefox"
       
    } catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}
