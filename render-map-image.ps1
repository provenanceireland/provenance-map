# Renders the map as it is today, every pin where it sits, to a still image.
# Used by the Featured profile pages for their closing "on the Provenance Map"
# frame. Re-run whenever pins move and commit the output.
#
#   powershell -File render-map-image.ps1 -Device pc       -> skehanahill/map-pc.jpg
#   powershell -File render-map-image.ps1 -Device mobile   -> skehanahill/map-mobile.jpg
#
# One still per device, because the map places pins differently on each:
# refX 82 with desktop overrides in landscape, refX 85 without in portrait.
# Pin sizes and colours follow CLAUDE.md, scaled so they read as they do on
# that device. The page picks the still by orientation.

param(
  [ValidateSet('pc', 'mobile')] [string]$Device = 'pc',
  [string]$Out = "",
  [int]$Size = 1400
)
if (-not $Out) { $Out = "skehanahill/map-$Device.jpg" }

Add-Type -AssemblyName System.Drawing
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$json = Get-Content -LiteralPath (Join-Path $root "producers.json") -Raw | ConvertFrom-Json
$art  = [System.Drawing.Image]::FromFile((Join-Path $root "ireland-map.png.png"))

# Draw at 2x and downsample for smooth glows.
$S = $Size * 2
$bmp = New-Object System.Drawing.Bitmap $S, $S
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = 'HighQualityBicubic'; $g.SmoothingMode = 'AntiAlias'; $g.PixelOffsetMode = 'HighQuality'
$g.DrawImage($art, 0, 0, $S, $S)

# PC: refX 82, desktop overrides applied, the artwork about 900 CSS px tall,
# so a CSS px is 1/900 of it. Mobile: refX 85, no overrides, the artwork the
# width of the phone, about 412 CSS px, and the pins a shade smaller. Same
# rules as positionPins in index.html.
if ($Device -eq 'pc') { $refX = 82; $px = $S / 900.0; $k = 1.0 } else { $refX = 85; $px = $S / 412.0; $k = 0.987 }

function Glow($cx, $cy, $r, $col, $steps) {
  for ($i = $steps; $i -ge 1; $i--) {
    $rr = $r * $i / $steps
    $a = [int]($col.A * (1 - ($i - 1) / $steps) / $steps * 1.6)
    if ($a -gt 255) { $a = 255 }
    $b = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($a, $col.R, $col.G, $col.B))
    $g.FillEllipse($b, $cx - $rr, $cy - $rr, 2 * $rr, 2 * $rr); $b.Dispose()
  }
}
function Dot($cx, $cy, $d, $fill, $border, $bw) {
  $r = $d / 2
  $b = New-Object System.Drawing.SolidBrush $fill
  $g.FillEllipse($b, $cx - $r, $cy - $r, $d, $d); $b.Dispose()
  if ($border) { $pen = New-Object System.Drawing.Pen $border, $bw; $g.DrawEllipse($pen, $cx - $r, $cy - $r, $d, $d); $pen.Dispose() }
}

$order = @{ discovered = 0; verified = 1; featured = 2 }
$pins = $json.producers | Where-Object { $_.lat -and $_.lng } | Sort-Object { $order[[string]$_.tier] }
foreach ($p in $pins) {
  $lat = $p.lat; $lng = $p.lng
  if ($Device -eq 'pc' -and $null -ne $p.lat_desktop -and $null -ne $p.lng_desktop) { $lat = $p.lat_desktop; $lng = $p.lng_desktop }
  $x = ($refX + ($lng + 5.90) * 15.217) / 100.0 * $S
  $y = (10 + (55.40 - $lat) * 20) / 100.0 * $S
  switch ([string]$p.tier) {
    'verified' {
      Glow $x $y (4.39 + 8) * $px ([System.Drawing.Color]::FromArgb(186, 89, 166, 102)) 6
      Dot $x $y (8.78 * $k * $px) ([System.Drawing.Color]::FromArgb(255, 89, 166, 102)) ([System.Drawing.Color]::FromArgb(153, 248, 248, 243)) (1 * $px)
    }
    'featured' {
      Glow $x $y (4.61 + 22) * $px ([System.Drawing.Color]::FromArgb(51, 201, 154, 56)) 8
      Glow $x $y (4.61 + 9) * $px ([System.Drawing.Color]::FromArgb(115, 201, 154, 56)) 6
      $d = 9.22 * $k * $px; $r = $d / 2
      $path = New-Object System.Drawing.Drawing2D.GraphicsPath
      $path.AddEllipse($x - $r, $y - $r, $d, $d)
      $pg = New-Object System.Drawing.Drawing2D.PathGradientBrush $path
      $pg.CenterPoint = New-Object System.Drawing.PointF ($x - $r * 0.32), ($y - $r * 0.4)
      $pg.CenterColor = [System.Drawing.Color]::FromArgb(255, 232, 198, 112)
      $pg.SurroundColors = @([System.Drawing.Color]::FromArgb(255, 169, 124, 40))
      $g.FillPath($pg, $path); $pg.Dispose(); $path.Dispose()
      $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(140, 201, 154, 56)), (1 * $px)
      $g.DrawEllipse($pen, $x - $r, $y - $r, $d, $d); $pen.Dispose()
    }
    default {
      Glow $x $y (2.93 + 5) * $px ([System.Drawing.Color]::FromArgb(102, 42, 90, 56)) 4
      Dot $x $y (5.85 * $k * $px) ([System.Drawing.Color]::FromArgb(255, 42, 90, 56)) ([System.Drawing.Color]::FromArgb(191, 232, 222, 200)) (1 * $px)
    }
  }
}
$g.Dispose()

$final = New-Object System.Drawing.Bitmap $Size, $Size
$g2 = [System.Drawing.Graphics]::FromImage($final)
$g2.InterpolationMode = 'HighQualityBicubic'; $g2.PixelOffsetMode = 'HighQuality'
$g2.DrawImage($bmp, 0, 0, $Size, $Size); $g2.Dispose()

$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object MimeType -eq 'image/jpeg'
$q = New-Object System.Drawing.Imaging.EncoderParameters 1
$q.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]86)
$outPath = if ([System.IO.Path]::IsPathRooted($Out)) { $Out } else { Join-Path $root $Out }
$final.Save($outPath, $enc, $q)
$final.Dispose(); $bmp.Dispose(); $art.Dispose()
"Rendered {0} pins for {4} to {1} ({2}x{2}, {3} KB)" -f $pins.Count, $Out, $Size, [math]::Round((Get-Item $outPath).Length / 1KB), $Device
