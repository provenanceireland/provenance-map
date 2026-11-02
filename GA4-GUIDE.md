# Reading GA4 for Provenance

How to find the numbers, written for the person looking at them rather than for
the person who wrote the tracking. For what fires where and with which
parameters, see `CONNECT-ANALYTICS.md`.

**Property: `G-Y56PR1JFH8`.** One property for the whole site. The tag is on
the map, `/connect/`, `/producer/`, `/collection/` and every bespoke
Highlighted page, so there is nowhere a visitor can go that is not counted.

---

## The one thing that confuses everyone

**Reports → Engagement → Events runs 24 to 48 hours behind.** It is built from
processed data. Anything that happened today is not in there, and that is not a
fault. If you have just pushed a post and the Events report looks empty, it is
because it is yesterday's report.

**To see what is happening now, use Realtime.**

---

## Where to click

| You want | Go to | Delay |
|---|---|---|
| Is tracking working at all? | Reports → **Realtime**, scroll to "Event count by event name" | Seconds |
| Is a specific press firing? | Admin → **DebugView** (needs debug mode on, easiest with the Google Analytics Debugger Chrome extension) | Seconds |
| How many people did X yesterday | Reports → Engagement → **Events** | 24 to 48 hours |
| Which pages they saw | Reports → Engagement → **Pages and screens** | 24 to 48 hours |
| Where they came from | Reports → Acquisition → **Traffic acquisition** | 24 to 48 hours |
| X broken down by farm, county or surface | **Explore** → Free form, drag in a custom dimension | 24 to 48 hours |

**The fastest sanity check:** open Realtime on one screen, open the page on your
phone, press Connect. It should appear within about ten seconds. If it does
not, something is actually wrong and it is worth saying so.

---

## The funnel that matters

In order. Each step should be a fraction of the one above it.

| Step | Event | Means |
|---|---|---|
| 1 | `page_view` on `/connect/` | They arrived |
| 2 | `connect_page_view` | The directory drew, carrying a `farms` count |
| 3 | `see_farm_click` | They opened a farm |
| 4 | `profile_view` | That farm's page loaded |
| 5 | **`connect_click`** | **They messaged a farmer** |

**`connect_click` is the number.** Everything else is how people got to it.

What the shape tells you:

- **High arrivals, low `see_farm_click`:** the directory is not making farms
  worth opening. A row problem.
- **High `see_farm_click`, low `connect_click`:** people are reading the farm
  and not acting. A page problem, usually copy, price or trust.
- **`connect_click` climbing:** the thing is working. That is the number to put
  in front of a producer.

---

## Every event, and whether to care

**Watch these**

| Event | Fires when | Carries |
|---|---|---|
| `connect_click` | Someone presses Connect to message a farm | producer, tier, county, `surface`, `channel` |
| `see_farm_click` | Someone opens a farm from the directory or a map card | producer, `surface` |
| `connect_page_view` | `/connect/` renders | `farms` |
| `profile_view` | Any producer profile loads | producer, tier, county, `surface` |
| `order_click` | Someone follows a farm's own shop link | producer, `surface` |

**Worth a glance**

| Event | Fires when |
|---|---|
| `follow` | Someone opens the weekly email sign-up. Rathphelan only, it is a Tier 1 benefit |
| `share` | Someone shares a producer |
| `film_play` | Someone presses play on a farm's video |
| `card_open` | A producer card opens on the map |
| `availability_shown` | A produce list renders, with how many items and whether it is fresh |
| `collection_click` | Someone goes to `/collection/`, with the doorway in `surface` |
| `collection_order_click` | Someone presses an order button on the Collection page |

**Background noise, ignore unless investigating**

`install_prompt_click`, `install_choice`, `install_dismissed`, `install_done`
(the add-to-home-screen bar), `connect_layer_click` (navigation presses),
`profile_click` (menu navigation), `qr_scan`, `availability_saved` (the
producer editor).

---

## Three traps

**1. `connect_click` fires twice on purpose.** Pressing Connect sends both
`connect_click` and a second event named for the farm, such as
`connect_click_rathphelan_farm`. That is deliberate, so you can read one farm
without building a report. It means your **total** event count is inflated, but
`connect_click` on its own is still an accurate count of presses. Read the named
one, never the total. Only `connect_click` and `order_click` do this.

**2. Custom dimensions do not backfill.** `producer`, `producer_name`, `tier`,
`county`, `surface` and `channel` are registered as custom dimensions, and GA4
only makes a parameter readable **from the moment you register it**. Anything
before that date still has the value attached to the hit but you cannot report
on it. If you add a new parameter later, register it the same day you ship it or
you lose the first weeks of it.

**3. There is no second copy.** `events_endpoint` in `connect-source.json` is
empty, so GA4 is the only record. If you ever want rows you own, that key points
at a Google Apps Script and the recipe is in `CONNECT-ANALYTICS.md`.

---

## A weekly routine

Five minutes, once a week, same day.

1. **Events report**, last 7 days. Write down `connect_page_view`,
   `see_farm_click` and `connect_click`.
2. **Explore → Free form**, dimension `producer`, metric event count, filtered
   to `connect_click`. That is which farms are actually getting messaged.
3. **Traffic acquisition**, last 7 days. Which post or channel sent them.

Number 2 is the one to send to a producer. A farmer who is told "nine people
messaged you through your page this week" understands what he is paying for.
One who is told nothing is paying for a feeling.
