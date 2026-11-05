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

> **The free confirmed tier is called Verified** (restored 2026-10-01, see
> CLAUDE.md). Write `"tier": "verified"` in `producers.json`. **Highlighted is
> the gold paid tier** (`"tier": "featured"`), never the free one. A producer is
> Verified only when they submitted their own details on the verify form; if the
> note was built from research, a website or Instagram, stop and say so instead
> of upgrading.

- **"Add producer: [Name]"** — the note's `id` (kebab-case of `name`) isn't in `producers.json` yet. If every meaningful field is filled in (name, product, county, Location, a real Description, a photo, and practice with `practice_confirmed: true`), list them as **Verified** even on first add. Otherwise list as **Discovered**.
- **"Upgrade producer: [Name]"** — the `id` already exists in `producers.json` (usually as Discovered). Update it to **Verified** (`tier: verified`), applying the latest note fields (description, practice, photo, attributes, etc.). This is the explicit verification command.

## Where the notes live

Vault: `C:\Users\darra\Documents\Provenance Map Obsidian\Provenance Map`
(granted to Claude via `.claude/settings.local.json` → `permissions.additionalDirectories`).

Producer notes are under **`1 Map/Provenance Map listings/`**, in a county
subfolder (`1 Map/Provenance Map listings/Tipperary/Happy Roots.md`). The vault
was reorganised on 2026-11-05 and the top-level folders are now numbered, so
that path used to be `Producers/Provenance Map listings/`. **Match on the
`Provenance Map listings` folder name rather than the full path**, so a future
tidy of its parent cannot break this skill. Read notes with PowerShell
(`Get-Content -LiteralPath ... -Raw`) so you don't depend on the directory grant
having reloaded. Skip any file whose name starts with `_` (templates) or is a
README / "Verify form questions" note.

**One note per producer** (set 2026-11-05). A farm's map listing and its Connect
listing live in the same note. There is no second note in a Connect folder, and
the intake template is `2 Connect/Templates/_TEMPLATE Producer intake.md`.

**That one note drives both listings.** Syncing a producer writes their map
record **and**, when the note carries `connect: true`, their `connect` block, so
one command puts them on the map and on `/connect/`. See *The Connect block,
from the same note* below. Only `visit_interest` and the *Help us build Connect*
answers stay in the vault: they are the sales record and are never published.

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
| `Eircode` | (nothing, by default) | use it to sanity-check the town and county. It becomes a `directions` link **only when the user asks** — see the Directions rule below |
| `county` | `county` | one of the 32 counties |
| `Location` | `lat`, `lng` | single string `"52.9971, -8.2733"` → split into `lat`, `lng` |
| `tier` | `tier` | `Discovered`→`discovered`, `Verified`→`verified`, `Highlighted`→`featured` (paid, never by sync) (see gating below) |
| `practice` | `practice` | see the **practice gating** rule |
| `practice_confirmed` | (gate) | see below |
| `instagram` | `social_instagram` | **null unless tier is Featured+** (see gating) |
| `website` | `website` | **null unless tier is Featured+** |
| `Email` | — | contact/admin only, never displayed on the map or stored in producers.json |
| `photo` | `photo_url` (+ `photo_bg`) | logo only — see photo rule |
| `Listed` | — | your tracking flag; write `Listed: Yes` back to the note after a successful sync (see last step) |

Set `date_added` to today as `YYYY-MM-DD` on every **new** listing (the map rings the pin as New this week for seven days from it; leave it alone on an upgrade). Keep every other producers.json field at its template default (`badge`, `badge2`,
`map_link`, `attributes: []`, `seal_active: false`, `where_to_buy: []`, etc.),
or, for an update, leave existing values untouched unless the note changes them.

## The Connect block, from the same note

**One note puts a producer on the map and on Connect (set 2026-11-06).** The
intake note carries both, so the sync writes both: the map record from the
fields above, and the `connect` block from the keys and sections below. Do not
make the user write a Connect block by hand afterwards, and never ask them for
a second note.

**The gate is `connect: true` in the front matter.** Anything else, including a
blank, means this producer is map only: write no `connect` block at all, and
leave an existing one untouched. A Verified-only submission is a complete note,
not an unfinished one.

