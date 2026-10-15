const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const { JSDOM } = require('jsdom');
const root = process.argv[2] || '_site';
function htmlFiles(dir) {
  return fs.readdirSync(dir, {withFileTypes:true}).flatMap(entry => {
    const file = path.join(dir, entry.name);
    return entry.isDirectory() ? htmlFiles(file) : file.endsWith('.html') ? [file] : [];
  });
}
let checked = 0;
for (const file of htmlFiles(root)) {
  const document = new JSDOM(fs.readFileSync(file, 'utf8')).window.document;
  const tag = document.querySelector('#writeops-analytics');
  if (tag) {
    assert.match(tag.dataset.measurementId, /^G-[A-Z0-9]+$/, file + ': invalid GA4 ID');
    assert.equal(document.querySelectorAll('#writeops-analytics').length, 1, file + ': duplicate tag');
    assert.ok(document.querySelector('#analytics-consent'), file + ': missing consent controls');
    assert.ok(document.querySelector('[data-analytics-settings]'), file + ': missing withdrawal control');
  }
  for (const link of document.querySelectorAll('.retailer-list a, .retailer-link, .detail-retailers a.btn, button.buy-btn')) {
    const context = link.closest('[data-book-title]');
    assert.ok(context && context.dataset.bookTitle, file + ': missing book title on purchase action');
    assert.ok(context.dataset.author, file + ': missing public author on purchase action');
    assert.ok(['ebook', 'audiobook'].includes(context.dataset.edition), file + ': missing format');
    if (link.dataset.edition === 'audiobook') {
      assert.equal(context.dataset.edition, 'audiobook', file + ': audio click inherits ebook format');
    }
    if (link.tagName === 'BUTTON') {
      const stores = JSON.parse(link.dataset.stores);
      assert.ok(Object.values(stores).every(url => url.startsWith('https://')), file + ': bad store JSON');
    }
    checked += 1;
  }
}
assert.ok(checked > 100, 'Expected catalogue, detail and audiobook purchase actions');
console.log(`Analytics markup validation passed: ${checked} purchase actions have book, author and format metadata.`);
