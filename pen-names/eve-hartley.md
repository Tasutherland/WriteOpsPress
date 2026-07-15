---
layout: pen-name
title: "Eve Hartley"
pen_id: eve-hartley
accent: "#6B3A2E"
promise: "Witty, emotionally grounded historical romance where capable women, inconvenient scandals, and carefully arranged matches turn into hard-won love."
description: "Eve Hartley writes witty, emotionally grounded historical romance where capable women, inconvenient scandals, and carefully arranged matches turn into hard-won love."
content_notes: false
permalink: /authors/eve-hartley/
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="Eve Hartley" %}

<div class="container">

  {% assign featured_books = site.data.books_eve | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="eve-hartley" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">Featured Books</h2>
    {% if site.data.books_eve.size > 0 %}
    <div class="books-grid">
      {% for book in site.data.books_eve %}
        {% include book-tile.html book=book pen_id="eve-hartley" %}
      {% endfor %}
    </div>
    {% else %}
    <div class="books-coming-soon">
      <p>Books coming soon.</p>
    </div>
    {% endif %}
  </section>

</div>

{% include pen-newsletter.html pen_name="Eve Hartley" %}
