# Provenance Map

Ireland's number one platform for finding real food producers. Not certification logos — direct access to verified farmers and producers. Built in Wexford, expanding county by county across all 32 counties.

## Platform Type

Progressive web app (PWA), hosted on GitHub Pages, built using Claude Code. Native iOS and Android apps planned post-PWA.

### The install invitation (2026-10-29)

**This is an in-page bar, not a push notification.** `#install-bar` in `index.html`, a slim bar at the foot of the map. **Web push is still rejected** for the same reason it was rejected for Follow: it needs a server holding a VAPID key and somewhere to keep each device's subscription, which breaks the rule that Provenance runs no backend and no page holds a credential. **Do not build web push to prompt an install, and do not call this a notification.** Nothing can reach a visitor who has closed the tab.

Two jobs behind the one bar. Chrome, on Android and desktop, fires `beforeinstallprompt`, so the button opens the browser's real install dialogue. **Every other browser on a phone fires nothing**, so the bar becomes a signpost to that browser's own menu item: Safari because Apple will not add the event, Firefox and Samsung Internet because they have the menu item but not the event. It was shown on iPhones only until 2026-10-29, which meant a visitor on Samsung Internet was never invited to install the map at all. **The signpost does not name the menu**, because the name differs between those three browsers and a confidently wrong instruction is worse than a vague right one. A late `beforeinstallprompt` swaps the signpost back to a real Install button.

**Closing it is a 45 day snooze, never permanent.** `pv-install-snooze` in `localStorage` holds a date. The first version wrote a permanent flag (`pv-install-dismissed`, now dead and read by nothing), so one press of "not now" turned the invitation off on that phone for good. An actual install snoozes it for ten years.

It is hidden while a producer card is open (`body.pv-card-open`), because the bar is above the card and covered its footer, and it lifts the producer counter while it shows (`body.pv-install-bar`), because they sit at the same height on the same edge. Events: `install_prompt_click` (with `platform`: `ios`, `prompt` or `signpost`), `install_choice`, `install_dismissed`, `install_done`.

## Business Model

### Producer Tiers (B2B)

| Tier | Price | Includes |
|------|-------|----------|
| **Discovered** | €0 | Free basic map pin. The default listing for any producer. |
| **Verified** | €0 | Free. The producer confirms their own details and farming practice via the "verify your profile" Fillout form. Green pin and a confirmed practice pill — **organic** (dark green `#4A8A55`, leaf icon), **regenerative** (gold `#C4A44A`, sprout icon) and/or **Korean Natural Farming** (teal `#4A8A8A`, fermenting crock icon, added 2026-10-20); a producer can hold more than one, shown side by side. The KNF slug is hyphenated, `korean-natural-farming`, because the card builds a CSS class from it and the label comes from a lookup rather than from capitalising the slug. Any other value shows no pill. A single card image (a logo or one representative photo) — but **no multi-image gallery, Instagram, website, or where-to-buy**; those begin at Highlighted. |
| **Provenance Highlighted** | One-off fee (amount TBD) | Visit-gated, farm-level. Never sold without a prior personal visit. **A one-off fee, never a monthly charge (confirmed 2026-10-08).** The fee covers the visit, the filmed vlog, the photography and building their profile page. Updates happen opportunistically when the founder is at the farm anyway. The monthly retainer belongs to the Seal, not to this tier. Includes the filmed farm visit (vlogged), a gold pulsing pin with priority placement, photo gallery, Instagram + website links, where-to-buy, a chatbot trained on the farm's practice, a monthly collaborative reel/carousel posted across Provenance, and a silver-bordered QR sticker. The producers currently on this tier are in `producers.json`, not in this file. |
| **Provenance Seal** | Price unspecified | Product-level, and **not yet sold or pitched to producers (2026-10-19)**. A QR code on the pack opens that product's story page: the farm, the people, the breed or variety, the ground, and the history behind what the buyer is holding. Price, what a fee would cover and the sticker treatment are all unspecified until the Collection case study is finished. **The word Seal is public (2026-10-19), but do not sell or pitch the Seal, Seal Lite or Seal Complete to producers, or show them in producer-facing decks,** until that is settled. The code slugs stay as they are. |

**The tier names, as they stand (restored 2026-10-01).** Three free-to-paid steps a visitor can see: **Discovered** (`"tier": "discovered"`, researched, not confirmed), **Verified** (`"tier": "verified"`, the producer submitted their own details on the verify form) and **Highlighted** (`"tier": "featured"`, the gold, visit-gated, paid tier with its own profile page). The **Provenance Collection** is a parchment-cream mark on top of a tier, not a tier. History, so nobody repeats it: on 2026-09-24 the free confirmed tier was renamed Verified → Highlighted, and two hours later the gold tier took the name Highlighted and the confirmed tier was relabelled **Discovered** ("Confirmed" in the legend). That left the map with no visible difference between a researched listing and one the producer had confirmed. On 2026-10-01 the user had the confirmed tier restored to **Verified** everywhere a visitor sees it: the card mark ("Provenance Verified"), the legend ("Verified producer"), the tier filter ("Verified"), the shared profile, the Connect listing, the Highlighted pages' Nearby cards, the Founder pages ("Verified by Provenance", "is verified on the Provenance Map"), the app manifest and the share-stub fallback. **Do not rename a tier again without the user asking.** **2026-10-08: at the user's request, every remaining use of "Featured" for the gold tier in this file was changed to Highlighted.** The tier is called Highlighted everywhere, in copy and in this file. Only the code slugs still say `featured`, and they stay that way. The slugs never changed: `verified`, `.tier-mark-verified`, `.pin.t-verified` and `p-ver` are the Verified tier; `featured`, `.tier-mark-featured` and `p-feat` are Highlighted. The Fillout form at `provenancemap.fillout.com/provenancemapverified` is **no longer linked from anywhere on the site** (2026-11-05): the menu and the foot of `/connect/` both point at the Zite producer app instead. The Fillout form itself is untouched and still works if a link to it is ever needed. **A producer becomes Verified only by submitting the form themselves**; an upgrade command does not make them Verified on its own.


**Highlighted has to be worth more than what Founders were given.** Founders got a full profile page for nothing, at a point when the map needed them more than they needed it. Highlighted is a paid tier, so it has to carry things a Founder page never did: the filmed visit, the trained chatbot, and ongoing upkeep rather than a page that is built once and left. If a Highlighted producer cannot see what the one-off fee bought them, the tier is priced wrong.

**Highlighted and the Seal are two separate layers, not a ladder.** Highlighted is about the *farm* (who the producer is, how they farm); the Seal is the story of a specific *packaged product*, reached by scanning the pack. Most Highlighted farms will never need a Seal, and a Seal can go to any producer with a qualifying product without a Highlighted relationship. **A Seal does involve a visit, but not the Highlighted visit**: a short introduction and a mapping of the product and the ground behind it, not a filmed day on the farm. Neither paid step is self-service: both are reached through a real conversation, never a public payment link.

### Pin fills: contact, then practice (set 2026-11-26, night; supersedes the two sections below)

**This is the settled scheme, chosen by the user after a day of trying others.** The fill first says whether the producer has spoken to us, then, if they have, what they farm:

