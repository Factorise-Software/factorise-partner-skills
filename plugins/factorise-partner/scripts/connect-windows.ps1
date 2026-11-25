# Save, list or remove the Factorise logins that curl reads (%USERPROFILE%\.factorise\netrc,
# readable only by this user). Prints only an outcome and environment addresses, never a user name
# or password.
#
#   powershell.exe -NoProfile -ExecutionPolicy Bypass -File connect-windows.ps1 <environment host>          ask for the login in a window and save it
#   powershell.exe -NoProfile -ExecutionPolicy Bypass -File connect-windows.ps1 list                        the addresses a login is saved for
#   powershell.exe -NoProfile -ExecutionPolicy Bypass -File connect-windows.ps1 forget <environment host>   remove the login saved for that address
#
# A host looks like acme.factorise-suite.com.
param([string]$First = "", [string]$Second = "")

# USERPROFILE, not $HOME: Git Bash, where Claude Code runs curl, uses USERPROFILE as its home.
$dir = Join-Path $env:USERPROFILE ".factorise"
$f = Join-Path $dir "netrc"
$utf8 = New-Object System.Text.UTF8Encoding($false)

$mode = "save"; $EnvHost = $First
if ($First -ceq "list") { $mode = "list" }
elseif ($First -ceq "forget") { $mode = "forget"; $EnvHost = $Second }

$ErrorActionPreference = "Stop"

# The saved logins, a line each.
$saved = @()
if (Test-Path -LiteralPath $f) {
  try { $saved = @([IO.File]::ReadAllLines($f, $utf8)) }
  catch {
    Write-Output "Not done: the file with your saved logins can't be read, so it was left as it is."
    exit 4
  }
}

if ($mode -eq "list") {
  # Only names that look like a host are printed, whatever else the file holds.
  $hosts = @($saved | ForEach-Object {
      $w = @($_.Trim() -split '\s+')
      if ($w.Count -ge 2 -and $w[0] -ceq "machine" -and $w[1].ToLowerInvariant() -cmatch '\A[a-z0-9][a-z0-9.-]*\.[a-z][a-z]+\z') { $w[1].ToLowerInvariant() }
    } | Sort-Object -Unique)
  if ($hosts.Count -gt 0) { Write-Output ("Logins saved for: " + ($hosts -join " ")) } else { Write-Output "No logins saved." }
  exit 0
}

# Lower case, so one environment is never saved twice. A name, not a number: it starts with a
# letter or digit and ends in letters.
$EnvHost = $EnvHost.ToLowerInvariant()
if ($EnvHost -cnotmatch '\A[a-z0-9][a-z0-9-]*(\.[a-z0-9-]+)*\.[a-z]{2,}\z') {
  Write-Output "Not done: the address should look like acme.factorise-suite.com, without https:// or a port."
  exit 2
}

# True for the line that holds this host's login.
function IsHostLine($line) {
  $w = @($line.Trim() -split '\s+')
  return ($w.Count -ge 2 -and $w[0] -ceq "machine" -and $w[1].ToLowerInvariant() -ceq $EnvHost)
}

# Write the lines to a new file, make it private to this user, and only then put it in place, so
# a login is never readable by others and the file stays as it was if anything fails.
function SaveLines($lines) {
  $tmp = "$f.new"
  try {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    [IO.File]::WriteAllText($tmp, "", $utf8)
    $sid = [Security.Principal.WindowsIdentity]::GetCurrent().User.Value
    icacls $tmp /inheritance:r /grant:r "*$($sid):(R,W,D)" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "icacls" }
    [IO.File]::WriteAllText($tmp, (($lines -join "`n") + "`n"), $utf8)
    Move-Item -Force -LiteralPath $tmp -Destination $f
    return $true
  } catch {
    try { if (Test-Path -LiteralPath $tmp) { Remove-Item -Force -LiteralPath $tmp } } catch { }
    return $false
  }
}

$lines = $saved
$others = @($lines | Where-Object { -not (IsHostLine $_) })

if ($mode -eq "forget") {
  if ($others.Count -eq $lines.Count) { Write-Output "No login was saved for $EnvHost."; exit 0 }
  $ok = $true
  if ($others.Count -eq 0) { try { Remove-Item -Force -LiteralPath $f } catch { $ok = $false } }
  else { $ok = SaveLines $others }
  if (-not $ok) { Write-Output "Not done: the file with your saved logins couldn't be changed."; exit 4 }
  Write-Output "Removed the login for $EnvHost."
  exit 0
}

# The password goes to this address with the first call, so an address outside Factorise's own
# domain is pointed out in the window itself, where the person typing sees it.
$note = ""
if (-not $EnvHost.EndsWith(".factorise-suite.com")) {
  $note = "Note: $EnvHost is not an address on factorise-suite.com. Only go on if you're sure it's your Factorise environment.`r`n`r`n"
}

