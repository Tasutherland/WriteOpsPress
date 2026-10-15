---
layout: default
title: "Audiobooks by WriteOps Press"
description: "Listen to published dark MM and monster romance audiobooks by Rook Brennan and Ash Wilder, with direct audiobook retailer purchase links."
permalink: /audiobooks/
---

<section class="section catalog-intro">
  <div class="container">
    <p class="press-eyebrow">WriteOps Press · Audio editions</p>
    <h1>Our Audiobooks</h1>
    <p>Listen to our romance stories in audio. Each listing below links directly to the <strong>audiobook edition</strong> on Kobo, not the ebook.</p>
    <p><a href="{{ '/books/' | relative_url }}">Prefer to read? Browse ebooks →</a></p>
  </div>
</section>

<section class="section">
  <div class="container">
    <div class="books-grid books-grid--curated catalog-all-grid">
      {% for audio in site.data.audiobooks %}
      <article class="book-tile" data-book-title="{{ audio.title | escape }}" data-work-id="{{ audio.work_id | escape }}" data-author="{{ audio.pen_name | escape }}" data-edition="audiobook" data-link-placement="audiobook_catalog">
        <div class="book-cover-wrap">
          <a href="{{ audio.book_url | relative_url }}" aria-label="About {{ audio.title | escape }} by {{ audio.pen_name | escape }}">
            <img src="{{ audio.cover | relative_url }}" alt="Cover of {{ audio.title | escape }} by {{ audio.pen_name | escape }}" class="book-cover" loading="lazy" width="320" height="480">
          </a>
        </div>
        <div class="book-info">
          <p class="book-series">{{ audio.pen_name }} · Audiobook</p>
          <h2 class="book-title"><a href="{{ audio.book_url | relative_url }}">{{ audio.title }}</a></h2>
          <p class="book-hook">Narrated by {{ audio.narrator }} · {{ audio.duration }} · English</p>
          {% if audio.stores.kobo %}
          <a class="btn btn-primary retailer-link" href="{{ audio.stores.kobo }}" target="_blank" rel="noopener noreferrer" data-edition="audiobook" data-work-id="{{ audio.work_id }}">Buy audiobook on Kobo</a>
          {% endif %}
          <p><a href="{{ audio.book_url | relative_url }}">View book details and ebook options →</a></p>
        </div>
      </article>
      {% endfor %}
    </div>
  </div>
</section>
