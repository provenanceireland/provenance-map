# Brief: Provenance Connect, layer two — availability

Written 2026-09-24. Paste this, or just say **"read CONNECT-BRIEF.md"**.

---

## What this is

Add an **availability layer** to Provenance Connect. A producer's profile gains
an optional Connect section saying **what they currently have**, and a Connect
button that sends the customer to whatever channel that producer chose.

**Build it on top of the existing map. Do not rebuild anything.** Connect layer
one already ships: a `whatsapp` number on a record puts a Connect button on the
map card and at the head of the profile page's link row, and `/connect/` lists
every producer who has one. This is layer two on that foundation.

## The one principle

**"What do you currently have", not "how many do you have."**

No quantities. No stock counts. No auto-deduction. No carts. A producer writes
**Grass-fed beef**, **Free-range eggs**, **Ling heather honey** — product types
in their own words — and updates it weekly or seasonally when it changes. If it
ever asks a farmer to count something, it is wrong.

## Hard requirements

1. **Free text, not a preset list.** A producer must be able to type
   `Ling heather honey` and have it show exactly that. Do not constrain
   availability to the `product_type` slugs the filters use — those stay as they
   are, for the map. Availability is the producer's own words.
2. **Updating takes seconds.** A list editor: add a line, remove a line, done.
   No multi-step form, no required fields beyond the name, no quantity field
   anywhere in the UI or the data.
3. **The Connect button goes where the producer says.** WhatsApp, their own
   website, phone or email — their choice, one channel, their call.
4. **No commission, no transactions.** Provenance never touches an order. The
   commercial model is a **monthly producer subscription** for being in the
   Connect network. Build no payment flow as part of this.
5. **The consumer path stays light:** browse the map, open a farm, see what's
   available, connect directly. Four steps, no account, no login.
6. **Leave a hole for Connect Plus** (chatbots, digital tools) and nothing more
   than a hole. One empty key in the data structure. No abstractions, no
   interfaces, no "pluggable" anything for a product that does not exist yet.

## Proposed data shape

On the producer's record in `producers.json`:

```json
"connect": {
  "active": true,
  "channel": { "type": "whatsapp", "value": "087 947 8954" },
  "updated": "2026-09-24",
  "available": [
    { "name": "Grass-fed beef", "note": "Boxes to order" },
    { "name": "Free-range eggs" },
    { "name": "Seasonal vegetables", "note": "Kale, leeks and roots" }
  ],
  "plus": {}
}
```

- `available[].name` — the producer's own words. No quantity field, by design.
- `available[].note` — optional prose, if they want to say *boxes to order* or
  *ready in a fortnight*. Prose, never a number field.
- `channel.type` — `whatsapp` | `website` | `phone` | `email`.
- `updated` — the date the producer last touched the list. **Load-bearing; see
  below.**
- `plus` — empty. Nothing reads it. That is the whole of the Connect Plus work.
- Absent or `"active": false` renders nothing, the same way an empty `whatsapp`
  number does today.

**Migrating layer one:** the bare `whatsapp` field on a record must keep
working. Treat `connect.channel` as the override when present, and do not
rewrite the existing records as part of this.

## `updated` is what replaces stock counts

This is the part worth getting right. Without quantities, the only thing making
"available now" honest is **how recently the producer said so**. So:

- Show the date plainly on the profile — *Updated this week*, *Updated
  19 September*.
- After a cutoff with no update, the section **stops claiming "now"**: it
  either softens to a "last listed" wording or hides entirely.

**Decision needed from Darragh: what the cutoff is** (a fortnight? a month?) and
whether a stale list softens or disappears. Pick a sensible default, implement
it as one named constant, and say in your reply what you chose.

## Where it shows

- **The profile page** carries the full list. This is the Connect section's home.
  Note there are two kinds of profile page: the bespoke Featured pages
  (`/skehanahill/`, `/tarahillhoney/`) and the shared one
  (`/producer/?id=<slug>`). Connect must work on both.
- **The map card** gets a light touch only — a single line, or a mark that there
  is availability, and nothing more. The card was just stripped of four rows of
  pills for being cluttered; do not grow it again. Its job is to send people to
  the profile.
- **`/connect/`** should reflect availability, since it is already the Connect
  index.

Everything labelling a producer is **text, not a badge** — see the
"card states things, it does not badge them" section in `CLAUDE.md`. No pills.

## The thing that blocks the editor — read this before designing it

The brief asks for a producer-facing control section that **updates the public
profile immediately**. As the platform stands, that is not possible, and the
reason matters:

> Provenance Map is a static PWA on GitHub Pages. `producers.json` is a file in
> the repo. There is no backend, no auth and no write path. A browser cannot
> write to it, and a change only goes public after a git commit and a Pages
> deploy (about a minute).

So "immediately" forces a choice about **where availability is stored**:

- **(A) Stays in `producers.json`.** Zero new infrastructure, consistent with
  everything else, and the public side can ship today. But there is no producer
  editor: the producer messages Darragh, or fills a short form, and he pushes.
  Seconds of his time, not theirs. Not self-service, and not immediate.
- **(B) Lives in a small hosted store**, read by the page at load. This is what
  makes a real editor and genuine immediacy possible. Costs a runtime
  dependency, a login for producers, and a new failure mode on the profile page.

**Do not pick this yourself and do not fake it.** Never build an editor that
appears to save and does not. Build the **public read side and the data shape
first** — that is valuable on its own and identical under either choice — then
put the question to Darragh with a recommendation.

## Also needs deciding, so ask rather than assume

- **Which tiers can use Connect.** Availability is a producer-authored claim,
  and `CLAUDE.md`'s rule is that claims on the map are producer-confirmed. That
  argues Connect needs at least **Highlighted**, where the producer has
  confirmed their own details. Not settled.
- **Whether the subscription is self-service.** `CLAUDE.md` currently says no
  paid step is self-service and there is never a public payment link. A monthly
  Connect subscription either changes that or is sold through a conversation
  like the others.
- **Where Connect sits in the model.** Featured and the Seal are explicitly
  *separate layers, not a ladder*. Connect looks like a third such layer rather
  than a step between them.

## Out of scope

Stock counts, quantity fields, auto-deduction, carts, checkout, payments,
commission, delivery, order history, producer accounts beyond what the editor
decision requires, chatbots, and every Connect Plus feature other than the
empty `plus` key.

## When you are done

Bump the `service-worker.js` cache, commit, push, confirm the deploy went live,
and update `CLAUDE.md` with the Connect layer two data model — the same way
layer one is recorded there.
