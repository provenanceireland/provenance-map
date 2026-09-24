/* Provenance Connect, layer two: availability.
   ────────────────────────────────────────────────────────────────────────
   What a producer currently has, in their own words. No quantities, here or
   in the data — "what do you have", never "how many do you have".

   Two sources, in order of precedence:

   1. A published Google Sheet fed by a Google Form. This is the live one.
      The producer edits their list in our own editor (/producer/edit/), which
      posts to the Form, which appends a row to the Sheet, which every profile
      page reads on load. No backend of ours, no credentials in the page, and
      an update is public on the next page load.

   2. The `connect` object on the producer's record in producers.json. The
      fallback, and what Provenance can always set by hand.

   Unconfigured or unreachable, (1) is skipped in silence and (2) renders. The
   feature therefore works before the Sheet exists and upgrades to live
   producer editing the moment it does, with no code change — only
   connect-source.json.

   Loaded as <script src="/connect.js?v=N"></script>. Bump N with the service
   worker cache, because the worker is cache-first for anything that is not a
   page. */

/* Past this many days without an update, the list stops claiming the present
   tense: the heading softens from "Available now" to "Last listed". This is
   the whole honesty mechanism that replaces stock counts, so it is one
   constant in one place. */
var CONNECT_FRESH_DAYS = 21;

var CONNECT_SOURCE = null;   // connect-source.json, once fetched
var CONNECT_LIVE = {};       // { producerId: { available, updated } }

/* Irish numbers are written as dialled (087...) and normalised to 353. */
function connectWhatsapp(number, name) {
  if (!number) return '';
  var d = String(number).replace(/[^0-9+]/g, '');
  if (d.charAt(0) === '+') d = d.slice(1);
  if (d.slice(0, 2) === '00') d = d.slice(2);
  if (d.charAt(0) === '0') d = '353' + d.slice(1);
  if (!/^\d{9,15}$/.test(d)) return '';
  return 'https://wa.me/' + d + '?text=' + encodeURIComponent(
    'Hi, I found your farm on the Provenance Map and would love to learn more about what you have available.');
}

function connectDays(updated) {
  if (!updated) return null;
  var d = new Date(String(updated).slice(0, 10) + 'T00:00:00');
  if (isNaN(d.getTime())) return null;
  return Math.floor((Date.now() - d.getTime()) / 86400000);
}

function connectWhen(days, updated) {
  if (days === null) return '';
  if (days <= 0) return 'Updated today';
  if (days === 1) return 'Updated yesterday';
  if (days <= 7) return 'Updated this week';
  if (days <= 14) return 'Updated last week';
  var d = new Date(String(updated).slice(0, 10) + 'T00:00:00');
  return 'Updated ' + d.getDate() + ' ' + ['January','February','March','April','May','June',
    'July','August','September','October','November','December'][d.getMonth()];
}

/* The effective list for a producer: the live row if there is one, otherwise
   whatever the record carries. */
function connectFor(producer) {
  if (!producer) return null;
  var live = CONNECT_LIVE[producer.id];
  var base = producer.connect || null;
  if (live && live.available && live.available.length) {
    // The sheet carries names and notes. The buying options and the produce
    // photos stay on the record, matched back by name, because a producer
    // types a list in a box and does not re-type those every week.
    var keep = {};
    ((base && base.available) || []).forEach(function (a) {
      if (a && a.name) keep[String(a.name).toLowerCase().trim()] = a;
    });
    var merged = live.available.map(function (a) {
      var was = keep[String(a.name).toLowerCase().trim()];
      if (!was) return a;
      return { name: a.name, note: a.note || was.note, options: was.options, photo: was.photo };
    });
    return {
      active: true,
      channel: (base && base.channel) || (producer.whatsapp ? { type: 'whatsapp', value: producer.whatsapp } : null),
      updated: live.updated,
      intro: (base && base.intro) || '',
      available: merged,
      plus: (base && base.plus) || {},
      source: 'live'
    };
  }
  if (!base || base.active === false) return null;
  var b = {};
  for (var k in base) if (Object.prototype.hasOwnProperty.call(base, k)) b[k] = base[k];
  if (!b.channel && producer.whatsapp) b.channel = { type: 'whatsapp', value: producer.whatsapp };
  b.source = 'record';
  return b;
}

