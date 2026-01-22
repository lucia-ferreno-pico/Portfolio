---
layout: default
title: Portfolio
---

<section class="hero">
  <div class="hero-grid">
    <img class="avatar" src="{{ '/assets/img/profile/avatar.png' | relative_url }}" alt="Foto de perfil de Lucía Ferreño">

    <div>
      <h1>Lucía Ferreño Pico</h1>

      <p class="subtitle">Un poco sobre mí</p>

      <p>
        Soy Lucía Ferreño. En 2025 he dado un giro profesional muy meditado. Tras varios años en contabilidad y gestión financiera y empresarial en distintos sectores económicos, decidí enfocarme en analítica e inteligencia de negocio ya que quiero asumir retos donde mi trabajo tenga un impacto claro y medible.
      </p>
      <p>
        Estoy convencida de que los beneficios corporativos y económicos llegan cuando las decisiones se toman con datos fiables, definiciones claras y una lectura correcta del contexto.
      </p>

      <div class="cta">
        <a class="btn btn--primary" href="{{ '/CV_Lucia_Ferreno.pdf' | relative_url }}" target="_blank" rel="noopener">Ver CV</a>
        <a class="btn" href="{{ '/CV_Lucia_Ferreno.pdf' | relative_url }}" download>Descargar CV</a>
        <a class="btn" href="https://www.linkedin.com/in/lucia-ferreno-data-analyst" target="_blank" rel="noopener">LinkedIn</a>
        <a class="btn" href="https://github.com/lucia-ferreno-pico" target="_blank" rel="noopener">GitHub</a>
      </div>
    </div>
  </div>
</section>

<section class="section" id="about">
  <div class="section-title">
    <h2>About</h2>
    <span>Enfoque</span>
  </div>

  <p>
    BI y analítica aplicada para apoyar decisiones con métricas consistentes, datos confiables y dashboards accionables.
  </p>

  <div class="personal">
    <div class="box">
      <h3>Family</h3>
      <p>Placeholder breve (lo afinamos cuando el diseño esté estable).</p>
    </div>
    <div class="box">
      <h3>Afición</h3>
      <p>Placeholder breve (lo afinamos cuando el diseño esté estable).</p>
    </div>
  </div>
</section>

<section class="section" id="proyectos">
  <div class="section-title">
    <h2>Proyectos</h2>
    <span>Por categoría</span>
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

<section class="section" id="cv">
  <div class="section-title">
    <h2>CV</h2>
    <span>PDF + credencial</span>
  </div>

  <div class="cta">
    <a class="btn btn--primary" href="{{ '/CV_Lucia_Ferreno.pdf' | relative_url }}" target="_blank" rel="noopener">Ver CV</a>
    <a class="btn" href="{{ '/CV_Lucia_Ferreno.pdf' | relative_url }}" download>Descargar CV</a>
    <a class="btn" href="https://learn.microsoft.com/api/credentials/share/es-es/luciaferrenopico-9943/D15B2D91C08BD62B?sharingId=1CE9A7D4EED2BA72" target="_blank" rel="noopener noreferrer">PL-300</a>
  </div>
</section>

<section class="section" id="contacto">
  <div class="section-title">
    <h2>Contacto</h2>
    <span>Minimal</span>
  </div>

  <div class="contact-line">
    <b>Email:</b> <span>luciaferreferre@gmail.com</span>
    <a href="mailto:luciaferreferre@gmail.com">Escríbeme</a>
  </div>

  <div class="contact-line" style="margin-top:10px;">
    <b>GitHub:</b> <a href="https://github.com/lucia-ferreno-pico" target="_blank" rel="noopener">lucia-ferreno-pico</a>
    <b>LinkedIn:</b> <a href="https://www.linkedin.com/in/lucia-ferreno-data-analyst" target="_blank" rel="noopener">lucia-ferreno-data-analyst</a>
  </div>
</section>
