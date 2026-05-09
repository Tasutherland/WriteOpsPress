---
layout: default
title: "About WriteOps Press"
description: "WriteOps Press is an independent romance publisher specializing in high-heat MM, monster, paranormal, romantasy, and dark fantasy romance."
permalink: /about/
body_class: about-page
---

<section class="press-hero">
  <div class="container">
    <div class="press-hero-inner">
      <p class="press-eyebrow">About WriteOps Press</p>
      <h1 class="press-title">Independent romance publishing with heat, bite, and emotional stakes.</h1>
      <p class="press-blurb">
        WriteOps Press is a curated independent romance publisher built around clear reader promises,
        high-heat storytelling, and books that tell readers exactly what kind of desire, danger,
        and devotion they are walking into.
      </p>
    </div>
  </div>
</section>

<section class="section">
  <div class="container prose-page" style="padding-block: 0;">
    <h2 class="section-heading">Our Mandate</h2>
    <p>
      WriteOps Press publishes high-heat romance across MM, monster, paranormal,
      romantasy, dark fantasy, and adjacent trope-forward lanes. The mandate is to
      pair commercial clarity with emotionally charged storytelling: books that make
      the promise plain, then deliver intensity, heat, and devotion with teeth.
    </p>
  </div>
</section>

<section class="section" style="background-color: var(--color-bg-alt); border-top: 1px solid var(--color-border); border-bottom: 1px solid var(--color-border);">
  <div class="container prose-page" style="padding-block: 0;">
    <h2 class="section-heading">What We Publish</h2>
    <ul>
      <li>MM BDSM and paranormal romance</li>
      <li>MM monster romance and dark fantasy</li>
      <li>MF monster romance and dark romantasy</li>
      <li>Monster court and fantasy romance</li>
      <li>Future historical and high-heat Regency romance as appropriate</li>
    </ul>
  </div>
</section>

<section class="section">
  <div class="container prose-page" style="padding-block: 0;">
    <h2 class="section-heading">What Readers Can Expect</h2>
    <ul>
      <li>Clear trope signaling</li>
      <li>High heat</li>
      <li>Emotional intensity</li>
      <li>Dangerous bargains, power dynamics, monsters, courts, bonds, and devotion</li>
      <li>Content notes where appropriate</li>
      <li>Pen names with distinct reader promises</li>
    </ul>
  </div>
</section>

<section class="section" style="background-color: var(--color-bg-alt); border-top: 1px solid var(--color-border); border-bottom: 1px solid var(--color-border);">
  <div class="container prose-page" style="padding-block: 0;">
    <h2 class="section-heading">Our Pen Names</h2>
    <ul>
      {% for pen in site.pen_names %}
      <li>
        <a href="{{ '/authors/' | append: pen.id | append: '/' | relative_url }}">{{ pen.name }}</a>:
        {{ pen.promise }}
      </li>
      {% endfor %}
    </ul>
  </div>
</section>

<section class="section">
  <div class="container prose-page" style="padding-block: 0;">
    <h2 class="section-heading">Not Every Pen Name Is Always Public</h2>
    <p>
      WriteOps Press develops and tests multiple romance lanes. The public catalogue
      focuses on active, reader-facing lines.
    </p>
  </div>
</section>
