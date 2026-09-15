---
layout: pen-name
title: "Rita Dole"
pen_id: rita-dole
accent: "#4B2A63"
promise: "High-heat MF monster romance and dark romantasy where bargains cut deep, queens are forged under pressure, and desire has teeth."
description: "Rita Dole writes high-heat MF monster romance and dark romantasy where bargains cut deep, queens are forged under pressure, and desire has teeth."
content_notes: true
content_notes_text: "Rita Dole's books contain explicit MF sexual content, non-human anatomy, dangerous bargains, power imbalance, and dark fantasy elements. Some titles include dubious consent (clearly flagged per book)."
permalink: /authors/rita-dole/
---

{% include pen-hero.html %}

<div class="container">
  {% include featured-books.html books=site.data.books_rita pen_id="rita-dole" %}

  {% if page.content_notes %}
  <div class="content-notes" id="content-notes">
    <p class="content-notes-title">Content Notes</p>
    <p>{{ page.content_notes_text }}</p>
  </div>
  {% endif %}

</div>
