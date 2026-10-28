# Provenance Map

Ireland's number one platform for finding real food producers. Not certification logos — direct access to verified farmers and producers. Built in Wexford, expanding county by county across all 32 counties.

## Platform Type

Progressive web app (PWA), hosted on GitHub Pages, built using Claude Code. Native iOS and Android apps planned post-PWA.

## Business Model

### Producer Tiers (B2B)

| Tier | Price | Includes |
|------|-------|----------|
| **Discovered** | €0 | Free basic map pin. The default listing for any producer. |
| **Verified** | €0 | Free. The producer confirms their own details and farming practice via the "verify your profile" Fillout form. Green pin and a confirmed practice pill — **organic** (dark green `#4A8A55`, leaf icon), **regenerative** (gold `#C4A44A`, sprout icon) and/or **Korean Natural Farming** (teal `#4A8A8A`, fermenting crock icon, added 2026-10-20); a producer can hold more than one, shown side by side. The KNF slug is hyphenated, `korean-natural-farming`, because the card builds a CSS class from it and the label comes from a lookup rather than from capitalising the slug. Any other value shows no pill. A single card image (a logo or one representative photo) — but **no multi-image gallery, Instagram, website, or where-to-buy**; those begin at Highlighted. |
| **Provenance Highlighted** | One-off fee (amount TBD) | Visit-gated, farm-level. Never sold without a prior personal visit. **A one-off fee, never a monthly charge (confirmed 2026-10-08).** The fee covers the visit, the filmed vlog, the photography and building their profile page. Updates happen opportunistically when the founder is at the farm anyway. The monthly retainer belongs to the Seal, not to this tier. Includes the filmed farm visit (vlogged), a gold pulsing pin with priority placement, photo gallery, Instagram + website links, where-to-buy, a chatbot trained on the farm's practice, a monthly collaborative reel/carousel posted across Provenance, and a silver-bordered QR sticker. The producers currently on this tier are in `producers.json`, not in this file. |
| **Provenance Seal** | Price unspecified | Product-level, and **not yet sold or pitched to producers (2026-10-19)**. A QR code on the pack opens that product's story page: the farm, the people, the breed or variety, the ground, and the history behind what the buyer is holding. Price, what a fee would cover and the sticker treatment are all unspecified until the Collection case study is finished. **The word Seal is public (2026-10-19), but do not sell or pitch the Seal, Seal Lite or Seal Complete to producers, or show them in producer-facing decks,** until that is settled. The code slugs stay as they are. |

**The tier names, as they stand (restored 2026-10-01).** Three free-to-paid steps a visitor can see: **Discovered** (`"tier": "discovered"`, researched, not confirmed), **Verified** (`"tier": "verified"`, the producer submitted their own details on the verify form) and **Highlighted** (`"tier": "featured"`, the gold, visit-gated, paid tier with its own profile page). The **Provenance Collection** is a parchment-cream mark on top of a tier, not a tier. History, so nobody repeats it: on 2026-09-24 the free confirmed tier was renamed Verified → Highlighted, and two hours later the gold tier took the name Highlighted and the confirmed tier was relabelled **Discovered** ("Confirmed" in the legend). That left the map with no visible difference between a researched listing and one the producer had confirmed. On 2026-10-01 the user had the confirmed tier restored to **Verified** everywhere a visitor sees it: the card mark ("Provenance Verified"), the legend ("Verified producer"), the tier filter ("Verified"), the shared profile, the Connect listing, the Highlighted pages' Nearby cards, the Founder pages ("Verified by Provenance", "is verified on the Provenance Map"), the app manifest and the share-stub fallback. **Do not rename a tier again without the user asking.** **2026-10-08: at the user's request, every remaining use of "Featured" for the gold tier in this file was changed to Highlighted.** The tier is called Highlighted everywhere, in copy and in this file. Only the code slugs still say `featured`, and they stay that way. The slugs never changed: `verified`, `.tier-mark-verified`, `.pin.t-verified` and `p-ver` are the Verified tier; `featured`, `.tier-mark-featured` and `p-feat` are Highlighted. The Fillout form is still at `provenancemap.fillout.com/provenancemapverified`. **A producer becomes Verified only by submitting the form themselves**; an upgrade command does not make them Verified on its own.


**Highlighted has to be worth more than what Founders were given.** Founders got a full profile page for nothing, at a point when the map needed them more than they needed it. Highlighted is a paid tier, so it has to carry things a Founder page never did: the filmed visit, the trained chatbot, and ongoing upkeep rather than a page that is built once and left. If a Highlighted producer cannot see what the one-off fee bought them, the tier is priced wrong.

**Highlighted and the Seal are two separate layers, not a ladder.** Highlighted is about the *farm* (who the producer is, how they farm); the Seal is the story of a specific *packaged product*, reached by scanning the pack. Most Highlighted farms will never need a Seal, and a Seal can go to any producer with a qualifying product without a Highlighted relationship. **A Seal does involve a visit, but not the Highlighted visit**: a short introduction and a mapping of the product and the ground behind it, not a filmed day on the farm. Neither paid step is self-service: both are reached through a real conversation, never a public payment link.

### Pin Colours

