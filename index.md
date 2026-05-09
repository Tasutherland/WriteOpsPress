---
layout: default
title: "WriteOps Press"
description: "Independent romance publisher specializing in high-heat MM, monster, paranormal, romantasy, and dark fantasy romance."
permalink: /
body_class: press-home
---

<section class="press-hero">
  <div class="container">
    <div class="press-hero-inner">
      <p class="press-eyebrow">WriteOps Press</p>
      <h1 class="press-title">Books that pull you in<br>and don't let go.</h1>
      <p class="press-blurb">
        WriteOps Press is an independent romance publisher specializing in high-heat MM,
        monster, paranormal, romantasy, and dark fantasy romance. Across every pen name,
        the stories are intense, trope-forward, emotionally charged, and built for readers
        who want heat with bite.
      </p>
    </div>
  </div>
</section>

<section class="section">
  <div class="container">
    <h2 class="section-heading" style="--pen-accent: #111">Our Authors</h2>
    <div class="pen-cards-grid">

      {% for pen in site.pen_names %}
      <a href="{{ '/authors/' | append: pen.id | append: '/' | relative_url }}" class="pen-card" style="--pen-accent: {{ pen.accent }};">
        <h3 class="pen-card-name">{{ pen.name }}</h3>
        <p class="pen-card-promise">{{ pen.promise }}</p>
        <span class="pen-card-link">Explore</span>
      </a>
      {% endfor %}

    </div>
  </div>
</section>

<section class="section" style="background-color: var(--color-bg-alt); border-top: 1px solid var(--color-border); border-bottom: 1px solid var(--color-border);">
  <div class="container" style="max-width: 580px; text-align: center;">
    <h2 style="font-family: var(--font-serif); margin-bottom: 1rem;">Stay in the loop.</h2>
    <p style="color: var(--color-text-muted); margin-bottom: 2rem;">New releases, cover reveals, and reader extras. Choose the authors you care about, or subscribe to all.</p>
    {% include mailerlite-form.html %}
  </div>
</section>
