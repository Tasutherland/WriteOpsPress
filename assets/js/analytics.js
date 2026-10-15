/* Consent-first GA4. One outbound event per activation; no pre-consent queue. */
(function () {
  'use strict';
  const script = document.getElementById('writeops-analytics');
  const measurementId = script && script.dataset.measurementId;
  if (!/^G-[A-Z0-9]+$/.test(measurementId || '')) return;

  const consentKey = 'writeops-analytics-consent-v1';
  const consentAge = 180 * 24 * 60 * 60 * 1000;
  const banner = document.getElementById('analytics-consent');
  let granted = false;
  let started = false;
  // This opt-in test mode persists only in this tab and is visible on every event.
  // It never grants analytics consent and must not be used for ordinary readers.
  const testFlag = new URLSearchParams(location.search).get('analytics_test');
  try {
    if (testFlag === '1') sessionStorage.setItem('writeops-analytics-test', '1');
    if (testFlag === '0') sessionStorage.removeItem('writeops-analytics-test');
  } catch (_) { /* Storage may be unavailable. */ }
  let testTraffic = testFlag === '1';
  try { testTraffic = sessionStorage.getItem('writeops-analytics-test') === '1'; } catch (_) { /* Keep URL value. */ }

  function readConsent() {
    try {
      const saved = JSON.parse(localStorage.getItem(consentKey));
      if (saved && Date.now() - saved.at < consentAge && saved.at <= Date.now() &&
          ['granted', 'denied'].includes(saved.choice)) return saved.choice;
    } catch (_) { /* Default to no consent. */ }
    return null;
  }

  function pageLocation() {
    const clean = new URL(location.origin + location.pathname);
    // Only deliberately simple campaign labels; never copy arbitrary query data.
    const incoming = new URLSearchParams(location.search);
    ['utm_source', 'utm_medium', 'utm_campaign', 'utm_content'].forEach(function (key) {
      const value = incoming.get(key);
      if (value && /^[a-zA-Z0-9_-]{1,80}$/.test(value)) clean.searchParams.set(key, value);
    });
    return clean.href;
  }

  function referrer() {
    try { return new URL(document.referrer).origin + '/'; } catch (_) { return ''; }
  }

  function startAnalytics() {
    if (started) return;
    started = true;
    window['ga-disable-' + measurementId] = false;
    window.dataLayer = window.dataLayer || [];
    window.gtag = function () { window.dataLayer.push(arguments); };
    window.gtag('consent', 'default', {
      analytics_storage: 'denied', ad_storage: 'denied',
      ad_user_data: 'denied', ad_personalization: 'denied'
    });
    window.gtag('consent', 'update', { analytics_storage: 'granted' });
    window.gtag('js', new Date());
    window.gtag('config', measurementId, {
      send_page_view: false,
      page_location: pageLocation(), page_referrer: referrer(),
      allow_google_signals: false, allow_ad_personalization_signals: false,
      cookie_expires: 15552000, cookie_update: false,
      traffic_type: testTraffic ? 'developer' : undefined,
      test_traffic: testTraffic ? 'yes' : 'no',
      debug_mode: testTraffic
    });
    const tag = document.createElement('script');
    tag.async = true;
    tag.src = 'https://www.googletagmanager.com/gtag/js?id=' + measurementId;
    document.head.appendChild(tag);
    window.gtag('event', 'page_view', {
      page_location: pageLocation(), page_referrer: referrer(), page_title: document.title,
      source_page: location.pathname, test_traffic: testTraffic ? 'yes' : 'no',
      debug_mode: testTraffic
    });
  }

  function clearAnalyticsCookies() {
    document.cookie.split(';').forEach(function (part) {
      const name = part.trim().split('=')[0];
      if (!/^_ga(?:_|$)/.test(name)) return;
      const expire = name + '=; Max-Age=0; path=/; SameSite=Lax';
      document.cookie = expire;
      const parts = location.hostname.split('.');
      for (let i = 0; i < parts.length - 1; i += 1) {
        document.cookie = expire + '; domain=.' + parts.slice(i).join('.');
      }
    });
  }

  function applyConsent(choice) {
    granted = choice === 'granted';
    if (granted) startAnalytics();
    else {
      // Disable first: even a queued tag load cannot send on a revoked page.
      window['ga-disable-' + measurementId] = true;
      clearAnalyticsCookies();
    }
  }

  function choose(choice) {
    const wasStarted = started;
    try { localStorage.setItem(consentKey, JSON.stringify({choice: choice, at: Date.now()})); } catch (_) { /* Page-only choice. */ }
    applyConsent(choice);
    if (banner) banner.hidden = true;
    const status = document.getElementById('analytics-settings-status');
    if (status) status.textContent = granted ? 'Analytics is enabled.' : 'Analytics is disabled.';
    // A loaded Google script cannot be unloaded. Reload after revocation to
    // guarantee that no later enhanced/engagement events can run on this page.
    if (!granted && wasStarted) location.reload();
  }

  function retailerFor(url) {
    const host = url.hostname.toLowerCase();
    if (/^(www\.)?amazon\.(com|ca|co\.uk|com\.au|de|fr|it|es|co\.jp|in|com\.mx|nl|com\.br|se|pl|com\.be)$/.test(host)) return 'amazon';
    if (host === 'kobo.com' || host.endsWith('.kobo.com')) return 'kobo';
    if (host === 'books.apple.com') return 'apple_books';
    if (host === 'barnesandnoble.com' || host.endsWith('.barnesandnoble.com')) return 'barnes_noble';
    if (host === 'books2read.com' || host.endsWith('.books2read.com')) return 'universal';
    return '';
  }

  function outbound(event) {
    if (!granted || !started || (event.type === 'auxclick' && event.button !== 1)) return;
    const link = event.target.closest('a[href]');
    if (!link || link.hasAttribute('download')) return;
    let url;
    try { url = new URL(link.href, location.href); } catch (_) { return; }
    if (!['https:', 'http:'].includes(url.protocol) || url.origin === location.origin ||
        ['writeopshq.com', 'www.writeopshq.com'].includes(url.hostname)) return;
    const retailer = retailerFor(url);
    const context = link.closest('[data-book-title]');
    const data = context ? context.dataset : {};
    const parameters = {
      link_domain: url.hostname, link_url: url.origin + url.pathname,
      outbound: true, source_page: location.pathname,
      test_traffic: testTraffic ? 'yes' : 'no', debug_mode: testTraffic,
      transport_type: 'beacon'
    };
    if (retailer && data.bookTitle) {
      Object.assign(parameters, {
        book_title: data.bookTitle, work_id: data.workId || 'unavailable',
        book_format: data.edition || 'ebook', retailer: retailer,
        author_name: data.author || 'unavailable',
        store_region: link.dataset.storeRegion || (retailer === 'kobo' ? url.pathname.split('/')[1] : 'other'),
        link_placement: link.dataset.linkPlacement || data.linkPlacement || 'direct'
      });
      window.gtag('event', 'retailer_click', parameters);
    } else {
      window.gtag('event', 'outbound_click', parameters);
    }
  }

  document.addEventListener('click', function (event) {
    const choice = event.target.closest('[data-analytics-choice]');
    if (choice) choose(choice.dataset.analyticsChoice);
    const settings = event.target.closest('[data-analytics-settings]');
    if (settings && banner) {
      banner.hidden = false;
      banner.querySelector('button').focus();
    }
    outbound(event);
  });
  document.addEventListener('auxclick', outbound);
  window.addEventListener('storage', function (event) {
    if (event.key !== consentKey) return;
    const choice = readConsent();
    const mustReload = started && choice !== 'granted';
    applyConsent(choice);
    if (banner) banner.hidden = choice !== null;
    if (mustReload) location.reload();
  });
  const initialChoice = readConsent();
  applyConsent(initialChoice);
  if (banner) banner.hidden = initialChoice !== null;
})();
