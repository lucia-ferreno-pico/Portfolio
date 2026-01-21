---
layout: default
---

<nav class="topnav">
  <div class="topnav__inner">
    <a class="topnav__brand" href="{{ '/' | relative_url }}">Lucía Ferreno</a>
    <div class="topnav__links">
      <a href="{{ '/' | relative_url }}#about">About</a>
      <a href="{{ '/' | relative_url }}#proyectos">Proyectos</a>
      <a href="{{ '/' | relative_url }}#cv">CV</a>
      <a href="{{ '/' | relative_url }}#contacto">Contacto</a>
    </div>
  </div>
</nav>

<section class="hero" id="inicio">
  <h1 class="hero__title">Lucía Ferreno Pico</h1>
  <p class="hero__subtitle">
    Analista de datos orientada a BI y analítica avanzada. Power BI (DAX + modelado), SQL, Python y R.
  </p>

  <div class="pills">
    <span class="pill">Power BI</span>
    <span class="pill">DAX</span>
    <span class="pill">Modelado</span>
    <span class="pill">SQL</span>
    <span class="pill">Python</span>
    <span class="pill">R</span>
  </div>

  <div class="hero__cta">
    <a class="btn btn--primary" href="{{ '/CV_Lucia_Ferreno.pdf' | relative_url }}" target="_blank" rel="noopener">Ver CV (PDF)</a>
    <a class="btn btn--ghost" href="https://www.linkedin.com/in/lucia-ferreno-data-analyst" target="_blank" rel="noopener">LinkedIn</a>
    <a class="btn btn--ghost" href="https://github.com/lucia-ferreno-pico" target="_blank" rel="noopener">GitHub</a>
  </div>
</section>

<section class="section" id="about">
  <div class="section__title">
    <h2>About</h2>
    <span class="section__hint">Qué aporto</span>
  </div>

  <p>
    Analista de datos orientada a BI y analítica avanzada. Transformo datos en decisiones con dashboards accionables,
    modelos de datos sólidos y análisis reproducibles.
  </p>

  <div class="grid">
    <div class="card" style="grid-column: span 4;">
      <div class="card__body">
        <p class="card__kicker">1) BI orientado a negocio</p>
        <h3 class="card__title">Dashboards que se usan</h3>
        <p class="card__desc">KPIs claros, storytelling visual y navegación pensada para usuario final.</p>
        <div class="card__tags">
          <span class="tag">Power BI</span><span class="tag">KPIs</span><span class="tag">UX</span>
        </div>
      </div>
    </div>

    <div class="card" style="grid-column: span 4;">
      <div class="card__body">
        <p class="card__kicker">2) Datos confiables</p>
        <h3 class="card__title">Modelado + calidad</h3>
        <p class="card__desc">Modelo estrella, definición de métricas y controles de calidad para evitar “números distintos”.</p>
        <div class="card__tags">
          <span class="tag">Modelado</span><span class="tag">DAX</span><span class="tag">Data QA</span>
        </div>
      </div>
    </div>

    <div class="card" style="grid-column: span 4;">
      <div class="card__body">
        <p class="card__kicker">3) Analítica aplicada</p>
        <h3 class="card__title">EDA y modelos</h3>
        <p class="card__desc">Análisis exploratorio, segmentación y modelos interpretables para apoyar decisiones.</p>
        <div class="card__tags">
          <span class="tag">Python</span><span class="tag">R</span><span class="tag">Clustering</span>
        </div>
      </div>
    </div>
  </div>

  <div class="pills" style="margin-top: 1rem;">
    <span class="pill">Power BI · DAX</span>
    <span class="pill">SQL · Window Functions</span>
    <span class="pill">Python · Pandas</span>
    <span class="pill">R · EDA</span>
  </div>
</section>

