# Dendrila Design Kits

Bibliothèque de thèmes/fronts réutilisables pour Dendrila CMS.

Ce dépôt contient la **couche de présentation** : structure HTML/CSS, composants visuels, médias de prévisualisation et exemples. Les contrats de styles, tokens sémantiques et contraintes d'accessibilité restent définis dans `jasmin-abernathy/dendrila-cms`.

## Principe

```text
Dendrila CMS (contenu + tokens)
        ↓
Design kit (structure + composants)
        ↓
Identité du site (couleurs + typo + logo + médias)
        ↓
Site final
```

Un design kit ne contient ni logique métier, ni nom de client, ni palette imposée. Il fournit une direction visuelle cohérente avec des valeurs neutres de secours que l'identité du site peut surcharger.

## Thèmes disponibles

### `simple-illustrated` — Simple avec quelques illustrations

Structure claire, sections respirantes, illustrations ponctuelles, formes douces et médias non destructifs. Ce thème est issu de la généralisation du travail réalisé pour Materceleste, sans reprendre son identité.

### `image-centered` — Centré sur les images

Les médias structurent la page : hero photographique immersif, grandes compositions, mosaïques et texte volontairement secondaire. La direction est basée uniquement sur la référence photographique immersive validée ; la deuxième maquette envoyée a été écartée.

### `quiet-elegant` — Sobre et élégant

Beaucoup d’espace, serif éditoriale, détails fins et images naturelles. Le décor botanique est fourni par le thème et reste optionnel : aucun asset graphique n’est demandé au client.

### `very-minimal` — Très minimal

Une seule surface, très peu de décor, grandes hiérarchies typographiques, séparateurs fins et composants fonctionnels presque bruts. Les images existent mais ne prennent jamais le pas sur la lecture.

### `dynamic-graphic` — Dynamique et graphique

Composition forte, aplats, diagonales, contrastes, découpes et galerie asymétrique. Le thème doit rester lisible et accessible même lorsqu'il assume davantage de personnalité graphique.

### `editorial` — Éditorial

Direction tirée des **principes de composition de l’advarP** (sans reprendre son nom, son logo, ses contenus ni ses couleurs) : titres hiérarchisés, filets de rubrique, mise en avant d’un article et deux colonnes secondaires, colonne de lecture étroite pour les analyses longues. Sur mobile, les rubriques deviennent des articles empilés et lisibles. Le thème demeure utilisable par n’importe quel média, association ou site riche en textes.

### `editorial` — Éditorial

Hiérarchie de presse, filets, une et colonnes secondaires inspirées de la grammaire de l’advarP, sans reprendre sa marque. Cette version consolide le thème de la PR #9 et les corrections de correspondance du catalogue de la PR #8.

## Contrat avec Dendrila CMS

Tous les thèmes consomment les variables structurelles compilées par Dendrila CMS :

- `--dendrila-content-max`
- `--dendrila-section-gap`
- `--dendrila-text-max`
- `--dendrila-radius`
- `--dendrila-border-width`
- `--dendrila-shadow`
- `--dendrila-heading-scale`
- `--dendrila-media-emphasis`
- `--dendrila-accent-strength`
- `--dendrila-motion-duration`

Les couleurs et polices restent des variables de marque `--dendrila-color-*` / `--dendrila-font-*`. Les thèmes fournissent uniquement des valeurs de secours pour leurs previews.

`catalog.json` est le point d'entrée machine du dépôt. Dendrila CMS peut le lire localement pour résoudre un `design_style` vers le design kit installé correspondant, sans téléchargement de code à l'exécution.

## Prévisualisations

Chaque thème contient une preview autonome dans `themes/<id>/preview/`. Elles utilisent des contenus et médias génériques : elles servent à comparer la direction graphique, pas à proposer un secteur métier.

## Validation

```sh
bash tests/run.sh
```


## Motifs et formes sans préparation d'assets

Chaque design kit déclare désormais un `decorative_system` dans son manifeste. Les motifs, masques et formes appartiennent au thème : ils sont produits en CSS ou livrés comme SVG locaux.

Le site n'a donc jamais besoin d'importer une feuille, une diagonale, une arche, un blob ou un autre élément décoratif pour reproduire la direction graphique. Dendrila conserve l'image source rectangulaire et applique la forme à l'affichage.

Les attributs déjà exposés par le renderer pilotent ce comportement :

- `data-media-shape` pour les formes d'images ;
- `data-dendrila-illustration-style` pour choisir la famille de motif ;
- `data-dendrila-illustration-frequency` pour désactiver ou doser le décor.

Voir `docs/DECORATIVE-SYSTEM.md`.


Les identifiants de thème et de style ne sont pas toujours identiques : `image-forward` → `image-centered`, `ultra-minimal` → `very-minimal`, `graphic-rhythm` → `dynamic-graphic`. Les trois autres correspondances sont directes. Les tests vérifient cette table explicitement.
