# Provenance Map

Ireland's number one platform for finding real food producers. Not certification logos — direct access to verified farmers and producers. Built in Wexford, expanding county by county across all 32 counties.

## Platform Type

Progressive web app (PWA), hosted on GitHub Pages, built using Claude Code. Native iOS and Android apps planned post-PWA.

## Business Model

### Producer Tiers (B2B)

| Tier | Price | Includes |
|------|-------|----------|
| **Discovered** | €0 | Free basic map pin. The default listing for any producer. |
| **Highlighted** | €0 | Free. The producer confirms their own details and farming practice via the "verify your profile" Fillout form. Green pin and a confirmed practice pill — **organic** (dark green `#4A8A55`, leaf icon) and/or **regenerative** (gold `#C4A44A`, sprout icon); a producer can hold both, shown side by side. Any other value shows no pill. A single card image (a logo or one representative photo) — but **no multi-image gallery, Instagram, website, or where-to-buy**; those begin at Featured. |
| **Provenance Featured** | One-off build fee, then a monthly retainer | Visit-gated, farm-level. Never sold without a prior personal visit. **Not a flat subscription.** The one-off covers the visit, the filmed vlog, the photography and building their profile page. The retainer covers keeping it alive: retraining the chatbot, refreshing photos, updating stockists and produce as the season changes. Figures to be set. Includes the filmed farm visit (vlogged), a gold pulsing pin with priority placement, photo gallery, Instagram + website links, where-to-buy, a chatbot trained on the farm's practice, a monthly collaborative reel/carousel posted across Provenance, and a silver-bordered QR sticker. Currently: Skehana Hill, Tara Hill Honey (from 2026-09-19). |
| **Provenance Seal Complete** | €149/month | Product-level — requires a qualifying packaged product (jarred / bottled / bagged / boxed, with a batch number and date). Full batch documentation, Eurofins facilitation, blockchain anchor, API store integration, and a gold-bordered QR sticker. Gold pulsing pin with a gold ring. |

**The free confirmed tier is called Highlighted.** Renamed from **Verified** on 2026-09-24. Every visible label changed — the card pill ("Provenance Highlighted"), the legend, the filter chip, the Featured pages' tier pill and their visit line, the Connect listing, the Founder pages, the app manifest and the share-stub fallback. **The data slug did not change:** `"tier": "verified"` is still what goes in producers.json, and `.tier-pill-verified`, `.pin.t-verified` and `p-ver` are still the class names. Renaming the slug would touch every record, the CSS, the share generator and both listing skills for nothing a visitor would see, so it stays. Code comments that say "Verified" are describing that slug and are correct as they are. Two things keep the old word on purpose: the Fillout form is still at `provenancemap.fillout.com/provenancemapverified` (their URL, not ours to change), and prose that means *verified* in the ordinary sense — lab results, batch documentation, "claims that cannot be verified" on `provenance-seal.html`, "a verified map" on `about.html` — is untouched, because that is a different word doing a different job.

**Featured has to be worth more than what Founders were given.** Founders got a full profile page for nothing, at a point when the map needed them more than they needed it. Featured is a paid tier, so it has to carry things a Founder page never did: the filmed visit, the trained chatbot, and ongoing upkeep rather than a page that is built once and left. If a Featured producer cannot see what the retainer buys them each month, the tier is priced wrong.

**Featured and the Seal are two separate layers, not a ladder.** Featured is about the *farm* (who the producer is, how they farm); the Seal is about a specific *packaged product*. Most Featured farms will never need a Seal, and a Seal can be sold directly to any producer with a qualifying product without a Featured relationship. Neither paid step is self-service — both are reached through a real conversation (the visit relationship or direct commercial outreach), never a public payment link.

### Pin Colours

