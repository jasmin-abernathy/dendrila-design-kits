# Simple avec quelques illustrations

## Rôle

Ce design kit donne un **front de base réutilisable** au preset Dendrila CMS `simple-illustrated`.

Le preset dans `dendrila-cms` exprime les intentions graphiques sous forme de tokens. Ce dépôt les transforme en composants réellement utilisables dans un front léger.

## Ce qui a été généralisé depuis Materceleste

La refonte Materceleste a servi de cas réel pour identifier les motifs utiles au style :

- hero scindé texte + média ;
- beaucoup de respiration sans vide excessif ;
- cartes simples et faciles à parcourir ;
- sections claires alternant fond neutre et fond doux ;
- pictogrammes ou petits ornements plutôt que décor permanent ;
- formes organiques appliquées aux médias ;
- décor arrière séparé de l'image ;
- CTA arrondis et immédiatement identifiables ;
- adaptation mobile sans composition parallèle.

Ces motifs ont été **désolidarisés de l'identité Materceleste**.

Ne font donc pas partie du thème :

- ses couleurs ;
- ses textes ;
- ses prestations ;
- ses médias ;
- ses symboles de marque ;
- ses intégrations réservation/paiement ;
- sa typographie exacte.

## Contrat média

Le fichier source n'est jamais découpé ou transformé pour correspondre au thème.

Exemple :

```html
<div
  class="d-media"
  data-media-shape="organic-soft"
  style="--d-media-x:42%;--d-media-y:35%;"
>
  <img class="d-media__image" src="/media/photo.webp" alt="Description">
</div>
```

Le CMS/front peut donc conserver :

- `src` : média original ;
- `alt` : alternative textuelle ;
- `shape` : `auto`, `organic-soft`, `organic-tall`, `arch`, `circle`, `rounded` ou `none` ;
- `focal_x` : 0–100 ;
- `focal_y` : 0–100.

Le renderer convertit `focal_x` / `focal_y` vers les variables CSS `--d-media-x` / `--d-media-y`.

Le fallback sans support de `mask-image` conserve une forme proche avec `border-radius`.

## Contrat de marque

Le design kit propose des valeurs neutres de secours. L'identité du site devrait surcharger au minimum :

```css
[data-dendrila-theme="simple-illustrated"] {
  --dendrila-color-bg: ...;
  --dendrila-color-surface: ...;
  --dendrila-color-text: ...;
  --dendrila-color-muted: ...;
  --dendrila-color-primary: ...;
  --dendrila-color-primary-strong: ...;
  --dendrila-color-accent-soft: ...;
  --dendrila-color-border: ...;
  --dendrila-font-heading: ...;
  --dendrila-font-body: ...;
}
```

## Relation avec les tokens Dendrila

Le thème lit directement les variables `--dendrila-*` produites par `CssTokenCompiler`.

Il ne remplace pas le preset et ne duplique pas son rôle : les tokens décident de l'intention, le design kit fournit les composants qui savent l'appliquer.

## Accessibilité

Le thème fournit :

- skip-link ;
- focus visible ;
- hiérarchie HTML native dans l'exemple ;
- médias décoratifs avec `alt=""` lorsque nécessaire ;
- aucune lecture automatique ;
- annulation des mouvements sous `prefers-reduced-motion` ;
- comportement responsive sans ordre visuel incohérent.

Les couleurs réelles de marque doivent toujours être contrôlées au minimum pour WCAG AA avant publication.


## Composants rendus par l'adaptateur public

La version 0.2 du kit couvre également les blocs génériques nécessaires au premier renderer Dendrila :

- galerie en grille, masonry, filmstrip ou éditorial selon le token du preset ;
- paires clé/valeur sémantiques en `<dl>` ;
- placeholders d'embed compatibles avec le consentement natif Dendrila Privacy ;
- médias de cartes ;
- attributs de structure pour l'ordre du hero et l'alignement.

Le thème ne décide pas du contenu : le renderer du CMS produit le HTML sémantique commun, tandis que le design kit détermine son apparence.
