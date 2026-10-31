@echo off
setlocal
set "SETUP_BAT=%~f0"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=[IO.File]::ReadAllText($env:SETUP_BAT,[Text.Encoding]::UTF8);& ([ScriptBlock]::Create($s.Substring($s.LastIndexOf('#=PS='))))"
echo.
pause
exit /b

#=PS=
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$Root = 'C:\Unity'
$RepoUrl = 'https://github.com/M-634/unity-game-dev-advance'
$RepoDir = Join-Path $Root 'unity-game-dev-advance'
$ProjectDir = Join-Path $RepoDir 'unity-game-dev-advance'
$CacheDir = Join-Path $Root '_installers'
$LogFile = Join-Path $Root 'setup-log.txt'
$ScriptDir = Split-Path -Parent $env:SETUP_BAT
$HubExe = Join-Path $env:ProgramFiles 'Unity Hub\Unity Hub.exe'
$HubUrl = 'https://public-cdn.cloud.unity3d.com/hub/prod/UnityHubSetup-x64.exe'
$MinFreeGB = 20
$AssetPages = @(
    'https://assetstore.unity.com/packages/3d/characters/unity-chan-model-18705',
    'https://assetstore.unity.com/packages/3d/characters/creatures/monster-minion-survivor-pbr-polyart-269515',
    'https://assetstore.unity.com/packages/3d/characters/humanoids/fantasy/mini-legion-rock-golem-pbr-hp-polyart-94707',
    'https://assetstore.unity.com/packages/3d/animations/rpg-animations-pack-free-288783'
)

function Write-Step($text) {
    Write-Host ''
    Write-Host "=== $text ===" -ForegroundColor Cyan
}

function Write-Ok($text) {
    Write-Host "OK: $text" -ForegroundColor Green
}

function Assert-Environment {
    $identity = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
    if ($identity.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        throw '管理者として実行されています。閉じてから、ファイルをダブルクリックで実行し直してください。'
    }
    if ($env:PROCESSOR_ARCHITECTURE -ne 'AMD64') {
        throw "この PC（$env:PROCESSOR_ARCHITECTURE）には対応していません。講師に連絡してください。"
    }
    if (-not (Get-Command curl.exe -ErrorAction SilentlyContinue)) {
        throw 'curl が見つかりません。Windows を更新するか、講師に連絡してください。'
    }
}

function Find-Git {
    $command = Get-Command git.exe -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }
    $candidates = @(
        (Join-Path $env:LOCALAPPDATA 'Atlassian\SourceTree\git_local\cmd\git.exe'),
        (Join-Path $env:LOCALAPPDATA 'Atlassian\SourceTree\git_local\bin\git.exe'),
        (Join-Path $env:ProgramFiles 'Git\cmd\git.exe')
    )
    foreach ($path in $candidates) {
        if (Test-Path -LiteralPath $path) { return $path }
    }
    return $null
}

function Get-GitPath {
    $git = Find-Git
    if ($git) { return $git }

    Write-Host 'Git が無いため、winget で入れます。'
    if (-not (Get-Command winget.exe -ErrorAction SilentlyContinue)) {
        throw 'winget が使えません。https://git-scm.com/download/win から Git を入れて、もう一度実行してください。'
    }
    & winget.exe install --id Git.Git --exact --silent --accept-source-agreements --accept-package-agreements
    $git = Find-Git
    if (-not $git) {
        throw 'Git を入れられませんでした。https://git-scm.com/download/win から入れて、もう一度実行してください。'
    }
    return $git
}

function Sync-Repository($git) {
    if (Test-Path -LiteralPath (Join-Path $RepoDir '.git')) {
        & $git -C $RepoDir config core.longpaths true
        & $git -C $RepoDir fetch origin
        if ($LASTEXITCODE -ne 0) { throw 'リポジトリの更新を確認できませんでした。ネットワークを確認してください。' }
        $behind = (& $git -C $RepoDir rev-list --count 'HEAD..origin/master' | Out-String).Trim()
        Write-Ok "$RepoDir は取得済みです。手元のファイルは変更しません。"
        if ($behind -ne '0') {
            Write-Host "未取得の更新が $behind 件あります。Sourcetree でプルしてください。" -ForegroundColor Yellow
        }
        return
    }

    if ((Test-Path -LiteralPath $RepoDir) -and (Get-ChildItem -LiteralPath $RepoDir -Force | Select-Object -First 1)) {
        throw "$RepoDir に Git ではないファイルがあります。中身を消さず、講師に連絡してください。"
    }

    & $git clone -c core.autocrlf=false -c core.longpaths=true $RepoUrl $RepoDir
    if ($LASTEXITCODE -ne 0) { throw 'Clone に失敗しました。ネットワークを確認して、もう一度実行してください。' }
    Write-Ok "$RepoDir に取得しました。"
}

function Read-EditorVersion {
    $file = Join-Path $ProjectDir 'ProjectSettings\ProjectVersion.txt'
    $text = [IO.File]::ReadAllText($file)
    $match = [regex]::Match($text, 'm_EditorVersionWithRevision:\s*(\S+)\s*\((\w+)\)')
    if (-not $match.Success) { throw 'ProjectVersion.txt から Unity のバージョンを読めません。講師に連絡してください。' }
    return @{ Version = $match.Groups[1].Value; Changeset = $match.Groups[2].Value }
}