- **Discovered Producers (tier: "discovered" / default):** Dark green — `#2A5A38`, 5.85px dot (5.78px on mobile), cream border (`1px solid rgba(232,222,200,0.75)`), faint green glow (`box-shadow: 0 0 4px 1px rgba(42,90,56,0.40)`). The default pin. No profile page, no badge. Card shows "Discovered Producer" pill in matching dark green (border `#2A5A38`, text `#4E8560`). Set `"tier": "discovered"` in producers.json (or omit tier field).
- **Highlighted Producers (tier: "verified"):** Green `#59A666`, 8.78px dot (8.67px on mobile) — 50% larger than Discovered, thin white border (`1px solid rgba(248,248,243,0.6)`), **static** green glow (`box-shadow: 0 0 6px 2px rgba(89,166,102,0.73)`) — no pulse; the pulsing pin is a paid (Featured/Seal) signal. The glow is deliberately tight: a wide glow paints many times the dot's own diameter and the pins merge into a wash as the map fills up. Card pill "Provenance Highlighted" in matching `#4A8A55`. Set `"tier": "verified"` in producers.json.
- **Provenance Featured (paid, gold):** Deep amber gold — a **radial gradient**, not a flat fill: `radial-gradient(circle at 34% 30%, #E8C670 0%, #CDA043 48%, #A97C28 100%)`, lit from the upper left so the dot reads as a raised bead rather than a flat disc, with an `inset 0 0 1.5px rgba(255,238,186,0.45)` highlight. The mid tone `#CDA043` is warmer and richer than the `#C4A44A` gold token (hue 40 vs 44, and more saturated). **9.22px dot (9.10px on mobile), 5% larger than Highlighted** — a deliberately modest bump, so colour and glow do the work rather than size. **No border** (unlike Discovered and Highlighted, which both carry a cream/white one), and a soft radial glow that is deliberately restrained: `box-shadow: 0 0 0 1px rgba(201,154,56,0.55), 0 0 7px 2px rgba(201,154,56,0.45), 0 0 16px 6px rgba(201,154,56,0.20)`. Earlier passes ran brighter and harder (`#E0B93C`, `#E9C93E`, a green-with-gold core `#6FB35A`, and a glow at double this strength) and read neon; this is the settled version. **Pulses**, very faintly: a 4.5s orange breath (`rgba(214,132,52,0.20)`, scaling to 2.8x, peak opacity 0.42) deliberately near the threshold of noticeable, so it reads as the pin being alive rather than as an alert. Reduced-motion turns it off. The visit-gated farm tier. Card pill "Provenance Featured" in `#D9AE55`, a lifted amber for legibility on the dark card. Set `"tier": "featured"` in producers.json. Unlocks Instagram + website links and where-to-buy on the card, plus the link to the producer's own profile page at `/<profile_slug>/`, which is where the photo gallery and the filmed visit live (never on the card). Instagram and website went live on 2026-09-07. Currently: Skehana Hill, Tara Hill Honey.
- **Provenance Seal Complete:** Gold — `#C4A44A`, pulsing + gold ring border. The €149/month product-level tier.
- **Provenance Founder:** Set `badge2: "Provenance Founder"`. Renders as a gold **button at the foot of the card** (`.card-action-founder`), not a pill beside the tier badge, and links to their full profile page at `map_link` (`producers/<slug>.html`). The badge line stays a single tier statement. No special pin treatment — pin appearance is controlled by tier. Currently: Newbard Organic Farm Ltd, Staffords Butchers, and Saltrock Dairy Farm (all Highlighted).

