---
layout: pen-name
title: "Ash Wilder"
pen_id: ash-wilder
accent: "#7A1E2C"
promise: "Dark, intense MM BDSM and paranormal romance where desire and danger collide."
description: "Ash Wilder writes MM BDSM and MM paranormal romance. Dark, consensual, and scorchingly hot."
content_notes: true
content_notes_text: "Ash Wilder's books contain explicit MM sexual content, BDSM dynamics (consensual), power exchange, and paranormal elements including werewolf/shifter content. Some titles include depictions of past trauma."
permalink: /pen-names/ash-wilder/
og_image: assets/img/og-ash.jpg
---

{% include pen-hero.html %}

{% include pen-newsletter.html pen_name="Ash Wilder" %}

<div class="container">

  {% assign featured_books = site.data.books_ash | where: "featured", true %}
  {% if featured_books.size > 0 %}
  <section class="section">
    <h2 class="section-heading">Start Here</h2>
    <div class="featured-grid">
      {% for book in featured_books %}
        {% include book-tile.html book=book pen_id="ash-wilder" %}
      {% endfor %}
    </div>
  </section>
  {% endif %}

  <section class="section">
    <h2 class="section-heading">All Books</h2>
    <div class="books-grid">
      {% for book in site.data.books_ash %}
        {% include book-tile.html book=book pen_id="ash-wilder" %}
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

{% include pen-newsletter.html pen_name="Ash Wilder" %}