<section class="section" id="proyectos">
  <div class="section__title">
    <h2>Proyectos</h2>
    <span class="section__hint">Portfolio por tecnología</span>
  </div>

  {% assign order = "SQL,Power BI,Python,R" | split: "," %}

  {% for cat in order %}
    {% assign items = site.data.projects | where: "category", cat %}
    {% if items and items.size > 0 %}

      {% assign anchor = cat | downcase | replace: " ", "" %}
      <div class="section" id="{{ anchor }}">
        <div class="section__title">
          <h2>{{ cat }}</h2>
          <span class="section__hint">{{ items.size }} proyecto(s)</span>
        </div>

        <div class="grid">
          {% for p in items %}
            <a class="card" href="{{ p.href | relative_url }}">
              {% if p.image %}
                <img class="card__thumb" src="{{ p.image | relative_url }}" alt="{{ p.title }}">
              {% endif %}
              <div class="card__body">
                <p class="card__kicker">{{ p.category }}</p>
                <h3 class="card__title">{{ p.title }}</h3>
                <p class="card__desc">{{ p.desc }}</p>
                {% if p.tags %}
                  <div class="card__tags">
                    {% for t in p.tags %}
                      <span class="tag">{{ t }}</span>
                    {% endfor %}
                  </div>
                {% endif %}
              </div>
            </a>
          {% endfor %}
        </div>
      </div>

    {% endif %}
  {% endfor %}
</section>

<section class="section" id="cv">
  <div class="section__title">
    <h2>CV</h2>
    <span class="section__hint">PDF</span>
  </div>

  <p>Descarga o visualiza mi CV en PDF.</p>

  <div class="hero__cta">
    <a class="btn btn--primary" href="{{ '/CV_Lucia_Ferreno.pdf' | relative_url }}" target="_blank" rel="noopener">Ver CV (PDF)</a>
    <a class="btn btn--ghost" href="{{ '/CV_Lucia_Ferreno.pdf' | relative_url }}" download>Descargar CV</a>
  </div>

  <div class="pills" style="margin-top:.9rem;">
    <span class="pill">PL-300</span>
    <span class="pill">Power BI</span>
    <span class="pill">SQL</span>
    <span class="pill">Python</span>
    <span class="pill">R</span>
  </div>
</section>

<section class="section" id="contacto">
  <div class="section__title">
    <h2>Contacto</h2>
    <span class="section__hint">Hablemos</span>
  </div>

  <p>
    Si quieres comentar un proyecto, una oportunidad o necesitas apoyo en BI/analítica, puedes contactarme por estos canales:
  </p>

  <div class="grid">
    <a class="card" style="grid-column: span 4;" href="mailto:luciaferreferre@gmail.com">
      <div class="card__body">
        <p class="card__kicker">Email</p>
        <h3 class="card__title">luciaferreferre@gmail.com</h3>
        <p class="card__desc">Canal preferido para propuestas y detalles.</p>
        <div class="card__tags"><span class="tag">mailto</span><span class="tag">respuesta rápida</span></div>
      </div>
    </a>

    <a class="card" style="grid-column: span 4;" href="https://www.linkedin.com/in/lucia-ferreno-data-analyst" target="_blank" rel="noopener">
      <div class="card__body">
        <p class="card__kicker">LinkedIn</p>
        <h3 class="card__title">Perfil profesional</h3>
        <p class="card__desc">Experiencia, certificación y publicaciones.</p>
        <div class="card__tags"><span class="tag">networking</span><span class="tag">mensajería</span></div>
      </div>
    </a>

    <a class="card" style="grid-column: span 4;" href="https://github.com/lucia-ferreno-pico" target="_blank" rel="noopener">
      <div class="card__body">
        <p class="card__kicker">GitHub</p>
        <h3 class="card__title">Repositorios</h3>
        <p class="card__desc">Código, notebooks y documentación de proyectos.</p>
        <div class="card__tags"><span class="tag">portfolio</span><span class="tag">repos</span></div>
      </div>
    </a>
  </div>

  <div class="hero__cta" style="margin-top: 1rem;">
    <a class="btn btn--primary" href="mailto:luciaferreferre@gmail.com">Escríbeme</a>
    <a class="btn btn--ghost" href="https://www.linkedin.com/in/lucia-ferreno-data-analyst" target="_blank" rel="noopener">Abrir LinkedIn</a>
  </div>
</section>
