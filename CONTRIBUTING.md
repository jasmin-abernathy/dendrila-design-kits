# Contribuer

[English](CONTRIBUTING.en.md)

1. Ouvrir une issue avec une idée, une maquette ou une amélioration. Un thème doit définir une direction visuelle et non un métier ou une marque cliente.
2. Forker le dépôt, créer une branche et copier le [kit de démarrage](starter/README.md) dans themes/identifiant. Utiliser un identifiant unique en minuscules.
3. Adapter theme.json, theme.css et preview/index.html ; ajouter le mapping au catalogue uniquement avec un design_style_id reconnu ou une proposition de contrat CMS explicitement documentée.
4. Utiliser les variables --dendrila-* ; conserver le contenu, les formulaires et les fonctionnalités métier. CSS délimité à la racine du thème. Pas de PHP, JavaScript importé, traçage, police distante ou chargement de ressources externes dans les nouveaux kits.
5. Fournir une prévisualisation avec contenu fictif, médias locaux, crédits (auteur, URL, licence, modifications) et captures ordinateur/mobile. Vérifier clavier, focus, contraste WCAG AA, zoom, réduction des animations, lisibilité et poids. Privilégier les créations originales, CC0 ou domaine public ; aucune image générée par IA dans les contributions proposées au catalogue.
6. Lancer bash tests/run.sh ; ouvrir une pull request avec résultat, limites, captures et crédits. Les tests ne remplacent pas la revue humaine ni le test d'intégration CMS.

Le mainteneur relit les propositions avant publication. Ne pas soumettre de données clients ni de secrets. La licence globale reste à confirmer : les contributions de code destinées à être distribuées ne seront pas intégrées avant accord sur la licence. Les crédits peuvent inclure un pseudonyme et un portfolio facultatif ; ne pas fournir d'adresse privée.