| Note | producers.json | Notes |
|------|----------------|-------|
| `connect: true` | `connect.active: true` | The gate. Nothing below is written without it |
| `connect_channel_type` + `connect_channel` | `connect.channel: { type, value }` | `type` is `whatsapp` \| `phone` \| `website` \| `email`. **See the consent rule** |
| `connect_updated` | `connect.updated` | The real submission date, never today's date unless that is when they sent it |
| Section 4, online ordering link | `connect.order_url` | Optional. Renders as a line of text on the profile, never a button, never on `/connect/` |
| Section 4, the delivery and collection answers | `connect.terms` | **One sentence for the whole list**, not a line per item |
| The `## Connect` section's intro | `connect.intro` | One or two sentences in their own words |
| Section 3, the products table | `connect.available[]` | One item per row: `name` from Product name, `note` from the description column. Seasonal goes in the `note` |
| `connect_tier` | `connect_tier` (top level, **not** inside `connect`) | Blank for a free listing. Never set it yourself: it is a paid tier |
| `visited` | `visited` (top level) | Only true when a Connect visit was actually made |

**Three things never reach `producers.json`.** `visit_interest` and anything
under *Help us build Connect* are the sales record and are not published.
`connect_consent` is a gate, not a field.

**The consent rule, and it is absolute.** `connect_consent` must be yes before
a channel is written. No consent means **no `channel` key at all**, which
renders as a greyed, inert Connect button rather than a live one. Never publish
a number a producer did not agree to publish.

**Numbers go in as dialled for the Republic (`087 123 4567`) and in
international form for the six counties (`+44 7xxx xxxxxx`).** `connectWhatsapp`
reads a ten digit number as Irish and an eleven digit one as UK, so a Derry
number written `07...` becomes a Republic number that does not exist.

**Free listings carry no prices and no produce photographs** (CLAUDE.md,
2026-11-04). If a submission has them anyway, leave them out and say so in your
report. Do not add a `photo` to an item or a price to a `note` on a free
listing.

**`source` is for a list that did not come from the farm.** A note filled from
the Zite form came from the farm, so leave `source` empty. Only set it when you
built the list from a website or a shop, and then say so in the line.

**Attributes vocabulary (fixed multi-select in the note).** Use these exact
labels, verbatim, when writing the `attributes` array — don't paraphrase or
re-case:

The vocabulary is grouped into three kinds of claim. The grouping matters because
the filter panel is built in the same three sections.

**How they farm** (husbandry and land) —
`Grass Fed` · `Free range` · `Pasture raised` · `Chemical Free`

**Native and heritage** (what the animal, bee or seed *is*, not how it was kept) —
`Native / rare breed` · `Heritage breed` · `Pedigree breed` ·
`Native Irish Honey Bee` · `Heritage variety`

`Heritage breed` and `Pedigree breed` were added on 2026-10-20 for O'Callaghan
Family Farm's Belted Galloways. They fill a real gap: a Belted Galloway is a
rare pedigree breed but a Scottish one, so `Native / rare breed` read as a
claim about Ireland that was not true. **Heritage breed** is for an old
established breed of animal, **Pedigree breed** for a registered herd or flock,
and a producer can tick both. `Heritage variety` stays what it always was, for
seeds and plants.

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
- **`korean-natural-farming` is the third practice** (added 2026-10-20 for New
  Leaf Urban Farmers). It renders a teal `#4A8A8A` pill with a fermenting crock
  icon, beside the organic leaf and the regenerative sprout. Write the slug
  **hyphenated**, never "Korean Natural Farming": the card builds its CSS class
  from the slug and a space would break it. The label comes from a lookup, not
  from capitalising the slug, so a multi-word practice renders properly.
- **Practice gating.** Only write a real practice (`regenerative`, `organic`
  and/or `korean-natural-farming`) to `producers.json` when the note's
  `practice_confirmed` is `true`. If practice is set but not confirmed, store
  `"practice": "unspecified"` (no pill shows) — never display a practice a
  producer hasn't confirmed. `conventional` and anything else render no pill;
  only those three do. A producer can hold more than one — store
  `"regenerative,organic"` and the card shows both pills side by side.