- **Discovered Producers (tier: "discovered" / default):** Dark green — `#2A5A38`, 5.85px dot (5.78px on mobile), cream border (`1px solid rgba(232,222,200,0.75)`), faint green glow (`box-shadow: 0 0 4px 1px rgba(42,90,56,0.40)`). The default pin. No profile page, no badge. Card shows "Discovered Producer" pill in matching dark green (border `#2A5A38`, text `#4E8560`). Set `"tier": "discovered"` in producers.json (or omit tier field).
- **Verified Producers (tier: "verified"):** Green `#59A666`, 8.78px dot (8.67px on mobile) — 50% larger than Discovered, thin white border (`1px solid rgba(248,248,243,0.6)`), **static** green glow (`box-shadow: 0 0 6px 2px rgba(89,166,102,0.73)`) — no pulse; the pulsing pin is a paid (Highlighted/Seal) signal. The glow is deliberately tight: a wide glow paints many times the dot's own diameter and the pins merge into a wash as the map fills up. Card pill "Provenance Verified" in matching `#4A8A55`. Set `"tier": "verified"` in producers.json.
- **Provenance Highlighted (paid, gold):** Deep amber gold — a **radial gradient**, not a flat fill: `radial-gradient(circle at 34% 30%, #E8C670 0%, #CDA043 48%, #A97C28 100%)`, lit from the upper left so the dot reads as a raised bead rather than a flat disc, with an `inset 0 0 1.5px rgba(255,238,186,0.45)` highlight. The mid tone `#CDA043` is warmer and richer than the `#C4A44A` gold token (hue 40 vs 44, and more saturated). **9.22px dot (9.10px on mobile), 5% larger than Verified** — a deliberately modest bump, so colour and glow do the work rather than size. **No border** (unlike Discovered and Verified, which both carry a cream/white one), and a soft radial glow that is deliberately restrained: `box-shadow: 0 0 0 1px rgba(201,154,56,0.55), 0 0 7px 2px rgba(201,154,56,0.45), 0 0 16px 6px rgba(201,154,56,0.20)`. Earlier passes ran brighter and harder (`#E0B93C`, `#E9C93E`, a green-with-gold core `#6FB35A`, and a glow at double this strength) and read neon; this is the settled version. **Pulses**, very faintly: a 4.5s orange breath (`rgba(214,132,52,0.20)`, scaling to 2.8x, peak opacity 0.42) deliberately near the threshold of noticeable, so it reads as the pin being alive rather than as an alert. Reduced-motion turns it off. The visit-gated farm tier. Card mark "Provenance Highlighted" (the gold tier is called Highlighted wherever a visitor sees it) in `#D9AE55`, a lifted amber for legibility on the dark card. Set `"tier": "featured"` in producers.json. Unlocks Instagram + website links and where-to-buy on the card, plus the link to the producer's own profile page at `/<profile_slug>/`, which is where the photo gallery and the filmed visit live (never on the card). Instagram and website went live on 2026-09-07. **Every Highlighted farm got there through a founder visit** (corrected 2026-10-08; an earlier note here wrongly said one went gold before a visit). Who is on the tier, and which profile pages are live, is in `producers.json`, not in this file.
- **Provenance Seal:** Unspecified (2026-10-19). A Seal may eventually change something on the farm's pin, but the treatment is not decided and the Seal is not publicly offered, so nothing renders for it today.
- **Provenance Founder:** Set `badge2: "Provenance Founder"`. Renders as a gold **button at the foot of the card** (`.card-action-founder`), not a pill beside the tier badge, and links to their full profile page at `map_link` (`producers/<slug>.html`). The badge line stays a single tier statement. No special pin treatment — pin appearance is controlled by tier. Who holds it is in `producers.json`, not in this file.

