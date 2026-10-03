// Preview-only interactions. Production consent is owned by Dendrila Privacy.
const dialog = document.querySelector('#lecture');
document.querySelectorAll('[data-article]').forEach(link => {
  link.addEventListener('click', event => {
    event.preventDefault();
    document.querySelector('#lecture-title').textContent = link.textContent;
    document.querySelector('#lecture-intro').textContent = link.closest('article').querySelector('h1 + p, h2 + p, h3 + p').textContent;
    dialog.showModal();
  });
});
document.querySelector('[data-dendrila-consent-allow]').addEventListener('click', event => {
  const status = document.querySelector('#consent-status');
  status.hidden = false;
  status.textContent = 'Démonstration : aucun service externe n’est chargé. Sur le site, Dendrila Privacy gère votre choix.';
  event.currentTarget.disabled = true;
});
