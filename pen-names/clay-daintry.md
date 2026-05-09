---
layout: pen-name
title: "Clay Daintry"
pen_id: clay-daintry
accent: "#6B4A2B"
promise: "High-heat MM western romance about hard men, hard weather, and the surrender that only happens when there is nowhere left to run."
description: "Clay Daintry writes high-heat MM western romance about hard men, hard weather, and the surrender that only happens when there is nowhere left to run."
content_notes: false
permalink: /authors/clay-daintry/
og_image: assets/img/og-clay.jpg
published: false
sitemap: false
robots: noindex, nofollow
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
    <h2 class="section-heading">Featured Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_clay %}
        {% include book-tile.html book=book pen_id="clay-daintry" %}
      {% endfor %}
    </div>
  </section>

</div>

{% include pen-newsletter.html pen_name="Clay Daintry" %}
