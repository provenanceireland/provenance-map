---
name: add-producer
description: >-
  Add a new food producer to the Provenance Map. Use this whenever the user
  asks to add, list, or create a producer/farm/listing — e.g. "add a free
  listing", "add discovered producer", "list this farm", "add a verified
  producer" — usually giving a name, product, coordinates, county and maybe an
  Instagram handle or website. Handles the producers.json entry, tier rules,
  photo wiring, a drafted description, the service-worker cache bump, the
  git commit + push, and (for Verified) the share-stub generation. Trigger this
  even if the user only pastes the raw details without saying "skill".
---

# Add a Producer to the Provenance Map

This repo is a PWA on GitHub Pages. Producers are pins on the map, rendered from
`producers.json`. Adding one is a fixed sequence with a few rules that are easy
to get wrong (tier → Instagram, cache bump, push). Follow the steps below.

## What the user gives you

Typically: **name, product, latitude, longitude, county**, and sometimes an
**Instagram handle**, a **website**, and a **photo file** they've dropped in the
repo. They'll say "free listing" / "discovered" or "verified" to signal tier.
If tier isn't stated, assume **discovered** (the free default).

If something essential is missing (usually coordinates), ask for it. Everything
else you can fill with sensible defaults.

## Step 1 — Decide the tier

The tier drives the pin colour, whether Instagram shows, and whether a share
page is generated.

| User says | `tier` value | Instagram? | Share stub? |
|-----------|-------------|-----------|-------------|
| "free listing", "discovered", or unspecified | `"discovered"` | **No** | No |
| "verified", "Provenance Verified" | `"verified"` | Yes | Yes (Step 6) |
| "seal", "Provenance Seal" | `"seal-lite"` or `"seal-complete"` | Yes | Yes |

**The most-missed rule: Discovered/free producers do NOT get an Instagram link.**
Instagram (and website) are a paid-tier benefit. Even if the user hands you a
handle for a free listing, set `social_instagram` to `null` and mention that you
left it off per the tier rule. See `CLAUDE.md` → Pin Colours for the full spec.

## Step 2 — Draft a description

Never paste marketing copy verbatim. Write 1–2 natural sentences in the
Provenance voice: plain, specific, and about the real thing — the family, the
land, the method, how they sell direct. The founding philosophy is *cutting out
the middleman between the farmer and the person eating the food*, so lean into
"sold direct", "from their own cows", named people and places.

- If the user gives a **website**, fetch it (`WebFetch`) and base the description
  on real detail (town, growers, method, how they sell) rather than inventing.
- Avoid the em dash and website-cliché phrasing ("nestled", "passionate about",
  "harvested and on the shelf within 24 hours"). Read it back — if it sounds
  copy-pasted, rewrite it plainer.
- **Always present the draft in your reply** so the user can edit it. Do not
  cold-DM or assume it's final; they will often tweak it.

## Step 3 — Add the entry to `producers.json`

Append a new object to the `producers` array (before the closing `]`). Use this
template, filling every field. Keep the field order consistent with existing
entries.

```json
{
  "id": "kebab-case-name",
  "name": "Producer Name",
  "tier": "discovered",
  "pin_classes": "",
  "badge": null,
  "badge2": null,
  "lat": 52.1234,
  "lng": -6.1234,
  "county": "Wexford",
  "location": "Town, Co. Wexford",
  "product": "Short product line",
  "product_type": ["dairy"],
  "description": "Your drafted description.",
  "photo_url": "photofile.jpg",
  "map_link": null,
  "social_instagram": null,
  "website": null,
  "attributes": [],
  "seal_active": false,
  "seal_url": null,
  "where_to_buy": [],
  "farmers_market": false,
  "farm_shop": false,
  "date_added": null
}
```

Field notes:
- **`id`** — kebab-case of the name (`galtee-honey-farm`). Must be unique.
- **`county`** — one of the 32 counties, matching the filter list in `index.html`.
- **`location`** — human string shown on the card ("Ardee, Co. Louth"). Derive
  the town from the coordinates or website if you can; otherwise "Co. X".
