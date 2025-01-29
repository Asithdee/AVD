#https://aka.ms/AzureConnectedMachineAgent

Try {
       
    # Download VSCode Sources
    Write-Host "Downloading ARC Agent sources..."
    Invoke-WebRequest -Uri 'https://aka.ms/AzureConnectedMachineAgent' -OutFile 'c:\windows\temp\AzureConnectedMachineAgent.msi'
    # Wait 10s
    Start-Sleep -Seconds 10
    # Install VSCode silently
    Write-Host "Installing ARC Connected Agent..."
    Start-Process -FilePath 'c:\windows\temp\AzureConnectedMachineAgent.msi' -Args '/quiet' -Wait -PassThru
    Write-Host "Successfully ARC Connected Agent..."

       } catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}
