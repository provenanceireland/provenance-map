# Builds a self-contained snapshot of a Featured profile page for review as
# an Artifact: the live page with producers.json and profile.json inlined,
# every image embedded, the analytics tag dropped, and each film poster
# opening YouTube in a new tab (the Artifact sandbox does not allow the
# embedded player). Nothing on the live page changes.
#
#   powershell -File snapshot-profile.ps1 -Slug skehanahill -Out "<path>.html"

param(
  [string]$Slug = "skehanahill",
  [string]$Out = "",
  [int]$PhotoEdge = 1100
)
Add-Type -AssemblyName System.Drawing
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$dir  = Join-Path $root $Slug
if (-not $Out) { $Out = Join-Path $root "$Slug-snapshot.html" }

$html    = Get-Content -LiteralPath (Join-Path $dir "index.html") -Raw -Encoding UTF8
$prods   = Get-Content -LiteralPath (Join-Path $root "producers.json") -Raw -Encoding UTF8
$profile = Get-Content -LiteralPath (Join-Path $dir "profile.json") -Raw -Encoding UTF8

# Inline every image the page references, resized so the snapshot stays light.
$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object MimeType -eq 'image/jpeg'
$q = New-Object System.Drawing.Imaging.EncoderParameters 1
$q.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]74)
function DataUri($file) {
  $img = [System.Drawing.Image]::FromFile($file)
  $scale = [Math]::Min(1.0, $PhotoEdge / [Math]::Max($img.Width, $img.Height))
  $w = [int]($img.Width * $scale); $h = [int]($img.Height * $scale)
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp); $g.InterpolationMode = 'HighQualityBicubic'; $g.DrawImage($img, 0, 0, $w, $h); $g.Dispose()
  $ms = New-Object System.IO.MemoryStream; $bmp.Save($ms, $enc, $q); $bmp.Dispose(); $img.Dispose()
  "data:image/jpeg;base64," + [Convert]::ToBase64String($ms.ToArray())
}
$uris = @{}
Get-ChildItem -LiteralPath $dir -File | Where-Object { $_.Extension -match '\.(jpg|jpeg|png)$' } | ForEach-Object { $uris[$_.Name] = DataUri $_.FullName }
foreach ($name in $uris.Keys) { $profile = $profile.Replace('"' + $name + '"', '"' + $uris[$name] + '"') }
$html = $html.Replace('<img src="map.jpg"', '<img src="' + $uris['map.jpg'] + '"')

# The page fetches its data; the snapshot carries it.
$fetchStart = $html.IndexOf('    // ── load ──')
$fetchEnd   = $html.IndexOf('  </script>', $fetchStart)
if ($fetchStart -lt 0 -or $fetchEnd -lt 0) { throw "load block not found" }
$inline = @"
    // ── snapshot: data inlined at build time ──
    const SNAPSHOT_PRODUCERS = $prods;
    const SNAPSHOT_PROFILE = $profile;
    render(SNAPSHOT_PRODUCERS.producers.find(p => p.id === PRODUCER_ID), SNAPSHOT_PRODUCERS.producers, SNAPSHOT_PROFILE);
"@
$html = $html.Substring(0, $fetchStart) + $inline + $html.Substring($fetchEnd)

# Posters open YouTube in a new tab instead of loading the player.
$html = $html.Replace("          w.innerHTML = ``<iframe src=`"https://www.youtube.com/embed/`${w.dataset.id}?autoplay=1&rel=0&playsinline=1`" allow=`"accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture`" allowfullscreen></iframe>``;", "          window.open('https://www.youtube.com/watch?v=' + w.dataset.id, '_blank', 'noopener');")

# No analytics from a review copy, and no fetch of the icon.
$tagStart = $html.IndexOf('  <!-- Google tag (gtag.js) -->')
$tagEnd   = $html.IndexOf('  <link rel="preconnect"', $tagStart)
if ($tagStart -ge 0 -and $tagEnd -gt $tagStart) { $html = $html.Substring(0, $tagStart) + $html.Substring($tagEnd) }
$html = $html.Replace('  <link rel="icon" href="../icons/icon-192.png" />' + "`n", '')
$html = $html.Replace('<title>Skehana Hill - Provenance</title>', '<title>Skehana Hill Profile</title>')
# Links back to the map point at the live site.
$html = $html.Replace('href="../?producer=', 'href="https://provenancemap.ie/?producer=').Replace('href="../"', 'href="https://provenancemap.ie/"')

[IO.File]::WriteAllText($Out, $html, (New-Object System.Text.UTF8Encoding $false))
"Snapshot written to {0} ({1} KB, {2} images inlined)" -f $Out, [math]::Round((Get-Item $Out).Length / 1KB), $uris.Count
