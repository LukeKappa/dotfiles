# harvest.ps1 - Run as Administrator
# This script copies YOUR CURRENT CONFIGS into the dotfiles folder

$User = [System.Environment]::UserName
$Dotfiles = "C:\Users\$User\dotfiles"
$AppData = "$env:APPDATA"
$SteamPath = "C:\Program Files (x86)\Steam\steamui\skins"

Write-Host "--- HARVESTING THEMES & PLUGINS ---" -ForegroundColor Cyan

# --- 1. STEAM (Millennium) ---
Write-Host "[1/4] Backing up Steam (Millennium)..." -ForegroundColor Yellow
$DestSteam = "$Dotfiles\steam\skins"
if (Test-Path $SteamPath) {
    if (!(Test-Path $DestSteam)) { New-Item -ItemType Directory -Path $DestSteam | Out-Null }
    Copy-Item -Path "$SteamPath\*" -Destination $DestSteam -Recurse -Force
    Write-Host "   - Skins copied." -ForegroundColor Green
} else {
    Write-Host "   - Steam skins folder not found." -ForegroundColor Red
}

# --- 2. EQUICORD ---
Write-Host "[2/4] Backing up Equicord..." -ForegroundColor Yellow
$EquicordThemes = "$AppData\Equicord\themes"
$EquicordPlugins = "$AppData\Equicord\plugins"

# Themes
if (Test-Path $EquicordThemes) {
    $Dest = "$Dotfiles\equicord\themes"
    if (!(Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest | Out-Null }
    Copy-Item -Path "$EquicordThemes\*.css" -Destination $Dest -Force
    Write-Host "   - Themes copied." -ForegroundColor Green
}

# Plugins
if (Test-Path $EquicordPlugins) {
    $Dest = "$Dotfiles\equicord\plugins"
    if (!(Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest | Out-Null }
    Copy-Item -Path "$EquicordPlugins\*.js" -Destination $Dest -Force
    Write-Host "   - Plugins copied." -ForegroundColor Green
}
# --- 3. SPICETIFY ---
Write-Host "[3/4] Backing up Spicetify..." -ForegroundColor Yellow

try {
    # 1. Run 'spicetify path' to get the root directory
    $SpicetifyRoot = (spicetify path).Trim()

    if ($SpicetifyRoot -match "fatal" -or -not (Test-Path $SpicetifyRoot)) {
        Write-Warning "   Command 'spicetify path' failed or returned invalid path."
    }
    else {
        Write-Host "   - Spicetify detected at: $SpicetifyRoot" -ForegroundColor DarkGray
        
        # Define the specific theme we want
        $TargetTheme = "Spicetify-retro"
        $ThemeSource = "$SpicetifyRoot\Themes\$TargetTheme"
        
        # Copy ONLY Spicetify-retro
        if (Test-Path $ThemeSource) {
            $Dest = "$Dotfiles\spicetify\Themes"
            if (!(Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest | Out-Null }
            
            # Copy the specific theme folder
            Copy-Item -Path $ThemeSource -Destination $Dest -Recurse -Force
            Write-Host "   - Theme '$TargetTheme' copied." -ForegroundColor Green
        } else {
            Write-Warning "   - Theme '$TargetTheme' not found in your Spicetify folder."
        }

        # Copy Extensions (Preserved, as these are usually required for the theme to work)
        $ExtensionSource = "$SpicetifyRoot\Extensions"
        if (Test-Path $ExtensionSource) {
            $Dest = "$Dotfiles\spicetify\Extensions"
            if (!(Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest | Out-Null }
            Copy-Item -Path "$ExtensionSource\*" -Destination $Dest -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "   - Extensions copied." -ForegroundColor Green
        }
    }
} catch {
    Write-Error "   Could not execute 'spicetify path'. Is Spicetify in your environment PATH?"
}

# --- 4. YOUTUBE ENHANCER ---
Write-Host "[4/4] YouTube Enhancer" -ForegroundColor Magenta
Write-Host "   ⚠️  MANUAL ACTION REQUIRED ⚠️" -ForegroundColor White
Write-Host "   Browser extensions cannot be script-copied safely."
Write-Host "   1. Open Enhancer for YouTube Settings."
Write-Host "   2. Scroll to 'Backup and restore'."
Write-Host "   3. Click 'Export settings'."
Write-Host "   4. Save the JSON file to: $Dotfiles\browsers\youtube-settings.json"

Write-Host "`n--- Harvest Complete! ---" -ForegroundColor Cyan
Write-Host "Next Step: Run these commands to sync to GitHub:"
Write-Host "cd $Dotfiles"
Write-Host "git add ."
Write-Host "git commit -m 'Backup my themes'"
Write-Host "git push"