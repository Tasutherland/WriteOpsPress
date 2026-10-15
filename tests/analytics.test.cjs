const { test } = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const { JSDOM } = require('jsdom');
const analytics = fs.readFileSync('assets/js/analytics.js', 'utf8');
const main = fs.readFileSync('assets/js/main.js', 'utf8');

function page({url = 'https://writeopshq.com/books/', saved, storageBlocked = false} = {}) {
  const dom = new JSDOM(`<!doctype html><html><head><title>Books</title>
    <script id="writeops-analytics" data-measurement-id="G-TEST123"></script></head><body>
    <section id="analytics-consent" hidden><button data-analytics-choice="denied">Reject</button><button data-analytics-choice="granted">Accept</button></section>
    <button data-analytics-settings>Settings</button>
    <article data-book-title="Captured by the Enforcer" data-work-id="W0092" data-author="Rook Brennan" data-edition="ebook" data-link-placement="book_tile">
      <a id="ebook" href="https://www.kobo.com/ca/en/ebook/captured?token=private#private">Ebook</a>
      <button class="buy-btn" data-title="Captured by the Enforcer" data-stores='{"us":"https://www.amazon.com/dp/B0GHS3ZQFT","ca":"https://www.amazon.ca/dp/B0GHS3ZQFT"}'>Choose Store</button>
      <a id="audio" href="https://www.kobo.com/ca/en/audiobook/captured" data-book-title="Captured by the Enforcer" data-work-id="W0092" data-author="Rook Brennan" data-edition="audiobook">Audio</a>
    </article>
    <a id="generic" href="https://example.com/about?email=private">External</a>
    <a id="email" href="mailto:someone@example.com">Mail</a>
    <a id="internal" href="/books/example/">Detail</a>
    <div id="buy-modal" hidden><h2 id="modal-title"></h2><div id="modal-store-buttons"></div><button class="modal-close">Close</button><div class="modal-backdrop"></div></div>
    </body></html>`, {url, referrer: 'https://example.org/path?email=private#secret', runScripts:'outside-only'});
  if (saved) dom.window.localStorage.setItem('writeops-analytics-consent-v1', JSON.stringify(saved));
  if (storageBlocked) Object.defineProperty(dom.window, 'localStorage', {get() { throw new Error('blocked'); }});
  dom.window.eval(analytics);
  dom.window.eval(main);
  const click = (selector, type = 'click', button = 0) => {
    const event = new dom.window.MouseEvent(type, {bubbles:true, cancelable:true, button});
    event.preventDefault(); // Test navigation is deliberately disabled, not event handling.
    dom.window.document.querySelector(selector).dispatchEvent(event);
  };
  const calls = () => Array.from(dom.window.dataLayer || [], item => Array.from(item));
  const events = () => calls().filter(item => item[0] === 'event');
  return {dom, window:dom.window, document:dom.window.document, click, calls, events};
}

test('no Google tag, cookies or events before consent, including after rejection', () => {
  const p = page();
  assert.equal(p.document.querySelector('#analytics-consent').hidden, false);
  p.click('#ebook');
  p.click('[data-analytics-choice="denied"]');
  p.click('#audio');
  assert.equal(p.document.querySelector('script[src*="googletagmanager"]'), null);
  assert.equal(p.calls().length, 0);
  assert.equal(p.document.cookie, '');
  assert.equal(p.document.querySelector('#analytics-consent').hidden, true);
});

test('consent loads one tag and one page view; discards pre-consent clicks', () => {
  const p = page();
  p.click('#ebook');
  p.click('[data-analytics-choice="granted"]');
  p.click('[data-analytics-settings]');
  p.click('[data-analytics-choice="granted"]');
  assert.equal(p.document.querySelectorAll('script[src*="googletagmanager"]').length, 1);
  assert.deepEqual(p.events().map(e => e[1]), ['page_view']);
  assert.equal(p.calls()[0][1], 'default');
  assert.equal(p.calls()[0][2].ad_storage, 'denied');
  assert.equal(p.calls()[1][2].analytics_storage, 'granted');
});

