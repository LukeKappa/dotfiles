# apply.ps1
$User = [System.Environment]::UserName
$Dotfiles = "C:\Users\$User\dotfiles"
$AppData = "$env:APPDATA"
$LocalAppData = "$env:LOCALAPPDATA"

Write-Host "--- Starting Dotfiles Sync ---" -ForegroundColor Cyan

# 1. STEAM (Millennium)
Write-Host "Linking Steam Skins..." -ForegroundColor Yellow
$SteamSkins = "C:\Program Files (x86)\Steam\steamui\skins"
# Creates the link if the folder exists in your dotfiles
if (Test-Path "$Dotfiles\steam\skins") {
    # Optional: Back up existing skins folder if needed, or just link inside it
    # This example links individual skin folders to avoid overwriting the whole dir
    Get-ChildItem "$Dotfiles\steam\skins" | ForEach-Object {
        $Target = "$SteamSkins\$($_.Name)"
        if (!(Test-Path $Target)) {
            New-Item -ItemType SymbolicLink -Path $Target -Target $_.FullName -Force | Out-Null
            Write-Host "Linked Skin: $($_.Name)"
        }
    }
}

# 2. EQUICORD
Write-Host "Linking Equicord Themes..." -ForegroundColor Yellow
$EquicordPath = "$AppData\Equicord"
# Ensure Equicord folder exists (it might not if you haven't run it yet)
if (!(Test-Path $EquicordPath)) { New-Item -ItemType Directory -Path $EquicordPath | Out-Null }

# Link Themes
if (Test-Path "$Dotfiles\equicord\themes") {
    $ThemeTarget = "$EquicordPath\themes"
    # Remove existing folder if it's a real folder to replace with symlink (Use with caution!)
    # Safer method: Link content INSIDE the folder
    if (!(Test-Path $ThemeTarget)) { New-Item -ItemType Directory -Path $ThemeTarget | Out-Null }
    
    Get-ChildItem "$Dotfiles\equicord\themes" | ForEach-Object {
        New-Item -ItemType SymbolicLink -Path "$ThemeTarget\$($_.Name)" -Target $_.FullName -Force | Out-Null
    }
}

# 3. SPICETIFY
Write-Host "Linking Spicetify..." -ForegroundColor Yellow
$SpicetifyConfigPath = "$AppData\spicetify"

# Link Themes
if (Test-Path "$Dotfiles\spicetify\Themes") {
    Get-ChildItem "$Dotfiles\spicetify\Themes" | ForEach-Object {
        New-Item -ItemType SymbolicLink -Path "$SpicetifyConfigPath\Themes\$($_.Name)" -Target $_.FullName -Force | Out-Null
    }
}

# Link Extensions
if (Test-Path "$Dotfiles\spicetify\Extensions") {
    Get-ChildItem "$Dotfiles\spicetify\Extensions" | ForEach-Object {
        New-Item -ItemType SymbolicLink -Path "$SpicetifyConfigPath\Extensions\$($_.Name)" -Target $_.FullName -Force | Out-Null
    }
}

Write-Host "Applying Spicetify..."
spicetify apply

Write-Host "--- Done! Restart Steam/Discord to see changes. ---" -ForegroundColor Green