- **Single card image.** Every tier gets **one** image (`photo_url`) — a logo is
  ideal, but a single representative photo (e.g. a farm shot) is also fine on
  Discovered and Verified. Check the image (Read it): if it's a logo on a
  white/transparent background add `"photo_bg": "white"`; a photo or a logo with
  its own solid background omits `photo_bg`. What stays Featured-only is the
  multi-image **gallery** (`photos` array) — never add a `photos` array to a
  Discovered/Verified record. If there's no image at all, set `photo_url: null`.
- **Only list what they produce themselves.** A producer is listed for the food
  they grow, raise or make on their own ground — never for what they buy in,
  butcher or resell. Check the research before writing `product` and
  `product_type`: if a farm sells four meats but only rears two, the listing
  carries the two. This also applies to the **description**: if the producer's own
  text advertises something they source from elsewhere, cut that clause, and say
  so in your report. That is the one case where a verified producer's words are
  edited rather than used verbatim, because the alternative is the map making a
  claim it cannot stand over.

  A farmer who butchers their own animals is still a producer (Staffords
  Butchers rear their own Angus and are listed for beef). A butcher who buys in
  is not.
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
5. **Write the `connect` block** when the note has `connect: true`, per *The
   Connect block, from the same note*. Check the consent gate before writing a
   channel. Skip this entirely when the key is absent or false: that producer
   is map only, and an existing block stays as it is.
6. **Validate** the JSON (`ConvertFrom-Json` in PowerShell) — confirm count and
   the changed producer's values. Then run the `date_added` check, which is the
   one mistake that fails silently (the key is already on every record, so
   leaving it null is not an error, the producer just goes on the map having
   never been new):

   ```
   powershell -NoProfile -ExecutionPolicy Bypass -File check-new-producers.ps1
   ```

   It exits 0 when nothing is missing, and prints who is glowing as New this
   week. **Do not commit on a non-zero exit** — go back and set the date. It
   compares against the committed copy, so it only sees a record while it is
   still uncommitted: run it before the commit, not after.
7. **Bump** `service-worker.js` cache `provenance-vNNN` → `NNN+1`. If you also
   touched `connect.js`, bump its `?v=N` on every page that loads it.
8. **Commit + push** (`producers.json`, `service-worker.js`, any new image), then
   confirm the GitHub Pages deploy went live (poll the live service-worker for the
   new version).
9. **Write back** to the Obsidian note — always, on every successful add or
   update: set `Listed: Yes` so the user's tracking stays accurate. Preserve the
   rest of the note (front matter order and body) and its UTF-8 encoding.
10. **Report**: what was added/changed, restate any drafted description for the
    user to edit, and flag anything left off by rule (Instagram/website/where-to-buy
    held for Featured; practice held because `practice_confirmed` was false).
    **Say explicitly whether they went on Connect as well as the map**, and if
    not, why: no `connect: true`, or no consent so the channel was held.

## Directions (opt-in, never the default)

**Do not add a directions link unless the user asks for it.** An Eircode on the
note is not a request for one. Leave the `directions` field off the record, say
in your report that you held it and that the Eircode is on file, and add it
later if they say so.

This was the default for Verified until September 2026 and was flipped after the
user removed it from six producers in a row. The reason is that most of these
Eircodes are a family home, not a shop. A Directions button invites a stranger
to drive to a farmer's house, and only the producer can decide they want that.
The map's job is to say who they are and what they make, not where to find them
uninvited. A farm shop, a stall or a pick-up point is a different case, and it
still waits for the user to say so.

Still use the Eircode to sanity-check the town and county. That never touches
the card.

When the user does ask, build a Google Maps link
`https://maps.google.com/?q=<EIRCODE>` (spaces → `+`) and set it as the
**`directions`** field in producers.json. **The field is `directions`, not
`map_link`.** `index.html` reads `p.directions` to render the Directions
button; a link written to `map_link` renders nothing.

Twelve producers carried a directions link when this flipped. They were left
alone. Removing one is a per-producer request, not a sweep.

## Verification updates specifically

A verification usually means the note changed `tier` to `Verified` , filled in
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
