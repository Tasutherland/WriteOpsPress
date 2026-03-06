---
layout: pen-name
title: "Clay Daintry"
pen_id: clay-daintry
accent: "#6B4A2B"
promise: "MM cowboy romance with grit, heat, and wide-open country."
description: "Clay Daintry writes MM cowboy romance — rugged settings, earned heat, and men who mean what they say."
content_notes: false
permalink: /pen-names/clay-daintry/
og_image: assets/img/og-clay.jpg
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="Clay Daintry" %}

<div class="container">

  {% assign featured_books = site.data.books_clay | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="clay-daintry" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">All Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_clay %}
        {% include book-tile.html book=book pen_id="clay-daintry" %}
      {% endfor %}
    </div>
  </section>

</div>

{% include pen-newsletter.html pen_name="Clay Daintry" %}
