# Dendrila Design Kits

Bibliothèque de thèmes/fronts réutilisables pour Dendrila CMS.

Ce dépôt contient la **couche de présentation** : structure HTML/CSS, composants visuels, masques média et exemples. Les contrats de styles, tokens sémantiques et contraintes d'accessibilité restent définis dans `jasmin-abernathy/dendrila-cms`.

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

Un design kit ne contient ni logique métier, ni nom de client, ni palette imposée. Il fournit un rendu cohérent avec des valeurs neutres de secours, que l'identité du site peut surcharger.

## Thèmes

### `simple-illustrated`

Premier thème de référence correspondant au style Dendrila **« Simple avec quelques illustrations »**.

Il s'appuie sur les enseignements de la refonte Materceleste pour généraliser notamment :

- hero en deux colonnes ;
- sections respirantes ;
- cartes simples ;
- illustrations/pictogrammes ponctuels ;
- médias non destructifs avec masques CSS/SVG ;
- point focal indépendant du fichier image ;
- fonds doux alternés ;
- navigation et CTA lisibles ;
- accessibilité clavier et mouvement réduit.

L'identité Materceleste elle-même n'est pas incluse : pas de palette terracotta, pas de contenu, pas de médias, pas de typographie ou de logique métier propres au site.

Voir `themes/simple-illustrated/` et `docs/simple-illustrated.md`.

## Contrat avec Dendrila CMS

Le thème `simple-illustrated` consomme les variables compilées par le preset `design-styles/simple-illustrated/style.json` de Dendrila CMS, notamment :

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

Le thème consomme directement ces variables de style `--dendrila-*`. Il ajoute en parallèle un contrat de marque distinct (`--dendrila-color-*` et `--dendrila-font-*`) pour les couleurs et polices. Ces valeurs doivent être alimentées par la composition du site ou l'adaptateur front.

Le fichier `catalog.json` est le point d’entrée machine du dépôt. Dendrila CMS peut le lire localement au déploiement pour résoudre un `design_style` vers un design kit installé, sans téléchargement de code à l’exécution.

## Validation

```sh
bash tests/run.sh
```