/* null when there is nothing worth showing. */
function connectState(producer) {
  var c = connectFor(producer);
  if (!c) return null;
  var items = (c.available || []).filter(function (a) { return a && a.name; });
  if (!items.length) return null;
  var days = connectDays(c.updated);
  var fresh = days !== null && days <= CONNECT_FRESH_DAYS;
  return {
    items: items,
    days: days,
    fresh: fresh,
    updated: c.updated || '',
    when: connectWhen(days, c.updated),
    heading: fresh ? 'Available now' : 'Last listed',
    intro: c.intro || '',
    channel: connectChannel(producer, c),
    source: c.source
  };
}

/* The one button, pointing wherever the producer chose. */
function connectChannel(producer, c) {
  c = c || connectFor(producer) || {};
  var ch = c.channel || (producer.whatsapp ? { type: 'whatsapp', value: producer.whatsapp } : null);
  if (!ch || !ch.value) return null;
  var v = String(ch.value);
  if (ch.type === 'whatsapp') { var u = connectWhatsapp(v, producer.name); return u ? { url: u, label: 'Connect', kind: 'whatsapp' } : null; }
  if (ch.type === 'website')  return { url: v, label: 'Connect', kind: 'website' };
  if (ch.type === 'phone')    return { url: 'tel:' + v.replace(/[^0-9+]/g, ''), label: 'Call the farm', kind: 'phone' };
  if (ch.type === 'email')    return { url: 'mailto:' + v, label: 'Email the farm', kind: 'email' };
  return null;
}

/* One typed line from the editor or the Form becomes one item. A dash or a
   pipe splits the name from an optional note, so "Beef boxes — ready Friday"
   reads correctly. There is deliberately nowhere for a number to go. */
function connectParseLine(line) {
  var s = String(line == null ? '' : line).trim();
  if (!s) return null;
  var m = s.match(/^(.*?)\s+(?:—|–|--|\||:)\s+(.*)$/);
  if (m && m[1].trim()) return { name: m[1].trim(), note: m[2].trim() };
  return { name: s };
}
function connectParseList(text) {
  return String(text == null ? '' : text).split(/\r?\n/).map(connectParseLine).filter(Boolean);
}
function connectToText(items) {
  return (items || []).filter(function (a) { return a && a.name; })
    .map(function (a) { return a.note ? a.name + ' — ' + a.note : a.name; }).join('\n');
}

/* ── the live source ─────────────────────────────────────────────────────
   connect-source.json holds the Sheet and Form ids. Empty values mean the
   Sheet does not exist yet, which is a normal state, not an error. */
function connectLoadSource() {
  if (CONNECT_SOURCE) return Promise.resolve(CONNECT_SOURCE);
  var base = (document.querySelector('script[src*="connect.js"]') || {}).src || '';
  var root = base ? base.replace(/connect\.js.*$/, '') : '/';
  return fetch(root + 'connect-source.json?v=' + Date.now(), { cache: 'no-store' })
    .then(function (r) { return r.ok ? r.json() : null; })
    .then(function (j) { CONNECT_SOURCE = j || {}; return CONNECT_SOURCE; })
    .catch(function () { CONNECT_SOURCE = {}; return CONNECT_SOURCE; });
}

/* Reads the published Sheet through the gviz endpoint, which needs no API key
   and no token — only that the Sheet is shared so anyone with the link can
   view it. The newest row per farm wins; Form responses are append-only, so
   an edit is a new row and a removal is a shorter list. */
