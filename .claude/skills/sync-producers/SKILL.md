---
name: sync-producers
description: >-
  Add or upgrade producers from the user's Obsidian vault. Two triggers:
  "Add producer: [Name]" — reads the Obsidian note and adds them to the map
  (Verified if all details are complete, Discovered otherwise).
  "Upgrade producer: [Name]" — reads the Obsidian note and upgrades an existing
  Discovered producer to Verified. Also triggers on "sync from Obsidian",
  "sync any updated producers", or an `obsidian://` link. Reads the note(s), maps
  the front matter to producers.json, applies the tier / practice / photo rules,
  bumps the service-worker cache, commits and pushes, and confirms the deploy.
---

# Sync Producers from Obsidian

The user keeps one Markdown note per producer in their Obsidian vault. This skill
turns those notes into live map changes. It handles two cases:

- **"Add producer: [Name]"** — the note's `id` (kebab-case of `name`) isn't in `producers.json` yet. If every meaningful field is filled in (name, product, county, Location, a real Description, a photo, and practice with `practice_confirmed: true`), list them as **Verified** even on first add. Otherwise list as **Discovered**.
- **"Upgrade producer: [Name]"** — the `id` already exists in `producers.json` (usually as Discovered). Update it to **Verified** (`tier: verified`), applying the latest note fields (description, practice, photo, attributes, etc.). This is the explicit verification command.

## Where the notes live

Vault: `C:\Users\darra\Documents\Provenance Map Obsidian\Provenance Map`
(granted to Claude via `.claude/settings.local.json` → `permissions.additionalDirectories`).

Producer notes are under **`Provenance Map listings/`**, usually in a county
subfolder (`Provenance Map listings/Tipperary/Happy Roots.md`), sometimes at the
top level. Read notes with PowerShell (`Get-Content -LiteralPath ... -Raw`) so
you don't depend on the directory grant having reloaded. Skip any file whose name
starts with `_` (templates) or is a README / "Verify form questions" note.

If the user names one producer ("sync Happy Roots"), find and read just that
note. If they say "sync any updated producers", read all notes and act on the
ones whose front matter differs from the current `producers.json` (new `id`s, or
`Listed: No`, or a changed tier/practice/description).

## Note front matter → producers.json field

The user's notes use these keys (values may be blank):

The note keys have changed over time — accept both the current and older names
(the note may use `product` **or** `produce`; the description may be a
`Description` property **or** in the note body).

| Note key | producers.json | Notes |
|----------|----------------|-------|
| `name` | `name` + `id` | `id` = kebab-case of name (`happy-roots`) |
| `product` (or `produce`) | `product` + `product_type` | `product` is the display line; infer `product_type` slugs (dairy, beef, lamb, honey, vegetables, fruit, drinks, eggs, cheese, produce, …). First slug drives the pin category. |
| `Description` (or note body) | `description` | Use the producer's text **verbatim** — never reword or re-voice it. Only if blank, research online and generate one (see rule). |
| `Attributes` | `attributes` | Comma- or line-separated tags → `attributes` array (e.g. `["Grass Fed","Free Range"]`). They render as small pills directly under the practice line. |
| `Eircode` | `directions` | build a maps link `https://maps.google.com/?q=<EIRCODE>` (spaces → `+`) so the card gets a Directions button; also use it to sanity-check the town |
| `county` | `county` | one of the 32 counties |
| `Location` | `lat`, `lng` | single string `"52.9971, -8.2733"` → split into `lat`, `lng` |
| `tier` | `tier` | `Discovered`→`discovered`, `Verified`→`verified` (see gating below) |
| `practice` | `practice` | see the **practice gating** rule |
| `practice_confirmed` | (gate) | see below |
| `instagram` | `social_instagram` | **null unless tier is Featured+** (see gating) |
| `website` | `website` | **null unless tier is Featured+** |
| `Email` | — | contact/admin only, never displayed on the map or stored in producers.json |
| `photo` | `photo_url` (+ `photo_bg`) | logo only — see photo rule |
| `Listed` | — | your tracking flag; write `Listed: Yes` back to the note after a successful sync (see last step) |