> **Implementation note:** the code ships tiers `discovered`, `verified`, `featured`, `seal-lite`, `seal-complete`. The gold **Featured** pin was wired in on 2026-08-24 with Skehana Hill as the first producer on it. The pin carries a very faint orange pulse (added 2026-08-24) plus a soft gold glow. Featured's card unlocks (gallery, Instagram, website, where-to-buy, filmed visit) are **not** wired in yet: Skehana Hill's card carries the tier pill, a gold top edge on the card itself (#card.featured-card), their Instagram and website, and an inert Featured Profile In Progress pill between the links and the confirmed line. **The profile page exists** (built 2026-09-14) at `provenancemap.ie/skehanahill`, served from `/skehanahill/index.html`; the public slug lives in a `profile_slug` field on the record, never in the `id`. Facts on the page come from `producers.json` (so card and page cannot drift; `where_to_buy` feeds both), visit content from `/<slug>/profile.json` (visit date, hero, film, story, product notes, and the `photos` gallery with captions and crop positions). **The map card never carries the photo gallery.** Decided 2026-09-14: the card keeps its single logo, the tier pill, the practice pill and the links, and its job is to send people to the profile page, which is where the photos live. So a Featured record has no `photos` array; the card's thumbnail strip and lightbox stay in the code but nothing feeds them. `profile_live: true` on the record swaps the card's inert "Featured Profile In Progress" span for the real link (`#card-featured-link`) and drops the page's own "Profile in progress" pill; **Skehana Hill went live on 2026-09-15.** The visit date is the line the tier stands on: a page does not go live without one. The card's where-to-buy entries are `{ name, url, note, when }`: the name links to `url`, `when` sits on the right (a day, or "Directions" for a maps link), `note` is a muted line under it, and a single entry spans the card. A second Featured producer is a copy of the folder with `PRODUCER_ID` and `PAGE_URL` changed and its own `profile.json`. **Provenance Connect, layer one (2026-09-21):** a `whatsapp` number on the record (written as dialled, `087...`; normalised to `353` for `wa.me`) puts a **Connect** button on the map card beside Featured Profile and a filled Connect button at the head of the profile page's link row; both open a WhatsApp chat prefilled with "Hi, I found <name> on the Provenance Map." An empty or missing number shows nothing. **Provenance Collection** membership is `"collection": true` on the record: the pin keeps its Highlighted green and size and takes a thin bright silver ring `#DCD9D0` and a soft silver glow in place of the white ring and green glow and the card carries a silver "Provenance Collection" pill beside the tier pill; the tier itself is unchanged. First member: Galtee Honey Farm, 2026-09-19. Saltrock renders on `verified` (green) with its logo as the single card image; its former gallery/IG/website/where-to-buy were removed from its record when it moved to Highlighted. `photo_url` is the single card image (a logo is preferred, but one representative photo is acceptable on any tier); only the multi-image `photos` gallery is Featured-only. Pin size is not affected by farming practice — organic/regenerative shows via the card practice pill only, never by enlarging the pin.
- **Farmers Market:** Terracotta — `#B0623A`, 5.95px dot (4.25px on mobile), no border, terracotta glow. Completely different card layout showing hours and a producer list. Currently: Gorey Farmers Market (Saturday 10am–2pm). Add `class="pin market"` and `data-category="market"` to the pin.

### The card states things, it does not badge them

Decided 2026-09-24. The card used to stack four rows of rounded pills — tier, Collection, confirmed attributes, produce, venue — and they read as chrome rather than as content. They are all text now, no borders and no backgrounds:

- **The tier** (`.tier-mark`) is one line of letterspaced small caps in the tier's own colour, and a hairline (`.tier-rule`) runs from it to the edge of the card. A second mark (Collection, Founder) is divided from the first by a vertical hairline, never boxed off on its own. Featured finally uses `#D9AE55`, the lifted amber this file always specified — as a solid gold block it had to carry dark text instead.
- **The practice line** was already set this way (Cormorant italic with a leaf or sprout icon, in the practice colour) and is unchanged. It is the warmest thing on the card and the hierarchy is built around it.
- **Confirmed attributes** (`.badge-attr`) are a quiet middot-separated line in muted cream under the practice.
- **Produce and venue tags** are the same line in green, so they read apart from the attributes directly above them.

The Connect listing page follows the same rule. Anything new that wants to label a producer gets a line of type, not a pill.

### Provenance Connect, layer two — availability

Built 2026-09-24. **What a producer currently has, in their own words.** The
governing rule: *what do you have*, never *how many do you have*. There is no
quantity field in the UI or in the data, deliberately, and none is to be added
— a note like "boxes to order" is prose, not a number.

On the record:

```json
"connect": {
  "active": true,
  "channel": { "type": "whatsapp", "value": "087 947 8954" },
  "updated": "2026-09-24",
  "available": [
    { "name": "Organic grass-fed beef", "note": "Boxes to order from the farm shop" },
    { "name": "Organic lamb" }
  ],
  "plus": {}
}
```

`available[].name` is free text, **not** a `product_type` slug — a producer can
write *Ling heather honey* and it shows exactly that. The slugs stay as they
are, for the filters and the menu. `channel.type` is `whatsapp` | `website` |
`phone` | `email`, and a bare `whatsapp` field on the record still works as the
fallback from layer one. `plus: {}` is the whole of the Connect Plus
groundwork: one empty key nothing reads.

**Two sources, live one first.** `connect.js` (shared by every surface, loaded
with `?v=N` because the worker is cache-first for non-pages) reads a published
Google Sheet fed by a Google Form, and falls back to the record's `connect`
block when the Sheet is unconfigured or unreachable. Newest row per farm wins;
Form responses are append-only, so an edit is a new row and a removal is a
shorter list. A Google outage degrades to the record, never to a broken page.
**Provenance runs no backend and no page holds a credential.** The Sheet and
Form ids live in `connect-source.json` — see `CONNECT-SETUP.md`, which is the
ten-minute recipe and is **not done yet**.

**`updated` is what replaces stock counts.** It is always on screen. Past
`CONNECT_FRESH_DAYS` (21, one constant in `connect.js`) the heading softens
from *Available now* to *Last listed* in muted grey. A list is only as
trustworthy as its date, so the date is never hidden.

**The producer's editor** is `/producer/edit/?id=<slug>` — our own UI, not a
Google Form: add a line, remove a line, Save. It posts to the Form and then
**confirms by re-reading the Sheet**, because a cross-origin form post cannot
be read back and "Published" must mean the row was actually seen. With no Form
configured it says so plainly and hands over the list to send to Provenance; it
never fakes a save. Drafts are kept in the producer's own browser so a closed
tab loses nothing, and the page says they are unpublished. The page is
`noindex` and unlinked: the URL is the key, so hand it out deliberately.

**Where it shows:** the full list with notes and the one button on the profile
pages (both the bespoke Featured pages and `/producer/`); names only, as a
quiet middot line, on the map card and on `/connect/`. The card's job is still
to send people to the profile — do not grow it.

**No commission, ever.** Provenance takes no part in the order; the button goes
straight to the producer's chosen channel. The commercial model is a monthly
producer subscription. Still open, and needing a decision: which tiers may use
Connect (availability is a producer-authored claim, which argues for
Highlighted as the floor, and nothing enforces a tier yet), and whether that
subscription is self-service, which this file currently says no paid step is.

### Navigation and profile pages

**The menu is three panels deep** (built 2026-09-24). Root: Provenance Connect, **Producers**, About Provenance, List Your Farm. Producers opens the produce categories; a category opens the farms in it, A–Z, each with its tier shown as the pin itself rather than as a word. A row goes to that producer's **profile page**, never back to their card on the map.

The category names and their order are read from the map's own filter chips at load, so the menu and the filters cannot disagree about what a category is called, and a category with no producers hides exactly the way an empty chip does. Everything is built from `producers.json`, so a new listing appears in the menu the moment it appears on the map.

**Every producer has a profile page, at every tier.** Where it lives:

| The record has | The profile is at |
|---|---|
| `profile_slug` + `profile_live` | `/<profile_slug>/` — the bespoke Featured page (Skehana Hill, Tara Hill Honey) |
| `map_link` | that path — the built Founder pages (Newbard, Staffords, Saltrock) |
| neither | `/producer/?id=<id>` — the shared page |

`profileUrl()` implements that rule and exists in both `index.html` and `/producer/index.html`. The shared page redirects to a bespoke one if it is ever reached by a stale link, so a producer can never be shown a lesser page than they have earned.

`/producer/index.html` is set in the **Featured pages' language** (charcoal, Playfair, forest green, no italic), not the map's, because it is a profile page. It shows only what the record can honestly carry: a Discovered farm gets what its card has, Highlighted adds the practice and the attributes they confirmed, and Instagram, website and where-to-buy are gated to Featured **in the page code as well as in the data**, so a stray field on a free record can never put a paid benefit on a free page. The single card image is contained rather than cropped, since it is usually a logo, and `photo_bg: "white"` gives it a white ground to sit on.

### Consumer Model (B2C, Freemium)

- Free forever: basic map discovery
- Premium (€3–€5/month): saved producers, batch notifications, full chatbot access, in-app ordering

### In-App Ordering (Phase 4)

- Stripe Connect for producer payouts
- Provenance takes 5% per transaction

## Design System

### Aesthetic

Painterly, illustrated — inspired by Ghost of Tsushima. Ireland from above, surrounded by ocean and cloud. Deep greens, teal water, atmospheric. Producer pins glow softly on hover. Feels like a world worth exploring, not a utility tool.

### Colours

| Token | Hex |
|-------|-----|
| Background | `#060807` |
| Card surface | `#0E100D` |
| Green accent | `#4A8A55` |
| Gold accent | `#C4A44A` |
| Teal accent | `#4A8A8A` |
| Cream text | `#E8DEC8` |
| Muted text | `#504838` |

### Typography

- Headings: Cormorant Garamond
- Body: Source Serif 4

**Featured profile pages are the exception** (decided 2026-09-15, Skehana Hill first): they are set like the carousel plates, not like the map. Charcoal ground `#1A1B18`, silver hairlines `rgba(201,198,189,0.14)`, Playfair Display for names, headings and pull quotes in deep forest green (`#2F5C3A` name, `#35663F` headings), upright throughout with no italic anywhere; Inter medium small caps in `#45704E`; Source Serif 4 body in cream `#E8DEC8`; the place line and buttons in a lighter green `#5A8C64` so they read apart. The map and its cards keep Cormorant.

## Producers

`producers.json` is the source of truth for who is listed on the map. The Obsidian vault (`Provenance Map listings/<County>/<Producer>.md`) is the source of truth for producer detail. Never rely on a producer list written into this file.

**A producer is listed only for what they produce themselves.** The pin covers the food they grow, raise or make on their own ground, never what they buy in, butcher or resell. If a farm sells four meats but rears two, the listing carries the two. This applies to the description as well: a clause advertising something they source elsewhere gets cut, even from a verified producer's own words, because the alternative is the map making a claim it cannot stand over. A farmer who butchers their own animals is still a producer (Staffords Butchers rear their own Angus and are listed for beef); a butcher who buys in is not.

## Data Models

### Producer Profile — what shows at each tier

**Every tier (including Discovered and Highlighted)** shows:
- Producer name
- County / Town
- Product type
- Verification tier badge (and, for Highlighted, the confirmed practice pill — **organic** in dark green with a leaf icon, and/or **regenerative** in gold with a sprout icon; a producer can hold both, shown side by side. Only these two render; any other practice value shows no pill)
- Short description
- A single image (`photo_url`): ideally the producer's **logo**, but one representative photo is fine too — never a multi-image gallery

**Highlighted only** additionally shows:
- The confirmed practice pill (organic and/or regenerative)
- **Attribute pills** (`attributes` array: Grass Fed, Free range, Pasture raised, Chemical Free, Native / rare breed, Native Irish bee, Heritage variety, Raw / unpasteurised, Non-Homogenised, Plastic Free)

> **Practice and attributes are producer-confirmed only.** Both come from the producer ticking boxes on the verify form, never from research, a website, or a farm's own marketing. A Discovered producer always has `"practice": "unspecified"` and `"attributes": []`. A pill reads as a claim Provenance stands over, and only the producer can earn that. Researched facts go in the description, which is understood to be secondhand. This is why a filter chip can sit empty and hidden while relevant farms are already listed — that is the correct state, not a bug.

**Provenance Featured and above** additionally show:
- Farm photo gallery (`photos` array — real farm/produce images, lightbox viewer)
- Instagram link
- Website link
- Where-to-buy
- Filmed farm-visit video

The rule: **one image on every card (logo preferred, a single photo is fine); the multi-image gallery, Instagram, website, and where-to-buy begin at Featured.**

### Provenance Seal Batch Documentation Page (Provenance Seal Complete)

- Named farm
- Named butcher or supplier
- Breed or variety
- Feeding regime or growing method
- Render or production date
- Kitchen or facility details
- Eurofins test results with EU limits alongside each number
- Lab report PDF download
- Sourcing footage (TikTok or YouTube embed)
- Render or production footage (TikTok or YouTube embed)
- AI chatbot embed
- QR code image
- Best before date
- Storage instructions

## Tools

| File | Purpose | Notes |
|------|---------|-------|
| `qr-generator.html` | QR code generator | Standalone HTML. Input: URL. Output: downloadable PNG at 1000×1000px minimum. Uses CDN-hosted QR library. Background matches design system. |
| `generate-share-pages.ps1` | Share stub generator | Creates `/share/<slug>.html` for every Highlighted+ producer in producers.json: OG tags for rich link previews, then redirects to `/?producer=<slug>` which opens their card on the map. **Run whenever a producer upgrades to Highlighted**, then commit the new stub. The card Share button (Highlighted only) shares this stub URL. |

## Social Channels

TikTok and Instagram — both accounts: **Provenance**

## Rollout

Starting in Wexford, expanding county by county across all 32 counties of Ireland.

## Philosophy and Positioning

The founding purpose, the problem Provenance solves, the commercial commitment to producers, the content arc, and the never-be-sold commitment live in `PHILOSOPHY.md`. Read that file when the work is about content, marketing, positioning, producer-facing copy, or a decision that turns on what Provenance is for. Routine build work (producers.json, pins, tiers, deploys) does not need it.