function connectLoadLive() {
  return connectLoadSource().then(function (src) {
    if (!src || !src.sheet_id) return {};
    var url = 'https://docs.google.com/spreadsheets/d/' + encodeURIComponent(src.sheet_id) +
      '/gviz/tq?tqx=out:json&headers=1' +
      (src.sheet_name ? '&sheet=' + encodeURIComponent(src.sheet_name) : '');
    return fetch(url, { cache: 'no-store' })
      .then(function (r) { return r.ok ? r.text() : ''; })
      .then(function (text) {
        var m = text.match(/setResponse\(([\s\S]*?)\);?\s*$/);
        if (!m) return {};
        var data = JSON.parse(m[1]);
        var cols = ((data.table || {}).cols || []).map(function (c) { return String(c.label || '').toLowerCase().trim(); });
        var iFarm = connectFindCol(cols, ['farm', 'producer', 'farm id', 'producer id', 'id']);
        var iList = connectFindCol(cols, ['available', 'available now', 'what do you have', 'produce']);
        var iTime = connectFindCol(cols, ['timestamp', 'time', 'date', 'submitted']);
        if (iFarm < 0 || iList < 0) return {};
        var out = {};
        ((data.table || {}).rows || []).forEach(function (row) {
          var cells = row.c || [];
          var farm = connectCell(cells[iFarm]);
          var list = connectCell(cells[iList]);
          if (!farm) return;
          farm = farm.trim();
          var stamp = iTime >= 0 ? connectStamp(cells[iTime]) : null;
          var prev = out[farm];
          if (prev && prev.stampMs != null && stamp != null && stamp <= prev.stampMs) return;
          out[farm] = {
            available: connectParseList(list),
            updated: stamp != null ? new Date(stamp).toISOString().slice(0, 10) : '',
            stampMs: stamp
          };
        });
        CONNECT_LIVE = out;
        return out;
      })
      .catch(function () { return {}; });
  });
}

function connectFindCol(cols, names) {
  for (var i = 0; i < cols.length; i++) {
    for (var j = 0; j < names.length; j++) {
      if (cols[i] === names[j] || cols[i].indexOf(names[j]) === 0) return i;
    }
  }
  return -1;
}
function connectCell(cell) { return cell && cell.v != null ? String(cell.v) : ''; }
/* gviz hands back dates as the literal string "Date(2026,8,24,10,30,0)". */
function connectStamp(cell) {
  if (!cell) return null;
  var v = cell.v;
  if (v instanceof Date) return v.getTime();
  var s = String(v == null ? '' : v);
  var m = s.match(/^Date\((\d+),(\d+),(\d+)(?:,(\d+),(\d+),(\d+))?\)$/);
  if (m) return new Date(+m[1], +m[2], +m[3], +(m[4] || 0), +(m[5] || 0), +(m[6] || 0)).getTime();
  var d = new Date(s);
  return isNaN(d.getTime()) ? null : d.getTime();
}

/* Shared markup for the list. Each page brings its own CSS.
   An item can carry `options` — the brackets an animal is sold in, quarter,
   half, whole or individual cuts — and a `photo`, which is a path from the
   site root so it resolves the same from any page depth. Both are optional
   and absent for most produce. */
function connectListHTML(items, escFn) {
  var e = escFn || function (s) {
    return String(s == null ? '' : s).replace(/[&<>"]/g, function (c) {
      return ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[c];
    });
  };
  return items.map(function (a) {
    var opts = (a.options || []).filter(Boolean);
    var photo = a.photo ? '<span class="a-photo"><img src="' + e(a.photo) + '" alt="' + e(a.name) + '" loading="lazy" /></span>' : '';
    return '<li>' + photo + '<span class="a-txt">' +
      '<span class="a-name">' + e(a.name) + '</span>' +
      (a.note ? '<span class="a-note">' + e(a.note) + '</span>' : '') +
      (opts.length ? '<span class="a-opts">' + opts.map(function (o) { return '<span>' + e(o) + '</span>'; }).join('') + '</span>' : '') +
      '</span></li>';
  }).join('');
}

var CONNECT_ICON = '<svg viewBox="0 0 24 24"><path d="M21 12a8.5 8.5 0 0 1-12.6 7.4L4 21l1.6-4.4A8.5 8.5 0 1 1 21 12z"/></svg>';
