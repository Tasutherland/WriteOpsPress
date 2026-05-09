---
layout: pen-name
title: "Nyx Montreaux"
pen_id: nyx-montreaux
accent: "#1C3F5E"
promise: "Luxury-noir dark mafia romance where obsession, power, and violence forge hard-won devotion."
description: "Nyx Montreaux writes luxury-noir dark mafia romance where obsession, power, and violence forge hard-won devotion."
content_notes: false
permalink: /authors/nyx-montreaux/
og_image: assets/img/og-nyx.jpg
published: false
sitemap: false
robots: noindex, nofollow
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
    <h2 class="section-heading">Featured Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_nyx %}
        {% include book-tile.html book=book pen_id="nyx-montreaux" %}
      {% endfor %}
    </div>
  </section>

</div>

{% include pen-newsletter.html pen_name="Nyx Montreaux" %}
