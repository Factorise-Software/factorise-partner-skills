# Get the Factorise docs pack: open its address in the default browser, where the partner signs
# in with their own docs login, wait for the download, check it and unpack it. Nothing here
# signs in or handles a login. Prints only the outcome, on one line.
#
#   powershell.exe -NoProfile -ExecutionPolicy Bypass -File get-docs-windows.ps1 <folder to unpack into> [refresh]
#
# "refresh" replaces a pack that is already there with a newly downloaded one. A pack downloaded
# more than 14 days ago is replaced too, and kept if no new one arrives.
param([string]$Dest = "", [string]$Refresh = "")

$url = "https://docs.factorise-suite.com/downloads/factorise-docs-pack.zip"
$dl = Join-Path $env:USERPROFILE "Downloads"
$waitS = 300
if ($Dest -eq "") { Write-Output "Not ready: no folder was given to unpack the docs into."; exit 2 }
$Dest = [IO.Path]::GetFullPath($Dest)

function BuiltOf($dir) {
  try { return (Get-Content (Join-Path $dir "pack.json") -Raw | ConvertFrom-Json).built } catch { return "" }
}

$work = Join-Path ([IO.Path]::GetTempPath()) ("factorise-docs-" + [Guid]::NewGuid().ToString("N"))

# End with the message, or, when only renewing an old pack, keep that one.
$keep = ""
function Stop($code, $message) {
  if (Test-Path $work) { Remove-Item -Recurse -Force $work }
  if ($keep -ne "") { Write-Output "Ready: docs pack of $keep, downloaded more than 14 days ago. A new one didn't arrive."; exit 0 }
  Write-Output $message; exit $code
}

if ($Refresh -ne "refresh" -and (Test-Path (Join-Path $Dest "pack.json")) -and (Test-Path (Join-Path $Dest "INDEX.md"))) {
  $stamp = Join-Path $Dest ".downloaded"
  if ((Test-Path $stamp) -and ((Get-Item -Force $stamp).LastWriteTime -gt (Get-Date).AddDays(-14))) {
    Write-Output "Ready: docs pack of $(BuiltOf $Dest)"; exit 0
  }
  $keep = BuiltOf $Dest; if ($keep -eq "") { $keep = "unknown date" }; $waitS = 120
}

New-Item -ItemType Directory -Force -Path $work | Out-Null

# The newest docs pack zip in Downloads or next to the destination, written after $since.
function Newest($since) {
  Get-ChildItem -Path $dl, (Split-Path $Dest -Parent) -Filter "factorise-docs-pack*.zip" -File -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -gt $since } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

# Check a zip and put it in place. Returns while a download is still being written, and exits
# with the outcome otherwise.
function Use($zip, $skipUnusable = $false) {
  $x = Join-Path $work "x"
  if (Test-Path $x) { Remove-Item -Recurse -Force $x }
  try {
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $archive = [IO.Compression.ZipFile]::OpenRead($zip.FullName)
    $names = @($archive.Entries | ForEach-Object { $_.FullName })
    $archive.Dispose()
  } catch { return }
  if ($names | Where-Object { $_ -match '(^[/\\]|^[A-Za-z]:|(^|[/\\])\.\.([/\\]|$))' }) {
    if ($skipUnusable) { return }
    Stop 3 "Not ready: the downloaded file isn't a Factorise docs pack."
  }
  try { Expand-Archive -Path $zip.FullName -DestinationPath $x -Force } catch { return }
  $packFile = Get-ChildItem -Path $x -Filter "pack.json" -Recurse -Depth 1 | Select-Object -First 1
  $ok = $false
  if ($packFile) {
    $root = $packFile.DirectoryName
    try { $ok = ((Get-Content $packFile.FullName -Raw | ConvertFrom-Json).format -eq 1) -and (Test-Path (Join-Path $root "INDEX.md")) } catch { $ok = $false }
  }
  if (-not $ok -and $skipUnusable) { return }
  if (-not $ok) {
    Stop 3 "Not ready: the downloaded file isn't a docs pack this version of make-demo can read."
  }
  try {
    if (Test-Path $Dest) { Remove-Item -Recurse -Force $Dest }
    New-Item -ItemType Directory -Force -Path (Split-Path $Dest -Parent) | Out-Null
    Move-Item -Path $root -Destination $Dest
    Set-Content -Path (Join-Path $Dest ".downloaded") -Value ""
  } catch {
    $script:keep = ""
    Stop 4 "Not ready: couldn't write to $Dest."
  }
  Remove-Item -Force $zip.FullName
  Remove-Item -Recurse -Force $work
  Write-Output "Ready: docs pack of $(BuiltOf $Dest)"; exit 0
}

# A pack downloaded in the last hour, such as after an earlier run timed out during sign-in.
# One that can't be used is skipped here, and a new one is downloaded.
$recent = Newest ((Get-Date).AddMinutes(-60))
if ($recent) { Use $recent $true }

$start = Get-Date
try { Start-Process $url } catch { Stop 4 "Not ready: couldn't open the browser on this computer." }

$waited = 0
while ($waited -lt $waitS) {
  Start-Sleep -Seconds 3; $waited += 3
  $found = Newest $start
  if ($found) { Use $found }
}
Stop 1 "Not downloaded: no docs pack arrived in the Downloads folder within $([int]($waitS / 60)) minutes."
