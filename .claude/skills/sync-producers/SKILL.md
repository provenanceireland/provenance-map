---
name: sync-producers
description: >-
  Sync producer notes from the user's Obsidian vault into the live Provenance
  Map — both adding brand-new producers and applying updates such as a
  verification. Use whenever the user says things like "sync Happy Roots from
  Obsidian", "sync from Obsidian", "sync any updated producers", "process the
  verification", "producer verified", "update <producer> from Obsidian", or
  pastes an `obsidian://` link to a producer note. Reads the note(s), maps the
  front matter to producers.json, applies the tier / practice / photo rules,
  bumps the service-worker cache, commits and pushes, and confirms the deploy.
---

# Sync Producers from Obsidian

The user keeps one Markdown note per producer in their Obsidian vault. This skill
turns those notes into live map changes. It handles two cases with the same flow:

- **New producer** — the note's `id` (kebab-case of `name`) isn't in `producers.json` yet → append a new record.
- **Update / verification** — the `id` already exists → change only the fields that differ (e.g. `tier: Discovered → Verified`, a newly confirmed `practice`, a better description).

## Where the notes live

Vault: `C:\Users\darra\Documents\Provenance Obsidian\Provenance`
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

| Note key | producers.json | Notes |
|----------|----------------|-------|
| `name` | `name` + `id` | `id` = kebab-case of name (`happy-roots`) |
| `produce` | `product` + `product_type` | `product` is the display line; infer `product_type` slugs (dairy, beef, lamb, honey, vegetables, fruit, drinks, eggs, cheese, produce, …). First slug drives the pin category. |
| `county` | `county` | one of the 32 counties |
| `Location` | `lat`, `lng` | single string `"52.9971, -8.2733"` → split into `lat`, `lng` |
| `Eircode` | — | not stored; use only to sanity-check the town/location string |
| `tier` | `tier` | `Discovered`→`discovered`, `Verified`→`verified` (see gating below) |
| `practice` | `practice` | see the **practice gating** rule |
| `practice_confirmed` | (gate) | see below |
| `instagram` | `social_instagram` | **null unless tier is Featured+** (see gating) |
| `website` | `website` | **null unless tier is Featured+** |
| `photo` | `photo_url` (+ `photo_bg`) | logo only — see photo rule |
| body text | `description` | if the body is still the template placeholder ("Write the producer description here…") treat it as empty and draft one (fetch the website first if there is one). Present the draft for the user to edit. No em dashes. |
| `Researched` / `Listed` | — | your tracking flags; optionally write `Listed: Yes` back to the note after a successful add (see last step) |

Keep every other producers.json field at its template default (`badge`, `badge2`,
`map_link`, `attributes: []`, `seal_active: false`, `where_to_buy: []`, etc.),
or, for an update, leave existing values untouched unless the note changes them.

## The rules that are easy to get wrong

- **First-add tier from completeness (new producers only).** When the `id` is new,
  set the tier by how complete the note is. If **every** meaningful field is filled
  in — `name`, `produce`, `county`, `Location`, a real (non-placeholder)
  description, a `photo`, and `practice` with `practice_confirmed: true` — list
  them as **Verified** (`tier: verified`), even if the note's `tier` still says
  Discovered. If any of those is blank/missing, list them as **Discovered**.
  (`instagram`, `website`, `Eircode` are optional and don't count toward
  completeness.) For an existing producer (an update/verification), take the tier
  from the note's `tier` field instead.
- **Tier gating (what the free tiers may show).** Discovered and Verified are both
  free and show only: name, county/town, product, tier badge, description, the
  single **logo**, and — for Verified — a confirmed practice pill. They must NOT
  carry Instagram, website, where-to-buy, a photo gallery, or a visit video.
  So for `discovered`/`verified`, set `social_instagram: null`, `website: null`,
  `where_to_buy: []`, and no `photos` array — even if the note fills them in.
  Those begin at **Featured** (`featured`/`seal-*`). Capture them only when the
  tier is Featured+.
- **Practice gating.** Only write a real practice (`regenerative` and/or
  `organic`) to `producers.json` when the note's `practice_confirmed` is `true`.
  If practice is set but not confirmed, store `"practice": "unspecified"` (no pill
  shows) — never display a practice a producer hasn't confirmed. `conventional`
  and anything else render no pill; only `organic`/`regenerative` show. A producer
  can hold both — store `"regenerative,organic"` and the card shows both pills
  side by side.
- **Logo only.** `photo_url` is always the producer's **logo**. Check the image
  (Read it) — if it's a logo on a white/transparent background add
  `"photo_bg": "white"`; if it has its own solid background, omit `photo_bg`.
  Never attach farm photography to a Discovered/Verified card. If only farm
  photos exist and no logo, set `photo_url: null`.
- The image file must be in the **map repo** (root or subfolder). If the note's
  `photo` names a file that isn't in the repo yet, tell the user to drop it in.

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
   update: set `Listed: Yes` (and `Researched: Yes` if you researched it) so the
   user's tracking stays accurate. Preserve the rest of the note (front matter
   order and body) and its UTF-8 encoding.
9. **Report**: what was added/changed, restate any drafted description for the
   user to edit, and flag anything left off by rule (Instagram/website/where-to-buy
   held for Featured; practice held because `practice_confirmed` was false).

## Verification updates specifically

A verification usually means the note changed `tier` to `Verified`, filled in
`practice` + `practice_confirmed: true`, and improved the description. Apply those
(tier → `verified`, set the confirmed practice pill, refine description/town) and
keep Instagram/website/where-to-buy null — those stay Featured-only. Mention to
the user that those paid-tier fields were captured in your notes but won't display
until Featured.

## Related

- `add-producer` skill — for adding a producer from details pasted directly into
  chat (not from a vault note). Overlaps on the producers.json record shape and
  the tier/photo rules; this skill is the Obsidian-driven path.
- Tier model, pin colours, practice pills, photo rule: `CLAUDE.md`.
