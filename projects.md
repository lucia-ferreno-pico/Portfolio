---
layout: default
title: Proyectos
permalink: /projects/
---

<section class="section">
  <div class="section-title">
    <h2>Proyectos</h2>
    <span>SQL · Power BI · Python · R</span>
  </div>

  <p class="subtitle" style="max-width: 70ch;">
    Una selección de proyectos agrupados por tecnología. Cada proyecto incluye una página de detalle y acceso al código.
  </p>

  {% assign cats = "Power BI,SQL,Python,R" | split: "," %}

  {% assign featured = site.data.projects | where: "featured", true | sort: "featured_order" %}
  {% if featured and featured.size > 0 %}
  <div class="projects-featured">
    <div class="section-title" style="margin-top: 8px;">
      <h2>Destacado</h2>
      <span>{{ featured.size }} proyecto(s)</span>
    </div>

    <div class="projects-list">
      {% for p in featured %}
      <div class="project-card">
        <div class="project-card__head">
          <p class="kicker">{{ p.category }}</p>
          <h3 class="title">{{ p.title }}</h3>
          <p class="desc">{{ p.desc }}</p>
        </div>

        <div class="project-card__actions">
          <a class="btn btn--primary" href="{{ p.href | relative_url }}">Ver proyecto</a>
          {% if p.repo %}
          <a class="btn" href="{{ p.repo }}" target="_blank" rel="noopener">Ver código</a>
          {% endif %}
        </div>
      </div>
      {% endfor %}
    </div>
  </div>
  {% endif %}

  <div class="projects-tabs" role="tablist" aria-label="Categorías de proyectos">
    <button class="tab is-active" type="button" data-filter="all" role="tab" aria-selected="true">All</button>
    {% for c in cats %}
      <button class="tab" type="button" data-filter="{{ c | downcase | replace: ' ', '' }}" role="tab" aria-selected="false">{{ c }}</button>
    {% endfor %}
  </div>

  <div class="projects-list">
    {% for c in cats %}
      {% assign items = site.data.projects | where: "category", c | sort: "order" %}
      {% for p in items %}
      <div class="project-card" data-cat="{{ c | downcase | replace: ' ', '' }}">
        <div class="project-card__head">
          <p class="kicker">{{ p.category }}</p>
          <h3 class="title">{{ p.title }}</h3>
          <p class="desc">{{ p.desc }}</p>
        </div>

        <div class="project-card__actions">
          <a class="btn btn--primary" href="{{ p.href | relative_url }}">Ver proyecto</a>
          {% if p.repo %}
          <a class="btn" href="{{ p.repo }}" target="_blank" rel="noopener">Ver código</a>
          {% endif %}
        </div>
      </div>
      {% endfor %}
    {% endfor %}
  </div>
</section>

<script>
  (function () {
    const tabs = document.querySelectorAll('.projects-tabs .tab');
    const cards = document.querySelectorAll('.project-card[data-cat]');

    function setActive(btn) {
      tabs.forEach(t => {
        t.classList.toggle('is-active', t === btn);
        t.setAttribute('aria-selected', t === btn ? 'true' : 'false');
      });
    }

    function filter(cat) {
      cards.forEach(card => {
        const c = card.getAttribute('data-cat');
        const show = (cat === 'all') || (c === cat);
        card.style.display = show ? '' : 'none';
      });
    }

    tabs.forEach(btn => {
      btn.addEventListener('click', () => {
        const cat = btn.getAttribute('data-filter');
        setActive(btn);
        filter(cat);
      });
    });
  })();
</script>
