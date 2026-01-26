---
layout: default
title: Proyectos
permalink: /projects/
---

<section class="section projects-page">
  <div class="projects-header">
    <div class="section-title">
      <h2>Proyectos</h2>
      <span>SQL · Power BI · Python · R</span>
    </div>

    <p class="projects-lede">
      Una selección de proyectos agrupados por tecnología. Cada proyecto incluye una página de detalle y acceso al código.
    </p>

    {% assign cats = "Power BI,SQL,Python,R" | split: "," %}
    <div class="projects-tabs" role="tablist" aria-label="Categorías de proyectos">
      <button class="tab is-active" type="button" data-filter="all" role="tab" aria-selected="true">Todos</button>
      {% for c in cats %}
        <button class="tab" type="button" data-filter="{{ c | downcase | replace: ' ', '' }}" role="tab" aria-selected="false">
          {{ c }}
        </button>
      {% endfor %}
    </div>
  </div>

  <div class="projects-grid">
    {% for c in cats %}
      {% assign items = site.data.projects | where: "category", c | sort: "order" %}
      {% for p in items %}

        {% assign tech_img = p.image %}
        {% if tech_img == nil or tech_img == "" %}
          {% if p.category == "Power BI" %}
            {% assign tech_img = "/assets/img/projects/powerbi.png" %}
          {% elsif p.category == "SQL" %}
            {% assign tech_img = "/assets/img/projects/sql.png" %}
          {% elsif p.category == "Python" %}
            {% assign tech_img = "/assets/img/projects/python.png" %}
          {% elsif p.category == "R" %}
            {% assign tech_img = "/assets/img/projects/rstudio.png" %}
          {% endif %}
        {% endif %}

        <article class="project-card" data-cat="{{ c | downcase | replace: ' ', '' }}">
          <a class="project-media" href="{{ p.href | relative_url }}" aria-label="Abrir proyecto: {{ p.title }}">
            <img src="{{ tech_img | relative_url }}" alt="" loading="lazy">
          </a>

          <div class="project-body">
            <p class="project-kicker">{{ p.category }}</p>
            <h3 class="project-title">
              <a href="{{ p.href | relative_url }}">{{ p.title }}</a>
            </h3>
            <p class="project-desc">{{ p.desc }}</p>

            {% if p.tags %}
            <div class="project-tags" aria-label="Tecnologías y técnicas">
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
        </article>

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