# A window of our own, not Get-Credential: that one is refused on some Windows computers. It
# stays on top, and closes by itself after 5 minutes, within the skill's 6-minute timeout.
$u = $null; $p = $null
try {
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing
  [Windows.Forms.Application]::EnableVisualStyles()
  $form = New-Object Windows.Forms.Form
  $form.Text = "Factorise login for $EnvHost"
  $form.FormBorderStyle = "FixedDialog"; $form.MaximizeBox = $false; $form.MinimizeBox = $false
  $form.StartPosition = "CenterScreen"; $form.TopMost = $true; $form.ShowInTaskbar = $true
  $form.AutoScaleMode = "Font"; $form.Font = New-Object Drawing.Font("Segoe UI", 9)
  $form.ClientSize = New-Object Drawing.Size(420, 10)
  $form.Padding = New-Object Windows.Forms.Padding(14)
  $panel = New-Object Windows.Forms.TableLayoutPanel
  $panel.Dock = "Fill"; $panel.ColumnCount = 2; $panel.AutoSize = $true; $panel.AutoSizeMode = "GrowAndShrink"
  $intro = New-Object Windows.Forms.Label
  $intro.Text = "$($note)Enter the Factorise account you made for Claude. The password goes straight into a file only you can read, not into the chat."
  $intro.AutoSize = $true; $intro.MaximumSize = New-Object Drawing.Size(390, 0)
  $intro.Margin = New-Object Windows.Forms.Padding(3, 3, 3, 12)
  $panel.Controls.Add($intro, 0, 0); $panel.SetColumnSpan($intro, 2)
  $userLabel = New-Object Windows.Forms.Label; $userLabel.Text = "User name"; $userLabel.AutoSize = $true; $userLabel.Anchor = "Left"
  $userBox = New-Object Windows.Forms.TextBox; $userBox.Width = 290
  $passLabel = New-Object Windows.Forms.Label; $passLabel.Text = "Password"; $passLabel.AutoSize = $true; $passLabel.Anchor = "Left"
  $passBox = New-Object Windows.Forms.TextBox; $passBox.Width = 290; $passBox.UseSystemPasswordChar = $true
  $panel.Controls.Add($userLabel, 0, 1); $panel.Controls.Add($userBox, 1, 1)
  $panel.Controls.Add($passLabel, 0, 2); $panel.Controls.Add($passBox, 1, 2)
  $buttons = New-Object Windows.Forms.FlowLayoutPanel
  $buttons.FlowDirection = "RightToLeft"; $buttons.AutoSize = $true; $buttons.Dock = "Fill"
  $buttons.Margin = New-Object Windows.Forms.Padding(0, 12, 0, 0)
  $cancel = New-Object Windows.Forms.Button; $cancel.Text = "Cancel"; $cancel.DialogResult = "Cancel"
  $save = New-Object Windows.Forms.Button; $save.Text = "Save"; $save.DialogResult = "OK"
  $buttons.Controls.Add($cancel); $buttons.Controls.Add($save)
  $panel.Controls.Add($buttons, 0, 3); $panel.SetColumnSpan($buttons, 2)
  $form.Controls.Add($panel); $form.AutoSize = $true; $form.AutoSizeMode = "GrowAndShrink"
  $form.AcceptButton = $save; $form.CancelButton = $cancel
  $timer = New-Object Windows.Forms.Timer; $timer.Interval = 300000
  $timer.Add_Tick({ $form.DialogResult = "Cancel"; $form.Close() }); $timer.Start()
  $form.Add_Shown({ $form.Activate(); $userBox.Focus() })
  # A program started without a window of its own, as from Claude Code's shell, can be told to
  # hide the first window it shows. This first call takes that instruction, so the form shows.
  $show = Add-Type -PassThru -Namespace Factorise -Name Win -MemberDefinition '[DllImport("user32.dll")] public static extern bool ShowWindow(System.IntPtr hWnd, int nCmdShow);'
  [void]$show::ShowWindow($form.Handle, 0)
  $result = $form.ShowDialog()
  $timer.Stop()
  if ($result -eq "OK") { $u = $userBox.Text; $p = $passBox.Text }
  $form.Dispose()
} catch {
  Write-Output "Not saved: the login window couldn't open on this computer."
  exit 4
}
if ($null -eq $u) { Write-Output "Cancelled. Nothing saved."; exit 1 }

foreach ($v in @($u, $p)) {
  if ([string]::IsNullOrEmpty($v) -or $v -match '[\s"\\#]') {
    Write-Output "Not saved: the user name or password is empty, or has a space, quote, # or backslash in it."
    exit 3
  }
}

if (-not (SaveLines ($others + "machine $EnvHost login $u password $p"))) {
  Write-Output "Not saved: the file with your saved logins couldn't be written, or couldn't be made private to your account."
  exit 4
}
Write-Output "Saved"
