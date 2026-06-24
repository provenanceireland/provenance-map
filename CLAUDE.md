# Provenance Map

Ireland's number one platform for finding real food producers. Not certification logos — direct access to verified farmers and producers. Built in Wexford, expanding county by county across all 32 counties.

## Platform Type

Progressive web app (PWA), hosted on GitHub Pages, built using Claude Code. Native iOS and Android apps planned post-PWA.

## Business Model

### Producer Tiers (B2B)

| Tier | Name | Price | Includes |
|------|------|-------|----------|
| 0 | Free Listing | €0 | Basic map pin |
| 0.5 | Provenance Approved | €0 | Free listing with darker green pin — manually awarded by Provenance |
| 1 | Map Pin | €33/month | Basic verified listing |
| 2 | Map Verified | €99/month | Map Pin + POV farm visit filmed and posted to Provenance social channels |
| 3 | Provenance Seal | €200/month | Full documentation, QR code on physical product, Eurofins purity testing results published, AI chatbot for customer Q&A and sales |

### Pin Colours

- **Free (Tier 0):** Deep muted green — `#3D7A4A`, 7px dot (6px on mobile), white border, soft green glow. The default pin. No profile page, no badge. 37 producers currently on this tier.
- **Provenance Approved:** Green — `#4A8A55`, soft green glow (the original free pin colour). 7px dot on mobile.
- **Provenance Founder:** Same green `#4A8A55` with gold border, 8.4px dot (20% larger). Awarded to founding producers. Currently: Newbard Organic Farm Ltd, Staffords Butchers. Staffords also has a profile page and video link. Add `class="pin approved gold-border"` and `data-badge2="Provenance Founder"` to the pin.
- **Provenance Visited:** Gold — `#C4AA28`, 8.5px dot, gold glow, thin white border. Add `class="pin approved gold"` and `data-badge="Provenance Visited"` to the pin.
- **Paid (Tier 1+):** Gold-orange — `#C48E28`, 9px dot, gold-orange glow (`rgba(196,142,40,...)`) — this exact colour applies to all paid tiers (1, 2 and 3)
- **Farmers Market:** Terracotta — `#B0623A`, 7px dot (5px on mobile), 0.7px cream border `#E8DEC8`, terracotta glow. Completely different card layout showing hours and a producer list. Currently: Gorey Farmers Market (Saturday 10am–2pm). Add `class="pin market"` and `data-category="market"` to the pin.

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

### Launch Producers (Wexford)

| Producer | Town | Product | Status |
|----------|------|---------|--------|
| Gorse Farm | Bunclody | Salad & vegetables | Confirmed |
| TBC | Wexford | Milk | Name to be confirmed |
| TBC | Wexford | Honey | Name to be confirmed |

## Data Models

### Producer Database Record

| Field | Notes |
|-------|-------|
| Producer name | |
| Product type | |
| County | |
| Town | |
| Instagram handle | |
| Website | |
| Date listed | |
| Date notification sent | |
| Notification response | |
| Date visited | |
| Subscription tier | 1 / 2 / 3 |
| Subscription start date | |
| Monthly report sent date | |
| Notes | |

### Producer Profile (public-facing, all tiers)

- Producer name
- County
- Town
- Product type
- Verification tier badge
- Short description (visible on all tiers including free)
- Photo
- Instagram link (paid tiers only)
- Website link (paid tiers only)

### Provenance Seal Batch Documentation Page (Tier 3)

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

## Social Channels

TikTok and Instagram — both accounts: **Provenance**

## Rollout

Starting in Wexford, expanding county by county across all 32 counties of Ireland.

## The Core Philosophy — Cutting Out the Middleman

Provenance exists to cut out the supermarket as the middleman
and connect real people directly with the farmers and producers
of Ireland.

This is not a tagline. It is the founding purpose of the
platform and every decision — what to build, what to charge,
who to list, how to represent producers — is tested against it.

### The Problem Provenance Solves

When a consumer buys food from a supermarket the farmer
receives a fraction of what the consumer pays. The supermarket
controls the price, the shelf space, the story and the margin.
The farmer has no direct relationship with the person eating
their food. The consumer has no way to verify anything about
where their food came from beyond what is printed on a label
the brand controls.

The label replaced the personal knowledge that once existed
in small communities where people knew their farmer, had been
to the farm and knew the land. The organic certification
replaced it with a third party audit that costs the farmer
money and tells the consumer almost nothing about the actual
farm or the actual person.

Both replacements solved a logistics problem and created a
trust deficit.

### What Provenance Does Instead

Provenance makes the personal knowledge of the small community
available at the scale of the modern food system.

The map pin is the farm gate.
The producer profile is the conversation at the farm gate.
The POV visit is the farm visit.
The blockchain record is the handshake that once happened
in person.
The QR code is the proof that travels with the product
wherever it is sold.

The trust is real again because the proof is real.

### The Commercial Commitment to Producers

Every producer on Provenance earns more per unit than they
would through a supermarket because there is no supermarket
margin removed from the chain.

When Provenance stocks a producer's product in the store
the producer earns a fair wholesale price. When the
marketplace launches producers sell directly to consumers
through the platform. Provenance takes a small platform fee
to fund the infrastructure. The supermarket takes nothing
because the supermarket is not involved.

### The Content Philosophy

The content never attacks supermarkets directly. It asks
questions supermarkets cannot answer. An attack invites a
defence. A question that goes unanswered is its own
indictment.

Every piece of content follows the same emotional arc.

Curiosity — you are going looking for something.
Recognition — the viewer sees their own behaviour reflected.
Quiet outrage — the unanswered question hanging in the air.
Relief — the producer. Real. Named. Findable.

The producer is never the conclusion of an argument.
They are the answer to a question the viewer has just
realised they should have been asking their whole life.

### The Founding Statement

Provenance is the infrastructure that cuts out the middleman
between Irish farmers and the people who eat their food.

No middleman. No supermarket margin. No anonymous supply chain.
Just the person who grew it and the person who eats it.

### What Provenance Will Never Be

Provenance will never be sold to a corporation, a logistics
company, a supermarket group or any entity whose interests
conflict with real food producers and the communities they
feed. This commitment is permanent and it is itself a
commercial asset — producers trust the platform more because
of it.
