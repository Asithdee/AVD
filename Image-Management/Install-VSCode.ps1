Try {
       
    # Download VSCode Sources
    Write-Host "Downloading VS Code sources..."
    Invoke-WebRequest -Uri 'https://aka.ms/vscode-win32-x64-system-stable' -OutFile 'c:\windows\temp\VSCode_x64.exe'
    # Wait 10s
    Start-Sleep -Seconds 10
    # Install VSCode silently
    Write-Host "Installing VS Code now..."
    Start-Process -FilePath 'c:\windows\temp\VSCode_x64.exe' -Args '/verysilent /suppressmsgboxes /mergetasks=!runcode' -Wait -PassThru
    Write-Host "Successfully installed VS Code..."
}
