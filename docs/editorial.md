# Éditorial / magazine

## Référence retenue

La dernière composition validée le 3 octobre 2026 : une de média modérément dense, un grand sujet à gauche et deux sujets secondaires à droite, puis trois sujets « À explorer », une galerie légendée, FAQ et contenu externe côte à côte, CTA et pied de page. La section « En quelques chiffres » a été explicitement supprimée, sans remplacement.

Le nom, les textes, rubriques et photographies de la preview sont des données de démonstration. Le nom Horizon respecte la convention des previews existantes ; les photos réutilisent les sources documentées dans PREVIEW-MEDIA.md. Les portraits d’auteurs ne sont pas nécessaires au thème ; les métadonnées restent textuelles.

## Contrat de présentation

- ID de thème et preset CMS : `editorial`.
- Variables de marque surchargeables : couleurs, polices et identité restent séparées du style.
- `.d-front-page` sur une `.d-card-grid` : article principal sur deux rangées et deux sujets secondaires.
- Le premier bloc `cards` standard du renderer bénéficie aussi de cette composition. Un bloc de trois cartes forme la une ; un second bloc de trois cartes forme « À explorer ».
- `.d-gallery` utilise une grande image et deux petites en mode editorial.
- `.d-editorial-utilities` réunit FAQ et embed sur desktop ; empilement mobile.
- Compatibilité conservée avec hero, cards, gallery, text/rich_text, statistics, key_values, faq, embed_safe et cta. Les statistiques ne sont pas cachées par CSS si un site en possède : leur absence est propre à la composition de démonstration.

## Limite explicite du renderer CMS actuel

Le renderer standard construit toujours son introduction de page puis des blocs indépendants. Il ne produit pas encore les rubriques/auteurs/temps de lecture ni le conteneur commun FAQ + embed. Le thème les prend en charge, la preview les illustre ; aucune nouvelle capacité d’édition de ces métadonnées n’est prétendue. La reproduction exacte de la preview dans une page générée nécessite ce balisage de composition. Le présent lot ne change pas le noyau CMS.

## Accessibilité et interactions

- Ordre DOM conservé sur mobile, navigation repliée sur plusieurs lignes, pas de défilement horizontal global.
- Un seul h1, rubriques en h2, articles secondaires de rubrique en h3, lien d’évitement et focus visible.
- FAQ native details/summary ; articles de preview ouverts dans un dialog natif, fermeture Échap et retour du focus.
- Le script preview est exclusivement démonstratif : aucun iframe tiers, stockage de consentement ou requête vers un fournisseur n’est activé au clic. Le vrai consentement reste la responsabilité de Dendrila Privacy.
- Pas de police distante ni dépendance JS du thème. Photographies distantes uniquement dans la preview.

## Validation

`bash tests/run.sh` valide les six thèmes et le contrat des identifiants CMS. `tests/editorial.py` vérifie les ancres, les six articles, le h1 unique, les alternatives, la FAQ et l’absence de statistiques/iframe dans la preview.
