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

  {% assign order = "SQL,Power BI,Python,R" | split: "," %}

  {% for cat in order %}
    {% assign items = site.data.projects | where: "category", cat %}
    {% if items and items.size > 0 %}

      <div class="section" style="padding: 22px 0; border-bottom: none;">
        <div class="section-title" style="margin-bottom: 12px;">
          <h2>{{ cat }}</h2>
          <span>{{ items.size }} proyecto(s)</span>
        </div>

        <div class="grid">
          {% for p in items %}
            <a class="card" href="{{ p.href | relative_url }}">
              <p class="kicker">{{ p.category }}</p>
              <h3 class="title">{{ p.title }}</h3>
              <p class="desc">{{ p.desc }}</p>
            </a>
          {% endfor %}
        </div>
      </div>

    {% endif %}
  {% endfor %}
</section>
