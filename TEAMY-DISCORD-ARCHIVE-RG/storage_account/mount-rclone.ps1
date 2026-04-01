param(
    [string]$StorageAccountName = 'teamydiscordarchive',
    [string]$ResourceGroupName = 'TEAMY-DISCORD-ARCHIVE-RG',
    [string]$ContainerName = 'teamy-discord-archive',
    [string]$RemoteName = 'teamydiscordarchive',
    [string]$MountPath = "$env:USERPROFILE\\rclone-mounts\\teamy-discord-archive",
    [string]$ConfigPath = (Join-Path $PSScriptRoot 'ignore\teamydiscordarchive-rclone.conf'),
    [string]$StorageAccountKey,
    [switch]$Force
)

$rclone = Get-Command rclone -ErrorAction SilentlyContinue
if (-not $rclone) {
    throw 'rclone is required but was not found on PATH.'
}

if (-not $StorageAccountKey) {
    $az = Get-Command az -ErrorAction SilentlyContinue
    if (-not $az) {
        throw 'Provide -StorageAccountKey or install Azure CLI so the script can fetch the key automatically.'
    }

    $StorageAccountKey = az storage account keys list --resource-group $ResourceGroupName --account-name $StorageAccountName --query "[0].value" --output tsv
    if (-not $StorageAccountKey) {
        throw 'Failed to resolve a storage account key via Azure CLI.'
    }
}

if ((Test-Path $ConfigPath) -and -not $Force) {
    throw "Config file already exists at $ConfigPath. Re-run with -Force to overwrite it."
}

New-Item -ItemType Directory -Path (Split-Path -Parent $ConfigPath) -Force | Out-Null

$mountParent = Split-Path -Parent $MountPath
if ($mountParent) {
    New-Item -ItemType Directory -Path $mountParent -Force | Out-Null
}

if (Test-Path $MountPath) {
    $existingEntries = @(Get-ChildItem -Force -LiteralPath $MountPath -ErrorAction Stop)
    if ($existingEntries.Count -gt 0) {
        throw "Mount path already exists and is not empty: $MountPath. Remove it or choose a different -MountPath."
    }

    Remove-Item -LiteralPath $MountPath -Force
}

$configLines = @(
    "[$RemoteName]",
    'type = azureblob',
    "account = $StorageAccountName",
    "key = $StorageAccountKey"
)

Set-Content -Path $ConfigPath -Value $configLines -Encoding ascii

Write-Host "Mounting $RemoteName`:$ContainerName to $MountPath"
Write-Host 'This stays in the foreground. Stop it with Ctrl+C when you want to unmount.'

& $rclone.Source mount "$RemoteName`:$ContainerName" $MountPath --config $ConfigPath --vfs-cache-mode full --dir-cache-time 5m