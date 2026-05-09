---
layout: default
title: "Authors"
description: "Meet the public WriteOps Press authors and their high-heat romance lanes."
permalink: /authors/
---

<section class="section section--lg">
  <div class="container">
    <h1 style="font-family: var(--font-serif); margin-bottom: 0.5rem;">Our Authors</h1>
    <p style="color: var(--color-text-muted); margin-bottom: 3rem; font-size: var(--text-lg);">Distinct reader promises across high-heat romance, monster romance, paranormal, romantasy, and dark fantasy.</p>

    <div class="pen-cards-grid">

      {% for pen in site.pen_names %}
      <a href="{{ '/authors/' | append: pen.id | append: '/' | relative_url }}" class="pen-card" style="--pen-accent: {{ pen.accent }};">
        <h2 class="pen-card-name">{{ pen.name }}</h2>
        <p class="pen-card-promise">{{ pen.promise }}</p>
        <span class="pen-card-link">Explore</span>
      </a>
      {% endfor %}

    </div>
  </div>
</section>
