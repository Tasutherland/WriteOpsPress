---
layout: pen-name
title: "Jay McGilvery"
pen_id: jay-mcgilvery
accent: "#1E4E7A"
promise: "Sports romance — locker rooms, rivalry, and the kind of chemistry that breaks records."
description: "Jay McGilvery writes sports romance with sharp banter, athletic heat, and heroes who play to win — on and off the ice."
content_notes: false
permalink: /pen-names/jay-mcgilvery/
og_image: assets/img/og-jay.jpg
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="Jay McGilvery" %}

<div class="container">

  {% assign featured_books = site.data.books_jay | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="jay-mcgilvery" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">All Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_jay %}
        {% include book-tile.html book=book pen_id="jay-mcgilvery" %}
      {% endfor %}
    </div>
  </section>

</div>

{% include pen-newsletter.html pen_name="Jay McGilvery" %}
