---
layout: pen-name
title: "Rook Brennan"
pen_id: rook-brennan
accent: "#2B5D3F"
promise: "Monster romance and dark fantasy where the creature always gets the girl."
description: "Rook Brennan writes monster romance and dark fantasy — creatures with sharp edges and devoted hearts."
content_notes: true
content_notes_text: "Rook Brennan's books contain explicit sexual content, non-human anatomy, dubious consent elements (clearly flagged per book), dark fantasy horror elements, and graphic scenes involving predator/prey dynamics. Each book includes a full content note in the front matter."
permalink: /pen-names/rook-brennan/
og_image: assets/img/og-rook.jpg
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="Rook Brennan" %}

<div class="container">

  {% assign featured_books = site.data.books_rook | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="rook-brennan" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">All Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_rook %}
        {% include book-tile.html book=book pen_id="rook-brennan" %}
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

{% include pen-newsletter.html pen_name="Rook Brennan" %}
