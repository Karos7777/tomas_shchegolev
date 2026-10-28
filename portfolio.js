(() => {
  const toggle = document.getElementById('langToggle');
  const metadata = {
    ru: {
      title: 'Томас Щёголев — приложения, программы и скрипты с помощью ИИ',
      description: 'Создаю приложения для Google Play, программы для Windows и браузерные скрипты с помощью ИИ. Мои проекты, реальные результаты и то, с чем я могу помочь.',
      switchLabel: 'Switch to English',
    },
    en: {
      title: 'Tomas Shchegolev — Apps, desktop tools & scripts with AI',
      description: 'I build Google Play apps, Windows tools and browser scripts with AI. My projects, real results and the things I can help you with.',
      switchLabel: 'Переключить на русский',
    },
  };

  function applyLanguage(lang) {
    document.querySelectorAll('[data-ru][data-en]').forEach(element => {
      element.textContent = element.dataset[lang];
    });
    document.querySelectorAll('[data-alt-ru][data-alt-en]').forEach(element => {
      element.alt = element.getAttribute('data-alt-' + lang);
    });
    document.documentElement.lang = lang;
    document.title = metadata[lang].title;
    document.querySelectorAll('meta[name="description"], meta[property="og:description"], meta[name="twitter:description"]').forEach(element => {
      element.content = metadata[lang].description;
    });
    document.querySelectorAll('meta[property="og:title"], meta[name="twitter:title"]').forEach(element => {
      element.content = metadata[lang].title;
    });
    toggle.setAttribute('aria-label', metadata[lang].switchLabel);
    toggle.querySelectorAll('[data-lang]').forEach(element => {
      element.classList.toggle('active', element.dataset.lang === lang);
    });
    try { localStorage.setItem('ts-lang', lang); } catch (_) { /* Language works without storage. */ }
  }

  let saved;
  try { saved = localStorage.getItem('ts-lang'); } catch (_) { /* Default to Russian. */ }
  applyLanguage(saved === 'en' ? 'en' : 'ru');
  toggle.addEventListener('click', () => applyLanguage(document.documentElement.lang === 'ru' ? 'en' : 'ru'));

})();