| Pin | Fill | Size | Ring and glow | Count at launch |
|---|---|---|---|---|
| Not yet in touch (`tier: discovered`) | dark green `#285C36` (sage, then grey, the same night: the user wanted a darker green that does not blend into the map, and the white ring keeps it off the land) | 5.85px, 5.20px mobile | white ring `1px solid rgba(248,248,243,0.6)`, no glow (ring added 2026-11-26 at the user's request) | 70 |
| Farm confirmed (was "Details submitted" until 2026-11-26), no organic or regenerative practice | sage `#BAD6AE` (was `#B4CBAA`, then `#A9CB9A`; made slightly lighter on 2026-11-27 at the user's request) | 8.78px, 7.80px mobile | soft white | 28 |
| Organic | bright green `#76E463` (was `#6BCB5E`; brightened 2026-11-27) | full | soft white | 10 |
| Regenerative | green `#45A355` (was `#3F8A4C`; slightly brightened 2026-11-27) | full | soft white | 33 |
| Organic and regenerative | 50/50 vertical split, organic left | full | soft white | 12 |
| Korean Natural Farming | teal `#4DB5AD` (the card's KNF teal `#4A8A8A`, brightened to sit with the lifted greens; the user's pick of the two, 2026-11-27) | full | soft white | 1 |

**The soft white ring and glow is the old Verified pin's**, `1px solid rgba(248,248,243,0.6)` with `0 0 6px 2px rgba(248,248,243,0.32)`, and it now means "this producer told us themselves", on every submitted pin whatever its practice. Conventional (19) and submitted-but-undeclared (8) sit on the full-size sage. **KNF got its own pin back on 2026-11-27**, at the user's request: `.pin.fm-knf`, which `farmingMethod()` already returned, now paints the teal, with a matching menu dot (`.m-dot-fm-knf`) and its own key row that filters like the other practice rows (`data-legend-method="knf"`). It is one producer, New Leaf Urban Farmers. `Map Screenshot/knf-pin-options.png` is the comparison it was picked from.

**Not-yet-in-touch farms are hidden when the map loads (set 2026-11-26).** The user asked whether to remove Discovered producers and chose this instead: the map opens on the 83 producers who have told us themselves, and the **"Discovered" legend row is the switch** that shows the other 70. It used to carry a line underneath ("70 hidden. Tap to show", then "Tap to hide"), which came off on 2026-11-27 when the key went to names only; the row still toggles, and `syncUnexploredUI()` skips the line when it is absent. `HIDE_UNEXPLORED_ON_LOAD` in `index.html`, beside `COLLECTION_LINKS_ON`, sets it; **false shows them on load again**, one flag. **Nothing is removed**: they stay in `producers.json`, the menu and their profile pages, and their cards still open. They stay on the map for the reasons the user was given: they are 70 of 153 pins, the pipeline of farms to turn green, and the source of the Discovered carousels.

How it behaves, all verified: `display: none` rather than opacity, so a hidden pin has no size and the tap and cluster-zoom hit-tests skip it with no extra code. **A filter that matches a hidden farm reveals it** (the `revealed` class), so searching for one by name never comes back invisible, and clearing the filter hides it again. **Clear all does not touch the switch**: it is a display setting, not a filter. Near Me counts and lists only pins on screen (`pinShown()`), and a hidden farm never takes one of the six new-pin glow slots. Not remembered between visits: every load starts hidden.

**What the not-in-touch producers are called: Discovered (settled 2026-11-26).** The original tier name, `tier: discovered`, is the name a visitor sees again. "Not established" and "Not yet in touch" were both tried the same day and dropped.

**"Farm confirmed" replaced "Details submitted" (2026-11-26).** The user found "Details submitted" read as form language, and as a miscellaneous leftover for producers he rates highly. The sage bucket is 28 producers in two groups: 10 for whom a farming practice does not apply (6 honey, 3 sea salt, 1 oysters) and 18 land farms with no organic or regenerative claim. Four of the ten ticked "conventional" only because the form offers no answer that fits a beekeeper or a salt harvester, and 5 of the 6 honey producers carry Native Irish bee. **Giving honey and sea their own fills (amber, sea blue) was proposed and declined for now**; only the label changed. **Still open: the Zite form needs a "we don't farm land" answer** so beekeepers stop being pushed into "conventional".

**Visited is not on the pin (off again 2026-11-27, at the user's request).** It went off on 2026-11-26, came back on 2026-11-27 as a gold ring, gold glow and still halo (first `#CDA043` with an orange halo, then the brand gold `#C4A44A`; `Map Screenshot/visited-brand-gold.png`), picked up a "Visited by Provenance" key row (a hollow gold ring), and the same evening the user had both taken off: the visited farms wear the ordinary white ring like every other submitted pin. The exact CSS is kept in a comment in the pin block of `index.html`, and how to restore the key row is in comments in the legend and in `pin-guide-export.html`. **Do not put gold back on the pin unasked.** `visited: true` stays on Skehana Hill, Tara Hill Honey and Rathphelan Farm, the pins still carry `is-visited`, and the Visited chip in the filter panel still filters.

**A still halo for Connect farms was built and declined the same day (2026-11-27).** The user asked for a subtle glow on every Connect farm, no pulse, different from the visited gold; it was a radial band in the Connect green `#B4D2BA` on `.pin.on-connect:not(.is-visited)::after` (8.78px, scale 3.3, peak 0.55 at 52%), with visited farms keeping only the gold. Seen in `Map Screenshot/glow-before-after.png`, the user pushed everything else and left it off. **Do not add it back unasked.**

**Legend (2026-11-27): six rows, names only, plus the disclaimer.** Organic, Regenerative, Organic and regenerative, Korean Natural Farming, Farm confirmed, Discovered. **The key states pin types and does not explain them** (the user's direction, 2026-11-27): no line under any row, **except Farm confirmed**, which carries "Conventional farms, honey, salt, seafood and more" (asked for the same day), because the sage is the one bucket whose name does not say what is in it: 27 farms, of which 6 honey, 3 salt and Hook Head's shellfish, the rest land farms with no organic, regenerative or KNF claim. The four practice rows filter; Farm confirmed describes only; Discovered is the show and hide switch. **The self-declared disclaimer stays at the foot of the legend** because practice is on the pin: it is the source line, not an explanation of a pin, and the user kept it when the key went to names only. The pin guide plate (`pin-guide-export.html`, untracked like the other exports) shows the same six names and the same footer.

**Practice still derives from `practice` through `farmingMethod()`.** There is no separate field and there should not be one.

**Types not on the map, offered 2026-11-27 with no preference given:** Biodynamic, In conversion to organic, and agroecology or permaculture. None is a pin type or a form option yet. Any new type needs a Zite form option first, because a pin only ever shows what the farm ticked.

**Buy direct is off for now (2026-11-26, at the user's request).** `BUY_DIRECT_ON = false` in `index.html`, beside `HIDE_UNEXPLORED_ON_LOAD`, puts `no-buy-direct` on `<body>`, which hides the Connect ripple on every pin and the Buy direct row in the key. **Nothing is deleted**: the 27 ripples are still built and the row still counts, so `true` brings both back in one line. The map's only remaining movement is the new-this-week aura. The pin guide plate (`pin-guide-export.html`) was redone without the Buy direct row; its entry is commented out in the plate's own list.

### Two fills, and the ring will say the rest (set 2026-11-26, evening)

**This supersedes the fill colours in the section below, which lasted half a day.** The user's plan, in his words: every producer who has submitted their details keeps the light green pin that used to mean Verified; anyone who has not is a very light sage, "like an unexplored icon on a video game map: no one has visited it yet, it just has the name and the basic explanation"; and **how they differentiate from there is by ring colour**, which is the next piece of work.

| Pin | Fill | Size | Border | Glow |
|---|---|---|---|---|
| Details submitted (`tier` verified or featured) | `#59A666` | 8.78px, 7.80px mobile | **none** | the original Verified glow, `0 0 6px 2px rgba(89,166,102,0.73)` |
| Not yet in touch (`tier` discovered) | `#B4CBAA` | 5.85px, 5.20px mobile | **none** | none |
| Visited by Provenance (`visited: true`) | as above | as above | 1px gold `#CDA043` | gold, plus the static halo |

**Why six fills failed, so it is not tried again.** On a phone it read as a mess: organic and regenerative were two greens nobody could tell apart at 8px, with the paler one shouting louder; the two neutral classes went from drowning the map to being invisible when they were quietened; and the legend grew to 172x232px, 12% of the screen, sitting on the island. **One 8px dot cannot carry six classes by colour alone.** The old tier pins had worked because they used size and colour together for three.

**No borders yet, deliberately.** The user asked for none until the ring colours are decided. **Do not add a border to either fill, or bring practice back as a fill, without the user asking.** The gold ring on a visited farm is the one exception and stays.

**What survives from phase 1 and is still live:** `farmingMethod()`, the `fm-*` classes and `data-farming-method` on every pin, the practice filter chips in the panel (Organic alone still returns 10), the independent Visited filter, and `visited: true` on the three Highlighted farms. They paint nothing on the pin until the rings are settled, and they are what the rings will be built from. There is still no `farmingMethod` field in `producers.json`.

**The legend is four rows and 164x109px**: Details submitted, Not yet in touch, Visited by Provenance, Buy direct. The two fill rows describe and do not filter. The self-declared disclaimer left the legend with the practice colours and **must come back the moment a ring shows a practice**; the filter panel still carries its own copy.

### The pin says how they farm, not what tier they are (set 2026-11-26)

**Phase 1 of the farming classification system.** The pin interior is the producer's self-declared farming practice. Tier no longer colours or sizes a pin. **Tier is not deleted and still runs everything else**: the card mark, the "Confirmed by" line, the share stubs, what `/producer/` is allowed to show, the Connect listing and the menu. The section below on tier colours is the record of what tier used to paint, and is now history for the map only.

**There is no `farmingMethod` field, on purpose.** The classification derives from the existing `practice` field through `farmingMethod()` in `index.html`. `practice` is already the producer's own declaration, written only when they tick the box on the form, so a second column would be the same fact twice and the two would drift the first time somebody verified a farm. A producer who declares tomorrow changes colour with nothing to migrate. **Do not add a `farmingMethod` key to `producers.json`.**

| Class | Fill | Border | From `practice` | Count at launch |
|---|---|---|---|---|
| Organic | `#59A666` | white | `organic` | 10 |
| Regenerative | `#B4CBAA` | `#F4F2E9` | `regenerative` | 33 |
| Both | 50/50 vertical split, `#59A666` then `#B4CBAA` | white | both values, either order | 12 |
| Conventional | `#8A8275` | soft `#F4F2E9` | `conventional` | 19 |
| Korean Natural Farming | `#4A8A8A` | `#F4F2E9` | `korean-natural-farming` | 1 |
| Not established | `#7E8B85` | soft `#F4F2E9` | `unspecified` or empty | 78 |

**Conventional is its own class and is not Unknown.** The producer told us; it simply is not one of the two. Collapsing it into Not established would say their practice is unrecorded when it is recorded. **KNF keeps the teal the design system already gives it on the card**, because filing a natural farming practice under conventional would be wrong and under Not established would erase a declaration. Both of these are additions to the four-way spec, agreed on 2026-11-26.

**Two sizes, one border weight (revised 2026-11-26, the same day).** Every producer who has spoken to Provenance is 8.78px, 7.80px on mobile. **What used to be Discovered keeps its original small dot, 5.85px and 5.20px on mobile**, keyed on `tier: discovered` and not on the Not established class, so a Verified farm that declared no practice stays full size. One size for all 153 was the spec and lasted an afternoon: 70 researched listings at full size crowded the map, and the first fix, fading them, made them invisible. The small dot with a full ring is what had worked all along. The new-pin glow carries its `--ng: 2.71` compensation for the small dot again.

**Every pin carries a full-strength ring; only the glow separates declared from not (revised 2026-11-26).** 97 of 153 pins carry no declared practice or a conventional one. Built to spec at full ring and glow they drowned out the farms that had told us something. The first correction took the glow off and faded the ring to 0.42 alpha, and that overshot: the user reported those farms as basically invisible, "even though they might be fantastic farms". **The ring is what gives a pin its definition against the painted map, so it is never faded.** A declared practice earns the glow, an absent one does not, and that is the whole difference. `farming-classification.png`, `farming-classification-softened.png` and `full-rings-before-after.png` in `Map Screenshot` are the three states.

**Highlighted is a gold border now, not a fill.** The farm's own practice keeps the interior and `#CDA043` says Provenance has been there. 1px, not 1.5px: Chrome snaps border-width to whole device pixels, so 1.5 renders as 1 at DPR 1 and 1.33 at DPR 3.

**Visited is a golden halo and ANDs with the classes.** `"visited": true` on the record, rendered on the existing `.pin-pulse` element, which used to carry the Highlighted halo, so there is still only one halo on the map. Organic plus Visited means visited organic farms, not either. **Only the three Highlighted farms are marked** (Skehana Hill, Tara Hill Honey, Rathphelan Farm, set 2026-11-26); every other farm the founder has stood on needs marking by hand.

**The legend carries the disclaimer and it is always on, never a tooltip:** "Farming practices are self-declared by producers and have not been independently verified by Provenance." The map shows a claim it has not checked, so the sentence saying so cannot be something you go looking for.

**What this costs, and it was accepted.** The map no longer shows verification at all. A Discovered farm and a Verified farm that declared no practice both render Not established, which is 78 pins with no visible difference between researched and producer-confirmed. On 2026-10-01 exactly that situation was reversed for being wrong. It is a deliberate trade now: the pin answers "how do they farm" instead of "how sure are we", and the answer to the second question still lives on the card.

**The four-way scheme does not fit a producer who is not a land farm.** Eight Verified producers declared no practice and most of them cannot: Donegal Sea Salt, Dingle Sea Salt, Hook Head Oysters, Staffords Butchers, Tom's Apiary, Galtee Honey Farm, Castlemine Farm, Sliabh Aughty Honey. "Not established" reads as an omission when the truth is that the question does not apply. Unsettled.

### Pin Colours

- **Discovered Producers (tier: "discovered" / default):** Dark green — `#2A5A38`, 5.85px dot (5.20px on mobile), cream border (`1px solid rgba(232,222,200,0.75)`), faint green glow (`box-shadow: 0 0 4px 1px rgba(42,90,56,0.40)`). The default pin. No profile page, no badge. Card shows "Discovered Producer" pill in matching dark green (border `#2A5A38`, text `#4E8560`). Set `"tier": "discovered"` in producers.json (or omit tier field).
- **Verified Producers (tier: "verified"):** Green `#59A666`, 8.78px dot (7.80px on mobile) — 50% larger than Discovered, thin white border (`1px solid rgba(248,248,243,0.6)`), **static** green glow (`box-shadow: 0 0 6px 2px rgba(89,166,102,0.73)`) — no pulse. **No tier pulses (2026-10-29).** The only movement on the map is Connect's ripple and the faint cream aura on a pin added in the last seven days. The glow is deliberately tight: a wide glow paints many times the dot's own diameter and the pins merge into a wash as the map fills up. Card pill "Provenance Verified" in matching `#4A8A55`. Set `"tier": "verified"` in producers.json.
- **Provenance Highlighted (paid, gold):** Deep amber gold — a **radial gradient**, not a flat fill: `radial-gradient(circle at 34% 30%, #E8C670 0%, #CDA043 48%, #A97C28 100%)`, lit from the upper left so the dot reads as a raised bead rather than a flat disc, with an `inset 0 0 1.5px rgba(255,238,186,0.45)` highlight. The mid tone `#CDA043` is warmer and richer than the `#C4A44A` gold token (hue 40 vs 44, and more saturated). **9.22px dot (8.19px on mobile), 5% larger than Verified** — a deliberately modest bump, so colour and glow do the work rather than size. **No border** (unlike Discovered and Verified, which both carry a cream/white one), and a soft radial glow that is deliberately restrained: `box-shadow: 0 0 0 1px rgba(201,154,56,0.55), 0 0 7px 2px rgba(201,154,56,0.45), 0 0 16px 6px rgba(201,154,56,0.20)`. Earlier passes ran brighter and harder (`#E0B93C`, `#E9C93E`, a green-with-gold core `#6FB35A`, and a glow at double this strength) and read neon; this is the settled version. **Does not pulse (2026-10-29).** It carried a faint 4.5s orange breath from 2026-08-24; that is now a **static orange halo** at the same colour, `rgba(214,132,52,0.20)` held at scale 2.1 and opacity 0.26. **Movement on the map never means a tier.** Three pins pulsing for three unrelated reasons (Connect, New this week, Highlighted) read as one signal and confused people; Highlighted was the one that had to stop, because it was the only one of the three that meant "this farm pays". Nothing is lost telling Highlighted apart, since it keeps the gold gradient, the largest dot and the strongest glow. **The old line that "a pulsing pin is a paid signal" is retired: do not give any tier a pulse.** The visit-gated farm tier. Card mark "Provenance Highlighted" (the gold tier is called Highlighted wherever a visitor sees it) in `#D9AE55`, a lifted amber for legibility on the dark card. Set `"tier": "featured"` in producers.json. Unlocks Instagram + website links and where-to-buy on the card, plus the link to the producer's own profile page at `/<profile_slug>/`, which is where the photo gallery and the filmed visit live (never on the card). Instagram and website went live on 2026-09-07. **Every Highlighted farm got there through a founder visit** (corrected 2026-10-08; an earlier note here wrongly said one went gold before a visit). Who is on the tier, and which profile pages are live, is in `producers.json`, not in this file.
- **Provenance Seal:** Unspecified (2026-10-19). A Seal may eventually change something on the farm's pin, but the treatment is not decided and the Seal is not publicly offered, so nothing renders for it today.
- **Provenance Founder:** Set `badge2: "Provenance Founder"`. Renders as a second mark beside the tier on the badge line (`.tier-mark-founder`, green `#7DB088`), divided by a vertical hairline. It was a button at the foot of the card until 2026-11-14; see below. No special pin treatment — pin appearance is controlled by tier. Who holds it is in `producers.json`, not in this file.


**The Founder is a badge again, not a button (2026-11-14).** It renders as a second `.tier-mark` beside the tier, divided by the vertical hairline, exactly as "The card states things, it does not badge them" always described a second mark. `.tier-mark-founder` was already in the stylesheet in green `#7DB088`, the colour the button used, and had never been emitted by anything. A Founder card now reads **"Provenance Verified | Provenance Founder"**.

**The gold button at the foot of the card is off.** `#card-founder` and `.card-action-founder` both stay in the page, so the whole of bringing it back is restoring the old condition, `if (pin.dataset.badge2 && pin.dataset.profile)`. The CSS comment calling it "the one gold element on the card" was already stale: it had been green for some time.

**`map_link` stays on all three records and is not only what fed that button.** `profileUrl()` routes the menu, and any stale link, to a Founder's built page with it, so emptying it strands `producers/<slug>.html` rather than tidying anything. That is what had happened to Saltrock.

**The badge needs only `badge2` now.** The button needed `badge2` **and** `map_link`, which is why Saltrock's was missing while the other two were fine. The mark has no such pairing, so a Founder cannot silently lose it again.
**Saltrock's Founder button was off because of a null `map_link` (restored 2026-11-14).** The button needs **both** `badge2` and `map_link`: `if (pin.dataset.badge2 && pin.dataset.profile)`, where `dataset.profile` comes from `map_link`. All three Founders had `badge2` set the whole time, so Newbard and Staffords were never affected and were still showing. Saltrock's `map_link` was emptied when it moved to Verified, alongside its gallery, Instagram, website and where-to-buy, but `producers/saltrock-dairy.html` was never deleted and is still maintained. It is back to `producers/saltrock-dairy.html` and all three now render. **`badge2` alone does not give a producer the Founder button**, which is worth knowing before concluding the badge has been removed from a record.

> **Implementation note:** the code ships tiers `discovered`, `verified`, `featured`, `seal-lite`, `seal-complete`. The gold **Highlighted** pin was wired in on 2026-08-24 with Skehana Hill as the first producer on it. The pin carries a very faint orange pulse (added 2026-08-24) plus a soft gold glow. Highlighted's card unlocks (gallery, Instagram, website, where-to-buy, filmed visit) are **not** wired in yet: Skehana Hill's card carries the tier pill, a gold top edge on the card itself (#card.featured-card), their Instagram and website, and an inert Highlighted Profile In Progress pill between the links and the confirmed line. **The profile page exists** (built 2026-09-14) at `provenancemap.ie/skehanahill`, served from `/skehanahill/index.html`; the public slug lives in a `profile_slug` field on the record, never in the `id`. Facts on the page come from `producers.json` (so card and page cannot drift; `where_to_buy` feeds both), visit content from `/<slug>/profile.json` (visit date, hero, film, story, product notes, and the `photos` gallery with captions and crop positions). **The map card never carries the photo gallery.** Decided 2026-09-14: the card keeps its single logo, the tier pill, the practice pill and the links, and its job is to send people to the profile page, which is where the photos live. So a Highlighted record has no `photos` array; the card's thumbnail strip and lightbox stay in the code but nothing feeds them. `profile_live: true` on the record swaps the card's inert "Highlighted Profile In Progress" span for the real link (`#card-featured-link`) and drops the page's own "Profile in progress" pill; **Skehana Hill went live on 2026-09-15.** The visit date is the line the tier stands on: a page does not go live without one. The card's where-to-buy entries are `{ name, url, note, when }`: the name links to `url`, `when` sits on the right (a day, or "Directions" for a maps link), `note` is a muted line under it, and a single entry spans the card. A second Highlighted producer is a copy of the folder with `PRODUCER_ID` and `PAGE_URL` changed and its own `profile.json`. **Provenance Connect, layer one (2026-09-21):** a `whatsapp` number on the record (written as dialled, `087...`; normalised to `353` for `wa.me`) puts a **Connect** button on the map card beside Highlighted Profile and a filled Connect button at the head of the profile page's link row; both opened a WhatsApp chat prefilled with a standard message. Neither is still true: the map card press is navigation now, and the prefill text is below. An empty or missing number shows nothing. **Provenance Collection** membership is `"collection": true` on the record: the pin keeps its Verified green and size and takes a thin parchment-cream ring `#F3EEDD` and a soft cream glow in place of the white ring and green glow (silver `#DCD9D0` until 2026-10-28) and the card carries a plain-text "Provenance Collection" mark beside the tier mark; the tier itself is unchanged. First member: Galtee Honey Farm, 2026-09-19. Saltrock renders on `verified` (green) with its logo as the single card image; its former gallery/IG/website/where-to-buy were removed from its record when it moved to Verified. `photo_url` is the single card image (a logo is preferred, but one representative photo is acceptable on any tier); only the multi-image `photos` gallery is Highlighted-only. Pin size is not affected by farming practice — organic/regenerative shows via the card practice pill only, never by enlarging the pin.
- **Farmers Market:** Terracotta — `#B0623A`, 5.95px dot (4.25px on mobile), no border, terracotta glow. Completely different card layout showing hours and a producer list. Add `class="pin market"` and `data-category="market"` to the pin.

### What moves on the map (set 2026-10-29, revised 2026-11-03)

**Two things move, and they say different things: a Connect farm sells direct, and a new pin has just been added.** Before 2026-10-29 three pins moved for three unrelated reasons and read as the same "look here":

| Mark | Was | Is now |
|---|---|---|
| **Connect** | 5s green ripple | Unchanged. Pale green `.pin-ripple`, travelling outward |
| **New this week** (`is-new`) | 2.6s expanding cream ring | A **faint cream aura** that breathes slowly, `pin-new-glow`, 4.2s |
| **Highlighted** | 4.5s orange breath | A **static** orange halo: scale 2.1, opacity 0.26 |

**New this week is a glow, not a ring (2026-11-03).** It drew a 1px circle that expanded outward, and `transform` scales a border along with everything else, so at the fractional pixel position a pin normally sits at the browser antialiased that circle thicker on one side than the other. **A lopsided ring around a dot does not read as "recently added", it reads as something broken on the map**, which is exactly how the user described it. It is now a radial gradient fading to nothing, which has no edge to render crooked at any position or zoom. **Keep it tight to the border.** It is a thin band of cream sitting just off the white border, transparent until 30% of the gradient (where the border's outer edge falls), up to 0.40 just past it, then away to nothing by the gradient's edge so no stop can read as a boundary. Scaled 2.2, the visible band runs from about 4.4px to 8px off centre on a Verified dot. Two attempts on 2026-11-03 spread it wide and faint instead, on the theory that it had to clear the tier's own green glow (which reaches about 12.4px) in order to be seen; the second reached 20px and read as a hazy blob around the pin rather than as a pin that is new. **It earns its visibility from being briefly opaque in a thin band, not from reach. If it needs adjusting, move the alpha, never the scale: widening it is what made it wrong twice.** `new-pin-glow-check.png` in the repo root is the comparison at actual size.

It still moves, because a static mark was tried on 2026-10-29 and reverted the next day: a ring expanding off a new pin is the map growing in front of you, and a static one does not say that. But it breathes slowly in place rather than firing outward and vanishing, since the quick travelling ripple belongs to Connect and means something else. **The part of the 2026-10-29 decision that stands is that no tier pulses**: `is-new` is an age mark on a seven day timer, not a tier, so it never says "this one is paid".

Discovered and Verified never pulsed; their `.pin-pulse` element is `display: none`. The `pulse-featured` and `pin-new-ring` keyframes were both deleted with their last users. The Seal, Farmers Market and the legacy `gold` / `tier-1..3` classes still carry pulse rules in the CSS, but no producer uses any of them: **if one is ever used again, take its pulse off first.**

`is-new` carries its own reduced-motion rule, holding the aura still at its mid value. The reduced-motion block separately zeroes `.pin-pulse`, so Highlighted's static halo is excepted there; otherwise those visitors would lose the halo rather than have it calmed.

**The glow is capped at six pins at once (`NEW_GLOW_MAX`, set 2026-11-10).** The seven day window still decides who is *eligible*; the cap decides how many of them light up, newest first, ties falling back to `producers.json` order so the choice is stable between loads. Sixteen were lit at the same time on 2026-11-10, on top of twenty Connect ripples, and the user reported the pins flickering and the zoom juddering on a phone. Thirty six running animations over a layer carrying 148 pins is what a phone shows as flicker. **Six also reads better**: a map with sixteen glowing pins is not saying "these are new", it is twinkling.

**Paint cost is the constraint on this map, not data (2026-11-10).** `producers.json` is about 150 records, so nothing here is fixed by a backend, and reaching for one would be solving the wrong problem. Three things were done the day it was first reported, all reversible and none touching pin coordinates:

- **Nothing on a pin animates during a zoom.** `markZooming()` in `applyMapZoom` sets `body.is-zooming` and clears it 750ms later, just past the 0.65s transition. `.pin-ripple`, `.pin-pulse` and the new-this-week `::before` all take `animation-play-state: paused`, which keeps their position and carries on rather than restarting, so nothing jumps when the map settles.
- **No `backdrop-filter` on a touchscreen.** It makes the browser re-read and re-blur whatever is behind the element every frame, and during a zoom that is the map layer with every pin on it. Five or six of them sit over the map at once (legend, Connect, Collection, filter, Near Me, zoom out). It costs almost nothing to lose: each already had a background between 0.88 and 1.0 alpha, so the blur showed through a sliver, and the alphas go to 0.96 to close it. **Desktop keeps the blur.**
- **The glow cap above.**


**Three more, the same evening (2026-11-10).**

- **The back button was invisible on every producer card.** `.card-footer` is a sibling of `#card` and sat at `z-index: 4` against the card's `30`, so the card painted straight over the strip. It is `31` now. The strip is touch-only by design (`@media not all and (pointer: coarse)` hides it and shows the `.card-close` X instead), so this only ever affected phones, which is where it was reported. On a 390px viewport the button lands 16px from the right edge and 12px from the bottom, and `elementFromPoint` at its centre returns `card-back`, which is the test that matters: it is topmost and it takes the tap.
- **No press effect on a pin, and one of the two was a bug.** `pin-tap` animated `translate(-50%,-50%) scale(...)` on `.pin-dot`, which is a flex child of `.pin` and already centred by it, so the translate shifted the dot up and left by half its own size for the length of the animation. Pins visibly jumped out of place as they were pressed. **`.pin` carries the centring transform; a `.pin-dot` never should.** Both that and `.pin:active .pin-dot { transform: scale(1.45) }` are gone, and `tapPin` is just `openCard` now. The card opening is feedback enough.
- **`#map-wrap` is promoted to its own layer only while it is moving.** It carried `will-change: transform` and `backface-visibility: hidden` permanently, which holds the map as a rastered compositor layer at all times. Zoom reaches `scale(7)` (`CLUSTER_MAX`), so coming back out the browser has to rebuild that texture from a 7x raster of a viewport-sized layer, and on a phone it gives up: **the artwork disappears for three or four seconds while the pins, which are their own layers, carry on drawing.** That is the "map goes missing and the pins stay alive" glitch. At rest it is an ordinary element now; `body.is-zooming #map-wrap` adds `will-change` for the move. **If it still blanks, the next lever is `CLUSTER_MAX`**, and that is a real trade: 7 is what turns pins 5px apart into 35px apart, so lowering it costs the ability to separate a cluster. Ask before touching it.
**If it is still not enough, the next lever is `positionPins`,** which writes `style.left` and `style.top` on all 148 pins and so forces layout every time it runs. Moving it to `transform: translate()` would make it compositor-only. It is deliberately not done yet: `.pin` already carries `translate(-50%,-50%)` and a `-20px` correction, and about forty producers hold hand-tuned desktop overrides on top, so that change risks moving every pin on the map. **Measure before touching it, and do it on its own, not alongside anything else.**

**`date_added` is what drives it, and a null there fails silently.** The key is on all 128 records, so leaving it null is not an error: the producer simply goes on the map having never been new, and nobody notices until the week is gone. It happened to Giron's Farm, Carraig Abhainn Farm and Carncash Farm. **`check-new-producers.ps1` is now the guard** and both the `add-producer` and `sync-producers` skills run it before committing; it diffs `producers.json` against the committed copy and exits non-zero if an id that was not there before has no date. Giron's Farm was backfilled to 2026-11-03; the other two were added earlier in October, so their week had already passed and dating them now would be a lie. The 96 listings from before the field existed stay null on purpose.




### The dark bands stay dark (reverted 2026-11-17)

**The map is back to how it was before the bleed work, at the user's request.** The artwork is square (1024x1024) and a phone is about 1:2.16, so `object-fit: contain` draws the island at 390x390 and leaves **227px of flat charcoal above and 227px below**, using 46% of the screen height. **That is the intended state again.** Both attempts to fill those bands are gone and nothing references them.

**What was tried, so it is not tried again the same way:**

- **A blurred copy of the artwork** (32px, upscaled, dimmed, masked). The user's verdict was that it looked like **camouflage**, and that is exactly what it was: a scaled-down copy keeps the artwork's light cloud and dark sea as patches, and low-contrast patches is the definition of camouflage. Smaller tiles and less dimming were tried at 24, 16 and 12px; every one kept the patches, because the patches **are** the image.
- **Flat colour fades** from the artwork's measured edge averages (`#B5C4B9` top, `#54646A` bottom), anchored at the seam with `calc((100dvh - 100vw) / 2)`. This removed the camouflage completely, and was still reverted. **The bands being dark is not a defect to be fixed.**

**Do not fill the dark bands again without the user asking for it specifically.** Two different approaches were built, shown and rejected in one week.

**The portrait crop is also closed.** Mocked up on 2026-11-17 and rejected on the numbers: the painted Ireland is **1.08:1, essentially square**, so width binds rather than the sea margin, and deleting every pixel of ocean and cloud takes it from 46% to **50%**. It also jams the island against the frame and pushes southern pins outside the crop. `portrait-crop-mock.png` in the repo root is that comparison. A real fix means repainting the artwork at Ireland's true proportions, which moves every pin.

**`assets/map-bleed.jpg` is a leftover and nothing references it.** 989 bytes, safe to delete.

**On checking a pin diff.** Every one of these passes was verified against a captured baseline of all pin rects. Worth remembering from it: `an-garrai-glas` once appeared to shift **1.305px on both axes**, which is half of 2.60px, which is exactly the Discovered to Verified dot size step. It had been upgraded; its `lat` and `lng` never changed. **A uniform shift of half a dot-size step on both axes is a tier change, not a move.**

### The resting zoom on a phone (set 2026-11-26)

**The bands are smaller because the map is bigger, not because anything was painted into them.** `MAP_BASE_SCALE` in `index.html` is **1.25**, and on a portrait phone the map now rests at that scale instead of 1. The island goes from 390px to 487px wide and the bands from 227px to 178px. This is not the bleed work coming back: nothing is drawn in the bands, and the rule against filling them stands. The user asked for a bigger map specifically, on 2026-11-26.

**No coordinate was touched and no pin moved.** `#pins` sits inside `#map-wrap` alongside the image, so a transform on the wrapper moves the island and the pins as one body. Measured across all 153 pins at 1.00x and 1.25x: **worst drift 0.00000%, 0.000px on screen.** `positionPins`, `getMapDims`, `latLngToPercent`, refX 85/82, the 15.217 and 20 scale factors, the `-20px` correction and the forty desktop overrides are all untouched.

**Why 1.25 and not more.** Measured off the artwork: the painted island spans **73.8%** of the artwork width, and the pins span **67.1%**.

| Scale | Coast to screen edge | Band |
|---|---|---|
| 1.00x | 51px | 227px |
| **1.25x** | **15px** | **178px** |
| 1.35x | 1px | 159px |
| 1.49x | clipped 20px | 131px |

The coast reaches the edge at **1.35x** and is clipped past it. Every pin stays on screen up to **1.49x**, and beyond that a full-height fill (2.16x) pushes **27 producers off screen**, including Dingle and Achill in the west and the entire east coast with Dublin and Belfast. **Pan now exists (drag and pinch, 2026-11-26), so raising `MAP_BASE_SCALE` is possible, but past 1.49x pins start off-screen at rest: decide it on a phone.**

**It is the resting value of `mapZoom`, not a second transform layer**, and that matters twice:

- **Near me** writes an absolute `tx`/`ty`/`s` worked out from untransformed pixels (`vw/2 - N*px`). Composing a base transform underneath it would silently put the user's location off centre. Because the base is just where `mapZoom` rests, Near me's maths is untouched and still correct.
- **`CLUSTER_MAX` stays a true ceiling.** Zoom runs 1.25 to 2.75 to 6.05 to 7, rather than reaching 8.75, so the texture the phone has to rebuild on the way back out is no bigger than it was. The phone-blanking risk is unchanged.

`resetMapZoom()` returns to the baseline rather than to 1, so the zoom-out chip and `exitNearMeMode` both land back on the resting view, and the chip's visibility is judged against the baseline rather than against 1. `layoutMap()` wraps `positionPins()` and re-settles the zoom on load and on resize; it defers a frame because the synchronous `mapImg.complete` branch runs while the script is still parsing and `mapZoom` is in its temporal dead zone.

**Desktop is deliberately excluded**: `mapBase()` returns identity unless the viewport is portrait and 768px or narrower, since a landscape window has no bands to reclaim. Verified at 1280x800: scale exactly 1.0000.

**Setting `MAP_BASE_SCALE` to 1 turns the whole thing off**, one number, no other edit.

**The artwork is the limit on going further.** It is 1024px, so at 1.25x on a DPR-3 phone the browser draws about 1463 device pixels from it, and a full-screen 2.16x would ask for 2532. The AVIF conversion in the loading notes is what buys the headroom for any larger resting scale.

### A quieter map on a phone, and a lighter artwork (set 2026-11-26)

**The interface steps back once the map arrives (phone only, `max-width: 768px`; desktop untouched).** The legend folds into a **Key chip** in the bottom-right corner (`#legend-key`) and opens directly above it on a tap, the chip reading Close while it is open. **The chip carries a small green dot whenever anything on the legend is switched on** (a practice row, Visited, Buy direct, or Discovered shown), so a filtered map never looks unexplained while the legend is folded away. The producer counter counts up as before and fades 2.6 seconds after it finishes, on a plain timer rather than the last animation frame so a throttled tab still gets there. It sits under the wordmark now (see Search at the thumb). **The Provenance wordmark stays.** It faded 4.2 seconds after the pins arrived for a few minutes on 2026-11-26, and the user asked for it back. Do not fade it again without asking. Menu, search and Connect stay. **The refresh button stays on purpose**: it clears stale cached files, which is how a change shows on the user's phone straight after a push. `placeZoomOut()` sits the Zoom out chip above the Key chip when the legend is folded.

**The artwork is WebP now: 213 KB instead of 2,018 KB**, `ireland-map.webp`, the same 1024x1024 image encoded at quality 0.92 in Chrome, inside a `<picture>` with the PNG as fallback. The map image was about 95% of the first load, so this is roughly a tenth of what a phone downloads. Compared at three times magnification on coast, surf and rivers, it is indistinguishable from the PNG; 0.86 (133 KB) was too, and 0.92 was chosen for margin on the painted texture. **It is not sharper**: there is no higher-resolution original anywhere on the machine, both `ireland-map.png` and `ireland-map.png.png` are the same 1024px file, and upscaling adds no detail. A crisp deep zoom needs the original artwork exported at 2048px or larger. Nothing reads the artwork's address, and `getMapDims()` works from ratios, so pins are unaffected; a 2048px export could drop straight in. `about.html` still loads the PNG.

**Drag and pinch is being built (2026-11-26); the half-height card sheet was mocked and not taken forward.**


### Search at the thumb (set 2026-11-26)

**On a phone (`max-width: 768px`), search is a wide bar in the bottom-left corner**, not an icon at the top, because finding a farm is the main job. The bottom row is **Search farms, then Connect, then the Key chip**. Desktop is unchanged.

- **Near Me is gone from the phone.** `#near-me-btn` is hidden; the machinery (geolocation, the 30km radius, the circle, the list panel) stays dormant, as it was before the button was switched on. It also frees the map transform for drag and pinch.
- **The search icon (`#filter-toggle`) and Connect left the top.** The refresh button took the search icon's place, top right, until later the same day (next bullet). It stays because it clears stale caches.
- **The menu and refresh buttons came down to the corners too (2026-11-26, at the user's request).** The menu sits above the search bar on the left, refresh above the Key chip on the right, centred on one line as they were at the top, and both lift over the install bar with the row. **The top of a phone screen is now just the wordmark and the producer counter.** Three consequences, all deliberate: the menu button is `z-index: 26` like the rest of the row so an open card covers it, rising to 120 only while the menu is open (the drop back waits 0.3s for the overlay's fade); **refresh steps aside while the Key is open**, because the legend opens into that corner; and `placeZoomOut()` now stacks the Zoom out chip above refresh. A scrolled menu list carries extra bottom padding so its last row clears the button. **On a phone the button is a Menu chip (2026-11-26, the user's pick of four mocked in `Map Screenshot/menu-button-options.png`)**: three lines and the word MENU, a twin of the Key chip, 40px tall. The lines still cross into an X while the menu is open and the word reads CLOSE, as the Key chip's does. It is a grid over the same three spans plus an `.mb-label`, so the X is the same animation; desktop hides the label and keeps its square button top left.
- **The producer counter sits under the wordmark on a phone (2026-11-26)**, just above the map, counts up and fades as before. It left the bottom-left corner to make room for the menu button. The mobile rule names every bottom rule that could reach it (install bar, the old bottom banner) so none of them can stretch the box between a top and a bottom.
- **The panel still drops from the top**, which is right for typing: the box sits above the keyboard and the results under it. The bar (`#search-pill`) opens it with the keyboard up and closes it again. **A Done button in the panel header** closes it too, because the keyboard can cover the bar. These, and tapping a result, are the only ways the panel closes, so **never hide the bar on a phone without giving the panel another way out**.
- **The bar says what the map is filtered by.** It reads "Close search" while open, the current search while one is applied, and carries the filter count in a green badge. Clear all resets it.
- **Results include Discovered farms**, and the panel says so under the box. A match reveals a hidden Discovered pin on the map. **Result and menu dots use the pin colours** through `dotClassFor()`; the menu's Producers list was still in the old tier colours, including the retired Highlighted gold.
- **The whole row lifts over the install bar** (`body.pv-install-bar`), which fixed a bug: the Key chip had been sitting underneath the install bar for first-time visitors since it went in earlier the same day.

**Testing touch layouts headlessly.** Rules gated on `(pointer: coarse)` never render in plain headless Chrome, which is why the Near Me button and the install-bar overlap were missing from earlier phone mocks. Launch Chrome with `--blink-settings=primaryPointerType=2,availablePointerTypes=2,primaryHoverType=1,availableHoverTypes=1` and `matchMedia('(pointer: coarse)')` is true, so the mock is what a phone shows.


### Drag and pinch (set 2026-11-26)

**On a touch screen, one finger drags the map and two pinch it.** The gestures live in one block, `if (coarsePointer) { ... }` after the map's tap handler, and write the same `mapZoom` state the tap-to-zoom uses, so the cluster tap, the Zoom out chip and `resetMapZoom` work unchanged. **Removing that block removes the feature cleanly.** Desktop is untouched: it rests at scale 1 with no offset, verified.

- **The painting always fills its frame.** `clampMapZoom()`, called from `applyMapZoom` for every move (not while Near Me holds the map), lets the artwork move but never show its edge along an axis where it is wider than the screen, and centres it along one where it is narrower, which is exactly the resting position. Tap-to-zoom near the coast is clamped too, so it no longer shows charcoal beyond the painting.
- **Pins grow gently, not with the map.** `--pk`, a registered custom property on `#map-wrap`, counter-scales every `.pin` about its own centre: `min(1, (base/s)^0.75)`. A Verified dot is 9.75px on screen at rest, 12.4px at 3.25x and **15px at 7x, where it used to be 55px**, so a cluster now genuinely separates when you zoom into it. It transitions alongside the transform for the tap-to-zoom glide. **Pin drift measured 0.0000%** at every zoom, because the scale is about the centre the translate puts on the coordinate.
- **A drag never opens a pin.** Movement past 8px makes it a drag; the click that ends a drag or pinch is swallowed in the capture phase. A plain tap still opens a card. Lifting one finger mid-pinch carries on as a drag with no jump.
- **The page itself never pans or zooms over the map**: `touch-action: none` on `#map-wrap`, `preventDefault` on gesture moves, and iOS `gesturestart`/`gesturechange` stopped inside the map.
- **The CSS transition is off during a gesture** so the map follows the finger exactly, and comes back afterwards.
- **On a touch screen the painting is a canvas, not the `<img>` (2026-11-26).** Pinching out from deep zoom left black squares across the artwork for a second or two: the `<img>` is painted into the map's layer, that layer is held at the scale the gesture began at, and at 7x coming back out the phone runs out of tile memory and shows the page background where tiles should be. `placeArt()`, called from `layoutMap()`, draws the artwork once into `#map-art`, a 2048 square canvas (high-quality smoothing from the 1024 file), which the GPU scales as one texture at every zoom, so there is nothing to rebuild. **It is placed from `getMapDims()`, the same numbers every pin uses**, so painting and pins cannot disagree; the `<img>` stays in the page with `visibility: hidden` because `getMapDims()` measures it. If drawing fails for any reason the `<img>` simply stays. Compared side by side at 7x it renders the same as the `<img>`, marginally crisper. **Desktop keeps the `<img>`.** Not reproducible headlessly, so the fix is by construction until the user has pinched on a phone.

**Not yet judged by hand.** Synthetic touches in headless Chrome prove the maths (edges, drift, sizes, taps), not the feel on a real thumb. **The resting view stays 1.25x**: with drag it could rest bigger, but past 1.49x Dublin and the east coast start off-screen, so that waits for the user to try it. `pinch-built.png` in `Map Screenshot` shows tap-zoom against pinch.

### The card states things, it does not badge them

Decided 2026-09-24. The card used to stack four rows of rounded pills — tier, Collection, confirmed attributes, produce, venue — and they read as chrome rather than as content. They are all text now, no borders and no backgrounds:

- **The tier** (`.tier-mark`) is one line of letterspaced small caps in the tier's own colour, and a hairline (`.tier-rule`) runs from it to the edge of the card. A second mark (Collection, Founder) is divided from the first by a vertical hairline, never boxed off on its own. Highlighted finally uses `#D9AE55`, the lifted amber this file always specified — as a solid gold block it had to carry dark text instead.
- **The practice line** was already set this way (Cormorant italic with a leaf or sprout icon, in the practice colour) and is unchanged. It is the warmest thing on the card and the hierarchy is built around it.
- **Confirmed attributes** (`.badge-attr`) are a quiet middot-separated line in muted cream under the practice.
- **Produce and venue tags** are the same line in green, so they read apart from the attributes directly above them.

The Connect listing page follows the same rule. Anything new that wants to label a producer gets a line of type, not a pill.

**"Confirmed by <farm>" sits above the Share row, not at the foot of the card (moved 2026-11-19).** It renders for Verified and Highlighted only, and it used to be the card's last line, under Share and under the button block. `#card` is the scroller and its content runs about 769px, so the line landed 660px down the screen while the Back strip stays pinned to the card's bottom edge. **On any viewport under about 755px the line sat beneath the strip or off the card entirely**, and most phones in a browser are shorter than that, so the one line saying who stood over this farm was the one line nobody saw without scrolling for it. Above Share it lands at 566px and clears the strip from about 648px of viewport, which covers every phone the map realistically meets. The Share row, bounded by its own two hairlines, is the last thing on the card instead. **The 96px bottom padding on `.card-body` is not what fixes this and must stay**: it is inside the scrolling content, so it only does its job once you have already scrolled to the bottom.

### Connect becomes part of being on the map (decided 2026-11-27, not yet built)

**Connect stops being a separate product you go to and becomes what every confirmed farm's card and profile does.** The map is the directory; the documentary is the main thing farms pay for. Settled by the user through six questions:

- **Every confirmed farm that agrees to its number being shown gets Connect automatically**: a message button and its "what they have now" list on its card and profile. No separate Connect sign-up. Discovered farms get it when they confirm. Consent is the `publish_number` answer; never put a researched number on the map.
- **Farms update their own details and list through a form, with no login.** The no-backend rule stands: submissions land in a database the user can see, and the map reads a published copy of it. Logins can come later if the volume calls for them.
- **Keeping the list current stays paid** (Connect Tier 1). A free farm shows a fixed list that never changes, as before.
- **Updates go live straight away**, dated, and the user pulls anything wrong afterwards. Nothing waits on approval.
- **`/connect/` folds into the map.** Its link opens the map showing only farms you can message, and each farm's profile carries the rest: one place, nothing to keep in step between two pages.
- **Follow is the visitors' first interactive feature**: leave an email, hear when the farm updates, no login. Only paying farms can be followed, since theirs are the lists that change, which gives a farm a reason to pay.
- **A farm with a documentary gets a film mark and a Watch the film button on its card.** The pin stays clean, in line with Visited coming off the pin on 2026-11-26.

### The Connect tiers (set 2026-10-29)

**Being on Connect is free, and free is not a tier.** A free listing carries the farmer, where they are, and what they produce. It is never updated. Everything above it is paid.

| | What the farm gets |
|---|---|
| **Free listing** | Who they are, where they are, what they produce. Never updated. Not a tier. |
| **Tier 1** | Photographs from around the farm, weekly availability updates, and promotion: a weekly post on the Provenance channels highlighting them |
| **Tier 2** | Everything in Tier 1, plus **the chatbot**. A visitor asks a question on the farm's page and gets an answer without needing WhatsApp and without waiting on the farmer to reply |
| **Tier 3** | Everything in Tier 2, plus **an ordering page through Provenance**. People see the produce, order it there, and Provenance passes the order to the farm. Just Eat for the farm. |

**The tiers are cumulative.** Each one includes everything below it, so the price has to rise at each step because the thing genuinely gets bigger. This is not a menu: a farm cannot take the chatbot without the weekly updates, because the chatbot and the ordering page both answer questions about what the farm currently has, and that list is Tier 1.

**No produce photos and no prices on the free listing (decided 2026-11-04).** A free Connect listing carries the product list (name, category, a plain description, seasonal note) and one profile image (a logo or a single photo, as on every map card). It never carries produce photographs or prices. Both belong to the paid tiers, and the paid onboarding form is still to be built. **Free-trial producers who already have produce photos keep them**; the rule applies to every listing set up from now on. Do not add a price field or a produce-photo upload to any free onboarding form.

**One onboarding app for the free listing (Zite, 2026-11-04).** A single Zite app sets a producer up on the map and the free Connect listing together. It asks first whether they are already Verified: if yes, they confirm their name and email and skip straight to the Connect questions, so nobody submits their map details twice. The same app with `?type=verified` is the Verified-only link and stops after the map listing. Submissions land in the Zite database with a Path and a Status (New / Reviewed / Live); nothing reaches `producers.json` until it is moved across by hand. A producer is still Verified only by submitting their own details, which this app satisfies.

**The two sign-up links (2026-11-05).** The producer app is `https://joinprovenancemap.zite.so` ("Provenance Producer Sign-up") and the community one is `https://connectinterest.zite.so` ("Provenance Connect Sign Up"). **They are different audiences and must not be swapped**: the producer link replaced List Your Farm in the map menu and sits at the foot of `/connect/`; the community link is a menu item of its own and a bordered `.hero-join` line at the head of `/connect/`, under the farm count. That one is bordered rather than filled because the filled buttons on `/connect/` reach a farm and this one does not, so it should not outrank Connect on the row below it. **Its label promises nothing beyond the action**, since what the form offers is set in the form: the page does not make a commitment on another page's behalf.

**A visit is not a tier and sits outside the ladder.** The founder goes to the farm, photographs their produce so they have professional photographs of their own, films the visit, and tells the story. Any farm can buy a visit at any level, including a free listing, and a Tier 3 farm might never have one. **Once a farm has been visited, the visit goes in the place on their Connect listing that used to carry their map tier.**

**The Connect listing no longer shows the map tier (2026-10-29).** Discovered, Verified and Highlighted describe a producer's standing on the map and said nothing about what they have on Connect. Two unrelated ladders in one column read as one. That slot now carries the Connect marks instead. The Collection mark stays, because it is a release mark and not a tier.

**The mark names what the visitor can do, never which tier the farmer bought.** A buyer browsing the directory has no reason to care that a farm pays for Tier 1, and every reason to care that its list was updated on Tuesday. So there is no numeral, no bar chart and no word "tier" on the page: the commercial ladder stays between Provenance and the producer, which also means the tiers can be repriced or restructured without it showing.

`"connect_tier": 1` on the record, cumulative, so a farm on 2 carries both marks. A farm with no `connect_tier` carries nothing at all, which is what makes a mark worth having: free is the listing, not the bottom rung of a rating. `"visited": true` is separate and sits outside the ladder, in muted grey `#9A968B` rather than the green `#5A8C64`. The marks, with their line-art icons:

| On the record | Shows | Icon |
|---|---|---|
| `connect_tier: 1` | Updated weekly | A circular refresh arrow |
| `connect_tier: 2` | Ask the farm | A speech bubble |
| `connect_tier: 3` | Order here | A basket |
| `visited: true` | Visited | A film camera |

Tier 3's mark is written but the tier does not exist, and when it does it may well want a button rather than a mark. The marks render on the `/connect/` directory row only: not on the shared profile, and **not on the map card**, which has spent two months having things taken off it.

**"Tier" now means two different things, so say which.** A *map* tier is Discovered, Verified or Highlighted. A *Connect* tier is 1, 2 or 3. They are unrelated ladders: a Discovered farm can be Connect Tier 3, and a Highlighted farm can be on the free Connect listing. **Highlighted is not a Connect tier**: a Highlighted page is a filmed visit the founder made, and Connect is a separate product. Do not conflate them.

**Rathphelan Farm is the Tier 1 pilot**, running from November 2026. Nothing is priced yet. What a tier costs, and whether any of it is self-service, are both still open.

### Provenance Connect, layer two — availability

**Connect is not paused (corrected 2026-10-19).** It is being worked on in the background. **The tier ladder was set on 2026-10-29 (see the section above); prices are still unspecified.** `CONNECT-SETUP.md` is still not done. The open questions at the end of this section stay open on purpose. Everything below is the record of what was built.

Built 2026-09-24. **What a producer currently has, in their own words.**

**Stock counts are in, and the no-counting rule is reversed (2026-10-30, at
the user's direction).** From 2026-09-24 the governing rule was *what do you
have*, never *how many do you have*, with no quantity field in the UI or the
data and none to be added. That is over. An item may carry `"qty": 8`, which
renders beside its name as **8 AVAILABLE** in the green, and Rathphelan Farm's
three boxes are the first to use it.

What the old rule was protecting still applies, so two things hold:

- **A count is only as true as its date.** A stale list was merely vague; a
  stale count is wrong, and says so precisely. `updated` therefore matters
  more than it did, not less, and a farm carrying counts needs its list kept
  current or the counts come off.
- **`sold_out` still wins over `qty`.** A farm that forgets to zero a number
  should not keep advertising stock.

`qty` is optional and most farms will not carry one. An item with no `qty`
renders exactly as it always did, and `sold_out` remains a yes or no.

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

**Two buttons on the directory, and they mean different things.** **Connect**
opens the chat. **See the farm** always goes to `/producer/?id=<id>` — the
shared profile, even for a farm with a bespoke page — so every farm on Connect
lands a visitor on the same kind of page. It is bordered rather than filled,
because it is a different job. A farm with no channel on file keeps the slot as
a greyed, inert `<span>`, so the row does not change shape when the detail
arrives and there is never a live button that goes nowhere.

**Order is not a button, and it is never on the directory (2026-10-29).** It
points at the farm's own shop (`order_url`, falling back to the record's
`website`). Given equal weight beside Connect it handed the buyer straight to a
checkout, which ended Provenance's part in it: no conversation, no
relationship, nothing learned about what the buyer actually wanted. It now
renders only on the shared profile at `/producer/?id=<id>`, as a line of text
under the Connect button ("They also sell through their own shop"), below the
"Provenance takes no part in the order" note. Reach the farm through the
conversation first; find the shop afterwards if that is what you would rather
do. **Do not put Order back on `/connect/`, and do not promote it to a button.**
The press is still tracked as `order_click`. The three bespoke Highlighted
pages keep their own Order button in their availability block, because a
Highlighted page is not a Connect surface.

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
| A Highlighted profile hero | `/producer/?id=<id>` — that farm's Connect profile | Changed by the user on 2026-10-29. It used to scroll to `#connect-section` further down the same page (settled 2026-10-01); that block is gone, so the button leaves the page. Do not change it again without asking |

Either button shows when the farm is **on Connect at all**, not when a
`whatsapp` number happens to be on the record, so neither can land somewhere
that is not there. The messaging button with the icon lives on `/connect/` and
in the availability block of a profile. The card's press is tracked as
`see_farm_click` — named for where it lands, so it sits alongside the same
press on `/connect/` rather than inventing a second event for one button.

**The prefilled message, changed 2026-11-05.** One text for every farm, in
`connectWhatsapp` in `connect.js` and nowhere else:

> Hi, I found your farm on Provenance Connect. I'd like to buy direct from you.

It replaces "Hi, I found your farm on the Provenance Map and would love to
learn more about what you have available." **It names Connect rather than the
map because every surface that opens a chat is a Connect surface**: the
directory and a profile's availability block. The one place it reads slightly
off is the Connect button in a Highlighted page's Where to buy, which is not a
Connect surface, and that was accepted rather than threading a surface
argument through for the sake of one button. It says "your farm" and not the
farm's name on purpose, so there is one string to change rather than a
template to get wrong. **There is now exactly one copy of it.** Four dead
`whatsappLink` functions carried the old text, in `producer/index.html` and the
three bespoke Highlighted pages: defined on all four pages, called on none of
them, and predating the UK number fix as well, so each of them would still have
turned a Northern Ireland number into a Republic one that does not exist. They
were deleted on 2026-11-05 and the old text is now nowhere in the repo.
`connectWhatsapp` is the only builder, reached through `connectChannel`, so the
message is changed in one place.

**The two kinds of profile are separate products, and each page is one of them
(2026-10-29).** A **Highlighted page** at `/<slug>/` is the story of a visit:
hero (name, place, produce, Connect with the farm, then Instagram, website and
share), quote, film, story, what they grow, Around the farm, Where to buy, the
visit record. A **Connect profile** at `/producer/?id=<id>` is the business:
what they have this week, the terms, Connect, Order, **Follow** and **Share**.

The Highlighted pages used to carry the whole Available now block as well,
which made them very long and made the two products read as one thing. It came
off all three (`skehanahill`, `rathphelanfarm`, `tarahillhoney`) on 2026-10-29.
**Do not put availability back on a Highlighted page.** Where to buy keeps its
own Connect button, because that is a way to reach the farmer rather than a
produce list.

**Follow and Share live on the Connect profile, not the Highlighted page.**
Share is on every shared profile whatever the tier. The events are `follow`
and `share`, both with `surface: shared_profile`.

**Follow is a Connect Tier 1 benefit and shows only at `connect_tier` 1 and
above (2026-10-30).** It used to show for any farm on Connect. The button
promises a list by email every week, and the weekly update is the thing a
Tier 1 farm has bought: a free listing is never updated, so offering to mail
it weekly from one would be a promise nothing behind the page can keep.
Today that is **Rathphelan Farm alone**, and any farm that takes Tier 1 gets
it with no code change. **Do not widen this back to every Connect farm.**

**Follow collects an email address, not a push subscription (decided
2026-10-29).** It is a link to a sign-up form, with `producer` and `farm`
appended as query parameters so one form serves every farm. The form's address
is the `FOLLOW_FORM` constant at the top of the script in
`producer/index.html`; **while it is empty, Follow does not render at all**,
because a button that collects nothing is worse than no button. It is a plain
link and not a toggle, because the form is submitted somewhere else and never
reports back, so the page cannot honestly say whether someone is following.
The line under it sets the expectation before the press instead.

Web push was considered and rejected: it needs somewhere to keep each device's
subscription and a server holding a VAPID key, which breaks the rule that
Provenance runs no backend and no page holds a credential, and **on iPhone it
only works for someone who has added the site to their home screen**, so the
whole build would reach the smaller half of the audience. Email reaches
everyone on every device and a weekly produce list is email-shaped. The
earlier version wrote a `pv-follow-<id>` flag to `localStorage` and notified
nobody; that key is dead and nothing reads it.

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

**`updated` is what the counts stand on.** It is always on screen. Past
`CONNECT_FRESH_DAYS` (21, one constant in `connect.js`) the heading softens
from *Available now* to *Last listed* in muted grey. A list is only as
trustworthy as its date, so the date is never hidden. It used to replace stock
counts entirely; since `qty` arrived on 2026-10-30 it carries them instead, and
a farm on counts needs its date kept honest or the counts come off.

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

**No commission, ever, up to Tier 2.** Provenance takes no part in the order;
Connect goes straight to the producer's chosen channel and the shop link goes
straight to their shop. **Tier 3 is the exception and is a different thing**:
the order is placed on a Provenance page and passed to the farm, so what
Provenance takes there is unspecified and has to be settled before Tier 3 is
offered to anyone.

Still open, and needing a decision: which **map** tier a farm must hold to be
on Connect at all (availability is a producer-authored claim, which argues for
Verified as the floor, and nothing enforces a tier yet), what each Connect tier
costs, and whether any of it is self-service, which this file currently says no
paid step is.

### Navigation and profile pages

**The menu is two panels deep** (built 2026-09-24 as three, made two on 2026-11-26). Root: Provenance Connect, **Join the Connect Community**, The Provenance Collection, **Producers**, About Provenance (hidden), List Your Farm. The two sign-up links are the Zite apps and both open in a new tab: **Join the Connect Community** goes to `https://connectinterest.zite.so` and is for people who want to buy, and **List Your Farm** goes to `https://joinprovenancemap.zite.so` and is for producers (added 2026-11-05). Producers opens **one page to find a farm**: a search box over every farm, Discovered included (name, place, county, what they make), then **What they make** (the categories as chips, with their counts, over the farm list A–Z) or **County** (the counties with how many farms each). Each farm wears its pin colour as a dot. A farm's name goes to that producer's **profile page**, as it always has.

**Show on map and County light up the map (2026-11-26, the user's choice).** Beside each farm is a pin: pressed, the menu closes, the map glides to the farm and its card opens. This is a second action next to the name, chosen by the user knowing the row itself goes to the profile page, so it does not overturn that rule. A county closes the menu and sets the **same county filter the search panel has**, so the county's farms light up (its hidden Discovered farms with them, so the map shows the count the menu gave), the search bar reads the county's name and Clear all undoes it; on a phone the map then glides to fit them between the wordmark and the controls, capped at 4.5x. Desktop gets the card and the filter without the glide. Both are tracked as `menu_browse`, with `action` (`show_on_map` or `county`) and the producer or county.

**On a phone the menu is a sheet that rises from the button (2026-11-26).** It is anchored just above the menu button in the bottom-left corner and grows out of that corner, with the button turning into the close X underneath; the map stays visible and dimmed around it, and a tap on the map closes it. Each root item carries a line icon, a one-line description and a chevron (or an arrow for the two that open a new tab). Going into Producers slides sideways and the sheet grows to fit, scrolling inside itself with the search box and chips held at the top. `#menu-sheet` is the sheet; on desktop it is `display: contents`, so **the desktop menu is the full-screen one it always was**, icons and descriptions hidden.

The category names and their order are read from the map's own filter chips at load, so the menu and the filters cannot disagree about what a category is called, and a category with no producers hides exactly the way an empty chip does. Everything is built from `producers.json`, so a new listing appears in the menu the moment it appears on the map.

**Every producer has a profile page, at every tier.** Where it lives:

| The record has | The profile is at |
|---|---|
| `profile_slug` + `profile_live` | `/<profile_slug>/` — the bespoke Highlighted page (Skehana Hill, Tara Hill Honey) |
| `map_link` | that path — the built Founder pages (Newbard, Staffords, Saltrock) |
| neither | `/producer/?id=<id>` — the shared page |

`profileUrl()` implements that rule and exists in both `index.html` and `/producer/index.html`. The shared page redirects to a bespoke one if it is ever reached by a stale link, so a producer can never be shown a lesser page than they have earned.

`/producer/index.html` is set in the **Highlighted pages' language** (charcoal, Playfair, forest green, no italic), not the map's, because it is a profile page. It shows only what the record can honestly carry: a Discovered farm gets what its card has, Verified adds the practice and the attributes they confirmed, and Instagram, website and where-to-buy are gated to Highlighted **in the page code as well as in the data**, so a stray field on a free record can never put a paid benefit on a free page. The single card image is contained rather than cropped, since it is usually a logo, and `photo_bg: "white"` gives it a white ground to sit on.

**The page order, reset 2026-10-27.** Hero photograph, then name, place, produce, practice and attributes, then the farm's description, then Connect, then **Follow and Share** (added 2026-10-29), then Available now (date, terms, the grouped list, the produce gallery, Connect, and Order as a line of text underneath), then the rest. The description used to sit under the *Available now* heading, where a description of the farm read as a preamble to the produce list. The produce photographs used to hang off each list row as 96px thumbnails and are now gathered into a gallery under the list. A second group inside the list is indented off a hairline, because on a farm selling a box the cuts are what is *inside* it, not a sibling of it.

**`hero_image` turns on the hero, and nothing else does (decided 2026-10-27).** A path from the site root, with an optional `hero_focus` giving an `object-position` for when the middle is the wrong part of the shot. **`photo_url` is never promoted into the hero**: 45 of the 128 producers have a logo there, and a logo stretched across a banner looks broken. A farm gets a hero when there is a photograph of the farm to put in it, and not before, so a page without one opens exactly as it did. Decided in preference to giving logo-only farms a muted band, because the user would rather collect real photographs than paper over the gap.

### The Provenance Collection

**One-off, limited-run releases made with producers already on the map.** Each one is a product from a producer the user has met and visited, announced and documented as a storytelling piece, and never restocked. Membership is the parchment-cream `"collection": true` mark described above: it sits on top of whatever tier the producer already holds and never replaces one. First member: Galtee Honey Farm, 2026-09-19.

**Members and releases.** Galtee Honey Farm was the first member (2026-09-19). **Moyletra Moileds is the second member and the first release**: beef tallow, October 2026. Galtee's Ling Heather honey follows it. Who else holds the mark is in `producers.json`.

**How the first release works, and why it is not the model yet.** Provenance sells the product and handles fulfilment; the producer makes it. The visit and the Seal story page are free to the producer. This is deliberately a case study rather than a finished commercial arrangement: the first release exists to find out what the work actually takes before any of it is priced. Do not treat the current terms as the permanent model, and do not quote them to another producer as standard.

**Every Collection release carries a Seal story page**, reached from a QR code on the pack at `/seal/<slug>/`.

**`/collection/` is the pre-sale landing page (built 2026-10-25, Collection parchment).** People reach it from the pre-sale email's "Explore the Collection & Order" button. It carries the two first-release products (Moyletra Moileds beef tallow, Galtee Honey Farm Ling Heather honey), a Collection bundle, a short Seal explainer (the bundle-saving line and the dispatch line were both removed on 2026-11-13 at the user's request, and the user declined a delivery line again later that day; an "About the Collection" section sits above the sign-off), and each product has an order button that goes to a Stripe payment link. The links, the optional prices and sizes and the optional priority-access deadline all sit in one `COLLECTION` settings block at the bottom of `collection/index.html`, so adding them is a data edit; a button with no link stays greyed as "Opens soon" rather than going nowhere, and a price or deadline that is empty is not shown. The page carries the site's Google Analytics tag, so `/collection/` is a trackable URL with its own page views, and the order buttons fire `collection_order_click` through `pvTrack` with the product (`tallow`, `honey` or `both`) in a `product` parameter. The email link should carry UTM tags, `?utm_source=email&utm_medium=email&utm_campaign=collection_presale`, which GA reads on its own. The page is `noindex` (kept off Google until the user decides otherwise) and it did not link to the Seal story pages until 2026-11-25, when the user asked for a link from the honey panel to the Galtee Seal page ("Read the story behind this honey"). The tallow panel still carries no such link. Still to be settled: whether sold-out releases stay listed and how they read once they are gone, where a pre-sale sign-up lives and what it posts to, and whether the page carries the email list.

**The Collection on the map (2026-10-28).** The Collection colour is **parchment cream `#F3EEDD`, not silver**: the pin ring and glow, the card's plain-text "Provenance Collection" mark, the corner button text and outline, and the strip are all that cream, and the strip and the card button carry dark green text `#243629`. Four doorways lead to `/collection/`, all tracked as one analytics event, `collection_click`, with the doorway in a `surface` parameter (`menu`, `fab`, `banner`, `card_button`):

- A **menu link**, "The Provenance Collection", under Provenance Connect.
- A **corner button**, "The Collection", solid parchment cream with dark text, like the strip (it was dark for a day on 2026-10-28 and went back to cream at the user's request). Top left under the menu on phones; top right under Connect from 601px wide, because the legend takes the top left there.
- A **strip**, parchment with dark text, dismissible and remembered per visitor in `localStorage` (`pv_collection_banner_1`). Across the top on phones, across the bottom (38px, larger type) from 601px wide, where the producer counter, refresh button, install prompt and zoom control all move up by its height while it shows. `COLLECTION_BANNER_ON` in `index.html` takes it down for everyone, and **it was set to `false` on 2026-10-29 at the user's request, so the strip no longer shows**. Set it back to `true` to bring it back.
- An **Access the Collection** button on the card of a Collection member only: full width, parchment with dark text, placed with Connect above the website, directions and share row (tags, then Connect, then Access the Collection, then the links). Every other card keeps Connect in its usual place. The card's "Provenance Collection" mark itself is plain text and not a link.


**The four doorways are off (2026-11-14, at the user's request).** `COLLECTION_LINKS_ON` in `index.html` is `false`, which puts `no-collection-links` on `<body>` and hides everything carrying `data-collection-link`: the menu link, the corner button, the strip and the card button. **One flag, not four edits**, because the strip already showed how that goes wrong: it had its own switch and the other three stayed up. Set it to `true` to bring all four back.

Nothing is deleted. Markup, CSS and the `collection_click` tracking all stay. **It is a class and not a node removal on purpose**: `openCard` looks up `#card-collection` on every open and calls `classList.toggle` on it, so removing that node throws and no card opens at all. A class also survives that toggle, which an inline style would not. The rule beats `.hidden` on specificity (0,2,1 against 0,1,0), both carrying `!important`.

**`/collection/` itself is untouched and still reachable by its URL**, which is how the pre-sale email gets there. The parchment ring and the card mark came off later the same day, see below.

**The pin ring and the card mark came off too (2026-11-14, later the same day).** The same flag now takes the Collection off the map entirely, not just its links. Two more things are gated by `no-collection-links`:

- **The parchment ring on a member's pin.** Gated the other way round, with `body:not(.no-collection-links)` on the `.pin.collection .pin-dot` rules themselves rather than a counter-rule, so the pin falls back to its own tier's dot instead of needing every Verified value written out a second time to undo it. All three rules are guarded: the base, the mobile size and the launch-week glow. Verified by computed style: both members are byte-identical to an ordinary Verified pin, and no pin carries `#F3EEDD` anywhere.
- **The plain-text "Provenance Collection" mark on the card**, `display: none`.

`"collection": true` stays on both records and the `collection` class is still put on the pin. Nothing is deleted, so `COLLECTION_LINKS_ON = true` brings the links, the ring and the mark back together.
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

### 5a. Discovered producers (personal channel, map hybrid)

Set 2026-11-03 and signed off the same day. **Template:** `Carousels/discovered-producers-carousel-template.html` in the Obsidian vault (Provenance Map Obsidian), beside the new and verified producer templates. Open it in a browser, fill in the opener, one card per farm (county, name, description) and the closer, then download all as a zip. The Building Provenance plate (section 5) with the producer plate's furniture from the Verified / new-producers carousels (`connect-new-producers-export.html`) brought across. Left aligned like the personal channel, which is what keeps it apart from the centred Verified plates on the Provenance page.

- Everything in section 5 applies: flat charcoal, header row in Inter `#35663F`, hairlines at 96px and 198px, Playfair for headings and body, cream `#E8DEC8` and `#CFC6B2`.
- **Kicker above the heading:** the Discovered pin, lifted from the map's pin CSS and scaled up (22px dot, `#2A5A38`, 3px cream ring `rgba(232,222,200,0.75)`, glow `0 0 14px 4px rgba(42,90,56,0.55)`), then the place in Inter 500 22px, 0.24em tracking, uppercase, green `#45704E`. This is the one addition to section 5's two-font rule: the kicker is Inter, as on the Verified plates.
- **Farm name** in Playfair 400, about 96px. A 130px hairline `rgba(232,222,200,0.22)` under it, 46px above and below.
- **Description:** cut down from the record's own `description` in `producers.json` (or the Obsidian note), in Playfair 44px `#CFC6B2`. Do not add claims the record does not make, and never a practice or attribute: those are producer-confirmed only.
- **Source line on every producer plate,** Playfair italic 26px `#8F897B`, under the bottom hairline: "Discovered by me. Not yet confirmed by the farm."
- **Running order:** opener (pin with "New Discovered farms", the heading "Four new producers." with the right count, then the food types and "Now on the Provenance Map."). These go out every day or two, so never date the opener ("this week's") and never write "tracked down". Then one plate per farm, then the closer (pin with "Recommendations", "Know a farm that should be on the map?", asking for recommendations or a share with a local producer). The closer never mentions the farms just listed.
- **Farm plates take the county only** in the kicker, and a short description cut down from the record. Check every farm is in `producers.json` with a `date_added` in the week before calling it new.

### Heritage style

Playfair headlines, Inter body, deep green and cream on dark brown, concentric rings, gold era tags, template in `heritage-style-template.html`. Not retired, but on the back burner. Keep it in the repo and do not offer it unless the user asks.

### Carousel exports

**1080 by 1350 (4:5)**, the largest size Instagram renders in feed, unless the user says otherwise for a given piece. Canvas based, with a button per plate and a download all as a zip. Every factual plate carries a source line in its footer. (The Irish Moiled and Tallow chapters of October 2026 were built square at 1080 by 1080; the spec above applies from here.)

## Voice and Content Rules

**Three channels, never mixed.** One test for any piece: who is speaking.

| Channel | Who is speaking |
|---|---|
| Provenance | The system. Facts, label research, map growth, producer spotlights, **Verified producers**, Collection storytelling |
| Personal | Darragh. Health, building in public, farm vlogs, reasoning and decisions, **Discovered producers** |
| Athnuachan | The brand. **Shelved (2026-10-12), not deleted.** Nothing is published on it until the user reopens it |

**Producer posts split by tier (set 2026-11-03).** Discovered producers go on the personal page; Verified producers go on the Provenance page. A Discovered listing is something Darragh found and researched, not something the farm has confirmed, so it is his to present, in his voice, with that said on the plate. A Verified listing carries the farm's own confirmed details, so the system can stand over it. Never post a Discovered producer from the Provenance account, and never present one as confirmed. Highlighted producers keep their own carousel style (see above).

**The Provenance voice is the system speaking, and it may say "we".** First person plural is the system's own voice and is allowed. First person singular is not: "I" belongs to the personal channel, and the founder is never the narrator of a Provenance piece.

**No em dashes. Ever.** Not in carousels, captions, DMs, bios, emails, or on any page.

**Sourcing.** Every factual claim carries a named source on the piece itself. Anything a producer says about their own operation that cannot be checked independently is labelled as a producer statement. A claim that cannot be sourced or checked does not get published: a weaker true sentence always beats a stronger unverifiable one. **Never invent, guess or misattribute a source.** Provenance exists to expose unverified claims, so a fabricated citation is a self-inflicted wound.

## Producers

`producers.json` is the source of truth for who is listed on the map. The Obsidian vault (`1 Map/Provenance Map listings/<County>/<Producer>.md`) is the source of truth for producer detail. Never rely on a producer list written into this file.

**One note per producer, and the vault is numbered (set 2026-11-05).** A farm's map listing and its Connect listing are the same farm, so they live in the same note: there is no second note in a Connect folder. The intake template is `2 Connect/Templates/_TEMPLATE Producer intake.md` and it follows the Zite app's questions in order, covering the map listing and the Connect listing together. A Verified-only producer answers the first two sections and stops, which is a complete note rather than an unfinished one.

The vault's top-level folders are numbered so they sort by priority rather than alphabetically: `1 Map`, `2 Connect`, `3 Collection`, `4 Content`, `5 Reference`, with `_Inbox` and `_archive` beneath. `Start here.md` at the root explains it. **Do not rename `Provenance Map listings`**: the `add-producer` and `sync-producers` skills find notes by that folder name, and renaming it breaks syncing.

Front matter keys `connect`, `connect_tier`, `publish_number`, `connect_updated`, `visited` and `visit_interest` are the user's own and are **not** synced to `producers.json`. They are what the vault is searched on, with no plugin: `["connect: true"]` for the Connect farms, `["visit_interest: yes"]` for everyone worth ringing about a visit. **`visit_interest` sits at the top of the note** although it is the last question on the form, because it is the answer that decides who gets a call.

**The intake template was cut from 29 properties to 19 (2026-11-05), and the rule is that every property on it is something the producer told you.** Nothing on it is a decision the user has to make or a blank they have to leave. Three kinds of field were jumbled into one list and only the first was ever theirs to fill: what the producer said, what Provenance decides (`tier`, `practice_confirmed`), and what the sync writes back (`Listed`, `Location`, `connect_tier`, `connect_updated`, `visited`). The last two kinds came off the template and are written during the sync instead. Two more went because the answer was already on the note: **`connect_channel` was the same number as `Phone`**, and `connect_channel_type` is read from it (a mobile means WhatsApp unless *Anything else* says otherwise). `order_url` came off because it falls back to `website`. `source` became **`sent_by_them`**, a yes or no, because a two word vocabulary was one more thing to remember, and `connect_consent` became **`publish_number`**, which is the actual question being asked. The 172 notes written before this keep the old key names, so **the sync skill reads both.**

**Report back only what the user could have filled in.** Naming your own blanks as gaps is what made the Glenview Farm sync read as though half the note was missing when one field was, and even that was answerable from `Phone` and the consent answer already on the note. A missing field is one line in the report, not a table.

**A producer is listed only for what they produce themselves.** The pin covers the food they grow, raise or make on their own ground, never what they buy in, butcher or resell. If a farm sells four meats but rears two, the listing carries the two. This applies to the description as well: a clause advertising something they source elsewhere gets cut, even from a verified producer's own words, because the alternative is the map making a claim it cannot stand over. A farmer who butchers their own animals is still a producer (Staffords Butchers rear their own Angus and are listed for beef); a butcher who buys in is not.

**Where they sell comes out of the map description (set 2026-11-10).** The second cut to a producer's own words, alongside the one above. A map description says **who they are and what they produce**; the markets they stand at, the shops that stock them, the pick-up points and the opening hours all come out, even when the producer wrote them. That detail is not wrong, it is in the wrong place: a buyer deciding whether to go to a farm reads it on Connect, where `terms` exists for exactly this and where it can be kept current. A market day written into a map description is a promise the record cannot keep when the market moves.

So the verbatim rule now has two exceptions and no more: **cut what they do not produce themselves, and cut where they sell.** Everything else stays in their words, including grammar and spelling.

**Both cuts are map-only (set 2026-11-19).** They protect what the *pin* claims, so neither reaches a Connect intro. **The map pin is a claim Provenance makes; a Connect intro is the farm's own voice describing its own shop.** A farm that also carries other people's produce says so on Connect, because the sentence names them as other producers and so misleads nobody, and because a shop stocking twenty local producers is exactly what a buyer on Connect wants to know. `terms` still carries where and how they sell. **Fisherwick Farm settled it on 2026-11-19**: "We also stock northern Ireland produce from a range of local suppliers" came off their map description that morning, and "We also proudly support 20 local producers, with a focus on whole, minimally processed foods" stayed in their Connect intro the same afternoon. Do not apply either cut to `connect.intro` again. Applied on 2026-11-10 to Open Hearth Farm, whose pick-up points and Killavullen market line moved into their Connect `terms`, and to Bird & Blossom Farm, who have no Connect listing, so theirs came off entirely. **A farm with no Connect listing loses the detail rather than keeping it on the card**: that is the cost, and it was accepted, because the alternative is the map carrying stale opening hours it has no way to update.


### Never round-trip producers.json through PowerShell (2026-11-25)

**`producers.json` is UTF-8 with no BOM and it must stay that way.** On
2026-11-19, commit `4cb095a` loaded the whole file into PowerShell and wrote it
back. `Get-Content` without `-Encoding UTF8` reads a BOM-less UTF-8 file as
Windows-1252, so every multi-byte character became two or three wrong ones, and
`Set-Content` then wrote those out as UTF-8 and added a BOM:

| Was | Became | Seen on the card as |
|---|---|---|
| `Glasraí Organic Farm` | `GlasraÃ­ Organic Farm` | "GlasraA" |
| `Tomás`, `Sinéad`, `Síle`, `Füde` | `TomÃ¡s`, `SinÃ©ad`, `SÃ­le`, `FÃ¼de` | |
| `€100` | `â‚¬100` | |
| `£6`, `Bóshaille®` | `Â£6`, `BÃ³shailleÂ®` | |

The commit changed **228 lines when the edit needed 4**. It then rode along in
six further commits and onto the live site, because the damage is invisible
unless you happen to look at a record with a fada in it. The user found it by
reading a producer's name on the map.

**The rule: change only the bytes you mean to change.** Use `perl -0777 -i -pe`
or `sed -i` from the Bash tool, which are byte-safe. Reading the file in
PowerShell is fine *if* you pass `-Encoding UTF8` and write nothing back, which
is what `generate-share-pages.ps1` already does correctly
(`Get-Content -Raw -Encoding UTF8`, then `WriteAllText` with
`UTF8Encoding($false)`). It is the write-back that does the damage. The same
applies to any file carrying a producer's words, the Obsidian notes included.

**`check-encoding.ps1` is the guard**, and the `add-producer` and
`sync-producers` skills both run it before committing, beside
`check-new-producers.ps1`. It reads raw bytes and never writes, so it cannot
itself damage anything. It fails on a UTF-8 BOM, on the `C3 83` double-encode
marker, on a `C2` plus C1-control sequence, and on anything that is not valid
UTF-8. **Do not commit on a non-zero exit.**

**To repair a file that is already damaged**, reverse the one round trip rather
than hand-editing the names: decode the bytes as UTF-8, strip any BOM, then
encode back to cp1252. That yields the original bytes exactly, because the
corruption is a pure function. Two cautions learned doing it: it is **cp1252,
not Latin-1** (`€` becoming `â‚¬` rather than `â‚¬` is the tell), and cp1252
leaves five positions undefined (`0x81 0x8D 0x8F 0x90 0x9D`) which .NET passes
through as C1 controls and most encoders then refuse, so the inverse needs an
explicit table. Verify by diffing the repaired file against the last known-good
commit: **the only differences should be genuine content changes, with no
encoding differences in either direction.** Regenerate the share stubs
afterwards, since they are built from this file and carry the damage onward.
## Data Models

### Producer Profile — what shows at each tier

**Every tier (including Discovered and Verified)** shows:
- Producer name
- County / Town
- Product type
- Verification tier badge (and, for Verified, the confirmed practice pill — **organic** in dark green with a leaf icon, **regenerative** in gold with a sprout icon, and/or **Korean Natural Farming** in teal `#4A8A8A` with a fermenting crock icon; a producer can hold more than one, shown side by side. Only these three render; any other practice value shows no pill)
- Short description

**Verified only** additionally shows:
- A single image (`photo_url`): ideally the producer's **logo**, but one representative photo is fine too — never a multi-image gallery
- The confirmed practice pill (organic, regenerative and/or Korean Natural Farming)
- **Attribute pills** (`attributes` array: Grass Fed, Free range, Pasture raised, Chemical Free, Native / rare breed, Heritage breed, Pedigree breed, Native Irish Honey Bee, Heritage variety, Raw / unpasteurised, Non-Homogenised, Plastic Free)

> **Practice and attributes are producer-confirmed only.** Both come from the producer ticking boxes on the verify form, never from research, a website, or a farm's own marketing. A Discovered producer always has `"practice": "unspecified"` and `"attributes": []`. A pill reads as a claim Provenance stands over, and only the producer can earn that. Researched facts go in the description, which is understood to be secondhand. This is why a filter chip can sit empty and hidden while relevant farms are already listed — that is the correct state, not a bug.

**Provenance Highlighted and above** additionally show:
- Farm photo gallery (`photos` array — real farm/produce images, lightbox viewer)
- Instagram link
- Website link
- Where-to-buy
- Filmed farm-visit video

The rule: **the single card image begins at Verified (logo preferred, a single photo is fine); the multi-image gallery, Instagram, website, and where-to-buy begin at Highlighted.**

**`connect_photo` is a second single image, for the Connect profile only (set 2026-11-08).** A producer may give **one** photograph of their own, and it **stands in place of the logo on `/producer/`** rather than beside it. The map card keeps `photo_url`, which is the logo: a pin is an identifying mark, and the Connect profile is where someone decides whether to buy, so a real photograph of the farm does more work there than a logo does. **A farm with no logo can point both fields at the same file**, which is the fallback rather than the aim. First use: Summerville Wagyu, 2026-11-08.

It is still **one** image, contained and never cropped, so this is not the Highlighted gallery arriving early by another name: `connect_photo` is a single string, never an array, and **nothing renders it on the map card or on `/connect/`**. It is rendered larger than a logo and without the white ground (`.mark-inner.is-photo`), because the 222px cap, the padding and `photo_bg` all exist to stop a logo swimming in its box and all make a photograph needlessly small. The same Verified gate applies: a Discovered record showing neither.

**A Discovered listing is a written profile and carries no image at all (set 2026-11-08).** It used to be the one thing every tier shared, and the rule beneath it was that no producer goes on the map without a photo. That rule is gone. It was holding listings off the map for want of a logo the producer had never sent, which is backwards: a Discovered listing is researched rather than confirmed, so what it has to offer is the writing, and the image is the first thing the producer gives when they verify. Chasing a photo for a farm that has not spoken to Provenance was work spent in the wrong place.

**It is gated in the page code, not by emptying the data.** `photo_url` stays on all 66 Discovered records that had one, and neither the map card nor `/producer/` renders it while the tier is `discovered`: `cardHasImage` in `index.html` and the tier test on the single image in `producer/index.html`. So an image appears by itself the moment a producer verifies, with no data to restore. **Do not strip `photo_url` from a Discovered record**, and do not reintroduce the empty-image placeholder for them: the photo area is hidden outright, the way it already was for a farmers market, because an empty frame on a card is worse than no frame.

**The Discovered card is sized to its content (set 2026-11-08, the same day).** `#card` is pinned `top: 74px; bottom: 0`, so its height is the gap between the two whatever is inside it. That was right while every tier carried an image and the card was always roughly full. With the image gone, a Discovered listing is a name, a place, a few lines of description and a produce tag, which left about **400px of empty ground under the last line on a phone** and a card that covered the map for no reason. `#card.discovered-card` sets `top: auto; height: auto` so the sheet is anchored to the bottom alone and sized to what is in it, with `max-height: calc(100dvh - safe-area-top - 74px)` keeping the cap exactly where the old top edge was, so a long description still scrolls rather than running off the top. Measured on a 390px phone: **304px instead of 770px**. `dvh` and not `%`, because a percentage resolves against whichever box turns out to be the containing block and this has to be the viewport.

**Only Discovered.** The class is toggled in `openCard` beside `featured-card`, and Verified, Highlighted and the farmers market sheet are untouched: they carry an image and fill the screen as they always did. The earlier rule that the card has to open high enough to cover the map still holds for them. It stopped applying to Discovered when the image came off.

The body carries its own bottom padding at that tier, `safe + 78px`, rather than the usual 18px on a phone or 96px on desktop. Both of those were measured for a sheet that reached the bottom of the screen anyway; this one stops where its content stops, so it needs enough to clear the back strip and still read as a margin rather than as a crop. **Leave a gap there**: flush to the last line is what it looked like before the padding was set.

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

**One exception, at the user's request (2026-11-23): the Galtee honey page takes the Farm Direct cream-paper look.** `"theme": "farm-direct"` in a release file layers it over the base stylesheet in `generate-seal-pages.ps1`: cream `#F6EEDE` ground, near-black `#1A1B18` Playfair Display 600 headings, the wordmark gold `#B49E63` for the wordmark, the hero rule and the statement edge, and a deeper gold `#8A7540` for small capitals, because the wordmark gold is too pale to read at that size on cream. A release with no `theme` builds exactly as before, so the tallow page stays Collection charcoal.

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
