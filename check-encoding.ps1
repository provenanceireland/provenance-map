# check-encoding.ps1
#
# Guards producers.json and the release files against the one mistake that has
# actually happened: a UTF-8 file read as Windows-1252 and written back as
# UTF-8, which turns every accented letter into mojibake.
#
#   Glasrai Organic Farm   ->  Glasra<C3><83><C2><AD> Organic Farm   (rendered "GlasraA-")
#   EUR 100                ->  <C3><A2><E2><82><AC>100
#   GBP 6                  ->  <C3><82><C2><A3>6
#
# It happened on 2026-11-19 (commit 4cb095a) and rode along in six commits and
# onto the live site before anyone noticed, because the damage is invisible
# unless you look at a record with a fada in it.
#
# This script reads raw BYTES and never writes anything, so it cannot itself
# damage a file. Run it before committing any change to producers.json:
#
#   powershell -NoProfile -ExecutionPolicy Bypass -File check-encoding.ps1
#
# Exit code 0 = clean, 1 = something is wrong. Do not commit on a non-zero exit.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$targets = @()
$targets += (Join-Path $root 'producers.json')
$releases = Join-Path $root 'releases'
if (Test-Path $releases) {
  $targets += (Get-ChildItem -Path $releases -Filter '*.json' -File | ForEach-Object { $_.FullName })
}

$problems = 0
$checked  = 0

foreach ($path in $targets) {
  if (-not (Test-Path $path)) { continue }
  $name  = [System.IO.Path]::GetFileName($path)
  $bytes = [System.IO.File]::ReadAllBytes($path)
  $checked++

  # 1. A UTF-8 BOM. None of these files is supposed to carry one, and a BOM
  #    appearing is the tell that something rewrote the file through a
  #    PowerShell text cmdlet rather than editing it in place.
  if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
    Write-Output "FAIL  $name : starts with a UTF-8 BOM. It should start with its first real character."
    $problems++
  }

  # 2. Double-encoding markers, scanned over raw bytes.
  #      C3 83          = "A-tilde", the first byte of any double-encoded accent
  #      C2 80..C2 9F   = "A-circumflex" + a C1 control, which real text never has
  $cnt3 = 0; $cnt2 = 0; $firstLine3 = 0; $firstLine2 = 0; $line = 1
  for ($i = 0; $i -lt $bytes.Length - 1; $i++) {
    if ($bytes[$i] -eq 0x0A) { $line++; continue }
    if ($bytes[$i] -eq 0xC3 -and $bytes[$i+1] -eq 0x83) {
      $cnt3++; if ($firstLine3 -eq 0) { $firstLine3 = $line }
    }
    elseif ($bytes[$i] -eq 0xC2 -and $bytes[$i+1] -ge 0x80 -and $bytes[$i+1] -le 0x9F) {
      $cnt2++; if ($firstLine2 -eq 0) { $firstLine2 = $line }
    }
  }
  if ($cnt3 -gt 0) {
    Write-Output "FAIL  $name : $cnt3 double-encoded sequence(s), first at line $firstLine3."
    $problems++
  }
  if ($cnt2 -gt 0) {
    Write-Output "FAIL  $name : $cnt2 stray C1 control sequence(s), first at line $firstLine2."
    $problems++
  }

  # 3. Valid UTF-8 throughout. Strict decoding throws on a bad sequence.
  try {
    $strict = New-Object System.Text.UTF8Encoding($false, $true)
    [void]$strict.GetString($bytes)
  } catch {
    Write-Output "FAIL  $name : not valid UTF-8. $($_.Exception.Message)"
    $problems++
  }
}

Write-Output ""
if ($problems -eq 0) {
  Write-Output "OK. $checked file(s) checked, encoding is clean."
  exit 0
}

Write-Output "$problems problem(s) found. DO NOT COMMIT."
Write-Output ""
Write-Output "Almost certainly a PowerShell read/write round trip. Get-Content without"
Write-Output "-Encoding UTF8 reads the file as Windows-1252, and Set-Content / Out-File"
Write-Output "then write those wrong characters back out as UTF-8."
Write-Output ""
Write-Output 'To edit producers.json, change only the bytes you mean to change,'
Write-Output 'with a byte-safe tool such as perl or sed from the Bash tool:'
Write-Output '  perl -0777 -i -pe ''s/OLD/NEW/'' producers.json'
Write-Output 'Never load the whole file into PowerShell and write it back.'
Write-Output ""
Write-Output "To repair a file that is already damaged, see the encoding section in CLAUDE.md."
exit 1
