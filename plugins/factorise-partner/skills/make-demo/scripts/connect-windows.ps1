# Ask for the Factorise login in a Windows sign-in dialog and save it where curl reads it
# (%USERPROFILE%\.factorise\netrc, readable only by this user). Prints only the outcome, never the login.
#
#   powershell.exe -NoProfile -ExecutionPolicy Bypass -File connect-windows.ps1 <environment host>
param([string]$EnvHost = "")

if ($EnvHost -notmatch '^[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)+$') {
  Write-Output "Not saved: the address should look like acme.factorise-suite.com, without https:// or a port."
  exit 2
}

$cred = $null
try {
  $cred = Get-Credential -Message "Factorise login for $EnvHost. Enter the account you made for Claude (role: Webhook). The password goes straight into a file only you can read, not into the chat."
} catch { $cred = $null }
if ($null -eq $cred) { Write-Output "Cancelled. Nothing saved."; exit 1 }

$u = $cred.UserName.TrimStart('\')
$p = $cred.GetNetworkCredential().Password
foreach ($v in @($u, $p)) {
  if ([string]::IsNullOrEmpty($v) -or $v -match '[\s"\\#]') {
    Write-Output "Not saved: the user name or password is empty, or has a space, quote, # or backslash in it."
    exit 3
  }
}

# USERPROFILE, not $HOME: Git Bash, where Claude Code runs curl, uses USERPROFILE as its home.
$dir = Join-Path $env:USERPROFILE ".factorise"
$f = Join-Path $dir "netrc"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$lines = @()
if (Test-Path $f) {
  $lines = @(Get-Content $f | Where-Object { -not ($_ -match "^machine\s+$([regex]::Escape($EnvHost))\s") })
}
$lines += "machine $EnvHost login $u password $p"
# Write a new file, make it private to this user, and only then put it in place, so the login is
# never readable by others and an existing file stays as it was if anything fails.
$tmp = "$f.new"
[IO.File]::WriteAllText($tmp, "", (New-Object System.Text.UTF8Encoding($false)))
$sid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
icacls $tmp /inheritance:r /grant:r "*$($sid):(R,W,D)" | Out-Null
if ($LASTEXITCODE -ne 0) {
  Remove-Item -Force $tmp
  Write-Output "Not saved: the file couldn't be made private to your account."
  exit 4
}
[IO.File]::WriteAllText($tmp, (($lines -join "`n") + "`n"), (New-Object System.Text.UTF8Encoding($false)))
Move-Item -Force $tmp $f
Write-Output "Saved"
