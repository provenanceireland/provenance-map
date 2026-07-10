# generate-share-pages.ps1
# Generates /share/<slug>.html stub pages for all Provenance Verified (and above) producers.
# Each stub carries the producer's Open Graph tags so shared links preview with their
# photo and name in WhatsApp/iMessage/etc., then redirects to the map with their card open.
#
# It also builds a 1200x630 Open Graph image per producer at /assets/og/<slug>.jpg
# (WhatsApp/Facebook require landscape ~1.91:1; raw product photos are usually square
# and get dropped). The producer photo is cover-fitted onto a dark branded canvas.
#
# Crawlers do NOT run JavaScript and DO follow <meta http-equiv="refresh">, so the stub
# uses a JS-only redirect — that keeps the crawler on the stub to read the OG tags
# instead of following through to the map page (which has no OG image).
#
# Run this after upgrading a producer to "verified" in producers.json:
#   powershell -File generate-share-pages.ps1
# Then commit the new share/<slug>.html and assets/og/<slug>.jpg files and push.

Add-Type -AssemblyName System.Drawing

$root = $PSScriptRoot
$data = Get-Content (Join-Path $root 'producers.json') -Raw -Encoding UTF8 | ConvertFrom-Json
$shareDir = Join-Path $root 'share'
$ogDir = Join-Path $root 'assets\og'
New-Item -ItemType Directory -Force $shareDir | Out-Null
New-Item -ItemType Directory -Force $ogDir | Out-Null

$verifiedTiers = @('verified', 'seal-lite', 'seal-complete')
$made = 0

# Build a 1200x630 OG image by contain-fitting the source photo onto a dark canvas
# (whole image visible, no cropping — safe for logos and portrait/square photos alike).
function New-OgImage($srcPath, $destPath) {
    $W = 1200; $H = 630
    $canvas = New-Object System.Drawing.Bitmap($W, $H)
    $g = [System.Drawing.Graphics]::FromImage($canvas)
    $g.InterpolationMode = 'HighQualityBicubic'
    $g.Clear([System.Drawing.Color]::FromArgb(6, 8, 7))
    if (Test-Path $srcPath) {
        $src = [System.Drawing.Image]::FromFile($srcPath)
        $scale = [Math]::Min($W / $src.Width, $H / $src.Height)
        $dw = $src.Width * $scale
        $dh = $src.Height * $scale
        $dx = ($W - $dw) / 2
        $dy = ($H - $dh) / 2
        $g.DrawImage($src, $dx, $dy, $dw, $dh)
        $src.Dispose()
    }
    $g.Dispose()
    $canvas.Save($destPath, [System.Drawing.Imaging.ImageFormat]::Jpeg)
    $canvas.Dispose()
}

foreach ($p in $data.producers) {
    if ($verifiedTiers -notcontains $p.tier) { continue }

    $slug  = $p.id
    $name  = $p.name
    $county = if ($p.county) { $p.county } else { 'Ireland' }
    $desc  = if ($p.description) { $p.description } else { "$name is a verified Irish producer in Co. $county. Found on the Provenance Map." }
    $desc  = $desc -replace '"', '&quot;'
    $mapUrl  = "https://provenancemap.ie/?producer=$slug"
    $stubUrl = "https://provenancemap.ie/share/$slug.html"

    # Generate the OG image from the producer photo; fall back to default if no photo.
    if ($p.photo_url) {
        $srcPhoto = Join-Path $root $p.photo_url
        New-OgImage $srcPhoto (Join-Path $ogDir "$slug.jpg")
        $ogImage = "https://provenancemap.ie/assets/og/$slug.jpg"
    } else {
        $ogImage = 'https://provenancemap.ie/assets/og-default.png'
    }

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
  <meta property="og:image" content="$ogImage" />
  <meta property="og:image:secure_url" content="$ogImage" />
  <meta property="og:image:type" content="image/jpeg" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />
  <meta property="og:image:alt" content="$name" />
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="$name &#8212; Provenance Map" />
  <meta name="twitter:description" content="$desc" />
  <meta name="twitter:image" content="$ogImage" />
  <style>
    html { background: #060807; color: #E8DEC8; font-family: Georgia, serif; }
    body { display: flex; align-items: center; justify-content: center; height: 100vh; margin: 0; }
    a { color: #C4A44A; }
  </style>
</head>
<body>
  <p>Opening <a href="$mapUrl">$name on the Provenance Map</a>&hellip;</p>
  <!-- JS-only redirect: crawlers stay here to read OG tags; real users go to the map. -->
  <script>location.replace('$mapUrl');</script>
</body>
</html>
"@

    $out = Join-Path $shareDir "$slug.html"
    [System.IO.File]::WriteAllText($out, $html, (New-Object System.Text.UTF8Encoding $false))
    Write-Output "Generated share/$slug.html + assets/og/$slug.jpg"
    $made++
}

Write-Output "$made share page(s) generated."
