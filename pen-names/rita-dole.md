---
layout: pen-name
title: "Rita Dole"
pen_id: rita-dole
accent: "#4B2A63"
promise: "Spicy contemporary romance with sharp wit, messy feelings, and swoon-worthy heat."
description: "Rita Dole writes spicy contemporary romance — smart heroines, swoony heroes, and all the feelings."
content_notes: true
content_notes_text: "Rita Dole's books contain explicit sexual content and, in some titles, discussions of anxiety and career pressure. Each book's full content note is listed on the retailer's product page."
permalink: /pen-names/rita-dole/
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
