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

Les médias structurent la page : hero photographique immersif, grandes compositions, mosaïques et texte volontairement secondaire. Les deux références visuelles validées servent de bornes : l'une plus immersive, l'autre plus éditoriale, sans transformer ce thème en thème magazine.

### `very-minimal` — Très minimal

Une seule surface, très peu de décor, grandes hiérarchies typographiques, séparateurs fins et composants fonctionnels presque bruts. Les images existent mais ne prennent jamais le pas sur la lecture.

### `dynamic-graphic` — Dynamique et graphique

Composition forte, aplats, diagonales, contrastes, découpes et galerie asymétrique. Le thème doit rester lisible et accessible même lorsqu'il assume davantage de personnalité graphique.

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
