# cho_os_portfolio

Flutter source for the portfolio site deployed from the repo root.

The original source was lost, so this was rebuilt from the compiled
`main.dart.js`: layout values, colors, animation timings and all text were
decoded from the bundle, and the content in `lib/data/portfolio_data.dart` is
copied verbatim from it.

## Build and deploy

```bash
cd app
MSYS_NO_PATHCONV=1 flutter build web --release --base-href /Portfolio-Flutter/
node ../i18n/build-en.js build/web
```

`MSYS_NO_PATHCONV=1` is only needed in Git Bash, which otherwise rewrites
`/Portfolio-Flutter/` into a Windows path.

Then copy `build/web/*` over the repo root (keep `.nojekyll`, `README.md` and
`i18n/`) and push `main`.

## Layout

- `lib/main.dart`: routes (`/`, `/portfolio`, `/desktop`, `/project/<slug>`,
  anything else shows the System Alert page)
- `lib/theme.dart`: light/dark palette, shadows, gradients
- `lib/data/`: projects, awards, toolkit
- `lib/pages/`, `lib/sections/`: screens
- `web/index.html`: language picker and back button (plain HTML over Flutter)
- `web/flutter_bootstrap.js`: loads `main.dart.en.js` when English is chosen
- `web/three_intro/`: the Three.js intro scene shown on `/`

## English

Korean strings are translated at build time, not in Dart: `i18n/en.json` maps
each Korean string to English and `i18n/build-en.js` writes
`main.dart.en.js`. When you add or change Korean text, add the English to
`en.json`; the script lists anything it could not translate.
