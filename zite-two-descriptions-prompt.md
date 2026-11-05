# Zite prompt: split the description in two

Paste the block below into the Zite producer app
(`joinprovenancemap.zite.so`). It changes one question and adds one.

---

```
Change the description question so the app collects two different
descriptions instead of one. They are written for two different places and
they should not be the same text.

Keep everything else exactly as it is: the visual style, colours, fonts,
section headings, spacing, inputs, buttons, the Verified skip logic and the
database.

CHANGE, in section 2 "Your map listing"

Replace the existing "Short description of your farm" question with:

  Label: A short description for the map
  Helper: This is the line on your pin on the Provenance Map, so keep it
  short. Who you are, what you produce, and what makes your place your
  place. Two or three sentences.
  Type: long text, required
  Maximum: 300 characters
  Show a live character counter under the field
  Placeholder: A family farm outside Bailieborough, Co. Cavan. We keep
  pasture-raised hens and grow no-dig vegetables, with no chemicals in the
  gardens.
  Database field: map_description

ADD, at the very start of section 3 "Products available", above the
products table

  Label: A fuller description for your Connect listing
  Helper: This one sits at the top of your own page on Provenance Connect,
  where people decide whether to buy from you. Take as much room as you
  want: the family, the ground, how you farm, how long you have been at it,
  anything you would tell someone at a market.
  Type: long text, required
  No maximum and no character counter
  Database field: connect_description

Section 3 is already skipped on the Verified-only link and for a producer
who answers Yes to being already Verified, so neither of them is asked for
a Connect description they do not need. Leave that logic alone.
```

---

## Why 300

Measured against the 132 descriptions already on the map:

| | Characters |
|---|---|
| Shortest | 58 |
| Median | 228 |
| 75% of them are under | 297 |
| 90% are under | 398 |
| Longest | 643 |

300 is about three sentences and already fits 102 of the 132, so it is short
without cutting off how people naturally write. It is a limit that bites only
on the ones that were too long for a map pin anyway.

## What changes on the site

Nothing, yet. `map_description` becomes the `description` on the record, which
is what the map card and the shared profile already show. `connect_description`
becomes `connect.intro`, which already renders at the top of a farm's Connect
listing.

The 132 producers already on the map keep the single description they have. It
stays their map line, and they have no Connect intro until they send one.
