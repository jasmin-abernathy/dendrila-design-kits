# Contributing

[Français](CONTRIBUTING.md)

1. Open an issue with an idea, mock-up or improvement. A kit defines a visual direction, not a business or client brand.
2. Fork, create a branch and copy the [starter](starter/README.md) into themes/your-id. Choose a unique lowercase identifier.
3. Adapt theme.json, theme.css and preview/index.html; add a catalogue mapping only with a recognised design_style_id or an explicitly documented CMS contract proposal.
4. Use --dendrila-* variables; preserve content, forms and business features. Scope CSS to the theme root. No PHP, imported JavaScript, tracking, remote fonts or external resource loading in new kits.
5. Supply a fictional-content preview, local assets, credits (author, URL, licence, changes), desktop/mobile screenshots. Check keyboard, focus, WCAG AA contrast, zoom, reduced motion, readability and weight. Prefer original, CC0 or public-domain artwork; no AI-generated images in proposed catalogue contributions.
6. Run bash tests/run.sh; open a pull request with results, limitations, screenshots and credits. Automated checks do not replace human review or CMS integration testing.

Maintainer review precedes publication. Never submit client data or secrets. Overall licensing is pending: contributions intended for distribution will not be merged until licensing is agreed. Credits may use a pseudonym and optional portfolio; no private addresses.
