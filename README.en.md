# Dendrila Design Kits

[Français](README.md) · [Contribute](CONTRIBUTING.en.md)

A community-oriented library of reusable presentation kits for Dendrila CMS. HTML/CSS structure, visual components, preview media and examples live here. The CMS defines semantic tokens and accessibility contracts. Content, functionality, visual style and site identity remain separate.

## Available kits on main

| ID | Direction |
| --- | --- |
| simple-illustrated | Clear layouts with occasional illustrations and soft shapes |
| image-centered | Immersive photography, galleries and image-led compositions |
| quiet-elegant | Generous space, editorial typography and optional botanical details |
| very-minimal | Restrained decoration and strong reading hierarchy |
| dynamic-graphic | Bold geometry, colour blocks and asymmetric compositions |

The official showcase includes six CMS-exported demos, including editorial; the current main catalogue contains five kits. This repository is not yet a stable end-user theme installer.

## Build and contribute

No framework is required. Start from [the starter](starter/README.md), follow the [contribution guide](CONTRIBUTING.en.md) and run:

```sh
bash tests/run.sh
```

Each kit provides theme.json, theme.css, a standalone preview and local assets. Reuse the structural and brand CSS variables defined in [the French README](README.md), preserve focus and reduced motion, avoid tracking and runtime remote dependencies. Decorative CSS/SVG belongs to the kit; source photographs must remain unchanged.

[Preview themes](https://dendrila.lepotager.org/themes/) · [Suggest a kit](https://github.com/jasmin-abernathy/dendrila-design-kits/issues/new/choose) · [Asset credits](docs/PREVIEW-MEDIA.md) · [Licensing status](LICENSE.md).

Contributions are reviewed before inclusion. The overall licence still requires maintainer confirmation; do not assume public availability grants redistribution rights.