Keep every other producers.json field at its template default (`badge`, `badge2`,
`map_link`, `attributes: []`, `seal_active: false`, `where_to_buy: []`, etc.),
or, for an update, leave existing values untouched unless the note changes them.

**Attributes vocabulary (fixed multi-select in the note).** Use these exact
labels, verbatim, when writing the `attributes` array — don't paraphrase or
re-case:

The vocabulary is grouped into three kinds of claim. The grouping matters because
the filter panel is built in the same three sections.

**How they farm** (husbandry and land) —
`Grass Fed` · `Free range` · `Pasture raised` · `Chemical Free`

**Native and heritage** (what the animal, bee or seed *is*, not how it was kept) —
`Native / rare breed` · `Native Irish bee` · `Heritage variety`

**How it's made** (what was *not* done to it afterwards) —
`Raw / unpasteurised` · `Non-Homogenised` · `Plastic Free`

`Plastic Free` was removed once, on the grounds that it describes packaging
rather than farming. It was restored in August 2026: producers tick it on the
form, it is a real and checkable commitment, and dropping it meant the form
collected an answer the map could not show. `Small batch` stays removed, it
describes batch size and is not checkable.

This list is the single source of truth and must stay identical to the checkbox
options in `_Verify form questions.md` in the vault. If you change one, change
the other in the same edit.

Only the ones ticked on the note go into the array, in the order above. They
render as small pills under the practice line.

**Attributes are Verified-only, the same as practice.** Never put an attribute on
a `discovered` producer, and never infer one from research, a website or a farm's
own marketing. An attribute pill reads as a claim Provenance stands over, and the
only thing that earns that is the producer ticking the box on the verify form.
For a Discovered producer, always write `"attributes": []`.

Researched facts about a farm belong in the **description**, which is understood
to be secondhand, or in the note body under a "Researched, not confirmed" heading.
They do not belong in the `Attributes:` property, because that field syncs
straight onto the map.

This is why the Native & heritage filter section can sit empty: the farms are
listed, but nobody has confirmed the breed yet. That is the correct state, not a
bug to work around.

## The rules that are easy to get wrong

