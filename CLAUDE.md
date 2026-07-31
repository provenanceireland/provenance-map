# Provenance Map

Ireland's number one platform for finding real food producers. Not certification logos — direct access to verified farmers and producers. Built in Wexford, expanding county by county across all 32 counties.

## Platform Type

Progressive web app (PWA), hosted on GitHub Pages, built using Claude Code. Native iOS and Android apps planned post-PWA.

## Business Model

### Producer Tiers (B2B)

| Tier | Price | Includes |
|------|-------|----------|
| **Discovered** | €0 | Free basic map pin. The default listing for any producer. |
| **Verified** | €0 | Free. The producer confirms their own details and farming practice via the "verify your profile" Fillout form. Green pin and a confirmed practice pill — **organic** (dark green `#4A8A55`, leaf icon) and/or **regenerative** (gold `#C4A44A`, sprout icon); a producer can hold both, shown side by side. Any other value shows no pill. A single card image (a logo or one representative photo) — but **no multi-image gallery, Instagram, website, or where-to-buy**; those begin at Featured. |
| **Provenance Featured** | €49/month | Visit-gated, farm-level. Never sold without a prior personal visit. Includes the filmed farm visit (vlogged), a gold pulsing pin with priority placement, photo gallery, Instagram + website links, where-to-buy, a chatbot trained on the farm's practice, a monthly collaborative reel/carousel posted across Provenance, and a silver-bordered QR sticker. No producer sits here yet. |
| **Provenance Seal Complete** | €149/month | Product-level — requires a qualifying packaged product (jarred / bottled / bagged / boxed, with a batch number and date). Full batch documentation, Eurofins facilitation, blockchain anchor, API store integration, and a gold-bordered QR sticker. Gold pulsing pin with a gold ring. |

**Featured and the Seal are two separate layers, not a ladder.** Featured is about the *farm* (who the producer is, how they farm); the Seal is about a specific *packaged product*. Most Featured farms will never need a Seal, and a Seal can be sold directly to any producer with a qualifying product without a Featured relationship. Neither paid step is self-service — both are reached through a real conversation (the visit relationship or direct commercial outreach), never a public payment link.

### Pin Colours

- **Discovered Producers (tier: "discovered" / default):** Dark green — `#2A5A38`, 6.9px dot (6.8px on mobile), cream border (`1px solid rgba(232,222,200,0.75)`), faint green glow (`box-shadow: 0 0 4px 1px rgba(42,90,56,0.40)`). The default pin. No profile page, no badge. Card shows "Discovered Producer" pill in matching dark green (border `#2A5A38`, text `#4E8560`). Set `"tier": "discovered"` in producers.json (or omit tier field).
- **Verified Producers (tier: "verified"):** Green `#59A666`, 10.35px dot (10.2px on mobile) — 50% larger than Discovered, thin white border (`1px solid rgba(248,248,243,0.6)`), **static** green glow (`box-shadow: 0 0 6px 2px rgba(89,166,102,0.73)`) — no pulse; the pulsing pin is a paid (Featured/Seal) signal. The glow is deliberately tight: a wide glow paints many times the dot's own diameter and the pins merge into a wash as the map fills up. Card pill "Provenance Verified" in matching `#4A8A55`. Set `"tier": "verified"` in producers.json.
- **Provenance Featured (paid, gold):** Gold — `#C4A44A`, pulsing pin with priority placement. The visit-gated €49/month farm tier. Unlocks the photo gallery, Instagram + website links, where-to-buy, and the filmed-visit video on the card. Currently: none.
- **Provenance Seal Complete:** Gold — `#C4A44A`, pulsing + gold ring border. The €149/month product-level tier.
- **Provenance Founder:** An additional pill (`data-badge2="Provenance Founder"`) on the card; the "See full profile" button reads "Provenance Founder". No special pin treatment — pin appearance is controlled by tier. The Founder pill is suppressed when it sits beside a tier pill. Currently: Newbard Organic Farm Ltd, Staffords Butchers, and Saltrock Dairy Farm (all Verified).

> **Implementation note:** the code today ships tiers `discovered`, `verified`, `seal-lite`, `seal-complete`. The gold **Featured** tier above is the target model, to be wired into the code when the first Featured producer signs. Saltrock renders on `verified` (green) with its logo as the single card image; its former gallery/IG/website/where-to-buy were removed from its record when it moved to Verified. `photo_url` is the single card image (a logo is preferred, but one representative photo is acceptable on any tier); only the multi-image `photos` gallery is Featured-only. Pin size is not affected by farming practice — organic/regenerative shows via the card practice pill only, never by enlarging the pin.
- **Farmers Market:** Terracotta — `#B0623A`, 7px dot (5px on mobile), no border, terracotta glow. Completely different card layout showing hours and a producer list. Currently: Gorey Farmers Market (Saturday 10am–2pm). Add `class="pin market"` and `data-category="market"` to the pin.

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

## Producers

`producers.json` is the source of truth for who is listed on the map. The Obsidian vault (`Provenance Map listings/<County>/<Producer>.md`) is the source of truth for producer detail. Never rely on a producer list written into this file.

## Data Models

### Producer Profile — what shows at each tier

**Every tier (including Discovered and Verified)** shows:
- Producer name
- County / Town
- Product type
- Verification tier badge (and, for Verified, the confirmed practice pill — **organic** in dark green with a leaf icon, and/or **regenerative** in gold with a sprout icon; a producer can hold both, shown side by side. Only these two render; any other practice value shows no pill)
- Short description
- A single image (`photo_url`): ideally the producer's **logo**, but one representative photo is fine too — never a multi-image gallery

**Provenance Featured (€49/mo) and above** additionally show:
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
| `generate-share-pages.ps1` | Share stub generator | Creates `/share/<slug>.html` for every Verified+ producer in producers.json: OG tags for rich link previews, then redirects to `/?producer=<slug>` which opens their card on the map. **Run whenever a producer upgrades to Verified**, then commit the new stub. The card Share button (Verified only) shares this stub URL. |

## Social Channels

TikTok and Instagram — both accounts: **Provenance**

## Rollout

Starting in Wexford, expanding county by county across all 32 counties of Ireland.

## Philosophy and Positioning

The founding purpose, the problem Provenance solves, the commercial commitment to producers, the content arc, and the never-be-sold commitment live in `PHILOSOPHY.md`. Read that file when the work is about content, marketing, positioning, producer-facing copy, or a decision that turns on what Provenance is for. Routine build work (producers.json, pins, tiers, deploys) does not need it.
