# Get the Factorise docs pack: open its address in the default browser, where the partner signs
# in with their own docs login, wait for the download, check it and unpack it. Nothing here
# signs in or handles a login. Prints only the outcome, on one line.
#
#   powershell.exe -NoProfile -ExecutionPolicy Bypass -File get-docs-windows.ps1 <folder to unpack into> [refresh|check]
#
# "check" only says whether a download is needed, and opens nothing.
# "refresh" replaces a pack that is already there with a newly downloaded one. A pack downloaded
# more than 14 days ago is replaced too, and kept if no new one arrives.
param([string]$Dest = "", [string]$Refresh = "")

$url = "https://docs.factorise-suite.com/downloads/factorise-docs-pack.zip"
$dl = Join-Path $env:USERPROFILE "Downloads"
$waitS = 150
if ($Dest -eq "") { Write-Output "Not ready: no folder was given to unpack the docs into."; exit 2 }
$Dest = [IO.Path]::GetFullPath($Dest).TrimEnd('\', '/')

# The folder is replaced whole with every new pack, so it must be one of ours: called
# factorise-docs, and either not there yet, empty, or holding a pack already.
if ((Split-Path $Dest -Leaf) -ne "factorise-docs") {
  Write-Output "Not ready: the docs folder has to be called factorise-docs."; exit 2
}
if (Test-Path -LiteralPath $Dest) {
  $isPack = (Test-Path -LiteralPath (Join-Path $Dest "pack.json")) -and (Test-Path -LiteralPath (Join-Path $Dest "INDEX.md"))
  $isEmptyFolder = (Test-Path -LiteralPath $Dest -PathType Container) -and -not (Get-ChildItem -LiteralPath $Dest -Force | Select-Object -First 1)
  if (-not $isPack -and -not $isEmptyFolder) {
    Write-Output "Not ready: $Dest already holds something that isn't a docs pack. Move it somewhere else first."; exit 4
  }
}
# Where the pack that's there waits while the new one is put in place. Never a name of the partner's.
$old = Join-Path (Split-Path $Dest -Parent) (".factorise-docs.replaced." + $PID)

# The pack's date, and nothing else a pack might put there.
function BuiltOf($dir) {
  try { $built = [string](Get-Content (Join-Path $dir "pack.json") -Raw | ConvertFrom-Json).built } catch { return "" }
  if ($built -match '\A[0-9-]{1,10}\z') { return $built }
  return ""
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
  $keep = BuiltOf $Dest; if ($keep -eq "") { $keep = "unknown date" }
}

New-Item -ItemType Directory -Force -Path $work | Out-Null

# The newest docs pack zip in Downloads or next to the destination, written after $since.
function Newest($since) {
  Get-ChildItem -Path $dl, (Split-Path $Dest -Parent) -Filter "factorise-docs-pack*.zip" -File -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -gt $since } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
}

# False when the browser recorded where the download came from and that isn't the docs site.
# A file with no such record, such as one copied by hand, passes.
function FromDocsSite($path) {
  try { $zone = @(Get-Content -LiteralPath $path -Stream Zone.Identifier -ErrorAction Stop) } catch { return $true }
  $from = $zone | Where-Object { $_ -like "HostUrl=*" } | Select-Object -First 1
  if (-not $from -or $from -eq "HostUrl=about:internet") { return $true }
  return $from.StartsWith("HostUrl=https://docs.factorise-suite.com/", [StringComparison]::OrdinalIgnoreCase)
}

# Check a zip and put it in place. Returns while a download is still being written, and exits
# with the outcome otherwise.
function Use($zip, $skipUnusable = $false) {
  $x = Join-Path $work "x"
  if (Test-Path $x) { Remove-Item -Recurse -Force $x }
  if (-not (FromDocsSite $zip.FullName)) {
    if ($skipUnusable) { return }
    Stop 3 "Not ready: $($zip.Name) didn't come from docs.factorise-suite.com, so it wasn't used. Remove it from the Downloads folder."
  }
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
  # Keep only the pages and pack.json. Nothing hidden, nothing that runs, and no file that Claude
  # Code would read as instructions of its own.
  Get-ChildItem -LiteralPath $x -Recurse -Force |
    Where-Object { $_.Name -like ".*" -or $_.Name -eq "__MACOSX" -or $_.Name -like "CLAUDE*.md" -or $_.Name -eq "AGENTS.md" } |
    ForEach-Object { if (Test-Path -LiteralPath $_.FullName) { Remove-Item -Recurse -Force -LiteralPath $_.FullName } }
  Get-ChildItem -LiteralPath $x -Recurse -Force -File |
    Where-Object { $_.Extension -ne ".md" -and $_.Name -ne "pack.json" } |
    ForEach-Object { Remove-Item -Force -LiteralPath $_.FullName }
  $packFile = Get-ChildItem -Path $x -Filter "pack.json" -Recurse -Depth 1 | Select-Object -First 1
  $ok = $false
  if ($packFile) {
    $root = $packFile.DirectoryName
    try { $ok = ((Get-Content $packFile.FullName -Raw | ConvertFrom-Json).format -eq 1) -and (Test-Path (Join-Path $root "INDEX.md")) } catch { $ok = $false }
  }
  if (-not $ok -and $skipUnusable) { return }
  # A pack in a newer format is ours, and no use to this version: don't leave it in Downloads.
  if (-not $ok -and $packFile -and (Test-Path (Join-Path $root "INDEX.md"))) { Remove-Item -Force $zip.FullName }
  if (-not $ok) {
    Stop 3 "Not ready: the downloaded file isn't a docs pack this version of make-demo can read."
  }
  # Keep the pack that's there until the new one is in place.
  if (Test-Path -LiteralPath $old) { Stop 4 "Not ready: couldn't write to $Dest." }
  try {
    if (Test-Path $Dest) { Move-Item -Path $Dest -Destination $old }
    New-Item -ItemType Directory -Force -Path (Split-Path $Dest -Parent) | Out-Null
    Move-Item -Path $root -Destination $Dest
    Set-Content -Path (Join-Path $Dest ".downloaded") -Value ""
    if (Test-Path $old) { Remove-Item -Recurse -Force $old }
  } catch {
    if ((Test-Path $old) -and -not (Test-Path $Dest)) { Move-Item -Path $old -Destination $Dest }
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
if ($Refresh -eq "check") {
  Remove-Item -Recurse -Force $work
  Write-Output "Needed: a docs pack has to be downloaded."; exit 0
}

$start = Get-Date
try { Start-Process $url } catch { Stop 4 "Not ready: couldn't open the browser on this computer." }

$waited = 0
while ($waited -lt $waitS) {
  Start-Sleep -Seconds 3; $waited += 3
  $found = Newest $start
  if ($found) { Use $found }
}
Stop 1 "Not downloaded: no docs pack arrived in the Downloads folder within $([int]($waitS / 60)) minutes."
