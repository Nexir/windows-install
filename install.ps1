# If script execution is not allowed, run the command below:
# Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# Change this list with your favorite programs :
# @{name = "wingetpackage.id"; source = "if_needed" },
$apps = @(
    @{name = "Microsoft.WindowsTerminal"; source = "msstore" }, 
    @{name = "Nvidia.GeForceExperience" },
    @{name = "Kensington.KensingtonWorks" },
    @{name = "LibreWolf.LibreWolf" }, 
    @{name = "Spotify.Spotify" }, 
    @{name = "Discord.Discord" }, 
    @{name = "Mozilla.Thunderbird" }, 
    @{name = "VideoLAN.VLC" },
    @{name = "VSCodium.VSCodium" },
    @{name = "7zip.7zip" },
    @{name = "KeePassXCTeam.KeePassXC" },
    @{name = "Microsoft.PowerToys" },
    @{name = "Valve.Steam" },
    @{name = "GOG.Galaxy" },
    @{name = "EpicGames.EpicGamesLauncher" },
    @{name = "Ubisoft.Connect" }
);

Clear-Host

# Get current winget version
$wingetVersion = winget --version

# Get latest winget version from github
$releases_url = 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$releases = Invoke-RestMethod -uri $releases_url

# Compare versions
if (!$wingetVersion -or $wingetVersion -lt $releases.tag_name) {
    Write-Host "Installing latest winget version"

    $latestRelease = $releases.assets | Where { $_.browser_download_url.EndsWith('msixbundle') } | Select -First 1

    "Installing winget from $($latestRelease.browser_download_url)"

    # Download and install latest winget version
    Add-AppxPackage -Path $latestRelease.browser_download_url
    
    Clear-Host
}
else {
    "winget already installed and up to date."
}

# Update winget sources
winget source update

winget upgrade --all --accept-source-agreements --accept-package-agreements

foreach ($app in $apps) {
    # Check if the app is already installed
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing:" $app.name
        if ($app.source -ne $null) {
            winget install --exact --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --id $app.name --source $app.source
        }
        else {
            winget install --exact --silent --accept-package-agreements --accept-source-agreements --disable-interactivity --id $app.name
        }
    }
    else {
        Write-host "Skipping Install of " $app.name
    }
}

Write-host "Installation over"
