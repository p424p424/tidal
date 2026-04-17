# Changelog

All notable changes to Tidal will be documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Tidal uses [Semantic Versioning](https://semver.org/).

---

## [Unreleased]

### Changed

- **Labeled arguments on all public builder functions** — every modifier beyond the piped component now uses Gleam's explicit label syntax (e.g. `button.label(text: "Save")`, `button.size(size: size.Sm)`, `input.on_input(handler: UserTyped)`). Callers must update call sites to pass the label name.
- **Descriptive parameter names** — removed all single-letter internal parameter names (`a`, `b`, `s`, `t`, `c`, etc.) from public functions; names now match their label (e.g. `styles`, `attributes`, `elements`, `handler`).
- **`new()` documentation comments** — every `new()` builder function now has a doc comment explaining what it creates, a complete builder chain example, and a link to the relevant DaisyUI/Lustre docs.
- `CONTRIBUTING.md` updated to document the labeled arg convention, descriptive naming rule, and `new()` doc comment requirement.
- `DESIGN.md` removed — superseded by inline module documentation and `CONTRIBUTING.md`.

### Added

- Full component library: `button`, `input`, `textarea`, `select`, `toggle`, `checkbox`, `radio`, `slider`, `file_input`, `badge`, `alert`, `avatar`, `tooltip`, `card`, `navbar`, `tabs`, `breadcrumb`, `menu`, `pagination`, `dock`, `modal`, `dropdown`, `drawer`, `loading`, `progress`, `radial_progress`, `stat`, `table`, `collapse`, `chat`, `rating`, `steps`, `timeline`, `countdown`, `diff`, `carousel`, `toast`, `hero`, `indicator`, `join`, `kbd`, `skeleton`, `swap`, `link`, `footer`, `fieldset`, `list_display`, `mockup_code`, `mockup_phone`, `mockup_window`, `theme_controller`
- Layout primitives: `el`, `row`, `column`, `container`, `grid`, `stack`, `text`, `image`, `spacer`, `divider`
- Complete Tailwind CSS utility coverage in `tidal/styling`: spacing, sizing, typography, colour, background, border, effects, filters, transition, transform, interactivity, layout, flexbox, grid, tables, SVG, and responsive breakpoints
- Responsive breakpoint modifiers (`sm`, `md`, `lg`, `xl`, `xxl`) that wrap any style value
- Named event handler functions on all interactive components (`on_click`, `on_input`, `on_check`, etc.)
- `APPEND` semantics on all `attrs()` and `style()` calls — calling either multiple times accumulates, never replaces
- `priv/tidal.js` safelist for Tailwind v4 static scanning
- `tidal/variant` and `tidal/size` shared type modules
- Working todo app example in `examples/example_app_todos`
