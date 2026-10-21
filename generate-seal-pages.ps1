# Builds the Seal story pages from releases/<slug>.json.
#
#   /seal/<slug>/index.html   one static page per release (works with no JavaScript)
#   /seal/index.html          the "code not recognised" page
#   /404.html                 the same message for any missing address, so a
#                             mistyped /seal/... address never lands on a bare 404
#
# Run it after adding or editing a release, then commit the output:
#   powershell -ExecutionPolicy Bypass -File generate-seal-pages.ps1
#
# The page code lives here. A new release is a data edit in releases/, never a
# code edit. See releases/README.md.

$ErrorActionPreference = 'Stop'
$root    = Split-Path -Parent $MyInvocation.MyCommand.Path
$origin  = 'https://provenancemap.ie'
$reportTo = 'provenanceireland@gmail.com'
$utf8    = New-Object System.Text.UTF8Encoding($false)

function E([string]$s) { [System.Net.WebUtility]::HtmlEncode($s) }

$css = @'
:root{--cream:#E8DEC8;--body:#CFC7B3;--muted:#9A968B;--source:#7A766A;--kicker:#45704E;--deep:#2F5C3A;--line:#C9C6BD;--h1:rgba(201,198,189,.30);--h2:rgba(201,198,189,.12)}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0}
html{background:#151614;-webkit-text-size-adjust:100%}
body{min-height:100vh;color:var(--body);background:radial-gradient(ellipse 85% 75% at 50% 45%,#222320 0%,#1C1D1A 65%,#151614 100%) fixed;font-family:'Source Serif 4',Georgia,'Times New Roman',serif;font-weight:300;font-size:18px;line-height:1.6;-webkit-font-smoothing:antialiased}
a{color:inherit}
:focus-visible{outline:1.5px solid var(--line);outline-offset:3px}
.wrap{max-width:560px;margin:0 auto;padding:0 22px}
.kick{font-family:Inter,Helvetica,Arial,sans-serif;font-weight:500;font-size:.68rem;letter-spacing:.26em;text-transform:uppercase;color:var(--kicker)}
h1,h2{font-family:'Playfair Display',Georgia,'Times New Roman',serif;font-weight:400;line-height:1.05;color:var(--cream);text-wrap:balance}
.top{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:20px 0;border-bottom:1px solid var(--h2)}
.mark{display:flex;align-items:center;gap:10px;text-decoration:none;font-family:'Playfair Display',Georgia,serif;font-size:1rem;letter-spacing:.16em;color:var(--cream)}
.hero{padding:44px 0 34px;border-bottom:1px solid var(--h1)}
.hero h1{font-size:clamp(2.6rem,12vw,3.6rem);margin:14px 0 14px}
.hero .producer{font-family:'Playfair Display',Georgia,serif;font-size:1.35rem;line-height:1.2;color:var(--cream)}
.hero .place{color:var(--muted);font-size:.98rem;margin-top:4px}
.hero .descriptor{margin-top:22px}
section{padding:38px 0;border-bottom:1px solid var(--h2)}
section h2{font-size:1.9rem;margin:10px 0 18px}
p+p{margin-top:1em}
.about p{color:var(--body)}
.statement{border-left:1px solid var(--h1);padding-left:14px}
.tag{display:block;font-family:Inter,Helvetica,Arial,sans-serif;font-weight:500;font-size:.6rem;letter-spacing:.24em;text-transform:uppercase;color:var(--kicker);margin-bottom:2px}
.cite,.src{font-size:.82rem;line-height:1.5;color:var(--source)}
.cite{display:block;margin-top:4px}
.src{margin-top:18px}
figure{margin:22px 0}
figure img,figure iframe{display:block;width:100%;border:0;background:#1C1D1A}
figure iframe{aspect-ratio:16/9}
figcaption{font-family:'Playfair Display',Georgia,serif;font-size:.95rem;color:var(--muted);margin-top:8px}
ul.sources{list-style:none}
ul.sources li{font-size:.9rem;line-height:1.5;color:var(--source);padding:6px 0;border-top:1px solid var(--h2)}
.links{display:flex;flex-wrap:wrap;gap:10px;margin-top:20px}
.btn{font-family:Inter,Helvetica,Arial,sans-serif;font-weight:500;font-size:.68rem;letter-spacing:.18em;text-transform:uppercase;text-decoration:none;color:var(--cream);border:1px solid var(--h1);padding:12px 16px}
.btn:hover{border-color:var(--line)}
.foot{display:flex;justify-content:space-between;gap:12px;padding:26px 0 48px;font-size:.82rem;color:var(--source)}
.foot a{text-decoration:none}
@media print{html,body{background:#fff!important;color:#222}h1,h2,.hero .producer{color:#111}.kick,.tag{color:#2F5C3A}.cite,.src,ul.sources li,.hero .place,figcaption,.foot{color:#555}.top,.hero,section{border-color:#ccc}.btn{display:none}.mark svg{stroke:#555}.mark{color:#111}a{text-decoration:none}}
'@

$head_fonts = '<link rel="preconnect" href="https://fonts.googleapis.com"><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin><link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400&family=Inter:wght@500&family=Source+Serif+4:opsz,wght@8..60,300&display=swap" rel="stylesheet">'


function Page([string]$title, [string]$desc, [string]$canonical, [bool]$index, [string]$body) {
  $robots = if ($index) { 'index, follow' } else { 'noindex, nofollow' }
  $og = ''
  if ($canonical) {
    $og = @"
<link rel="canonical" href="$(E $canonical)">
<meta property="og:type" content="website">
<meta property="og:site_name" content="Provenance Map">
<meta property="og:title" content="$(E $title)">
<meta property="og:description" content="$(E $desc)">
<meta property="og:url" content="$(E $canonical)">
<meta name="twitter:card" content="summary">
<meta name="twitter:title" content="$(E $title)">
<meta name="twitter:description" content="$(E $desc)">
"@
  }
  return @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>$(E $title)</title>
<meta name="description" content="$(E $desc)">
<meta name="robots" content="$robots">
<meta name="theme-color" content="#1C1D1A">
$og
$head_fonts
<style>$css</style>
</head>
<body>
<div class="wrap">
<header class="top"><a class="mark" href="/"><span>PROVENANCE</span></a></header>
$body
<footer class="foot"><span>Provenance</span><a href="/">provenancemap.ie</a></footer>
</div>
</body>
</html>
"@
}

function Media($items) {
  $out = ''
  foreach ($m in @($items)) {
    if (-not $m) { continue }
    $cap = ''
    if ($m.caption) { $cap = '<figcaption>' + (E $m.caption) + '</figcaption>' }
    if ($m.type -eq 'photo') {
      $out += '<figure><img src="' + (E $m.src) + '" alt="' + (E $m.alt) + '" loading="lazy">' + $cap + '</figure>'
    } elseif ($m.type -eq 'video') {
      $out += '<figure><iframe src="' + (E $m.url) + '" title="' + (E $m.title) + '" loading="lazy" allow="encrypted-media; picture-in-picture" allowfullscreen referrerpolicy="strict-origin-when-cross-origin"></iframe>' + $cap + '</figure>'
    }
  }
  return $out
}

function Blocks($blocks) {
  $out = ''
  foreach ($b in @($blocks)) {
    $cite = ''
    if ($b.cite) { $cite = '<span class="cite">Source: ' + (E $b.cite) + '</span>' }
    if ($b.type -eq 'statement') {
      $out += '<p class="statement"><span class="tag">' + (E $b.label) + '</span>' + (E $b.text) + $cite + '</p>'
    } else {
      $out += '<p>' + (E $b.text) + $cite + '</p>'
    }
  }
  return $out
}

$banned = @('verified', [string][char]0x2014, 'eurofins', 'blockchain')

# ---- one page per release ----
$releases = Get-ChildItem (Join-Path $root 'releases') -Filter '*.json'
foreach ($f in $releases) {
  $r = Get-Content $f.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
  $slug = $r.slug
  if ($slug -ne [IO.Path]::GetFileNameWithoutExtension($f.Name)) { throw "$($f.Name): slug '$slug' must match the file name." }

  $b = ''
  $b += '<div class="hero"><p class="kick">' + (E $r.kicker) + '</p>'
  $b += '<h1>' + (E $r.product) + '</h1>'
  $b += '<p class="producer">' + (E $r.producer.name) + '</p>'
  $b += '<p class="place">' + (E $r.producer.place) + '</p>'
  $b += '<p class="descriptor">' + (E $r.descriptor) + '</p></div>'

  $b += '<section class="about" aria-label="About this page">'
  foreach ($p in @($r.intro)) { $b += '<p>' + (E $p) + '</p>' }
  $b += '</section>'

  foreach ($s in @($r.sections)) {
    $b += '<section id="' + (E $s.id) + '"><p class="kick">' + (E $s.kicker) + '</p><h2>' + (E $s.heading) + '</h2>'
    $b += Blocks $s.blocks
    $b += Media $s.media
    if ($s.source) { $b += '<p class="src">' + (E $s.source) + '</p>' }
    $b += '</section>'
  }

  if (@($r.sources).Count -gt 0) {
  $b += '<section id="sources"><p class="kick">Sources</p><h2>Where this comes from</h2><ul class="sources">'
  foreach ($x in @($r.sources)) { $b += '<li>' + (E $x) + '</li>' }
  $b += '</ul></section>'
  }

  $c = $r.collection
  $b += '<section id="collection"><p class="kick">The Collection</p><h2>' + (E $c.heading) + '</h2>'
  foreach ($p in @($c.text)) { $b += '<p>' + (E $p) + '</p>' }
  $b += '<div class="links"><a class="btn" href="' + (E $r.producer.profile) + '">' + (E $c.profile_label) + '</a>'
  $b += '<a class="btn" href="/collection/">' + (E $c.next_label) + '</a></div></section>'

  $title = "$($r.product), $($r.producer.name) | Provenance"
  $canon = "$origin/seal/$slug/"
  $index = $false
  if ($r.PSObject.Properties.Name -contains 'index') { $index = [bool]$r.index }
  $html = Page $title $r.og_description $canon $index $b

  foreach ($w in $banned) {
    if ($html.IndexOf($w, [StringComparison]::OrdinalIgnoreCase) -ge 0) { throw "${slug}: banned term '$w' found in page." }
  }

  $dir = Join-Path $root "seal\$slug"
  New-Item -ItemType Directory -Force $dir | Out-Null
  [IO.File]::WriteAllText((Join-Path $dir 'index.html'), $html, $utf8)
  Write-Host "built /seal/$slug/"
}

# ---- the page for an address that is not recognised ----
$nf  = '<div class="hero"><p class="kick">Provenance</p><h1>Code not recognised</h1>'
$nf += '<p class="descriptor">This address does not match a Provenance page. The code on your pack may be damaged, or the page may not be ready yet.</p></div>'
$nf += '<section><p class="kick">Report it</p><h2>Tell us what you scanned</h2>'
$nf += '<p>Send us a message with the product and where you bought it, and we will put it right.</p>'
$nf += '<div class="links"><a class="btn" href="mailto:' + $reportTo + '?subject=Code%20not%20recognised">Report this code</a><a class="btn" href="/">Go to the map</a></div></section>'
$nfHtml = Page 'Code not recognised | Provenance' 'This code is not recognised.' '' $false $nf

New-Item -ItemType Directory -Force (Join-Path $root 'seal') | Out-Null
[IO.File]::WriteAllText((Join-Path $root 'seal\index.html'), $nfHtml, $utf8)
[IO.File]::WriteAllText((Join-Path $root '404.html'), $nfHtml, $utf8)
Write-Host 'built /seal/ and /404.html'
