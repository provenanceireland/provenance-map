# Provenance Connect, layer two — turning on live producer editing

Built 2026-09-24. **The code is done and live.** Skehana Hill's availability is
showing now, read from the `connect` block on their record in `producers.json`.

What is not done, because it needs your Google account and not mine: the Form
and the Sheet that let a producer publish their own list. Until those exist,
the editor at `/producer/edit/?id=<slug>` works as an editor but its Save says
plainly that publishing is not connected and hands over the list to send you.
It never pretends to have published.

This takes about ten minutes, once.

---

## 1. Make the Form

Google Forms, new blank form. Call it **Provenance Connect — availability**.

Two questions, both **short answer / paragraph**, both **required**:

| # | Question title | Type | Why |
|---|---|---|---|
| 1 | `Farm` | Short answer | The producer id, e.g. `skehana-hill`. The editor fills this in; a producer never sees it. |
| 2 | `Available` | Paragraph | One product per line. A dash separates an optional note: `Organic grass-fed beef — Boxes to order`. |

Keep those two words as the titles. The reader matches on them, case-insensitively, and also accepts `Available now`, `Producer`, `Produce` and a few others — but `Farm` and `Available` are what it expects.

In the form's settings, **turn off** "Collect email addresses" and "Limit to 1 response". A producer will submit many times, and they should never need a Google account.

## 2. Point it at a Sheet

On the Responses tab, link it to a new Google Sheet. Note the tab's name — it
is usually **Form responses 1**.

## 3. Share the Sheet so the map can read it

In the Sheet: **Share → General access → Anyone with the link → Viewer.**

This is the only step that can silently break the feature. The map reads the
Sheet with no key and no token, so it has to be link-readable. It contains
nothing private — farm ids and lists of produce that are about to be public
anyway.

## 4. Collect three ids

- **Sheet id** — from the Sheet's URL:
  `docs.google.com/spreadsheets/d/`**`THIS_PART`**`/edit`
- **Form id** — from the Form's *live* link (Send → link, or Preview):
  `docs.google.com/forms/d/e/`**`THIS_PART`**`/viewform`
  Not the id in the editing URL. The one after `/d/e/`.
- **The two field ids** — open the live form, View Source, and search for
  `entry.`. You want the two numbers, in question order:
  `entry.1234567890` is `Farm`, the next one is `Available`.

## 5. Fill in `connect-source.json`

```json
{
  "sheet_id": "1AbC...",
  "sheet_name": "Form responses 1",
  "form_id": "1FAIpQLSc...",
  "fields": {
    "farm": "entry.1234567890",
    "available": "entry.9876543210"
  }
}
```

Commit it, bump the service worker, push. **No code changes.** The editor's
Save starts publishing for real, and every profile page starts reading the
Sheet on load, preferring it over the record.

## 6. Prove it on Skehana Hill

Send Fintan `provenancemap.ie/producer/edit/?id=skehana-hill`. He should be
able to take the pork off and add something in under a minute, hit Save, and
see it on `provenancemap.ie/skehanahill` on a reload.

The editor confirms by re-reading the Sheet rather than by trusting the POST —
a cross-origin form post cannot be read back, so "Published" means the row was
actually seen on the Sheet, not that the request was sent.

---

## How it behaves

- **Precedence:** the Sheet wins over the record's `connect` block. Newest row
  per farm wins on the Sheet. Form responses are append-only, so an edit is a
  new row and a removal is just a shorter list — nothing is ever deleted.
- **Unreachable or unconfigured:** silent fallback to the record. A Google
  outage degrades to yesterday's list, never to a broken page.
- **Staleness:** past **21 days** without an update (`CONNECT_FRESH_DAYS` in
  `connect.js`, one constant) the heading stops saying *Available now* and
  softens to *Last listed*, in muted grey. This is what replaces stock counts:
  the list is only ever as trustworthy as its date, so the date is always on
  screen.
- **Drafts:** a half-finished list is kept in the producer's own browser so a
  closed tab loses nothing, and the page says it has not been published.

## What the editor URL is, and who should have it

`/producer/edit/?id=<producer-id>` — it is `noindex`, not linked from anywhere
public, and you hand it out. There is no login, so treat the link as the key.
Worth knowing: without the Form configured, or with it, the worst a stranger
with a link can do is add a row to your Sheet for that one farm, which you can
see and overwrite. There are no credentials on the page to steal.

If you want real per-producer auth later, that is the moment to reopen the
backend question — not now.

## Still open, from the brief

- **Which tiers can use Connect.** Availability is a producer-authored claim,
  and the map's rule is that claims are producer-confirmed, which argues for
  Highlighted as the floor. Nothing in the code enforces a tier yet.
- **Whether the monthly Connect subscription is self-service.** `CLAUDE.md`
  still says no paid step is, and that there is never a public payment link.
- **Where Connect sits in the model** — it looks like a third separate layer
  beside Featured and the Seal rather than a step between them.
