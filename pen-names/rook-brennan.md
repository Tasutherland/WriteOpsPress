---
layout: pen-name
title: "Rook Brennan"
pen_id: rook-brennan
accent: "#2B5D3F"
promise: "MM monster romance and dark fantasy with dangerous creatures, possessive heat, and love that bites back."
description: "Rook Brennan writes MM monster romance and dark fantasy with dangerous creatures, possessive heat, and love that bites back."
content_notes: true
content_notes_text: "Rook Brennan's books contain explicit MM sexual content, non-human anatomy, dubious consent elements (clearly flagged per book), dark fantasy horror elements, and graphic scenes involving predator/prey dynamics."
permalink: /authors/rook-brennan/
---

{% include pen-hero.html %}

<div class="container">
  {% assign featured_books = site.data.books_rook | where: "featured", true | sort: "featured_order" %}
  {% assign amazon_books = featured_books | where: "distribution_group", "amazon-ku" %}
  {% assign wide_books = featured_books | where: "distribution_group", "wide" %}

  <section class="section" aria-labelledby="rook-featured-heading">
    <h2 class="section-heading" id="rook-featured-heading">Featured Books</h2>
    <div class="distribution-grid">
      <section class="distribution-shelf" aria-labelledby="rook-amazon-heading">
        <div class="distribution-shelf-header">
          <h3 id="rook-amazon-heading">Amazon &amp; Kindle Unlimited</h3>
          <p>Read in Kindle Unlimited or buy on Amazon.</p>
        </div>
        <div class="books-grid books-grid--shelf">
          {% for book in amazon_books %}
            {% include book-tile.html book=book pen_id="rook-brennan" %}
          {% endfor %}
        </div>
      </section>

      <section class="distribution-shelf" aria-labelledby="rook-wide-heading">
        <div class="distribution-shelf-header">
          <h3 id="rook-wide-heading">Other Retailers</h3>
          <p>Available through participating ebook retailers.</p>
        </div>
        {% if wide_books.size > 0 %}
        <div class="books-grid books-grid--shelf">
          {% for book in wide_books %}
            {% include book-tile.html book=book pen_id="rook-brennan" %}
          {% endfor %}
        </div>
        {% else %}
        <div class="books-coming-soon books-coming-soon--shelf">
          <p>More retailer editions will be added here as verified links become available.</p>
        </div>
        {% endif %}
      </section>
    </div>
  </section>

  {% if page.content_notes %}
  <div class="content-notes" id="content-notes">
    <p class="content-notes-title">Content Notes</p>
    <p>{{ page.content_notes_text }}</p>
  </div>
  {% endif %}

</div>
