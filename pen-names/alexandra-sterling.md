---
layout: pen-name
title: "Alexandra Sterling"
pen_id: alexandra-sterling
accent: "#7B3F61"
promise: "High-heat monster court romance and fantasy romance with dangerous rulers, binding bargains, and heroines who refuse to break."
description: "Alexandra Sterling writes high-heat monster court romance and fantasy romance with dangerous rulers, binding bargains, and heroines who refuse to break."
content_notes: true
content_notes_text: "Alexandra Sterling's books contain explicit sexual content, monster and fantasy romance elements, power imbalance, dangerous bargains, and dark court politics. Individual titles may include additional content notes."
permalink: /authors/alexandra-sterling/
og_image: assets/img/og-alexandra.jpg
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="Alexandra Sterling" %}

<div class="container">

  {% assign featured_books = site.data.books_alexandra | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="alexandra-sterling" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">Featured Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_alexandra %}
        {% include book-tile.html book=book pen_id="alexandra-sterling" %}
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

{% include pen-newsletter.html pen_name="Alexandra Sterling" %}
