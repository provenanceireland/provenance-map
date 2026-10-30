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
| `connect_click` | **The WhatsApp button is pressed** | producer set, `surface`, `channel` |
| `order_click` | **The Order button is pressed** — off to the farm's own shop | producer set, `surface` |
| `connect_layer_click` | A Connect button that is navigation, not a chat: the map card and the profile hero | producer set, `surface` |
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

## Per producer, per button, with no GA4 setup

The two commercial buttons also fire a **second event named for the farm**, so
they are readable in GA4 the moment they happen, with nothing configured:

```
connect_click_skehana_hill        order_click_skehana_hill
connect_click_rathphelan_farm     order_click_rathphelan_farm
```

**Reports → Engagement → Events.** The list shows every one with its count.
That is the answer to "how many people pressed Order for Rathphelan" with no
admin work at all. To add the page, open **Explore → Free form**, drag in
**Event name** and **Page path and screen class** as rows — both are collected
by GA4 automatically and need no registering.

This is deliberately limited to `connect_click` and `order_click`. A name per
producer per event is what blows GA4's 500-event-name ceiling, which this file
fixed once already; two names per Connect farm leaves room for roughly 240
farms before that is in sight. Every other event keeps the producer in a
parameter. The names are lower-cased, non-alphanumerics become underscores,
and they are cut to GA4's 40-character limit — checked against all 106 current
ids, no collisions.

## Reading it in GA4

Events appear in **Reports → Engagement → Events** within a few minutes, and
in **Realtime** immediately.

**The better way, and it takes five minutes.** The named events above work
with no setup, but they cannot be sliced — you get a count per farm and that is
all. Registering the parameters turns every event into something you can filter
and cross-tabulate: Order presses by county, Connect rate by tier, which
surface does the work. Go to **Admin → Custom definitions → Create custom
dimension** and add one for each, scope **Event**:

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

The cheapest thing that works, and the same shape as the availability Sheet.
**New Google Sheet → Extensions → Apps Script**, and paste this in whole:

```javascript
function doPost(e) {
  var ss = SpreadsheetApp.getActiveSpreadsheet();
  var sheet = ss.getSheetByName('events') || ss.insertSheet('events');
  if (sheet.getLastRow() === 0) {
    sheet.appendRow(['at', 'event', 'producer', 'producer name',
                     'tier', 'county', 'surface', 'channel', 'page']);
  }
  var d = {};
  try { d = JSON.parse(e.postData.contents); } catch (err) {}
  var p = d.params || {};
  sheet.appendRow([
    d.at || new Date().toISOString(),
    d.event || '',
    p.producer || '',
    p.producer_name || '',
    p.tier || '',
    p.county || '',
    p.surface || '',
    p.channel || '',
    d.page || ''
  ]);
  return ContentService.createTextOutput('ok');
}
```

Then **Deploy → New deployment → Web app**, execute as **you**, access
**Anyone**. Copy the `/exec` URL into `events_endpoint` in
`connect-source.json`, commit, push. Every click starts landing as a row.

`sendBeacon` posts as `text/plain`, which is why the script reads
`e.postData.contents` and parses it itself rather than using `e.parameter`.

**Reading it.** Insert → Pivot table on the `events` sheet: **producer** as
rows, **event** as columns, COUNTA of `at` as values. That is one grid showing,
per farm, how many opened the card, how many went to Connect, how many pressed
WhatsApp and how many pressed Order. Add **surface** as a second row field to
see which page did the work.

That grid is the thing to put in front of a producer at the end of a month, and
it is a filter on a spreadsheet rather than an export from someone else's tool.

## What is deliberately not here

No cookies of ours, no fingerprinting, no cross-site anything, and no
per-visitor identity. Provenance counts actions, not people. If a producer asks
how many people looked at their farm, the honest answer is a count of card
opens and profile views, and that is exactly what this measures.