> **Implementation note:** the code ships tiers `discovered`, `verified`, `featured`, `seal-lite`, `seal-complete`. The gold **Highlighted** pin was wired in on 2026-08-24 with Skehana Hill as the first producer on it. The pin carries a very faint orange pulse (added 2026-08-24) plus a soft gold glow. Highlighted's card unlocks (gallery, Instagram, website, where-to-buy, filmed visit) are **not** wired in yet: Skehana Hill's card carries the tier pill, a gold top edge on the card itself (#card.featured-card), their Instagram and website, and an inert Highlighted Profile In Progress pill between the links and the confirmed line. **The profile page exists** (built 2026-09-14) at `provenancemap.ie/skehanahill`, served from `/skehanahill/index.html`; the public slug lives in a `profile_slug` field on the record, never in the `id`. Facts on the page come from `producers.json` (so card and page cannot drift; `where_to_buy` feeds both), visit content from `/<slug>/profile.json` (visit date, hero, film, story, product notes, and the `photos` gallery with captions and crop positions). **The map card never carries the photo gallery.** Decided 2026-09-14: the card keeps its single logo, the tier pill, the practice pill and the links, and its job is to send people to the profile page, which is where the photos live. So a Highlighted record has no `photos` array; the card's thumbnail strip and lightbox stay in the code but nothing feeds them. `profile_live: true` on the record swaps the card's inert "Highlighted Profile In Progress" span for the real link (`#card-featured-link`) and drops the page's own "Profile in progress" pill; **Skehana Hill went live on 2026-09-15.** The visit date is the line the tier stands on: a page does not go live without one. The card's where-to-buy entries are `{ name, url, note, when }`: the name links to `url`, `when` sits on the right (a day, or "Directions" for a maps link), `note` is a muted line under it, and a single entry spans the card. A second Highlighted producer is a copy of the folder with `PRODUCER_ID` and `PAGE_URL` changed and its own `profile.json`. **Provenance Connect, layer one (2026-09-21):** a `whatsapp` number on the record (written as dialled, `087...`; normalised to `353` for `wa.me`) puts a **Connect** button on the map card beside Highlighted Profile and a filled Connect button at the head of the profile page's link row; both open a WhatsApp chat prefilled with "Hi, I found <name> on the Provenance Map." An empty or missing number shows nothing. **Provenance Collection** membership is `"collection": true` on the record: the pin keeps its Verified green and size and takes a thin parchment-cream ring `#F3EEDD` and a soft cream glow in place of the white ring and green glow (silver `#DCD9D0` until 2026-10-28) and the card carries a plain-text "Provenance Collection" mark beside the tier mark; the tier itself is unchanged. First member: Galtee Honey Farm, 2026-09-19. Saltrock renders on `verified` (green) with its logo as the single card image; its former gallery/IG/website/where-to-buy were removed from its record when it moved to Verified. `photo_url` is the single card image (a logo is preferred, but one representative photo is acceptable on any tier); only the multi-image `photos` gallery is Highlighted-only. Pin size is not affected by farming practice — organic/regenerative shows via the card practice pill only, never by enlarging the pin.
- **Farmers Market:** Terracotta — `#B0623A`, 5.95px dot (4.25px on mobile), no border, terracotta glow. Completely different card layout showing hours and a producer list. Add `class="pin market"` and `data-category="market"` to the pin.

### The card states things, it does not badge them

Decided 2026-09-24. The card used to stack four rows of rounded pills — tier, Collection, confirmed attributes, produce, venue — and they read as chrome rather than as content. They are all text now, no borders and no backgrounds:

- **The tier** (`.tier-mark`) is one line of letterspaced small caps in the tier's own colour, and a hairline (`.tier-rule`) runs from it to the edge of the card. A second mark (Collection, Founder) is divided from the first by a vertical hairline, never boxed off on its own. Highlighted finally uses `#D9AE55`, the lifted amber this file always specified — as a solid gold block it had to carry dark text instead.
- **The practice line** was already set this way (Cormorant italic with a leaf or sprout icon, in the practice colour) and is unchanged. It is the warmest thing on the card and the hierarchy is built around it.
- **Confirmed attributes** (`.badge-attr`) are a quiet middot-separated line in muted cream under the practice.
- **Produce and venue tags** are the same line in green, so they read apart from the attributes directly above them.

The Connect listing page follows the same rule. Anything new that wants to label a producer gets a line of type, not a pill.

### Provenance Connect, layer two — availability

**Connect is not paused (corrected 2026-10-19).** It is being worked on in the background, and the user will update it later in the week. Prices and what is paid are unspecified for now. `CONNECT-SETUP.md` is still not done. The two open questions at the end of this section stay open on purpose: which tiers may use Connect, and whether the producer subscription is self-service. Everything below is the record of what was built.

Built 2026-09-24. **What a producer currently has, in their own words.** The
governing rule: *what do you have*, never *how many do you have*. There is no
quantity field in the UI or in the data, deliberately, and none is to be added
— a note like "boxes to order" is prose, not a number.

On the record:

```json
"connect": {
  "active": true,
  "channel": { "type": "whatsapp", "value": "083 434 8763" },
  "order_url": "https://www.rathphelanfarm.ie/pages/shop",
  "updated": "2026-09-25",
  "intro": "One or two sentences: who they are and what they sell, in their terms.",
  "terms": "How collection and delivery work here, said once for the whole list.",
  "source": "Only when the list was not submitted by the farm. See below.",
  "groups": [
    { "name": "Monthly subscription", "note": "A standing order, billed monthly." },
    { "name": "Boxes", "note": "One-off boxes, made up off their own cattle." },
    { "name": "Individual cuts", "match": "profile_only",
      "note": "Collection only. Not available to order for delivery." }
  ],
  "available": [
    { "name": "Beef box, 5kg", "group": "Boxes",
      "note": "Steaks and mince rather than the slow-cooking cuts." },
    { "name": "Quarter, half or whole heifer", "group": "Boxes",
      "note": "Cut, bagged and labelled to order for the freezer.",
      "options": ["Quarter", "Half", "Whole"] },
    { "name": "T-bone steak", "note": "Striploin one side of the bone, fillet the other.",
      "profile_only": true, "photo": "/produce/rathphelan-farm/t-bone-steak.jpg" }
  ],
  "plus": {}
}
```

**Every item gets a plain line.** `note` says what the thing actually is — for
a cut, where it comes off the animal and how it cooks, in a few words. Not
flavour writing: *"Picanha: the rump cap, fat left on"*, not *"reflecting the
depth of flavour that comes from heritage breeding"*. Box contents come off the
farm's own shop, never invented.

**`groups` give the list its headings**, so a reader can tell a standing order
from a one-off box from a single cut. A group takes its items either by name
(`"group": "Boxes"` on the item) or by a `match` rule — `profile_only` for the
detail a farm keeps on its own page, `listed` for what the directory carries —
which saves putting a line on forty items when the split already exists. A
group's own `note` is where a rule that applies to just those items goes, right
on top of them rather than once at the top of the page where it is read and
forgotten. Ungrouped items fall through to one plain list, and a farm with no
groups renders exactly as before.

**`options`** are the brackets a thing is sold in (Quarter, Half, Whole).
**`fulfilment`** is a per-item exception to `terms` and is rarely needed;
`terms` said once beat it repeated down fifteen cuts.

**Three buttons, and they mean different things.** **Connect** opens the chat,
**Order** goes to the farm's own shop (`order_url`, falling back to the
record's `website`), and both get you to the producer so they look alike.
**See the farm** always goes to `/producer/?id=<id>` — the shared profile, even
for a farm with a bespoke page — so every farm on Connect lands a visitor on
the same kind of page. It is bordered rather than filled, because it is a
different job. A farm with no channel or no shop on file keeps the slot as a
greyed, inert `<span>`, so the row does not change shape when the detail
arrives and there is never a live button that goes nowhere.

**A Highlighted farm with its own built page gets a quiet line** under the
buttons, "View their Highlighted profile", in the Highlighted amber. A line and
not a fourth button: the buttons are what to do here, the filmed page is
somewhere to go afterwards. It only renders when `profile_live` is true.

**Connect on the map card and on a profile hero is navigation, not a chat.**
Both are the plain word with no message icon, and neither opens WhatsApp. They
go to different places on purpose:

| Pressed on | Goes to | Why |
|---|---|---|
| The map card | `/producer/?id=<id>` — that farm's See the farm page | From a pin you want *that* producer, not a list of everyone. Their page carries the full list, the terms and the Connect and Order buttons, so nothing is lost by skipping the directory |
| A Highlighted profile hero | `#connect-section` on the same page | Settled by the user on 2026-10-01; do not change it without asking. The Highlighted profile at `/<slug>/` runs: hero (name, place, produce, a small Connect with the farm button, then Instagram, website and share), quote, film, story, what they grow, Around the farm, **Available now** (list, Connect and Order), **Where to buy** (Connect beside the farm shop Directions; "Direct from the farm" when nowhere is on file), visit record. The Connect profile at `/producer/?id=<id>` carries the same list |

Either button shows when the farm is **on Connect at all**, not when a
`whatsapp` number happens to be on the record, so neither can land somewhere
that is not there. The messaging button with the icon lives on `/connect/` and
in the availability block of a profile. The card's press is tracked as
`see_farm_click` — named for where it lands, so it sits alongside the same
press on `/connect/` rather than inventing a second event for one button.

**Numbers outside the Republic go in international form.** `connectWhatsapp`
normalises a dialled number, and a leading zero is not always Irish: the map
covers all thirty-two counties. A Republic mobile dialled is ten digits
(`087...`), a UK one eleven (`07...`), and that length is the tell the code
uses. Anything written with `+` or `00` is left alone, so **a Northern Ireland
number is written `+44 7775 810253`** rather than `07775 810253`. Before this
was handled, a Derry number became a Republic number that does not exist.

**A list that did not come from the farm says so.** The Connect page tells
people each farm submits its own list weekly. A `source` line on the connect
block renders under the list and is for exactly the case where that is not
true yet — Moyletra Moileds was built from their own shop at moilies.com, and
the line says so. Do not populate a `connect` block from research and leave
this empty; the `updated` date would be borrowing credibility from a
submission that never happened.

**`profile_only: true`** on an item holds it back from the `/connect/`
directory and keeps it on the farm's own page. The directory carries the
headline offers — boxes, the whole animal, a subscription — and a line saying
how many cuts are on the farm's page. Rathphelan Farm has fifteen marked,
Moyletra Moileds nineteen.

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

**Where it shows.** Three surfaces, each carrying a different amount:

| Surface | What it carries |
|---|---|
| The profile pages (`/producer/` and the bespoke Highlighted ones) | Everything: every item including `profile_only` ones, grouped, **with the produce photographs**, and the Connect + Order buttons |
| `/connect/` | The headline offers only — `profile_only` items are held back — **with no photographs**, plus a line saying how many cuts are on the farm's page |
| The map card | **Nothing.** Availability came off the card on 2026-09-24. It carries the Connect button and that is the whole job |

Photographs are *not rendered* on `/connect/` rather than hidden with CSS
(`connectListHTML(items, esc, { photos: false })`), so a phone does not
download a megabyte of cut photos to sit in 96px squares. The card's job is to
send people to Connect or to the profile — **do not grow it**.

**The Connect page has its own link preview.** `assets/og/connect.jpg`, 1200x630,
built by a script in the profile pages' language. Without an `og:image` WhatsApp
renders a bare link, which is what it did until 2026-09-30. Any new shareable
page needs the full set: `og:image` plus its width, height and type, and the
`twitter:card` block, all with **absolute** URLs.

**Analytics are wired through one funnel** — `pvTrack()` in `connect.js`, never
`gtag` directly. `connect_click` is the WhatsApp press, `order_click` the shop,
`connect_layer_click` the navigation ones, and each carries the producer, tier,
county and surface. Event names stay few and the producer goes in a parameter:
GA4 caps an account at 500 distinct event names. Full table in
`CONNECT-ANALYTICS.md`.

**Produce photos** live at `/produce/<producer-id>/<cut>.jpg`, referenced from
the record as a path from the site root (`/produce/...`) so it resolves the same
from any page depth. Square, 700px, q84 — a centre crop of a packet shot reads
well at the 96px the list renders. Rathphelan Farm has thirteen (2026-09-25).

**No commission, ever.** Provenance takes no part in the order; the button goes
straight to the producer's chosen channel. The commercial model is a monthly
producer subscription. Still open, and needing a decision: which tiers may use
Connect (availability is a producer-authored claim, which argues for
Verified as the floor, and nothing enforces a tier yet), and whether that
subscription is self-service, which this file currently says no paid step is.

### Navigation and profile pages

**The menu is three panels deep** (built 2026-09-24). Root: Provenance Connect, **Producers**, About Provenance, List Your Farm. Producers opens the produce categories; a category opens the farms in it, A–Z, each with its tier shown as the pin itself rather than as a word. A row goes to that producer's **profile page**, never back to their card on the map.

The category names and their order are read from the map's own filter chips at load, so the menu and the filters cannot disagree about what a category is called, and a category with no producers hides exactly the way an empty chip does. Everything is built from `producers.json`, so a new listing appears in the menu the moment it appears on the map.

**Every producer has a profile page, at every tier.** Where it lives:

| The record has | The profile is at |
|---|---|
| `profile_slug` + `profile_live` | `/<profile_slug>/` — the bespoke Highlighted page (Skehana Hill, Tara Hill Honey) |
| `map_link` | that path — the built Founder pages (Newbard, Staffords, Saltrock) |
| neither | `/producer/?id=<id>` — the shared page |

`profileUrl()` implements that rule and exists in both `index.html` and `/producer/index.html`. The shared page redirects to a bespoke one if it is ever reached by a stale link, so a producer can never be shown a lesser page than they have earned.

`/producer/index.html` is set in the **Highlighted pages' language** (charcoal, Playfair, forest green, no italic), not the map's, because it is a profile page. It shows only what the record can honestly carry: a Discovered farm gets what its card has, Verified adds the practice and the attributes they confirmed, and Instagram, website and where-to-buy are gated to Highlighted **in the page code as well as in the data**, so a stray field on a free record can never put a paid benefit on a free page. The single card image is contained rather than cropped, since it is usually a logo, and `photo_bg: "white"` gives it a white ground to sit on.

**The page order, reset 2026-10-27.** Hero photograph, then name, place, produce, practice and attributes, then the farm's description, then Connect, then Available now (date, terms, the grouped list, the produce gallery, Connect and Order), then the rest. The description used to sit under the *Available now* heading, where a description of the farm read as a preamble to the produce list. The produce photographs used to hang off each list row as 96px thumbnails and are now gathered into a gallery under the list. A second group inside the list is indented off a hairline, because on a farm selling a box the cuts are what is *inside* it, not a sibling of it.

**`hero_image` turns on the hero, and nothing else does (decided 2026-10-27).** A path from the site root, with an optional `hero_focus` giving an `object-position` for when the middle is the wrong part of the shot. **`photo_url` is never promoted into the hero**: 45 of the 128 producers have a logo there, and a logo stretched across a banner looks broken. A farm gets a hero when there is a photograph of the farm to put in it, and not before, so a page without one opens exactly as it did. Decided in preference to giving logo-only farms a muted band, because the user would rather collect real photographs than paper over the gap.

### The Provenance Collection

**One-off, limited-run releases made with producers already on the map.** Each one is a product from a producer the user has met and visited, announced and documented as a storytelling piece, and never restocked. Membership is the parchment-cream `"collection": true` mark described above: it sits on top of whatever tier the producer already holds and never replaces one. First member: Galtee Honey Farm, 2026-09-19.

**Members and releases.** Galtee Honey Farm was the first member (2026-09-19). **Moyletra Moileds is the second member and the first release**: beef tallow, October 2026. Galtee's Ling Heather honey follows it. Who else holds the mark is in `producers.json`.

**How the first release works, and why it is not the model yet.** Provenance sells the product and handles fulfilment; the producer makes it. The visit and the Seal story page are free to the producer. This is deliberately a case study rather than a finished commercial arrangement: the first release exists to find out what the work actually takes before any of it is priced. Do not treat the current terms as the permanent model, and do not quote them to another producer as standard.

**Every Collection release carries a Seal story page**, reached from a QR code on the pack at `/seal/<slug>/`.

**`/collection/` is the pre-sale landing page (built 2026-10-25, Collection parchment).** People reach it from the pre-sale email's "Explore the Collection & Order" button. It carries the two first-release products (Moyletra Moileds beef tallow, Galtee Honey Farm Ling Heather honey), a Collection bundle, a short Seal explainer and the dispatch line, and each product has an order button that goes to a Stripe payment link. The links, the optional prices and sizes and the optional priority-access deadline all sit in one `COLLECTION` settings block at the bottom of `collection/index.html`, so adding them is a data edit; a button with no link stays greyed as "Opens soon" rather than going nowhere, and a price or deadline that is empty is not shown. The page carries the site's Google Analytics tag, so `/collection/` is a trackable URL with its own page views, and the order buttons fire `collection_order_click` through `pvTrack` with the product (`tallow`, `honey` or `both`) in a `product` parameter. The email link should carry UTM tags, `?utm_source=email&utm_medium=email&utm_campaign=collection_presale`, which GA reads on its own. The page is `noindex` (kept off Google until the user decides otherwise) and it deliberately does not link to the two Seal story pages. Still to be settled: whether sold-out releases stay listed and how they read once they are gone, where a pre-sale sign-up lives and what it posts to, and whether the page carries the email list.

**The Collection on the map (2026-10-28).** The Collection colour is **parchment cream `#F3EEDD`, not silver**: the pin ring and glow, the card's plain-text "Provenance Collection" mark, the corner button text and outline, and the strip are all that cream, and the strip and the card button carry dark green text `#243629`. Four doorways lead to `/collection/`, all tracked as one analytics event, `collection_click`, with the doorway in a `surface` parameter (`menu`, `fab`, `banner`, `card_button`):

- A **menu link**, "The Provenance Collection", under Provenance Connect.
- A **corner button**, "The Collection", solid parchment cream with dark text, like the strip (it was dark for a day on 2026-10-28 and went back to cream at the user's request). Top left under the menu on phones; top right under Connect from 601px wide, because the legend takes the top left there.
- A **strip**, parchment with dark text, dismissible and remembered per visitor in `localStorage` (`pv_collection_banner_1`). Across the top on phones, across the bottom (38px, larger type) from 601px wide, where the producer counter, refresh button, install prompt and zoom control all move up by its height while it shows. `COLLECTION_BANNER_ON` in `index.html` takes it down for everyone.
- An **Access the Collection** button on the card of a Collection member only: full width, parchment with dark text, placed with Connect above the website, directions and share row (tags, then Connect, then Access the Collection, then the links). Every other card keeps Connect in its usual place. The card's "Provenance Collection" mark itself is plain text and not a link.

**Launch week glow.** Until `COLLECTION_LIVE_UNTIL` (2026-11-04, inclusive, in `index.html`) the Collection pins glow brighter, through `body.collection-live`. After that date they settle back to the ordinary cream ring.

**The Connect button is deep forest green with white text (2026-10-28)**: `#2F5C3A`, hover `#35663F`, on every card that has Connect and on the corner Connect button. It was a pale mint with dark green type before; the mint remains only on small marks (the Connect pin ripple, the legend count and the Install button).


**Provenance works with producers and does not make its own products (decided 2026-10-12).** A Collection release is a collaboration with a named producer, carrying their product and their name, not a Provenance-manufactured line. **Athnuachan, the user's own grass-fed tallow brand, is shelved** and is not in the pipeline; it does not appear on Collection releases and a Collection product is not routed through it. Do not propose an own-brand product, a Provenance-made line or an Athnuachan collaboration unless the user reopens it himself.

### Consumer Model (B2C, Freemium)

- Free forever: basic map discovery
- Premium (€3–€5/month): saved producers, new release notifications, full chatbot access, in-app ordering

### In-App Ordering (Phase 4)

- Stripe Connect for producer payouts
- Provenance takes 5% per transaction

## Design System

**Five languages, and they do not mix.** Pick by surface, never by taste.

### 1. The map (Cormorant)

The map, its cards and the About page. Painterly and illustrated, inspired by Ghost of Tsushima: Ireland from above, surrounded by ocean and cloud, deep greens, teal water, atmospheric. Producer pins glow softly on hover. It should feel like a world worth exploring, not a utility tool.

| Token | Hex |
|-------|-----|
| Background | `#060807` |
| Card surface | `#0E100D` |
| Green accent | `#4A8A55` |
| Gold accent | `#C4A44A` |
| Teal accent | `#4A8A8A` |
| Cream text | `#E8DEC8` |
| Muted text | `#504838` |

Headings Cormorant Garamond, body Source Serif 4. **Playfair Display was swapped in across the map on 2026-10-23 and reverted the same day at Darragh's request.** The map stays on Cormorant. Playfair belongs to the profile pages, the Seal story pages and the Collection, and what keeps the map apart from them is its heading face as much as its colours. Do not move the map to Playfair again without the user asking.

### 2. Profile pages (charcoal, Playfair, forest green)

Decided 2026-09-15. Highlighted profile pages and `/producer/` are set like the carousel plates, not like the map: charcoal ground `#1A1B18`, silver hairlines `rgba(201,198,189,0.14)`, Playfair Display for names, headings and pull quotes in deep forest green (`#2F5C3A` name, `#35663F` headings), upright throughout with no italic anywhere; Inter medium small caps in `#45704E`; Source Serif 4 body in cream `#E8DEC8`; the place line and buttons in a lighter green `#5A8C64` so they read apart. The map and its cards keep Cormorant.

### 3. Collection charcoal (storytelling, and the Seal story page)

Chapter carousels, any Collection storytelling piece, and **the Seal story page**, which uses this language rather than the profile one.

- Background `radial-gradient(ellipse 85% 75% at 50% 45%, #222320 0%, #1C1D1A 65%, #151614 100%)`
- Cream `#E8DEC8`, body `#CFC7B3`, muted `#9A968B`, source lines `#7A766A`
- Green kicker `#45704E`, deep green `#2F5C3A`
- Two hairline insets on a plate: 36px at `rgba(201,198,189,0.30)` and 46px at `rgba(201,198,189,0.12)`; content box inset 100px left and right, 96px top and bottom
- Playfair Display 400 for headings, line height 1.05, cream `#E8DEC8`
- Inter 500 for kickers: 21px, 0.26em tracking, uppercase, `#45704E`
- Source Serif 4 300 for body: 27px, line height 1.5, `#CFC7B3`
- Figure captions Playfair 22px `#9A968B`; source lines 19px `#7A766A`
- Line art in `#C9C6BD`, stroke width 1.1, round caps and joins
- Plate footer: "Provenance" on the left, a roman numeral `X / Y` on the right

### 4. Collection parchment (announcements)

Announcements, explainers, opening pieces and collab posts only. Background `#F3EEDD`, primary `#243629`, muted `#6C6858`. Playfair Display and Inter. No gold. **Never used for storytelling**, which is always charcoal.

### 5. Building Provenance (the personal channel)

Darragh's own page. Set 2026-10-27, replacing the 2026-10-22 version of this section (cream only, Cormorant and Source Serif, no green), which the user moved away from over the October posts. Deliberately **not** the Collection's parchment: a personal post is not a Collection announcement and should not borrow its look.

- **Plate:** 1080 by 1350, flat charcoal `#1A1B18`, no gradient (that is what separates it from Collection charcoal). Content inset 110px left and right. Hairlines in `rgba(232,222,200,0.14)` across the top at 96px and across the bottom at 198px from the foot.
- **Header row:** "BUILDING PROVENANCE" on the left at 140px from the top, the page count `n / N` on the right. Inter 500, 22px, uppercase, 0.24em tracking (0.1em on the count), dark forest green `#35663F`. **These two are the only things in Inter.**
- **Everything else is Playfair Display 400.** Headings cream `#E8DEC8`, line height 1.06, usually 90 to 130px. Supporting lines also Playfair, about 44px, line height 1.4, in a slightly darker cream `#CFC6B2`. Do not bring Source Serif or a third face back in: the user asked for this down to two fonts on 2026-10-26.
- **Layout:** left aligned, the text block centred vertically between the hairlines. One idea per plate, one heading and at most two short supporting lines. No images unless the user supplies one.
- **Accents, used sparingly:** a single key word may take the brand green `#4A8A55` (the map's green accent), e.g. "connect" in "How do your customers connect with you?". A quoted phrase may go in Playfair italic, with its opening quote mark hung outside the margin so the letters line up with the lines above. Neither is a default; one accent per plate at most.
- **Copy:** short, plain, said the way a person would say it. No slogans, nothing that reads like an ad. Break lines by hand so no line ends on a single word.

**Voice is the personal channel**, so first person singular, and never the Provenance "we".

**When a post shows something from the map, lift the real artwork.** The attribute icons post took its icons straight from `PV_ATTR_ICONS` in `connect.js` rather than redrawing them, so the post cannot drift from what the map actually renders.

### Heritage style

Playfair headlines, Inter body, deep green and cream on dark brown, concentric rings, gold era tags, template in `heritage-style-template.html`. Not retired, but on the back burner. Keep it in the repo and do not offer it unless the user asks.

### Carousel exports

**1080 by 1350 (4:5)**, the largest size Instagram renders in feed, unless the user says otherwise for a given piece. Canvas based, with a button per plate and a download all as a zip. Every factual plate carries a source line in its footer. (The Irish Moiled and Tallow chapters of October 2026 were built square at 1080 by 1080; the spec above applies from here.)

## Voice and Content Rules

**Three channels, never mixed.** One test for any piece: who is speaking.

| Channel | Who is speaking |
|---|---|
| Provenance | The system. Facts, label research, map growth, producer spotlights, Collection storytelling |
| Personal | Darragh. Health, building in public, farm vlogs, reasoning and decisions |
| Athnuachan | The brand. **Shelved (2026-10-12), not deleted.** Nothing is published on it until the user reopens it |

**The Provenance voice is the system speaking, and it may say "we".** First person plural is the system's own voice and is allowed. First person singular is not: "I" belongs to the personal channel, and the founder is never the narrator of a Provenance piece.

**No em dashes. Ever.** Not in carousels, captions, DMs, bios, emails, or on any page.

**Sourcing.** Every factual claim carries a named source on the piece itself. Anything a producer says about their own operation that cannot be checked independently is labelled as a producer statement. A claim that cannot be sourced or checked does not get published: a weaker true sentence always beats a stronger unverifiable one. **Never invent, guess or misattribute a source.** Provenance exists to expose unverified claims, so a fabricated citation is a self-inflicted wound.

## Producers

`producers.json` is the source of truth for who is listed on the map. The Obsidian vault (`Provenance Map listings/<County>/<Producer>.md`) is the source of truth for producer detail. Never rely on a producer list written into this file.

**A producer is listed only for what they produce themselves.** The pin covers the food they grow, raise or make on their own ground, never what they buy in, butcher or resell. If a farm sells four meats but rears two, the listing carries the two. This applies to the description as well: a clause advertising something they source elsewhere gets cut, even from a verified producer's own words, because the alternative is the map making a claim it cannot stand over. A farmer who butchers their own animals is still a producer (Staffords Butchers rear their own Angus and are listed for beef); a butcher who buys in is not.

## Data Models

### Producer Profile — what shows at each tier

**Every tier (including Discovered and Verified)** shows:
- Producer name
- County / Town
- Product type
- Verification tier badge (and, for Verified, the confirmed practice pill — **organic** in dark green with a leaf icon, **regenerative** in gold with a sprout icon, and/or **Korean Natural Farming** in teal `#4A8A8A` with a fermenting crock icon; a producer can hold more than one, shown side by side. Only these three render; any other practice value shows no pill)
- Short description
- A single image (`photo_url`): ideally the producer's **logo**, but one representative photo is fine too — never a multi-image gallery

**Verified only** additionally shows:
- The confirmed practice pill (organic, regenerative and/or Korean Natural Farming)
- **Attribute pills** (`attributes` array: Grass Fed, Free range, Pasture raised, Chemical Free, Native / rare breed, Heritage breed, Pedigree breed, Native Irish Honey Bee, Heritage variety, Raw / unpasteurised, Non-Homogenised, Plastic Free)

> **Practice and attributes are producer-confirmed only.** Both come from the producer ticking boxes on the verify form, never from research, a website, or a farm's own marketing. A Discovered producer always has `"practice": "unspecified"` and `"attributes": []`. A pill reads as a claim Provenance stands over, and only the producer can earn that. Researched facts go in the description, which is understood to be secondhand. This is why a filter chip can sit empty and hidden while relevant farms are already listed — that is the correct state, not a bug.

**Provenance Highlighted and above** additionally show:
- Farm photo gallery (`photos` array — real farm/produce images, lightbox viewer)
- Instagram link
- Website link
- Where-to-buy
- Filmed farm-visit video

The rule: **one image on every card (logo preferred, a single photo is fine); the multi-image gallery, Instagram, website, and where-to-buy begin at Highlighted.**

### Provenance Seal Story Page

**The Seal is the story behind the product, not a verification certificate (decided 2026-10-19).** A buyer scans the code on the pack and reaches a page that tells them where the thing in their hand came from and who made it. That is the whole product.

**The word Seal is public; the Seal is not yet sold or pitched (corrected 2026-10-19).** Seal story pages are live to buyers of Collection releases and the word Seal may be used on them. What is not happening is selling or pitching the Seal to producers: Seal, Seal Lite and Seal Complete stay out of producer-facing decks and material until the Collection case study is finished. Price and what a fee would cover are unspecified.

**What the Seal page is not.** It carries no batch numbers, render or production dates, best before dates, net weights, jar or unit counts, laboratory or Eurofins results, lab report downloads, and no blockchain or IPFS anchor. The word *verified* does not appear on it. That was the earlier definition of the Seal and it is retired: do not reintroduce any of it, and do not add placeholder fields for it.

What a Seal page carries:

- Named farm and the people on it
- Breed or variety
- The ground the product came off, and how it is grazed or grown
- How the product was made, in plain language, without dates or process data
- The history behind the food itself, sourced
- Practical use and storage
- A sources block naming every source used
- Link to the producer's profile on the Provenance Map
- Sourcing or production footage (TikTok or YouTube embed) where it exists
- QR code image

**One page per product.** A producer with several Seal products gets a standalone page for each, never one page carrying them all.

**Provenance writes the page.** The producer supplies facts and statements; the research, writing and sourcing are ours.

**Producer statements are labelled as producer statements.** Anything the farm says about itself that cannot be checked independently (herd size, finishing, practice) is attributed to the farm on the page. Anything historical carries its source. Nothing else goes on.

**Planned but not built:** the AI chatbot embed on the page, and store API integration. Both are part of the Seal as intended; neither exists yet, so neither goes in a pitch as though it does.

**Where it lives.** `/seal/<slug>/`, for example `/seal/moyletra-tallow`. Pages are generated from `releases/<slug>.json` so a new release is a data edit, not a code edit, and the built page works with no JavaScript. The QR on the pack points at that address, and because it is printed it cannot be changed afterwards.

**Design language:** Collection charcoal, not the profile page language. See the Design System below.

## Tools

| File | Purpose | Notes |
|------|---------|-------|
| `qr-generator.html` | QR code generator | Standalone HTML. Input: URL. Output: downloadable PNG at 1000×1000px minimum. Uses CDN-hosted QR library. Background matches design system. A Seal sticker always encodes `/seal/<slug>/`. |
| `seal-qr.html` | Seal sticker QR generator | Input: a release slug. Output: PNG (2000×2000) and SVG of a sticker that encodes `https://provenancemap.ie/seal/<slug>/`. Cream parchment sticker with a charcoal QR, border and caption, transparent outside the ring; an empty slug makes a code for the home page. |
| `generate-seal-pages.ps1` | Seal page generator | Builds `/seal/<slug>/index.html` from every `releases/<slug>.json`, plus `/seal/index.html` and `/404.html` (code not recognised). **Run after any edit to a release file, then commit the output.** See `releases/README.md`. |
| `provenance-seal.html` | Old Seal marketing page | **Out of date and public.** Still sells Eurofins results, a blockchain anchor and Athnuachan, all of which are retired. Rewrite it against the Seal story page section above, and keep it offline-in-spirit until the Seal is publicly offered again. |
| `generate-share-pages.ps1` | Share stub generator | Creates `/share/<slug>.html` for every Verified+ producer in producers.json: OG tags for rich link previews, then redirects to `/?producer=<slug>` which opens their card on the map. **Run whenever a producer upgrades to Verified**, then commit the new stub. The card Share button (Verified only) shares this stub URL. |

## Social Channels

TikTok and Instagram — both accounts: **Provenance**

## Rollout

Starting in Wexford, expanding county by county across all 32 counties of Ireland.

## Project files

| File | What it is |
|------|------------|
| `CLAUDE.md` | This file. The master strategic reference: what everything is and why. If a decision changes, it is updated in the same session. |
| `PROVENANCE-EXECUTION-GUIDE.md` | The phased task list: what order to do things in. **Does not currently exist in the repo and is to be rebuilt.** |
| `PHILOSOPHY.md` | Founding purpose, positioning, the never-be-sold commitment. |

If `CLAUDE.md` and the execution guide ever disagree, `CLAUDE.md` wins.

**Phases have triggers, not dates.** The API waits for real subscriber volume. The consumer app waits for real Seal density. Automation waits for ten manual subscribers. Do not start a later phase because it sounds exciting: ask what the trigger is.

## Philosophy and Positioning

The founding purpose, the problem Provenance solves, the commercial commitment to producers, the content arc, and the never-be-sold commitment live in `PHILOSOPHY.md`. Read that file when the work is about content, marketing, positioning, producer-facing copy, or a decision that turns on what Provenance is for. Routine build work (producers.json, pins, tiers, deploys) does not need it.
