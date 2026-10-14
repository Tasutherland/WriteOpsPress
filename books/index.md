---
layout: default
title: "Romance Books by WriteOps Press"
description: "Browse the WriteOps Press catalog: MM monster romance, dark MM BDSM romance, why-choose romantasy and dark MF monster romance."
permalink: /books/
---
<section class="section catalog-intro">
  <div class="container">
    <p class="press-eyebrow">WriteOps Press</p>
    <h1>Browse Our Books</h1>
    <p>Explore dark MM romance, monster romance, BDSM romance, why-choose romantasy, and dark fantasy romance from our active authors.</p>
    <nav class="catalog-author-nav" aria-label="Jump to author">
      {% for pen in site.pen_names %}
        <a href="#{{ pen.id }}">{{ pen.name }}</a>
      {% endfor %}
    </nav>
  </div>
</section>
{% for pen in site.pen_names %}
{% assign data_key = 'books_' | append: pen.data_key %}
{% assign books = site.data[data_key] %}
<section class="section catalog-author-section" id="{{ pen.id }}">
  <div class="container">
    <h2>{{ pen.name }}</h2>
    <p>{{ pen.promise }}</p>
    <p><a href="{{ '/authors/' | append: pen.id | append: '/' | relative_url }}">About {{ pen.name }} →</a></p>
    <div class="books-grid books-grid--curated catalog-all-grid">
    {% for book in books %}
      {% include book-tile.html book=book %}
    {% endfor %}
    </div>
  </div>
</section>
{% endfor %>