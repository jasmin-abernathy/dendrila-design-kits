# Dendrila — contrat responsive des six thèmes

Les compositions doivent rester reconnaissables sur mobile, y compris avant l’ajout de contenus.

## Seuils et navigation

- **≤ 64 rem / tablette** : le menu principal est remplacé par une commande native `<details><summary>Menu</summary>`, sans JavaScript. La commande est atteignable au clavier, les liens disposent d’une hauteur minimale de 44 px, et la liste se déploie dans un panneau de largeur bornée à l’écran.
- **≤ 60 rem / tablette étroite** : les compositions à deux colonnes et les grandes photographies se réorganisent en respectant le caractère du thème.
- **≤ 42 rem / téléphone** : une seule colonne pour les fiches, prestations ou tarifs ; les galeries photo conservent une grille de deux images lorsque possible ; typographie fluide et marges maîtrisées.
- **≤ 23 rem / petit téléphone** : réduction des éléments d’en-tête, titres et commande de navigation.
- **Paysage et faible hauteur** : panneau de menu scrollable et limité à 70dvh.
- **Accessibilité** : état ouvert/fermé fourni par HTML natif ; contour de focus 3 px ; aucune animation imposée en cas de préférence pour une réduction des animations. Les liens ne sont pas soulignés selon la direction graphique demandée, mais le focus et le survol restent perceptibles.

## Direction par direction

| Thème | Tablette | Téléphone |
|---|---|---|
| Simple illustré | Composition image/texte resserrée et cartes sur deux colonnes | Illustration sous le titre, cartes et étapes empilées |
| Sobre et élégant | Couverture photo sous le texte, chambre sur deux colonnes | Image recadrée, cartes et informations empilées |
| Centré sur les images | Triptyque grand format et photos en trois colonnes | Triptyque horizontal compact et galeries sur deux colonnes |
| Très minimal | Présentation typographique sur une colonne, offres en deux | Liste de services linéaire, offres et étapes sur une colonne |
| Dynamique et graphique | Affiche avec scène graphique sous le titre | Titre compact, formes décoratives recadrées, programme sur une colonne |
| Éditorial | Manuscrit en deux colonnes et manchette préservée | Une colonne de lecture avec une hiérarchie de titres claire |

## Tests

`bash tests/run.sh` exécute également `tests/responsive-check.py` pour s’assurer que les six pages de démonstration possèdent un menu mobile sans dépendance JS et les seuils CSS prévus.

Ces vérifications automatisées portent sur la structure CSS/HTML, **pas sur une comparaison de captures de véritables navigateurs à 320, 375, 430, 768 et 1024 px**. La recette visuelle et les interactions tactiles restent à effectuer avant de considérer les six thèmes esthétiquement validés.
