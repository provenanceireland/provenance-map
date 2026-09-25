# Analytics on the Connect layer

Built 2026-09-25. Live now, no setup needed: the site already carries GA4
(`G-Y56PR1JFH8`) and every event below is firing into it from the moment it
deploys.

---

## The one funnel

Every event on the map goes through **`pvTrack(name, params)`** in
`connect.js`. Nothing calls `gtag` directly any more. It fans out to three
destinations, all optional and independent:

1. **GA4**, whenever `gtag` is on the page. This is on today.
2. **`window.PV_TRACK`**, if a page defines one. The hook for any other tool —
   Plausible, Fathom, a tag manager, a console logger while testing. Define it
   before `connect.js` loads and it receives every event.
3. **`events_endpoint`** in `connect-source.json`, posted with `sendBeacon`.
   Empty by default. See "Owning the raw log" below.

Swapping analytics tool is one function, not thirty call sites.

## What is tracked

| Event | Fires when | Parameters |
|---|---|---|
| `connect_page_view` | `/connect/` loads | `farms` |
| `card_open` | A producer's card opens on the map | producer set, `has_availability` |
| `profile_view` | Any producer profile page loads | producer set, `surface` |
| `availability_shown` | A Connect list is rendered anywhere | producer set, `surface`, `items`, `fresh` |
| `connect_click` | The Connect button is pressed | producer set, `surface`, `channel` |
| `profile_click` | The Highlighted Profile button on a card | producer set, `surface` |
| `see_farm_click` | "See the farm" on `/connect/` | producer set, `surface` |
| `share` | A producer is shared | producer set, `surface` |
| `qr_scan` | A page opened from a QR sticker (`?src=qr`) | `producer`, `surface` |
| `availability_saved` | A producer saves their list in the editor | `producer`, `items`, `published` |

**The producer set** on every producer event: `producer` (the id),
`producer_name`, `tier`, `county`.

**`surface`** says where it happened: `map_card`, `shared_profile`,
`featured_profile`, `featured_hero`, `connect_page`.

Nothing personal is ever sent. An id, a tier, a county, a surface, a count.

## The three numbers asked for

- **How many people click Connect** — `connect_click`, split by `producer` and
  by `surface` to see whether the card or the profile is doing the work.
- **How many people visit a profile** — `profile_view`, split by `producer`.
- **How many people visit Provenance Connect** — `connect_page_view`.

And the ones that make those numbers mean something:

- **Connect rate**: `connect_click` over `availability_shown`, per producer.
  This is the number that tells a producer what the subscription buys them.
- **Card to profile**: `profile_click` over `card_open`.
- **Is the producer keeping it current**: `availability_saved` per producer per
  month, against the *Last listed* state a stale list falls into after 21 days.

## Reading it in GA4

Events appear in **Reports → Engagement → Events** within a few minutes, and
in **Realtime** immediately.

**One setup step, and it matters.** GA4 will not let you *break down* by a
custom parameter until you register it. Go to **Admin → Custom definitions →
Create custom dimension** and add one for each, scope **Event**:

| Dimension name | Event parameter |
|---|---|
| Producer | `producer` |
| Producer name | `producer_name` |
| Tier | `tier` |
| County | `county` |
| Surface | `surface` |
| Channel | `channel` |

Until then the events count correctly but every one looks the same. GA4 only
collects dimension data from the moment it is registered, so do this early.

**Why the event names are few.** They used to be one name per producer
(`skehana-hill-share`). GA4 caps an account at 500 distinct event names, and
106 producers times a handful of actions goes through that ceiling and then
silently drops the rest. Producers are parameters now. That change is already
applied to the old share and QR events.

## Owning the raw log

GA4 is fine for counts but it is not yours and it is awkward to put a number in
front of a producer. For that, set `events_endpoint` in `connect-source.json`
and every event is also posted as JSON to that URL with `sendBeacon`.

The cheapest thing that works, and the same shape as the availability Sheet:

1. New Google Sheet, **Extensions → Apps Script**.
2. A `doPost(e)` that appends `JSON.parse(e.postData.contents)` as a row.
3. **Deploy → New deployment → Web app**, execute as you, access **Anyone**.
4. Paste the `/exec` URL into `events_endpoint`, commit, push.

Then a producer's numbers are a filter on a Sheet, and a monthly line for them
is a formula rather than an export. No backend, same trade as the availability
Sheet: it is Google's, and it is free.

The payload is `{ event, at, page, params }`.

## What is deliberately not here

No cookies of ours, no fingerprinting, no cross-site anything, and no
per-visitor identity. Provenance counts actions, not people. If a producer asks
how many people looked at their farm, the honest answer is a count of card
opens and profile views, and that is exactly what this measures.
