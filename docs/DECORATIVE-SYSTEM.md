# Système décoratif sans asset client

Les design kits Dendrila doivent pouvoir reproduire leurs motifs, découpes et formes d'images **sans demander à l'utilisateur de préparer ou télécharger un élément graphique**.

## Contrat

Chaque `theme.json` expose un objet `decorative_system` :

- `no_upload_required: true` : aucune ressource décorative n'est attendue du site ;
- `motifs` : familles décoratives disponibles dans le thème ;
- `default_motif` : comportement de secours ;
- `image_shapes` : formes que le thème sait appliquer à une image source normale ;
- `implementation: theme-owned-css-svg` : CSS, pseudo-éléments et SVG locaux au design kit.

## Commandes déjà disponibles dans le renderer

Le renderer Dendrila fournit :

- `data-media-shape` sur chaque média ;
- `data-dendrila-illustration-style` sur la page ;
- `data-dendrila-illustration-frequency` sur la page.

Les thèmes utilisent ces attributs plutôt que de modifier les fichiers source.

## Par thème

- **Simple avec quelques illustrations** : masques organiques + motif linéaire léger.
- **Centré sur les images** : cadrage photo, arche/cercle et cadre linéaire optionnel.
- **Sobre et élégant** : arche, masque organique et motif botanique intégré.
- **Très minimal** : cercle/arrondi et simple trait CSS ; aucun motif bitmap.
- **Dynamique et graphique** : découpes géométriques, diagonales et motif géométrique intégré.

## Règle de conception

Une image envoyée dans Dendrila reste une image rectangulaire exploitable partout. Le design kit décide uniquement de sa présentation. Changer de thème ne doit jamais nécessiter de recadrer ou de réexporter le média.
