---
layout: default
title: Proyectos
permalink: /projects/
---

<section class="section section--projects">
  <div class="container container--projects">

    <header class="projects-hero">
      <div class="projects-hero__top">
        <p class="projects-kicker">PROYECTOS</p>
        <p class="projects-tech">SQL · Power BI · Python · R</p>
      </div>

      <p class="projects-lede">
        Una selección de proyectos agrupados por tecnología. Cada proyecto incluye una página de detalle y acceso al código.
      </p>

      {% assign cats = "Power BI,SQL,Python,R" | split: "," %}

      <div class="projects-tabs" role="tablist" aria-label="Categorías de proyectos">
        <button class="tab is-active" type="button" data-filter="all" role="tab" aria-selected="true">Todos</button>
        {% for c in cats %}
          <button class="tab" type="button" data-filter="{{ c | downcase | replace: ' ', '' }}" role="tab" aria-selected="false">{{ c }}</button>
        {% endfor %}
      </div>
    </header>

    {% assign items_all = site.data.projects | sort: "order" %}

    <div class="projects-feed" aria-live="polite">
      {% for p in items_all %}
        {% assign cat_key = p.category | downcase | replace: ' ', '' %}
        {% if cat_key == 'r' %}
          {% assign cat_key = 'rstudio' %}
        {% endif %}

        <article class="project-row" data-cat="{{ p.category | downcase | replace: ' ', '' }}">
          <div class="project-row__content">
            <p class="project-meta">{{ p.category }}</p>
            <h3 class="project-title">{{ p.title }}</h3>
            <p class="project-desc">{{ p.desc }}</p>

            {% if p.tags %}
            <div class="project-tags" aria-label="Tecnologías">
              {% for t in p.tags %}
                <span class="tag">{{ t }}</span>
              {% endfor %}
            </div>
            {% endif %}

            <div class="project-actions">
              <a class="btn btn--primary" href="{{ p.href | relative_url }}">Ver proyecto</a>
              {% if p.repo %}
                <a class="btn" href="{{ p.repo }}" target="_blank" rel="noopener">Ver código</a>
              {% endif %}
            </div>
          </div>

          <div class="project-row__media" aria-hidden="true">
            <img
              src="{{ p.image | default: '/assets/img/projects/' | append: cat_key | append: '.png' | relative_url }}"
              alt=""
              loading="lazy"
            >
          </div>
        </article>
      {% endfor %}
    </div>

  </div>
</section>

<script>
  (function () {
    const tabs = document.querySelectorAll('.projects-tabs .tab');
    const rows = document.querySelectorAll('.project-row[data-cat]');

    function setActive(btn) {
      tabs.forEach(t => {
        t.classList.toggle('is-active', t === btn);
        t.setAttribute('aria-selected', t === btn ? 'true' : 'false');
      });
    }

    function filter(cat) {
      rows.forEach(row => {
        const c = row.getAttribute('data-cat');
        const show = (cat === 'all') || (c === cat);
        row.style.display = show ? '' : 'none';
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
