Try {
    # Download Notepad++ Sources
    Write-Host "Downloading Notepad++ sources..."
    Invoke-WebRequest -Uri 'https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.5.6/npp.8.5.6.Installer.x64.exe' -OutFile 'c:\windows\temp\npp.8.5.6.Installer.x64.exe'
    # Wait 10s
    Start-Sleep -Seconds 10
    # Install VSCode silently
    Write-Host "Installing Notepad++ now..."
    Start-Process -FilePath 'c:\windows\temp\npp.8.5.6.Installer.x64.exe' -Args '/S' -Wait -PassThru
    Write-Host "Successfully installed Notepad++..."
       
    } catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}