- **`product_type`** — array of lowercase category slugs used by the filter:
  `dairy, beef, pork, lamb, honey, vegetables, fruit, fish, bread, preserves,`
  `drinks, eggs, salt, meat, cheese, seeds, oats, chicken, produce`. Reuse an
  existing one; only invent a new slug if nothing fits.
- **`social_instagram` / `website`** — `null` for discovered/free (Step 1). For
  Verified+, set the handle (no `@`, no URL — just `saltrockfarm`) / full URL.
- **`photo_url`** — see Step 4. `null` if no photo yet (card shows a placeholder).

## Step 4 — Wire the photo

The image file lives in the **repo root** (or a subfolder); `photo_url` is its
path relative to root, e.g. `"galteehoney.png"`.

- **Logo with a transparent or off-brand background** that should sit on white:
  add `"photo_bg": "white"`. (If the logo already has its own solid background,
  don't — let it sit on the default dark card.)
- **Multiple photos (gallery)** — add a `"photos"` array of paths:
  `"photos": ["saltrock-verified/1.jpg", "saltrock-verified/2.jpg"]`. The card
  leads with the first photo (cover-filled) and opens them in the fullscreen
  viewer. Keep folder names URL-safe (no spaces — rename the folder if needed).

`git add` the image file(s) along with `producers.json` in Step 7.

## Step 5 — Bump the service-worker cache

Open `service-worker.js` and increment the version by one:
`const CACHE = 'provenance-vNNN';` → `vNNN+1`. **This is not optional** — mobile
users keep serving the old cached app until the version changes, so a skipped
bump means the new pin silently doesn't appear for them.

## Step 6 — (Verified+ only) generate the share stub

If the tier is `verified`, `seal-lite`, or `seal-complete`, run the share-page
generator so the producer gets a shareable link with a correct social preview:

```powershell
powershell -File generate-share-pages.ps1
```

This writes `share/<id>.html` (OG tags → redirect to the card) and a 1200×630
`assets/og/<id>.jpg`. `git add` both. Discovered/free producers skip this.

## Step 7 — Commit and push

Always push — GitHub Pages only serves the change once it's deployed, and the
user relies on that for mobile.

```bash
git add producers.json service-worker.js <photofile> [share/ assets/og/ .claude/]
git commit -m "Add <Name> (<tier>, <county>) with photo, bump cache to vNNN"
git push
```

## Step 8 — Report back

Tell the user it's live and at what cache version, restate the **drafted
description** for them to edit, and flag anything you inferred (county from
coordinates, town, left-off Instagram). Offer to add a photo if none was given.

## Adding from the Obsidian vault

The user keeps producer notes in their Obsidian vault, one note per producer, at
`C:\Users\darra\Documents\Provenance Obsidian\Provenance\Producers` (access
granted via `.claude/settings.local.json` → `permissions.additionalDirectories`;
needs a Claude Code restart to take effect the first time). Each note has YAML
frontmatter — `name, product, lat, lng, county, tier, practice,
practice_confirmed, instagram, website, photo` — and the description in the body.

When the user says "add producers from Obsidian" (or similar):
1. List the `.md` notes in that Producers folder; skip `_TEMPLATE.md` and
   `README.md`.
2. Parse each note's frontmatter + body. Skip any whose `name` already maps to an
   existing `producers.json` id, unless the user asks to update it.
3. Build a producers.json entry per the Step 3 template, mapping fields straight
   across. Carry `practice` through as-is; `practice_confirmed` (true/false)
   governs whether the practice pill is shown on the card — never display an
   organic/regenerative practice the producer hasn't confirmed.
4. Then follow Steps 4–7 for the batch (photos, single cache bump, one commit,
   push). Present the drafted descriptions for the user to edit as usual.

## Quick reference

- Pin colours & tier spec: `CLAUDE.md` → "Pin Colours"
- Producer record fields: `CLAUDE.md` → "Data Models"
- Founding philosophy (voice for descriptions): `CLAUDE.md` → "The Core Philosophy"
- Share stub tool: `CLAUDE.md` → "Tools" → `generate-share-pages.ps1`
