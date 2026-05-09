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

<section class="section section--newsletter">
  <div class="container">
    {% include mailerlite-form.html
      shell_class="newsletter-shell--home"
      eyebrow="Newsletter"
      heading="Get the next release first."
      body="New releases, cover reveals, and reader extras from WriteOps Press. Choose the heat level, monsters, bargains, and devotion you want in your inbox."
    %}
  </div>
</section>
