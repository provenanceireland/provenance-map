# Releases

Each file here is one Collection release and becomes one page at `/seal/<slug>/`.
The slug is the file name. The QR code on the pack points at that address, and a
printed code cannot be changed, so settle the slug before ordering stickers.

## Add the next release

1. Copy `moyletra-tallow.json` to `releases/<new-slug>.json` and change `"slug"` to match the file name.
2. Replace the content. Keep the same structure so any producer slots in:
   - `product`, `producer` (name, place, `profile` link), `descriptor`, `og_description`, `intro`
   - `sections`: each has `id`, `kicker`, `heading`, `blocks`, and an optional `source` line
   - `blocks`: `{"type":"p","text":"...","cite":"..."}` or `{"type":"statement","label":"Farm statement","text":"..."}`
   - `sources`: every source named in full; `collection`: the closing block
3. Run `powershell -ExecutionPolicy Bypass -File generate-seal-pages.ps1`.
4. Commit the new `seal/<slug>/index.html`, then make the sticker with `seal-qr.html`.

## Rules the page follows

- Every factual claim names its source on the page. Anything the farm says about itself that cannot be checked is a `statement` labelled as the farm's.
- No batch numbers or dates, weights, counts, lab results or blockchain. The word "verified", the em dash, "Eurofins" and "blockchain" stop the build.
- No health or nutrition claims, and no comparisons of breeds or fats.

## Photos and video

Add them to a section with `"media"`; sections without it render nothing extra.

- Photo: `{"type":"photo","src":"/seal/<slug>/hero.jpg","alt":"...","caption":"..."}`
- Video: `{"type":"video","url":"https://www.youtube-nocookie.com/embed/<id>","title":"...","caption":"..."}`. Use the `youtube-nocookie.com` address so the page sets no tracking cookies.

## Visibility

Pages are `noindex` by default. Set `"index": true` in the release file when it is ready for search engines.