function Assert-UnitySigned($path) {
    Write-Host 'インストーラーの署名を確認しています...'
    $signature = Get-AuthenticodeSignature -LiteralPath $path
    if ($signature.Status -eq 'Valid' -and $signature.SignerCertificate.Subject -match 'O=Unity Technologies') { return }
    if ($path.StartsWith($CacheDir)) { Remove-Item -LiteralPath $path -Force }
    throw "Unity の正しい署名がありません: $path もう一度実行し、続く場合は講師に連絡してください。"
}

function Get-Installer($url, $name) {
    $local = Join-Path $ScriptDir $name
    if (Test-Path -LiteralPath $local) {
        Write-Host "同じフォルダの $name を使います。"
        return $local
    }

    $destination = Join-Path $CacheDir $name
    if (Test-Path -LiteralPath $destination) { return $destination }

    New-Item -ItemType Directory -Force -Path $CacheDir | Out-Null
    $partial = "$destination.part"
    for ($attempt = 1; $attempt -le 5; $attempt++) {
        Write-Host "ダウンロード中: $name（$attempt 回目）"
        & curl.exe -L -f -C - --connect-timeout 30 --speed-limit 1024 --speed-time 120 -o $partial $url
        if ($LASTEXITCODE -eq 0) {
            Move-Item -LiteralPath $partial -Destination $destination -Force
            return $destination
        }
        Start-Sleep -Seconds 10
    }
    throw 'ダウンロードが途中で止まりました。もう一度実行すると続きから再開します。'
}

function Install-Hub {
    if (Test-Path -LiteralPath $HubExe) {
        Write-Ok 'Unity Hub は入っています。'
        return
    }

    $installer = Get-Installer $HubUrl 'UnityHubSetup-x64.exe'
    Assert-UnitySigned $installer
    Write-Host '許可を求める画面が出たら「はい」を押してください。'
    Start-Process -FilePath $installer -ArgumentList '/S' -Verb RunAs -Wait
    if (-not (Test-Path -LiteralPath $HubExe)) { throw 'Unity Hub をインストールできませんでした。' }
    Write-Ok 'Unity Hub を入れました。'
}

function Get-EditorRoots {
    $roots = @()
    $settings = Join-Path $env:APPDATA 'UnityHub\secondaryInstallPath.json'
    if (Test-Path -LiteralPath $settings) {
        $custom = [string](Get-Content -LiteralPath $settings -Raw -Encoding UTF8 | ConvertFrom-Json)
        if ($custom) { $roots += $custom }
    }
    $roots += Join-Path $env:ProgramFiles 'Unity\Hub\Editor'
    return $roots
}

function Install-Editor($editor) {
    $version = $editor.Version
    $roots = @(Get-EditorRoots)
    foreach ($root in $roots) {
        if (Test-Path -LiteralPath (Join-Path $root "$version\Editor\Unity.exe")) {
            Write-Ok "Unity $version は入っています。"
            return
        }
    }

    $freeGB = [math]::Floor((Get-PSDrive -Name C).Free / 1GB)
    if ($freeGB -lt $MinFreeGB) {
        throw "C ドライブの空きが足りません（空き $freeGB GB、必要 $MinFreeGB GB）。"
    }

    $name = "UnitySetup64-$version.exe"
    $url = "https://download.unity3d.com/download_unity/$($editor.Changeset)/Windows64EditorInstaller/$name"
    $installer = Get-Installer $url $name
    Assert-UnitySigned $installer

    $target = Join-Path $roots[0] $version
    Write-Host '許可を求める画面が出たら「はい」を押してください。インストールには 10〜20 分ほどかかります。'
    Start-Process -FilePath $installer -ArgumentList "/S /D=$target" -Verb RunAs -Wait
    if (-not (Test-Path -LiteralPath (Join-Path $target 'Editor\Unity.exe'))) {
        throw "Unity $version をインストールできませんでした。"
    }
    Write-Ok "Unity $version を入れました。"
}

function Open-NextSteps {
    try { Set-Clipboard -Value $ProjectDir } catch { }

    Write-Step 'ここから先は手で行います'
    Write-Host '1. Unity Hub にサインインします（ライセンスの画面が出たら Personal を選びます）'
    Write-Host '2. Projects → Add → Add project from disk で次のフォルダを選びます（コピー済みです）'
    Write-Host "   $ProjectDir"
    Write-Host '3. 開いた 4 つの Asset Store のページで「マイアセットに追加」を押します'
    Write-Host '4. Unity の Package Manager → My Assets で 4 つを Download → Import します'
    Write-Host '5. Assets/_DemoGame/Scenes/DemoTitle.unity を開いて再生します'

    Start-Process -FilePath $HubExe
    foreach ($page in $AssetPages) {
        Start-Process $page
        Start-Sleep -Milliseconds 500
    }
}

try {
    Assert-Environment
    New-Item -ItemType Directory -Force -Path $Root | Out-Null
    Start-Transcript -LiteralPath $LogFile -Append | Out-Null

    Write-Step '1/3 プロジェクトを取得'
    Sync-Repository (Get-GitPath)

    Write-Step '2/3 Unity Hub を確認'
    Install-Hub

    $editor = Read-EditorVersion
    Write-Step "3/3 Unity $($editor.Version) を確認"
    Install-Editor $editor

    if (Test-Path -LiteralPath $CacheDir) { Remove-Item -LiteralPath $CacheDir -Recurse -Force }

    Open-NextSteps
    Write-Host ''
    Write-Host '自動の手順は完了しました。このウィンドウは閉じて構いません。' -ForegroundColor Green
}
catch {
    Write-Host ''
    Write-Host "止まりました: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "もう一度実行すると、終わった手順は飛ばして再開します。記録: $LogFile"
}
finally {
    try { Stop-Transcript | Out-Null } catch { }
}
