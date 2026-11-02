# Fillout prompt: the weekly list sign-up

Paste the block below into Fillout. Notes and the two things Fillout will not
do on its own are underneath.

---

```
Rebuild this email sign-up form.

PURPOSE
Somebody is on an Irish farm's page on Provenance Connect, looking at what
that farm has for sale this week. They want to be told when the farm posts
next week's list. The form collects an email address and nothing else. One
form serves every farm; which farm it is arrives on the URL.

HIDDEN FIELDS, set these first
"farm"     populated from the URL parameter "farm". Default value: "this farm"
"producer" populated from the URL parameter "producer". Default value: blank
Neither is ever shown to the person filling the form. The default on "farm"
matters: without it, anyone opening the form without the parameter sees a
sentence with a hole in it.

PAGE 1

Heading, with the farm field piped into it:
  Get {farm}'s weekly list

Subheading, with the farm field piped in again:
  Every week {farm} posts what they actually have, with the date they sent
  it. Leave your email and we will send you their list.

Field 1. Email address. Short answer, email validation, required.
  Label: Your email address
  Placeholder: name@example.com

Field 2. Consent. Single checkbox, required, with the farm field piped in.
  Label: Yes, email me {farm}'s weekly list from Provenance. I can
  unsubscribe from any of them.

Submit button: Send me the list

A small line under the button, not a field:
  One email a week about this farm. We never pass your address to anyone.

THANK YOU PAGE

Heading: You are on the list
Body, with the farm field piped in:
  {farm}'s next list will come by email. Nothing else, and there is an
  unsubscribe link on every one.
  In the meantime, their page has everything they have right now.

COPY RULES
Plain and direct, the way a person would say it. No exclamation marks, no
marketing language, nothing about journeys or communities or being excited.
Do not use em dashes anywhere; use full stops or commas. Sentence case for
every label and button, never title case.

DESIGN
Dark, quiet and editorial. Not a bright consumer form.
Page background #1A1B18. Field and card background #222320.
Borders and dividers: a single hairline #2B2C29, 1px, never thicker.
Headings in Playfair Display, regular weight, cream #E8DEC8.
Body text and field labels in Source Serif 4, light weight, cream #E8DEC8.
Helper text, placeholder text and the line under the button: #9A968B.
Submit button: background #2F5C3A, text #E8DEC8, 3px corner radius,
uppercase with wide letter spacing in Inter medium.
Button hover background #35663F. Focus and active states #5A8C64.
No italics. No gradients, no shadows, no pill shapes, no icons, no stock
imagery, no progress bar.
```

---

## What the prompt will not do for you

**The piping.** Fillout's AI builder will not reliably wire `{farm}` to the URL
parameter. After it generates the form, open each hidden field's settings and
set its value source to a URL parameter named exactly `farm` and `producer`,
lower case. Then insert the `farm` field into the heading, the subheading, the
consent line and the thank you body using Fillout's own variable picker rather
than typing the braces.

**Set the default on `farm` to "this farm".** This is the one that will bite
you. The live button on Rathphelan's page always passes the parameter, but the
moment anyone shares the bare form link, or opens it from an old message, the
heading reads "Get 's weekly list". A default turns that into "Get this farm's
weekly list", which is what the form says today anyway.

**Test it properly** by opening:
`https://provenancemap.fillout.com/t/rgzp4Act45us?producer=rathphelan-farm&farm=Rathphelan%20Farm`
You should see his name in four places. Submit once and check both columns
landed in the responses.

**The colours.** AI builders usually ignore styling instructions, so set them
in Fillout's Theme panel by hand from the list in the prompt.

## One thing I changed from the current form

The heading is cream rather than the forest green I gave you last time. Green
headings measure about 3 to 1 against that background, which is the bare floor
for large text and poor on a phone in daylight. Cream is 12.6 to 1. The same
change was made to the Connect page headline for the same reason.

## Not fixable from here

The thank you page carries a **"Make your own Fillout"** badge. That is their
free plan. It is the only thing on either screen that does not look like
Provenance, and removing it needs a paid Fillout plan.
