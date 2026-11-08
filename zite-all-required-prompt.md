# Zite prompt: make every question compulsory

Paste the block below into the Zite producer app
(`joinprovenancemap.zite.so`). It changes nothing except which questions a
producer can skip.

---

```
Make every question in this app required, so the form cannot be submitted
with a question left blank.

Change nothing else at all: the visual style, colours, fonts, section
headings, order of questions, helper text, placeholders, field types,
character limits, the Verified skip logic, and the database field names all
stay exactly as they are.

THE ONE QUESTION THAT CHANGES THE MOST

"A fuller description for your Connect listing" (database field
connect_description) is currently optional. Make it required, like
everything else.

HOW "REQUIRED" SHOULD BEHAVE

Required means the producer has to answer, not that they have to invent
something they do not have. For every question where "none" is a real and
honest answer, keep it required but give them a way to say none, rather than
blocking the form:

  - Website, Instagram: add a "I don't have one" tick box beside the field.
    Ticking it satisfies the requirement and saves an empty value.
  - Certifier: only required when Farming Practice is an answer that names a
    certification. If they are not certified, it is not asked at all.
  - Collection Details: only required when they answered Yes to collection.
  - Online Ordering Link: only required when they answered Yes to having
    their own online shop.
  - Farmers Markets: keep required, and add "We don't do markets" as a
    choice.
  - Contact Instructions: add "Any time is fine" as a choice.
  - Eircode: the map covers all thirty-two counties, so a producer in the six
    counties has a UK postcode and not an Eircode. Relabel it "Eircode or
    postcode" and accept either.

Everything else becomes plainly required with no escape hatch: business name,
contact name, email, phone, main produce, map description, connect
description, town, county, farming practice, produce attributes, profile
image, the delivery and collection questions, contact method, contact value,
contact consent, the products table, and the promotion, visit and updates
questions.

A required question that is skipped for a given producer by the existing
Verified logic stays skipped. Section 3 is already skipped on the
Verified-only link and for a producer who answers Yes to being already
Verified, so neither of them is ever asked for a Connect description or a
products table. Leave that logic exactly as it is.

Show the validation message under the field it belongs to, in the app's
existing style, and do not let the submit button move the producer past a
section with an unanswered question in it.
```

---

## Why the escape hatches

"Every question required" and "every question answerable" are not the same
thing, and the gap between them is where a real producer gets stuck at the
last step and gives up.

Of the farms already through the form:

| | What would have blocked them |
|---|---|
| Four Leaf Farm | No website. They gave an Instagram URL in the website field to get past it, which is why their record had a social link sitting in the wrong place |
| Castlescreen Organic Farm | No Instagram |
| Summerville Wagyu | No Instagram, no farmers markets |
| Glenview Farm | No markets, and nothing to say in contact instructions |
| Castlescreen, Four Leaf | In the six counties, so a UK postcode rather than an Eircode |

Every one of those is an honest "none", not a producer being lazy. A tick box
or a "none" choice still forces them to answer, which is what compulsory is
for: it tells us the answer is genuinely nothing, instead of leaving us to
guess whether they skipped it or do not have one. That distinction is the
whole value of the change.

## What this does not fix

The form still does not ask for the **Connect photo** (`connect_photo`), the
single photograph that now stands in place of the logo on a producer's Connect
profile. That is a separate question to add when you want it, and it should be
optional rather than required: a logo is the fallback, and a farm with no
photograph of their own should not be stopped from listing.
