<#
  Catches the one mistake that fails silently.

  date_added is what the map rings as New this week, for seven days. Every
  record already carries the key, so leaving it null is not a syntax error and
  not a broken page: the producer simply goes on the map having never been
  new, and nobody notices for a week, by which point it is too late to fix.
  That happened to Giron's Farm, Carraig Abhainn Farm and Carncash Farm.

  So this compares producers.json against the committed copy and fails if an
  id that was not there before has no date. Run it before committing a new
  listing. It is a check, not a fixer: it never writes to producers.json.

  Usage:  powershell -NoProfile -File check-new-producers.ps1
  Exit 0 = nothing to flag.  Exit 1 = something needs a date.
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

function Load($text) {
  $obj = $text | ConvertFrom-Json
  if ($obj.PSObject.Properties.Name -contains 'producers') { return $obj.producers }
  return $obj
}

$now = Load (Get-Content -LiteralPath 'producers.json' -Raw)

# The committed copy. On a first commit of the file there is nothing to diff
# against, so every record counts as new.
$wasText = $null
try { $wasText = (& git show HEAD:producers.json 2>$null) -join "`n" } catch {}
$wasIds = @()
if ($wasText) { $wasIds = @(Load $wasText | ForEach-Object { $_.id }) }

$added  = @($now | Where-Object { $wasIds -notcontains $_.id })
$noDate = @($added | Where-Object { -not $_.date_added })

# A date that is not a date, or is in the future, on any record.
$today = (Get-Date).Date
$bad = @($now | Where-Object {
  $_.date_added -and (
    ($_.date_added -notmatch '^\d{4}-\d{2}-\d{2}$') -or
    ([datetime]::ParseExact($_.date_added, 'yyyy-MM-dd', $null) -gt $today)
  )
})

Write-Output "producers.json: $($now.Count) records, $($added.Count) new since HEAD"
Write-Output ""

if ($noDate.Count) {
  Write-Output "MISSING date_added on a new listing:"
  foreach ($p in $noDate) { Write-Output ("  {0}  ({1})" -f $p.name, $p.id) }
  Write-Output ""
  Write-Output "Set it to today as YYYY-MM-DD, or the pin never shows as New this week."
}
if ($bad.Count) {
  Write-Output "BAD date_added:"
  foreach ($p in $bad) { Write-Output ("  {0}  = '{1}'" -f $p.name, $p.date_added) }
  Write-Output ""
}

if (-not $noDate.Count -and -not $bad.Count) {
  $glow = @($now | Where-Object {
    $_.date_added -and
    $_.date_added -match '^\d{4}-\d{2}-\d{2}$' -and
    ($today - [datetime]::ParseExact($_.date_added, 'yyyy-MM-dd', $null)).Days -lt 7
  })
  Write-Output "OK. Nothing missing a date."
  Write-Output "Glowing as New this week right now: $($glow.Count)"
  foreach ($p in $glow) { Write-Output ("  {0}  {1}" -f $p.date_added, $p.name) }
  exit 0
}
exit 1
