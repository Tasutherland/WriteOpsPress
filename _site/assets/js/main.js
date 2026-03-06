/* ============================================================
   WriteOps Press — main.js
   - Mobile nav toggle
   - Buy modal (country picker)
   ============================================================ */

(function () {
  'use strict';

  /* ----------------------------------------------------------
     Mobile nav toggle
     ---------------------------------------------------------- */
  const navToggle = document.querySelector('.nav-toggle');
  const primaryNav = document.querySelector('.primary-nav');

  if (navToggle && primaryNav) {
    navToggle.addEventListener('click', function () {
      const isOpen = primaryNav.classList.toggle('is-open');
      navToggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    });
  }

  /* ----------------------------------------------------------
     Dropdown — click to open/close, click outside to dismiss
     ---------------------------------------------------------- */
  const dropdownToggles = document.querySelectorAll('.dropdown-toggle');

  function closeAllDropdowns() {
    dropdownToggles.forEach(function (t) {
      t.setAttribute('aria-expanded', 'false');
    });
  }

  dropdownToggles.forEach(function (toggle) {
    toggle.addEventListener('click', function (e) {
      e.stopPropagation();
      const expanded = this.getAttribute('aria-expanded') === 'true';
      closeAllDropdowns();
      if (!expanded) {
        this.setAttribute('aria-expanded', 'true');
      }
    });
  });

  /* Close when clicking anywhere outside the dropdown */
  document.addEventListener('click', function (e) {
    if (!e.target.closest('.nav-has-dropdown')) {
      closeAllDropdowns();
    }
  });

  /* Close on Escape key */
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeAllDropdowns();
  });

  /* ----------------------------------------------------------
     Buy Modal — country picker
     ---------------------------------------------------------- */
  const modal         = document.getElementById('buy-modal');
  const modalTitle    = document.getElementById('modal-title');
  const storeButtons  = document.getElementById('modal-store-buttons');
  const modalClose    = document.querySelector('.modal-close');
  const modalBackdrop = document.querySelector('.modal-backdrop');

  const STORE_LABELS = {
    ca: { label: 'Amazon Canada',    flag: '🇨🇦', note: 'amazon.ca' },
    us: { label: 'Amazon US',        flag: '🇺🇸', note: 'amazon.com' },
    uk: { label: 'Amazon UK',        flag: '🇬🇧', note: 'amazon.co.uk' },
    au: { label: 'Amazon Australia', flag: '🇦🇺', note: 'amazon.com.au' },
  };

  function openModal(title, stores) {
    if (!modal) return;

    modalTitle.textContent = title;
    storeButtons.innerHTML = '';

    Object.entries(stores).forEach(function ([key, url]) {
      const info = STORE_LABELS[key] || { label: key.toUpperCase(), flag: '🛒', note: url };
      const a = document.createElement('a');
      a.href = url;
      a.target = '_blank';
      a.rel = 'noopener noreferrer';
      a.className = 'store-btn';
      a.innerHTML = `
        <span class="store-btn-left">
          <span class="store-btn-flag" aria-hidden="true">${info.flag}</span>
          <span class="store-btn-label">${info.label}</span>
        </span>
        <span class="store-btn-domain text-muted text-sm">${info.note}</span>
      `;
      storeButtons.appendChild(a);
    });

    modal.removeAttribute('hidden');
    document.body.style.overflow = 'hidden';

    // Focus the close button for accessibility
    if (modalClose) modalClose.focus();
  }

  function closeModal() {
    if (!modal) return;
    modal.setAttribute('hidden', '');
    document.body.style.overflow = '';
  }

  // Wire up every Buy button
  document.addEventListener('click', function (e) {
    const btn = e.target.closest('.buy-btn');
    if (!btn) return;
    const title  = btn.dataset.title  || 'Buy this book';
    const stores = JSON.parse(btn.dataset.stores || '{}');
    openModal(title, stores);
  });

  if (modalClose)    modalClose.addEventListener('click', closeModal);
  if (modalBackdrop) modalBackdrop.addEventListener('click', closeModal);

  // Close on Escape
  document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape' && modal && !modal.hasAttribute('hidden')) {
      closeModal();
    }
  });

  /* ----------------------------------------------------------
     Detect preferred store by browser locale (convenience hint)
     Highlights the likely best match but keeps all options visible.
     ---------------------------------------------------------- */
  function guessCountry() {
    const lang = (navigator.language || '').toLowerCase();
    if (lang.includes('en-gb') || lang.includes('en-ie')) return 'uk';
    if (lang.includes('en-au') || lang.includes('en-nz')) return 'au';
    if (lang.includes('en-ca') || lang.includes('fr-ca')) return 'ca';
    return 'us';
  }

  window.writeopsGuessCountry = guessCountry;

})();
