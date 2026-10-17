const CACHE = 'provenance-v688';
/* What the install downloads. The island artwork used to be in here, which
   made installing the app a 2MB download before it had drawn anything; it is
   cache-first like every other image, so it lands on first view instead and
   is in the cache long before anyone installs. What is left is small and is
   what the app cannot start without. */
const ASSETS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/connect.js',
  '/icons/icon-192.png',
  '/icons/icon-512.png',
  '/icons/apple-touch-icon.png'
];

self.addEventListener('install', e => {
  e.waitUntil(
    /* One at a time, not addAll. addAll rejects as a unit, so a single
       missing file failed the whole install and left the app with no cache
       and nothing offline. One renamed icon should not cost you the lot. */
    caches.open(CACHE).then(cache =>
      Promise.all(ASSETS.map(url => cache.add(url).catch(() => {})))
    )
  );
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    )
  );
  self.clients.claim();
});

self.addEventListener('fetch', e => {
  const url = new URL(e.request.url);

  // Network-first for HTML pages â€” always get fresh content
  if (e.request.destination === 'document' || url.pathname.endsWith('.html') || url.pathname === '/') {
    e.respondWith(
      fetch(e.request).then(response => {
        const clone = response.clone();
        caches.open(CACHE).then(cache => cache.put(e.request, clone));
        return response;
      }).catch(() => caches.match(e.request))
    );
    return;
  }

  // Cache-first for everything else (images, fonts, etc.)
  e.respondWith(
    caches.match(e.request).then(cached => cached || fetch(e.request))
  );
});
