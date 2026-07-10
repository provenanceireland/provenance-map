# generate-share-pages.ps1
# Generates /share/<slug>.html stub pages for all Provenance Verified (and above) producers.
# Each stub carries the producer's Open Graph tags so shared links preview with their
# photo and name in WhatsApp/iMessage/etc., then redirects to the map with their card open.
#
# Run this after upgrading a producer to "verified" in producers.json:
#   powershell -File generate-share-pages.ps1
# Then commit the new share/<slug>.html file and push.

$root = $PSScriptRoot
$data = Get-Content (Join-Path $root 'producers.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$shareDir = Join-Path $root 'share'
New-Item -ItemType Directory -Force $shareDir | Out-Null

$verifiedTiers = @('verified', 'seal-lite', 'seal-complete')
$made = 0

foreach ($p in $data.producers) {
    if ($verifiedTiers -notcontains $p.tier) { continue }

    $slug  = $p.id
    $name  = $p.name
    $county = if ($p.county) { $p.county } else { 'Ireland' }
    $desc  = if ($p.description) { $p.description } else { "$name is a verified Irish producer in Co. $county. Found on the Provenance Map." }
    $desc  = $desc -replace '"', '&quot;'
    $photo = if ($p.photo_url) { "https://provenancemap.ie/$($p.photo_url)" } else { 'https://provenancemap.ie/assets/og-default.png' }
    $mapUrl  = "https://provenancemap.ie/?producer=$slug"
    $stubUrl = "https://provenancemap.ie/share/$slug.html"

    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>$name &#8212; Provenance Map</title>
  <meta name="description" content="$desc" />
  <link rel="canonical" href="$stubUrl" />
  <meta property="og:type" content="website" />
  <meta property="og:site_name" content="Provenance Map" />
  <meta property="og:title" content="$name &#8212; Provenance Map" />
  <meta property="og:description" content="$desc" />
  <meta property="og:url" content="$stubUrl" />
  <meta property="og:image" content="$photo" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="$name &#8212; Provenance Map" />
  <meta name="twitter:description" content="$desc" />
  <meta name="twitter:image" content="$photo" />
  <meta http-equiv="refresh" content="0;url=$mapUrl" />
  <style>
    html { background: #060807; color: #E8DEC8; font-family: Georgia, serif; }
    body { display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
    a { color: #C4A44A; }
  </style>
</head>
<body>
  <p>Opening <a href="$mapUrl">$name on the Provenance Map</a>&hellip;</p>
  <script>location.replace('$mapUrl');</script>
</body>
</html>
"@

    $out = Join-Path $shareDir "$slug.html"
    [System.IO.File]::WriteAllText($out, $html, (New-Object System.Text.UTF8Encoding $false))
    Write-Output "Generated share/$slug.html"
    $made++
}

Write-Output "$made share page(s) generated."
