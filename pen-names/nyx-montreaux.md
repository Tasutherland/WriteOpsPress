---
layout: pen-name
title: "Nyx Montreaux"
pen_id: nyx-montreaux
accent: "#1C3F5E"
promise: "Mafia romance dripping with danger, obsession, and heat."
description: "Nyx Montreaux writes dark FM mafia romance — possessive heroes, fierce heroines, and plots that move fast."
content_notes: false
permalink: /authors/nyx-montreaux/
og_image: assets/img/og-nyx.jpg
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="Nyx Montreaux" %}

<div class="container">

  {% assign featured_books = site.data.books_nyx | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="nyx-montreaux" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">All Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_nyx %}
        {% include book-tile.html book=book pen_id="nyx-montreaux" %}
      {% endfor %}
    </div>
  </section>

</div>

{% include pen-newsletter.html pen_name="Nyx Montreaux" %}
