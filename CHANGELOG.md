# Changelog

All notable changes to Tidal will be documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Tidal uses [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Added

- Full component library: `button`, `input`, `textarea`, `select`, `toggle`, `checkbox`, `radio`, `slider`, `file_input`, `badge`, `alert`, `avatar`, `tooltip`, `card`, `navbar`, `tabs`, `breadcrumb`, `menu`, `pagination`, `bottom_nav`, `modal`, `dropdown`, `drawer`, `loading`, `progress`, `stat`, `table`, `collapse`
- Layout primitives: `el`, `row`, `column`, `stack`, `text`, `image`, `spacer`, `divider`
- Complete Tailwind CSS utility coverage across 18 style modules: `spacing`, `sizing`, `typography`, `color`, `background`, `border`, `effects`, `filters`, `transition`, `transform`, `interactivity`, `layout`, `flexbox`, `grid`, `tables`, `svg`, `accessibility`, `responsive`
- Responsive breakpoint modifiers (`sm`, `md`, `lg`, `xl`, `xxl`) that wrap any style value
- Named event handler functions on all interactive components (`on_click`, `on_input`, `on_check`, etc.)
- `APPEND` semantics on all `attrs()` and `style()` calls — calling either multiple times accumulates, never replaces
- `priv/tidal.js` safelist for Tailwind v4 static scanning
- `tidal/variant` and `tidal/size` shared type modules
- Working todo app example in `examples/example_app_todos`
