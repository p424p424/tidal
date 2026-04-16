# tidal

[![Package Version](https://img.shields.io/hexpm/v/tidal)](https://hex.pm/packages/tidal)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/tidal/)

A UI component library for [Lustre](https://hexdocs.pm/lustre/) built on [Tailwind CSS](https://tailwindcss.com/) and [DaisyUI](https://daisyui.com/).

Tidal gives you a builder-pattern API where every component, layout primitive, and style utility is a plain Gleam function. No HTML, no CSS class strings, no raw attributes — just a pipeline.

```gleam
button.new("Save changes")
|> button.variant(variant.Primary)
|> button.size(size.Lg)
|> button.on_click(UserClickedSave)
|> button.build
```

```gleam
card.new()
|> card.style([sizing.w_full(), responsive.md(sizing.max_w_lg())])
|> card.children([
  card.figure_el([html.img([attribute.src("/hero.jpg")])]),
  card.body_el([
    card.title_el([element.text("Hello, Tidal")]),
    text.new("Build UIs in pure Gleam.")
    |> text.style([typography.text_sm()])
    |> text.build,
  ]),
])
|> card.build
```

```gleam
column.new()
|> column.style([sizing.w_full(), sizing.max_w_md(), spacing.mx_auto()])
|> column.children([
  text.new("Sign in")
  |> text.h2()
  |> text.style([typography.text_2xl(), typography.font_bold()])
  |> text.build,
  input.new()
  |> input.type_(input.Email)
  |> input.placeholder("you@example.com")
  |> input.on_input(UserTypedEmail)
  |> input.build,
  input.new()
  |> input.type_(input.Password)
  |> input.placeholder("Password")
  |> input.on_input(UserTypedPassword)
  |> input.build,
  button.new("Sign in")
  |> button.variant(variant.Primary)
  |> button.style([sizing.w_full()])
  |> button.on_click(UserSubmitted)
  |> button.build,
])
|> column.build
```

---

## Why Tidal

**No class strings.** Every visual property is a typed function call. Typos in class names are compile errors, not silent style breakage.

**Consistent API across every component.** Every component follows the same `new() |> ... |> build` pipeline. Learn one, know them all.

**Styles compose freely.** The `style()` function on every component and layout primitive accepts any list of style values from `tidal/style/*`. Call it multiple times — styles always append, never replace.

**Responsive modifiers are first-class.** Wrap any style in `responsive.sm()`, `responsive.md()`, etc. There's no separate responsive API to learn.

**Full Tailwind coverage.** All 15 Tailwind utility categories — layout, flexbox, grid, typography, filters, transforms, and more — are wrapped as typed Gleam functions. Custom values go through `style.raw()`.

**35+ themes out of the box.** DaisyUI's semantic colour tokens mean your components automatically respect whichever theme is active.

---

## Requirements

- Gleam >= 1.4
- [Lustre](https://hex.pm/packages/lustre) >= 5.6
- Node.js (for Tailwind and DaisyUI)
- [Lustre Dev Tools](https://hex.pm/packages/lustre_dev_tools) (recommended for development)

---

## Installation

```sh
gleam add tidal
gleam deps download
```

---

## CSS setup

Tidal generates Tailwind class names at runtime inside compiled JavaScript. Tailwind's static scanner can't see them, so the package ships a safelist at `priv/tidal.js` that lists every class any Tidal function can emit. You need one `@source` line in your CSS to point Tailwind at it.

### 1. Install Tailwind and DaisyUI

```sh
npm install tailwindcss @tailwindcss/vite daisyui
```

### 2. Create your CSS entry point

```css
/* src/app.css */
@import "tailwindcss";
@import "../node_modules/daisyui/daisyui.css";

@source "../build/packages/tidal/priv/tidal.js";
```

> The `@source` path is relative to the CSS file's location. If your CSS lives at `src/app.css`, the path above is correct for a standard Gleam project layout. Adjust the `..` segments if your CSS is elsewhere.

> **Why `.js`?** Tailwind v4 only scans file types it recognises as source files. A `.css` file gets parsed as CSS, not scanned for class names. The `.js` extension makes Tailwind extract the class list correctly.

### 3. Vite config

```js
// vite.config.js
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
});
```

### 4. Start developing

```sh
gleam run -m lustre/dev_tools serve
```

### Using `style.raw()`

If you reach for `style.raw("my-class")` to pass a class Tidal doesn't have a typed function for, that class won't be in the safelist. Add it with an inline source directive in your CSS:

```css
@source inline("my-class another-class");
```

---

## Theming

DaisyUI themes are activated by setting `data-theme` on the root element:

```html
<html data-theme="dark">
```

Switch themes at runtime by updating the attribute from Gleam:

```gleam
attribute.attribute("data-theme", current_theme)
```

All 35+ built-in DaisyUI themes work without any additional configuration. See the [DaisyUI theme docs](https://daisyui.com/docs/themes/) for the full list.

---

## Components

All components follow the same pipeline: `new()` creates a default, modifier functions configure it, `build` produces an `Element(msg)`.

| Module | Description |
|--------|-------------|
| `tidal/button` | Button with variants, sizes, and event handlers |
| `tidal/input` | Text, email, password, number, and other input types |
| `tidal/textarea` | Multi-line text input |
| `tidal/select` | Dropdown select with option list |
| `tidal/toggle` | Toggle switch |
| `tidal/checkbox` | Checkbox |
| `tidal/radio` | Radio button |
| `tidal/slider` | Range slider |
| `tidal/file_input` | File picker |
| `tidal/badge` | Inline badge/tag |
| `tidal/alert` | Alert/notification banner |
| `tidal/avatar` | Avatar with image, placeholder, and status indicator |
| `tidal/tooltip` | Tooltip wrapper |
| `tidal/card` | Card with figure, title, body, and actions slots |
| `tidal/navbar` | Navigation bar with start/center/end slots |
| `tidal/tabs` | Tab bar |
| `tidal/breadcrumb` | Breadcrumb trail |
| `tidal/menu` | Vertical navigation menu |
| `tidal/pagination` | Page number navigation |
| `tidal/bottom_nav` | Mobile bottom navigation bar |
| `tidal/modal` | Dialog/modal overlay |
| `tidal/dropdown` | Dropdown menu |
| `tidal/drawer` | Sidebar drawer |
| `tidal/loading` | Loading spinner and variants |
| `tidal/progress` | Progress bar |
| `tidal/radial_progress` | Circular progress indicator |
| `tidal/stat` | Stat display block |
| `tidal/table` | Data table |
| `tidal/collapse` | Collapsible content panel |
| `tidal/chat` | Chat bubble with start/end alignment and colour variants |
| `tidal/rating` | Star/heart rating input |
| `tidal/steps` | Step progress indicator |
| `tidal/timeline` | Vertical or horizontal event timeline |
| `tidal/countdown` | Slot-machine style number display |
| `tidal/diff` | Side-by-side content comparison with draggable divider |
| `tidal/carousel` | Scroll-snap slide container |
| `tidal/toast` | Toast notification stack |
| `tidal/hero` | Full-width hero section with overlay support |
| `tidal/indicator` | Badge/dot overlay on any element |
| `tidal/join` | Join adjacent elements into a group |
| `tidal/kbd` | Keyboard key display |
| `tidal/skeleton` | Loading skeleton placeholder |
| `tidal/swap` | Swap two elements with animation |
| `tidal/link` | Styled anchor element |
| `tidal/footer` | Site footer with columnar navigation |
| `tidal/fieldset` | Form field grouping with legend and label |
| `tidal/list_display` | Styled list with row borders |
| `tidal/mockup_code` | Terminal/code block mockup |
| `tidal/mockup_phone` | Phone device frame |
| `tidal/mockup_window` | Browser/desktop window frame |
| `tidal/theme_controller` | DaisyUI theme switcher via checkbox or radio |

### Variants and sizes

Most components accept `variant.Primary`, `variant.Secondary`, etc. and `size.Sm`, `size.Md`, `size.Lg`, etc.:

```gleam
import tidal/size
import tidal/variant

badge.new("New")
|> badge.variant(variant.Success)
|> badge.size(size.Sm)
|> badge.build
```

### Events

Interactive components have named event functions — no need to reach for `attrs([event.on_click(...)])`:

```gleam
toggle.new()
|> toggle.variant(variant.Primary)
|> toggle.on_check(UserToggledDarkMode)
|> toggle.build

select.new()
|> select.options([#("us", "United States"), #("gb", "United Kingdom")])
|> select.on_change(UserSelectedCountry)
|> select.build
```

---

## Layout primitives

| Module | Description |
|--------|-------------|
| `tidal/el` | Generic block container (`div`) |
| `tidal/row` | Horizontal flex row |
| `tidal/column` | Vertical flex column |
| `tidal/stack` | Relative-positioned stack (for layering) |
| `tidal/text` | Span, paragraph, and heading elements |
| `tidal/image` | Image element |
| `tidal/spacer` | Flex spacer (`flex-1`) |
| `tidal/divider` | Horizontal or vertical divider |

```gleam
row.new()
|> row.style([flexbox.items_center(), flexbox.justify_between(), spacing.px(4)])
|> row.children([
  text.new("Inbox")
  |> text.h1()
  |> text.style([typography.text_xl(), typography.font_semibold()])
  |> text.build,
  spacer.spacer(),
  button.new("Compose")
  |> button.variant(variant.Primary)
  |> button.size(size.Sm)
  |> button.on_click(UserClickedCompose)
  |> button.build,
])
|> row.build
```

---

## Style system

Style functions live under `tidal/style/*` and cover the full Tailwind utility surface. Every component and layout primitive has a `style(List(Style))` function — pass a list of style values, call it as many times as you need, and they always accumulate.

| Module | Description |
|--------|-------------|
| `tidal/style/spacing` | Padding and margin (`p`, `m`, `px`, `py`, `mx`, `my`, and directional variants) |
| `tidal/style/sizing` | Width, height, min/max, logical sizing |
| `tidal/style/typography` | Font family, size, weight, style, line height, decoration, and more |
| `tidal/style/color` | Semantic colour tokens for text, background, and border |
| `tidal/style/background` | Background attachment, clip, image, position, repeat, size |
| `tidal/style/border` | Border width, radius, style, outline |
| `tidal/style/effects` | Shadow, text shadow, opacity, blend modes, masks |
| `tidal/style/filters` | Blur, brightness, contrast, grayscale, hue-rotate, and backdrop variants |
| `tidal/style/transition` | Transition property, behaviour, duration, easing, delay |
| `tidal/style/transform` | Scale, rotate, translate, skew, origin, perspective, backface |
| `tidal/style/interactivity` | Cursor, pointer events, resize, scroll snap, touch, accent, field sizing |
| `tidal/style/layout` | Display, position, overflow, visibility, z-index, box decoration |
| `tidal/style/flexbox` | Direction, wrap, grow, shrink, align, justify, gap, order |
| `tidal/style/grid` | Template columns/rows, span, flow, auto sizing, gap |
| `tidal/style/tables` | Border collapse, spacing, table layout, caption side |
| `tidal/style/svg` | Fill, stroke, stroke width |
| `tidal/style/accessibility` | Forced colour adjust |
| `tidal/style/responsive` | Breakpoint modifiers: `sm`, `md`, `lg`, `xl`, `xxl` |

### Responsive styles

Wrap any style value in a breakpoint modifier:

```gleam
el.new()
|> el.style([
  layout.flex(),
  flexbox.flex_col(),
  responsive.md(flexbox.flex_row()),
  spacing.p(4),
  responsive.md(spacing.p(8)),
  responsive.lg(spacing.p(12)),
])
|> el.build
```

### Colours

The `color` module exposes DaisyUI's semantic colour tokens. Using these instead of hardcoded colours means your UI automatically adapts to the active theme:

```gleam
import tidal/style/color

text.new("Warning")
|> text.style([typography.text_color(color.Warning)])
|> text.build

el.new()
|> el.style([color.bg(color.Base200)])
|> el.build
```

---

## Examples

The `examples/` directory contains a fully working todo app built with Tidal. To run it:

```sh
cd examples/example_app_todos
gleam deps download
npm install
gleam run -m lustre/dev_tools serve
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Licence

Apache 2.0 — see [LICENSE](LICENSE).
