---
layout: pen-name
title: "Rita Dole"
pen_id: rita-dole
accent: "#4B2A63"
promise: "MF monster romance and reverse harem dark fantasy — dark, daring, and seriously spicy."
description: "Rita Dole writes MF monster romance and reverse harem dark fantasy with heat, heart, and creatures who choose you back."
content_notes: true
content_notes_text: "Rita Dole's books contain explicit MF sexual content, reverse harem dynamics, non-human anatomy, and dark fantasy elements. Some titles include dubious consent (clearly flagged per book)."
permalink: /authors/rita-dole/
og_image: assets/img/og-rita.jpg
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="Rita Dole" %}

<div class="container">

  {% assign featured_books = site.data.books_rita | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="rita-dole" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">All Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_rita %}
        {% include book-tile.html book=book pen_id="rita-dole" %}
      {% endfor %}
    </div>
  </section>

  {% if page.content_notes %}
  <div class="content-notes" id="content-notes">
    <p class="content-notes-title">Content Notes</p>
    <p>{{ page.content_notes_text }}</p>
  </div>
  {% endif %}

</div>

{% include pen-newsletter.html pen_name="Rita Dole" %}