test('retailer classification includes correct book, work, format and source exactly once', () => {
  const p = page();
  p.click('[data-analytics-choice="granted"]');
  p.click('#ebook');
  p.click('#audio');
  p.click('#internal');
  p.click('#email');
  const events = p.events().filter(e => e[1] === 'retailer_click');
  assert.equal(events.length, 2);
  assert.equal(events[0][2].book_title, 'Captured by the Enforcer');
  assert.equal(events[0][2].work_id, 'W0092');
  assert.equal(events[0][2].book_format, 'ebook');
  assert.equal(events[1][2].book_format, 'audiobook');
  assert.equal(events[1][2].retailer, 'kobo');
  assert.equal(events[0][2].source_page, '/books/');
  assert.equal(events[0][2].link_url, 'https://www.kobo.com/ca/en/ebook/captured');
  assert.equal(p.events().length, 3);
});

test('regional picker opening is not a retailer click; each chosen region retains metadata', () => {
  const p = page();
  p.click('[data-analytics-choice="granted"]');
  p.click('.buy-btn');
  assert.equal(p.events().length, 1);
  assert.equal(p.document.querySelector('#buy-modal').hidden, false);
  p.click('#modal-store-buttons a[data-store-region="ca"]');
  const event = p.events()[1];
  assert.equal(event[1], 'retailer_click');
  assert.equal(event[2].retailer, 'amazon');
  assert.equal(event[2].store_region, 'ca');
  assert.equal(event[2].work_id, 'W0092');
  assert.equal(event[2].book_format, 'ebook');
  assert.equal(event[2].link_placement, 'regional_picker');
  assert.equal(p.document.querySelector('#modal-store-buttons a').href, 'https://www.amazon.com/dp/B0GHS3ZQFT');
});

test('other outbound clicks use a separate mutually exclusive event and middle-click counts once', () => {
  const p = page();
  p.click('[data-analytics-choice="granted"]');
  p.click('#generic');
  p.click('#ebook', 'auxclick', 1);
  p.click('#ebook', 'auxclick', 2);
  assert.deepEqual(p.events().map(e => e[1]), ['page_view', 'outbound_click', 'retailer_click']);
  assert.equal(p.events()[1][2].link_url, 'https://example.com/about');
});

test('query strings, fragments, referrer paths and unsafe campaign values do not enter payloads', () => {
  const p = page({url:'https://writeopshq.com/books/?email=private@example.org&utm_source=newsletter&utm_campaign=private@example.org#secret'});
  p.click('[data-analytics-choice="granted"]');
  const event = p.events()[0][2];
  assert.equal(event.page_location, 'https://writeopshq.com/books/?utm_source=newsletter');
  assert.equal(event.page_referrer, 'https://example.org/');
  assert.ok(!JSON.stringify(p.calls()).includes('private'));
});

test('expired consent does not start analytics; storage failures default to off', () => {
  for (const options of [{saved:{choice:'granted', at:0}}, {storageBlocked:true}]) {
    const p = page(options);
    assert.equal(p.calls().length, 0);
    assert.equal(p.document.querySelector('#analytics-consent').hidden, false);
  }
});

test('test visits are explicitly labelled and still need consent', () => {
  const p = page({url:'https://writeopshq.com/books/?analytics_test=1'});
  assert.equal(p.calls().length, 0);
  p.click('[data-analytics-choice="granted"]');
  assert.equal(p.events()[0][2].test_traffic, 'yes');
  assert.equal(p.events()[0][2].debug_mode, true);
  assert.equal(p.calls().find(e => e[0] === 'config')[2].traffic_type, 'developer');
});

test('revocation from another tab disables tracking and removes existing GA cookies', () => {
  const p = page({saved:{choice:'granted', at:Date.now()}});
  p.document.cookie = '_ga=old; path=/';
  p.window.localStorage.setItem('writeops-analytics-consent-v1', JSON.stringify({choice:'denied', at:Date.now()}));
  // jsdom cannot navigate, but the disable switch and cookie removal precede reload.
  p.window.dispatchEvent(new p.window.StorageEvent('storage', {key:'writeops-analytics-consent-v1'}));
  const before = p.events().length;
  p.click('#ebook');
  assert.equal(p.events().length, before);
  assert.equal(p.window['ga-disable-G-TEST123'], true);
  assert.equal(p.document.cookie, '');
});
