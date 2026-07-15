---
layout: pen-name
title: "M. Farrow"
pen_id: m-farrow
accent: "#28306F"
promise: "High-heat why-choose monster romantasy where dangerous bargains create impossible bonds, heroines seize power under pressure, and devotion is never limited to two."
description: "M. Farrow writes high-heat why-choose monster romantasy where dangerous bargains create impossible bonds, heroines seize power under pressure, and devotion is never limited to two."
content_notes: true
content_notes_text: "M. Farrow's books may contain explicit sexual content, why-choose relationships, non-human anatomy, dangerous magical bonds, court pressure, power imbalances, and dark fantasy elements. Individual titles may include additional content notes."
permalink: /authors/m-farrow/
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="M. Farrow" %}

<div class="container">

  {% assign featured_books = site.data.books_farrow | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="m-farrow" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">Featured Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_farrow %}
        {% include book-tile.html book=book pen_id="m-farrow" %}
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

{% include pen-newsletter.html pen_name="M. Farrow" %}
