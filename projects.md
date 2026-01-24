---
layout: default
title: Proyectos
---

<section class="section projects">
  <div class="section-title">
    <h2>Proyectos</h2>
    <span>SQL · Power BI · Python · R</span>
  </div>

  <p class="projects-lead">
    Una selección de proyectos agrupados por tecnología. Cada proyecto incluye una página de detalle y acceso al código.
  </p>

  <div class="filters" aria-label="Filtrar proyectos por categoría">
    <button class="chip is-active" type="button" data-filter="All">All</button>
    <button class="chip" type="button" data-filter="Power BI">Power BI</button>
    <button class="chip" type="button" data-filter="SQL">SQL</button>
    <button class="chip" type="button" data-filter="Python">Python</button>
    <button class="chip" type="button" data-filter="R">R</button>
  </div>

  {% assign cats = "SQL,Power BI,Python,R" | split: "," %}

  <div class="projects-grid">
    {% for cat in cats %}
      {% assign items = site.data.projects | where: "category", cat | sort: "order" %}
      {% for p in items %}

        {% comment %}
        Imagen por categoría (sin tocar projects.yml)
        Guardar en /assets/img/tools/
        {% endcomment %}

        {% assign tool_img = "" %}
        {% if p.category == "SQL" %}
          {% assign tool_img = "/assets/img/tools/sql.png" %}
        {% elsif p.category == "Power BI" %}
          {% assign tool_img = "/assets/img/tools/powerbi.png" %}
        {% elsif p.category == "Python" %}
          {% assign tool_img = "/assets/img/tools/python.png" %}
        {% elsif p.category == "R" %}
          {% assign tool_img = "/assets/img/tools/rstudio.png" %}
        {% endif %}

        <article class="project-card" data-category="{{ p.category }}">
          <div class="project-media">
            {% if tool_img != "" %}
              <img class="project-img" src="{{ tool_img | relative_url }}" alt="Imagen de {{ p.category }}">
            {% endif %}
          </div>

          <div class="project-body">
            <div class="project-top">
              <div class="project-cat">{{ p.category }}</div>
            </div>

            <h3 class="project-title">{{ p.title }}</h3>
            <p class="project-desc">{{ p.desc }}</p>

            {% if p.tags %}
              <div class="tags">
                {% for t in p.tags %}
                  <span class="tag">{{ t }}</span>
                {% endfor %}
              </div>
            {% endif %}

            <div class="project-actions">
              <a class="btn btn--primary btn--sm" href="{{ p.href | relative_url }}">Ver proyecto</a>
              {% if p.repo %}
                <a class="btn btn--sm" href="{{ p.repo }}" target="_blank" rel="noopener">Ver código</a>
              {% endif %}
            </div>
          </div>
        </article>

      {% endfor %}
    {% endfor %}
  </div>
</section>

<script>
  document.addEventListener("DOMContentLoaded", function () {
    const chips = document.querySelectorAll(".chip[data-filter]");
    const cards = document.querySelectorAll(".project-card[data-category]");

    function setFilter(filter) {
      chips.forEach(c => c.classList.toggle("is-active", c.dataset.filter === filter));
      cards.forEach(card => {
        const ok = (filter === "All") || (card.dataset.category === filter);
        card.style.display = ok ? "" : "none";
      });
    }

    chips.forEach(chip => chip.addEventListener("click", () => setFilter(chip.dataset.filter)));
    setFilter("All");
  });
</script>