- **Tier depends on the command and completeness.**
  - **"Add producer"** — if every meaningful field is filled in (name, product, county, Location, a real Description, a photo, and practice with `practice_confirmed: true`), list as **Verified** on first add. If any of those is blank/missing, list as **Discovered**. (`instagram`, `website`, `Email`, `Attributes`, `Eircode` are optional and don't count toward completeness.)
  - **"Upgrade producer"** → always sets `tier: verified`. This is the explicit verification command for existing Discovered producers.
- **Tier gating (what the free tiers may show).** Discovered and Verified are both
  free and show only: name, county/town, product, tier badge, description, the
  single **logo**, and — for Verified — a confirmed practice pill. They must NOT
  carry Instagram, website, where-to-buy, a photo gallery, or a visit video.
  So for `discovered`/`verified`, set `social_instagram: null`, `website: null`,
  `where_to_buy: []`, and no `photos` array — even if the note fills them in.
  Those begin at **Featured** (`featured`/`seal-*`). Capture them only when the
  tier is Featured+.
- **Description — producer's words verbatim, else research.** If the note's
  `Description` (or body) has real content, use it **exactly as written** — do not
  reword, rewrite, re-case, fix grammar/spelling, or convert first-person to
  third-person. It is the producer's own description and goes in verbatim (a
  producer's voice is the point). Only when the description is blank or still the
  template placeholder do you generate one by researching online (`WebFetch` the
  `website` if present, `WebSearch` the producer name + county), written in the
  Provenance voice (plain, named people/places, no em dashes, no website clichés).
  If research turns up nothing specific, write a minimal honest line from the known
  facts and say so. Present any *generated* description in your reply for the user
  to edit; a verbatim producer one needs no sign-off.
- **Practice gating.** Only write a real practice (`regenerative` and/or
  `organic`) to `producers.json` when the note's `practice_confirmed` is `true`.
  If practice is set but not confirmed, store `"practice": "unspecified"` (no pill
  shows) — never display a practice a producer hasn't confirmed. `conventional`
  and anything else render no pill; only `organic`/`regenerative` show. A producer
  can hold both — store `"regenerative,organic"` and the card shows both pills
  side by side.
- **Single card image.** Every tier gets **one** image (`photo_url`) — a logo is
  ideal, but a single representative photo (e.g. a farm shot) is also fine on
  Discovered and Verified. Check the image (Read it): if it's a logo on a
  white/transparent background add `"photo_bg": "white"`; a photo or a logo with
  its own solid background omits `photo_bg`. What stays Featured-only is the
  multi-image **gallery** (`photos` array) — never add a `photos` array to a
  Discovered/Verified record. If there's no image at all, set `photo_url: null`.
- The image file must be in the **map repo** (root or subfolder). If the note's
  `photo` names a file that isn't in the repo yet, tell the user to drop it in.
- **Never list a producer with no image.** Every producer on the map has one, and
  a card with a blank image looks broken next to the rest. If the note has no
  `photo`, do not add the record: say which producers are held back and what image
  is needed, and let the user supply it first. This applies to bulk adds too —
  check images for the whole batch *before* writing any of them, not after.

## Steps

1. **Read** the target note(s) from the vault (PowerShell, raw).
2. For each: parse front matter + body, compute the `id`, and check
   `producers.json` for that `id`.
3. **New** → append a full record (template field order; match existing entries).
   **Existing** → edit only the changed fields in place.
4. Apply the gating rules above (tier, practice_confirmed, logo, IG/website).
5. **Validate** the JSON (`ConvertFrom-Json` in PowerShell) — confirm count and
   the changed producer's values.
6. **Bump** `service-worker.js` cache `provenance-vNNN` → `NNN+1`.
7. **Commit + push** (`producers.json`, `service-worker.js`, any new image), then
   confirm the GitHub Pages deploy went live (poll the live service-worker for the
   new version).
8. **Write back** to the Obsidian note — always, on every successful add or
   update: set `Listed: Yes` so the user's tracking stays accurate. Preserve the
   rest of the note (front matter order and body) and its UTF-8 encoding.
9. **Report**: what was added/changed, restate any drafted description for the
   user to edit, and flag anything left off by rule (Instagram/website/where-to-buy
   held for Featured; practice held because `practice_confirmed` was false).

## Directions (default for Verified)

When upgrading or adding a producer as Verified, always include directions if an
Eircode is available in the note. Build a Google Maps link:
`https://maps.google.com/?q=<EIRCODE>` (spaces → `+`), and set it as the
**`directions`** field in producers.json. This is the default behaviour for all
Verified producers unless the user explicitly says otherwise.

**The field is `directions`, not `map_link`.** `index.html` reads
`p.directions` to render the Directions button; a link written to `map_link`
renders nothing.

## Verification updates specifically

A verification usually means the note changed `tier` to `Verified`, filled in
`practice` + `practice_confirmed: true`, and improved the description. Apply those
(tier → `verified`, set the confirmed practice pill, use the description as
written, set the town) and keep Instagram/website/where-to-buy null — those stay
Featured-only. Mention to
the user that those paid-tier fields were captured in your notes but won't display
until Featured.

## Related

- `add-producer` skill — for adding a producer from details pasted directly into
  chat (not from a vault note). Overlaps on the producers.json record shape and
  the tier/photo rules; this skill is the Obsidian-driven path.
- Tier model, pin colours, practice pills, photo rule: `CLAUDE.md`.
