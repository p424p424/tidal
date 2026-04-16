# Tidal API Design

Tidal is a typed, Flutter-inspired Gleam UI library that wraps DaisyUI components using
the builder pattern. Every component follows: `new()` → zero or more modifier functions →
`build` → `Element(msg)`.

```gleam
button.new()
|> button.label("OK")
|> button.primary
|> button.size(size.Lg)
|> button.disabled
|> button.on_click(UserClickedOk)
|> button.build
```

---

## Naming Conventions

| Rule | Description | Example |
|---|---|---|
| **Color variants** | One function per semantic color — always the same 8 | `primary`, `secondary`, `accent`, `neutral`, `info`, `success`, `warning`, `error` |
| **Size** | Always `size(Size)`, never individual functions | `size(size.Lg)` |
| **Boolean modifiers** | Enabler functions, not setters | `outline()` not `outline(True)` |
| **Style escape hatch** | `style(List(Style))` — appends Tailwind utility classes; may be called multiple times | `style([styling.w_full()])` |
| **Attrs escape hatch** | `attrs(List(Attribute(msg)))` — appends raw HTML attributes; always last | `attrs([attribute.id("foo")])` |
| **Short text** | `label(String)` for button text, badge text, tab labels | `label("Save")` |
| **Long/body text** | `text(String)` for paragraph/body copy | `text("This will be deleted.")` |
| **Child elements** | `children(List(Element(msg)))` or semantic slots | `body([...])`, `header(...)`, `footer(...)` |
| **Event handlers** | `on_click(msg)`, `on_input(fn(String)->msg)`, `on_check(fn(Bool)->msg)`, `on_change(fn(String)->msg)`, `on_focus(msg)`, `on_blur(msg)` | |
| **`new()` takes no args** | All components start with `new()`. Content/label is set via modifier | `button.new() \|> button.label("OK")` |
| **Module-qualified variants** | Use individual functions, not a `variant(Variant)` parameter | `button.primary` not `button.variant(variant.Primary)` |
| **Gleam keyword suffix** | HTML attributes that clash with Gleam keywords use a trailing underscore | `type_`, `for_` |

> **Implementation note:** All components now follow `new()` + `label(t)` + individual
> color functions (`primary`, `secondary`, …). `variant(Variant)` is no longer used.

---

## Shared Types

### `Size` — `tidal/size`

```gleam
pub type Size { Xs | Sm | Md | Lg | Xl }
```

`Md` is the default for all components and adds no extra class.

---

### `Variant` — `tidal/variant`

> **Deprecation target.** Individual shorthand functions (`primary`, `secondary`, …) on each
> component module are preferred. `Variant` may be retained for components that accept a
> runtime-selected variant.

```gleam
pub type Variant {
  Primary | Secondary | Accent | Neutral
  Info | Success | Warning | Error
  Ghost | Link | Outline
}
```

`Ghost`, `Link`, and `Outline` are style variants rather than semantic colors. Not every
component accepts all values.

---

### `Align` — `tidal/align`

Used for `align-items` in flex/grid containers.

```gleam
pub type Align { Start | Center | End | Stretch | Baseline }
```

| Value | Tailwind class |
|---|---|
| `Start` | `items-start` |
| `Center` | `items-center` |
| `End` | `items-end` |
| `Stretch` | `items-stretch` |
| `Baseline` | `items-baseline` |

---

### `Justify` — `tidal/justify`

Used for `justify-content` in flex/grid containers.

```gleam
pub type Justify { Start | Center | End | Between | Around | Evenly | Stretch }
```

| Value | Tailwind class |
|---|---|
| `Start` | `justify-start` |
| `Center` | `justify-center` |
| `End` | `justify-end` |
| `Between` | `justify-between` |
| `Around` | `justify-around` |
| `Evenly` | `justify-evenly` |
| `Stretch` | `justify-stretch` |

---

### `Direction` — `tidal/direction`

```gleam
pub type Direction { Row | Col | RowReverse | ColReverse }
```

| Value | Tailwind class |
|---|---|
| `Row` | `flex-row` |
| `Col` | `flex-col` |
| `RowReverse` | `flex-row-reverse` |
| `ColReverse` | `flex-col-reverse` |

---

### `Wrap` — `tidal/wrap`

```gleam
pub type Wrap { Wrap | Nowrap | WrapReverse }
```

| Value | Tailwind class |
|---|---|
| `Wrap` | `flex-wrap` |
| `Nowrap` | `flex-nowrap` |
| `WrapReverse` | `flex-wrap-reverse` |

---

### `Gap`

**Decision: Int-based via `styling.gap(n)`.** Tailwind's gap scale is numeric
(`gap-1` through `gap-96` and beyond with arbitrary values). Enumerating all values as
variants would be verbose and incomplete. An `Int` parameter maps directly to `gap-{n}` and
is self-documenting. Use `styling.gap(4)` for `gap-4` (1rem).

Provide `styling.gap(Int)`, `styling.gap_x(Int)`, `styling.gap_y(Int)` in the styling module.

---

### `Padding` / `Margin`

**Decision: Int-based via `styling.p(n)`, `styling.px(n)`, etc.** Same rationale as Gap —
Tailwind's spacing scale is a numeric scale (0–96 + fractions). Individual typed constructors
would be unmanageable. Provide `p`, `px`, `py`, `pt`, `pr`, `pb`, `pl` and the same
pattern for `m`, `mx`, `my`, `mt`, `mr`, `mb`, `ml`.

---

### `Position` — `tidal/position`

```gleam
pub type Position { Static | Relative | Absolute | Fixed | Sticky }
```

| Value | Tailwind class |
|---|---|
| `Static` | `static` |
| `Relative` | `relative` |
| `Absolute` | `absolute` |
| `Fixed` | `fixed` |
| `Sticky` | `sticky` |

---

### `Overflow` — `tidal/overflow`

```gleam
pub type Overflow { Auto | Hidden | Visible | Scroll | Clip }
```

Applies to both `overflow`, `overflow-x`, and `overflow-y` variants. Expose via styling
functions `styling.overflow(Overflow)`, `styling.overflow_x(Overflow)`,
`styling.overflow_y(Overflow)`.

---

### `BorderRadius` — `tidal/border_radius`

```gleam
pub type BorderRadius { None | Sm | Md | Lg | Xl | Xl2 | Xl3 | Full }
```

| Value | Tailwind class |
|---|---|
| `None` | `rounded-none` |
| `Sm` | `rounded-sm` |
| `Md` | `rounded-md` |
| `Lg` | `rounded-lg` |
| `Xl` | `rounded-xl` |
| `Xl2` | `rounded-2xl` |
| `Xl3` | `rounded-3xl` |
| `Full` | `rounded-full` |

---

### `Placement` — shared enum for positional modifiers

Several components (tooltip, dropdown, toast, modal, indicator) share a placement concept.
Define a single shared type:

```gleam
pub type Placement { Top | Bottom | Left | Right | Start | End | Center | Middle }
```

Not all placement values are valid for all components; the component module documents which
apply.

---

### `LoadingStyle` — `tidal/loading` sub-type

```gleam
pub type LoadingStyle {
  Spinner | Dots | Ring | Ball | Bars | Infinity
}
```

---

## Layout Primitives

### `row` — `tidal/row`

Horizontal flex container. Renders as `<div class="flex flex-row ...">`.

**Status:** Implemented.
calls for all flex options.

| Modifier function | Tailwind class | Type | Notes |
|---|---|---|---|
| `new()` | `flex flex-row` | — | base constructor |
| `align(a)` | `items-{value}` | `Align` | align-items |
| `justify(j)` | `justify-{value}` | `Justify` | justify-content |
| `wrap(w)` | `flex-wrap` / `flex-nowrap` | `Wrap` | flex wrapping |
| `gap(n)` | `gap-{n}` | `Int` | gap between children |
| `gap_x(n)` | `gap-x-{n}` | `Int` | horizontal gap |
| `gap_y(n)` | `gap-y-{n}` | `Int` | vertical gap |
| `grow` | `flex-1` | — | boolean — row fills available space |
| `reverse` | `flex-row-reverse` | — | boolean — reverses direction |
| `children(els)` | — | `List(Element(msg))` | child elements |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### `column` — `tidal/column`

Vertical flex container. Renders as `<div class="flex flex-col ...">`.

**Status:** Implemented.

| Modifier function | Tailwind class | Type | Notes |
|---|---|---|---|
| `new()` | `flex flex-col` | — | base constructor |
| `align(a)` | `items-{value}` | `Align` | align-items |
| `justify(j)` | `justify-{value}` | `Justify` | justify-content |
| `wrap(w)` | `flex-wrap` / `flex-nowrap` | `Wrap` | flex wrapping |
| `gap(n)` | `gap-{n}` | `Int` | gap between children |
| `gap_x(n)` | `gap-x-{n}` | `Int` | horizontal gap |
| `gap_y(n)` | `gap-y-{n}` | `Int` | vertical gap |
| `grow` | `flex-1` | — | boolean — column fills available space |
| `reverse` | `flex-col-reverse` | — | boolean — reverses direction |
| `children(els)` | — | `List(Element(msg))` | child elements |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### `container` — `tidal/container`

Constrained-width centered wrapper. Renders as `<div class="container mx-auto ...">`.
Tailwind's `container` class sets `max-width` breakpoint values; `mx-auto` centers it.

| Modifier function | Tailwind class | Type | Notes |
|---|---|---|---|
| `new()` | `container mx-auto` | — | base constructor |
| `padding(n)` | `px-{n}` | `Int` | horizontal padding |
| `max_width(bp)` | responsive — set by breakpoint prefix | `Breakpoint` | narrow the container at a breakpoint; use `style()` for now |
| `children(els)` | — | `List(Element(msg))` | child elements |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### `grid` — `tidal/grid`

CSS grid container. Renders as `<div class="grid ...">`.

| Modifier function | Tailwind class | Type | Notes |
|---|---|---|---|
| `new()` | `grid` | — | base constructor |
| `cols(n)` | `grid-cols-{n}` | `Int` | number of equal columns (1–12) |
| `rows(n)` | `grid-rows-{n}` | `Int` | number of equal rows |
| `gap(n)` | `gap-{n}` | `Int` | grid gap |
| `gap_x(n)` | `gap-x-{n}` | `Int` | column gap |
| `gap_y(n)` | `gap-y-{n}` | `Int` | row gap |
| `align(a)` | `items-{value}` | `Align` | align-items for all cells |
| `justify(j)` | `justify-{value}` | `Justify` | justify-content |
| `children(els)` | — | `List(Element(msg))` | child elements |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch (use for `grid-cols-[custom]`) |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### `stack` — `tidal/stack`

DaisyUI `stack` — absolute overlay stacking of children. Renders as
`<div class="stack ...">`. Each child is stacked on top of the previous.

**Status:** Implemented.

| Modifier function | DaisyUI class | Type | Notes |
|---|---|---|---|
| `new()` | `stack` | — | base constructor |
| `top` | `stack-top` | — | align children to top |
| `bottom` | `stack-bottom` | — | align children to bottom (default) |
| `align_start` | `stack-start` | — | align children to start (horizontal) |
| `align_end` | `stack-end` | — | align children to end (horizontal) |
| `children(els)` | — | `List(Element(msg))` | child elements |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### `spacer` — `tidal/spacer`

Flex spacer — inserts a `<div class="flex-1">` to push siblings apart.

**Status:** Implemented (minimal, likely `html.div([attribute.class("flex-1")], [])`).

| Modifier function | Tailwind class | Type | Notes |
|---|---|---|---|
| `new()` | `flex-1` | — | base constructor; no modifiers needed |
| `build` | — | — | produces `Element(msg)` |

---

### `divider` — `tidal/divider`

DaisyUI `divider`. Renders as `<div class="divider ...">`. Can contain optional label text.

**Status:** Implemented.

| Modifier function | DaisyUI class | Type | Notes |
|---|---|---|---|
| `new()` | `divider` | — | base constructor; default is vertical (horizontal line) |
| `horizontal` | `divider-horizontal` | — | divides horizontal (vertical line) |
| `label(t)` | — | `String` | optional label text between the two lines |
| `primary` | `divider-primary` | — | color |
| `secondary` | `divider-secondary` | — | color |
| `accent` | `divider-accent` | — | color |
| `neutral` | `divider-neutral` | — | color |
| `info` | `divider-info` | — | color |
| `success` | `divider-success` | — | color |
| `warning` | `divider-warning` | — | color |
| `error` | `divider-error` | — | color |
| `align_start` | `divider-start` | — | positions label text at start |
| `align_end` | `divider-end` | — | positions label text at end |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

## Components — DaisyUI

---

### Button

**DaisyUI page**: https://daisyui.com/components/button/
**HTML element**: `<button>`
**Status**: Implemented.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `btn` | — | base constructor |
| `label(t)` | — | `String` | button text content |
| `primary` | `btn-primary` | — | color variant |
| `secondary` | `btn-secondary` | — | color variant |
| `accent` | `btn-accent` | — | color variant |
| `neutral` | `btn-neutral` | — | color variant |
| `info` | `btn-info` | — | color variant |
| `success` | `btn-success` | — | color variant |
| `warning` | `btn-warning` | — | color variant |
| `error` | `btn-error` | — | color variant |
| `ghost` | `btn-ghost` | — | style variant — transparent bg |
| `link` | `btn-link` | — | style variant — looks like a link |
| `outline` | `btn-outline` | — | style variant — outlined |
| `dash` | `btn-dash` | — | style variant — dashed border |
| `soft` | `btn-soft` | — | style variant — soft/muted |
| `size(s)` | `btn-xs` … `btn-xl` | `Size` | button size |
| `wide` | `btn-wide` | — | wider horizontal padding |
| `block` | `btn-block` | — | full width |
| `square` | `btn-square` | — | 1:1 aspect ratio; use for icon buttons |
| `circle` | `btn-circle` | — | 1:1 fully rounded; use for icon buttons |
| `active` | `btn-active` | — | force active state appearance |
| `disabled` | `btn-disabled` + `disabled` attr | — | boolean modifier |
| `children(els)` | — | `List(Element(msg))` | replaces label with custom content |
| `on_click(msg)` | — | `msg` | click handler |
| `on_focus(msg)` | — | `msg` | focus handler |
| `on_blur(msg)` | — | `msg` | blur handler |
| `on_keydown(f)` | — | `fn(String)->msg` | keydown handler |
| `on_keyup(f)` | — | `fn(String)->msg` | keyup handler |
| `on_mouse_enter(msg)` | — | `msg` | mouse enter handler |
| `on_mouse_leave(msg)` | — | `msg` | mouse leave handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Input

**DaisyUI page**: https://daisyui.com/components/input/
**HTML element**: `<input type="text">` (or other HTML input type)
**Status**: Implemented.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `input` | — | base constructor; defaults to `type="text"` |
| `type_(t)` | `type="{t}"` | `InputType` | `Text \| Email \| Password \| Number \| Tel \| Url \| Search` |
| `placeholder(t)` | `placeholder="{t}"` | `String` | placeholder text |
| `value(v)` | `value="{v}"` | `String` | controlled value |
| `primary` | `input-primary` | — | color |
| `secondary` | `input-secondary` | — | color |
| `accent` | `input-accent` | — | color |
| `neutral` | `input-neutral` | — | color |
| `info` | `input-info` | — | color |
| `success` | `input-success` | — | color |
| `warning` | `input-warning` | — | color |
| `error` | `input-error` | — | color |
| `ghost` | `input-ghost` | — | style variant — minimal appearance |
| `size(s)` | `input-xs` … `input-xl` | `Size` | input size |
| `disabled` | `disabled` attr | — | boolean modifier |
| `required` | `required` attr | — | boolean modifier |
| `on_input(f)` | — | `fn(String)->msg` | fires on each keystroke |
| `on_change(f)` | — | `fn(String)->msg` | fires on blur/enter |
| `on_focus(msg)` | — | `msg` | focus handler |
| `on_blur(msg)` | — | `msg` | blur handler |
| `on_keydown(f)` | — | `fn(String)->msg` | keydown handler |
| `on_keyup(f)` | — | `fn(String)->msg` | keyup handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Textarea

**DaisyUI page**: https://daisyui.com/components/textarea/
**HTML element**: `<textarea>`
**Status**: Implemented.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `textarea` | — | base constructor |
| `placeholder(t)` | `placeholder="{t}"` | `String` | placeholder text |
| `value(v)` | — | `String` | controlled value (text content) |
| `rows(n)` | `rows="{n}"` | `Int` | number of visible rows |
| `primary` | `textarea-primary` | — | color |
| `secondary` | `textarea-secondary` | — | color |
| `accent` | `textarea-accent` | — | color |
| `neutral` | `textarea-neutral` | — | color |
| `info` | `textarea-info` | — | color |
| `success` | `textarea-success` | — | color |
| `warning` | `textarea-warning` | — | color |
| `error` | `textarea-error` | — | color |
| `ghost` | `textarea-ghost` | — | style variant |
| `size(s)` | `textarea-xs` … `textarea-xl` | `Size` | textarea size |
| `disabled` | `disabled` attr | — | boolean modifier |
| `required` | `required` attr | — | boolean modifier |
| `on_input(f)` | — | `fn(String)->msg` | fires on each keystroke |
| `on_change(f)` | — | `fn(String)->msg` | fires on blur |
| `on_focus(msg)` | — | `msg` | focus handler |
| `on_blur(msg)` | — | `msg` | blur handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Select

**DaisyUI page**: https://daisyui.com/components/select/
**HTML element**: `<select>`
**Status**: Implemented.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `select` | — | base constructor |
| `placeholder(t)` | `<option disabled selected>` | `String` | first disabled option |
| `options(opts)` | — | `List(#(String, String))` | list of (value, label) pairs |
| `value(v)` | `selected` attr on matching option | `String` | currently selected value |
| `primary` | `select-primary` | — | color |
| `secondary` | `select-secondary` | — | color |
| `accent` | `select-accent` | — | color |
| `neutral` | `select-neutral` | — | color |
| `info` | `select-info` | — | color |
| `success` | `select-success` | — | color |
| `warning` | `select-warning` | — | color |
| `error` | `select-error` | — | color |
| `ghost` | `select-ghost` | — | style variant |
| `size(s)` | `select-xs` … `select-xl` | `Size` | select size |
| `disabled` | `disabled` attr | — | boolean modifier |
| `required` | `required` attr | — | boolean modifier |
| `on_change(f)` | — | `fn(String)->msg` | fires when selection changes |
| `on_focus(msg)` | — | `msg` | focus handler |
| `on_blur(msg)` | — | `msg` | blur handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Toggle

**DaisyUI page**: https://daisyui.com/components/toggle/
**HTML element**: `<input type="checkbox">`
**Status**: Implemented.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `toggle` | — | base constructor |
| `checked(b)` | `checked` attr | `Bool` | controlled checked state |
| `primary` | `toggle-primary` | — | color |
| `secondary` | `toggle-secondary` | — | color |
| `accent` | `toggle-accent` | — | color |
| `neutral` | `toggle-neutral` | — | color |
| `info` | `toggle-info` | — | color |
| `success` | `toggle-success` | — | color |
| `warning` | `toggle-warning` | — | color |
| `error` | `toggle-error` | — | color |
| `size(s)` | `toggle-xs` … `toggle-xl` | `Size` | toggle size |
| `disabled` | `disabled` attr | — | boolean modifier |
| `on_check(f)` | — | `fn(Bool)->msg` | fires on toggle change |
| `on_focus(msg)` | — | `msg` | focus handler |
| `on_blur(msg)` | — | `msg` | blur handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Checkbox

**DaisyUI page**: https://daisyui.com/components/checkbox/
**HTML element**: `<input type="checkbox">`
**Status**: Implemented.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `checkbox` | — | base constructor |
| `checked(b)` | `checked` attr | `Bool` | controlled checked state |
| `primary` | `checkbox-primary` | — | color |
| `secondary` | `checkbox-secondary` | — | color |
| `accent` | `checkbox-accent` | — | color |
| `neutral` | `checkbox-neutral` | — | color |
| `info` | `checkbox-info` | — | color |
| `success` | `checkbox-success` | — | color |
| `warning` | `checkbox-warning` | — | color |
| `error` | `checkbox-error` | — | color |
| `size(s)` | `checkbox-xs` … `checkbox-xl` | `Size` | checkbox size |
| `disabled` | `disabled` attr | — | boolean modifier |
| `on_check(f)` | — | `fn(Bool)->msg` | fires on change |
| `on_focus(msg)` | — | `msg` | focus handler |
| `on_blur(msg)` | — | `msg` | blur handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Radio

**DaisyUI page**: https://daisyui.com/components/radio/
**HTML element**: `<input type="radio">`
**Status**: Implemented.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `radio` | — | base constructor |
| `name(n)` | `name="{n}"` | `String` | group name — required for radio groups |
| `value(v)` | `value="{v}"` | `String` | radio value |
| `checked(b)` | `checked` attr | `Bool` | controlled checked state |
| `primary` | `radio-primary` | — | color |
| `secondary` | `radio-secondary` | — | color |
| `accent` | `radio-accent` | — | color |
| `neutral` | `radio-neutral` | — | color |
| `info` | `radio-info` | — | color |
| `success` | `radio-success` | — | color |
| `warning` | `radio-warning` | — | color |
| `error` | `radio-error` | — | color |
| `size(s)` | `radio-xs` … `radio-xl` | `Size` | radio size |
| `disabled` | `disabled` attr | — | boolean modifier |
| `on_check(f)` | — | `fn(Bool)->msg` | fires on change |
| `on_focus(msg)` | — | `msg` | focus handler |
| `on_blur(msg)` | — | `msg` | blur handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Slider (Range)

**DaisyUI page**: https://daisyui.com/components/range/
**HTML element**: `<input type="range">`
**Status**: Implemented (as `slider.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `range` | — | base constructor |
| `value(v)` | `value="{v}"` | `Int` | current value |
| `min(n)` | `min="{n}"` | `Int` | minimum value |
| `max(n)` | `max="{n}"` | `Int` | maximum value |
| `step(n)` | `step="{n}"` | `Int` | step increment |
| `primary` | `range-primary` | — | color |
| `secondary` | `range-secondary` | — | color |
| `accent` | `range-accent` | — | color |
| `neutral` | `range-neutral` | — | color |
| `info` | `range-info` | — | color |
| `success` | `range-success` | — | color |
| `warning` | `range-warning` | — | color |
| `error` | `range-error` | — | color |
| `size(s)` | `range-xs` … `range-xl` | `Size` | range size |
| `disabled` | `disabled` attr | — | boolean modifier |
| `on_input(f)` | — | `fn(String)->msg` | fires while dragging |
| `on_change(f)` | — | `fn(String)->msg` | fires on release |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### FileInput

**DaisyUI page**: https://daisyui.com/components/file-input/
**HTML element**: `<input type="file">`
**Status**: Implemented (`file_input.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `file-input` | — | base constructor |
| `multiple` | `multiple` attr | — | allow multiple file selection |
| `accept(t)` | `accept="{t}"` | `String` | accepted MIME types / extensions |
| `primary` | `file-input-primary` | — | color |
| `secondary` | `file-input-secondary` | — | color |
| `accent` | `file-input-accent` | — | color |
| `neutral` | `file-input-neutral` | — | color |
| `info` | `file-input-info` | — | color |
| `success` | `file-input-success` | — | color |
| `warning` | `file-input-warning` | — | color |
| `error` | `file-input-error` | — | color |
| `ghost` | `file-input-ghost` | — | style variant |
| `size(s)` | `file-input-xs` … `file-input-xl` | `Size` | file input size |
| `disabled` | `disabled` attr | — | boolean modifier |
| `on_change(f)` | — | `fn(String)->msg` | fires when file selected |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Rating

**DaisyUI page**: https://daisyui.com/components/rating/
**HTML element**: `<div>` wrapping `<input type="radio">` elements
**Status**: Implemented (`rating.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `rating` | — | base constructor |
| `value(n)` | — | `Int` | currently selected star (1-based) |
| `max(n)` | — | `Int` | number of stars; default 5 |
| `name(n)` | `name="{n}"` | `String` | radio group name — required for multiple ratings per page |
| `half` | `rating-half` | — | enable half-star ratings |
| `allow_clear` | `rating-hidden` | — | adds hidden first radio to allow clearing |
| `size(s)` | `rating-xs` … `rating-xl` | `Size` | rating size |
| `on_change(f)` | — | `fn(Int)->msg` | fires when rating changes |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Badge

**DaisyUI page**: https://daisyui.com/components/badge/
**HTML element**: `<span>`
**Status**: Implemented (`badge.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `badge` | — | base constructor |
| `label(t)` | — | `String` | badge text |
| `primary` | `badge-primary` | — | color |
| `secondary` | `badge-secondary` | — | color |
| `accent` | `badge-accent` | — | color |
| `neutral` | `badge-neutral` | — | color |
| `info` | `badge-info` | — | color |
| `success` | `badge-success` | — | color |
| `warning` | `badge-warning` | — | color |
| `error` | `badge-error` | — | color |
| `outline` | `badge-outline` | — | style variant |
| `dash` | `badge-dash` | — | style variant — dashed border |
| `soft` | `badge-soft` | — | style variant — muted |
| `ghost` | `badge-ghost` | — | style variant — minimal |
| `size(s)` | `badge-xs` … `badge-xl` | `Size` | badge size |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Alert

**DaisyUI page**: https://daisyui.com/components/alert/
**HTML element**: `<div role="alert">`
**Status**: Implemented (`alert.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `alert` | — | base constructor |
| `info` | `alert-info` | — | color |
| `success` | `alert-success` | — | color |
| `warning` | `alert-warning` | — | color |
| `error` | `alert-error` | — | color |
| `outline` | `alert-outline` | — | style variant |
| `dash` | `alert-dash` | — | style variant — dashed border |
| `soft` | `alert-soft` | — | style variant — muted background |
| `horizontal` | `alert-horizontal` | — | layout: content arranged horizontally (default on desktop) |
| `vertical` | `alert-vertical` | — | layout: content stacked vertically |
| `icon(el)` | — | `Element(msg)` | optional icon element (SVG, etc.) |
| `title(t)` | — | `String` | bold alert heading |
| `text(t)` | — | `String` | alert body text |
| `actions(els)` | — | `List(Element(msg))` | optional action buttons |
| `children(els)` | — | `List(Element(msg))` | full custom content override |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

> **Note:** Alert does not have `primary`/`secondary`/`accent` color modifiers in DaisyUI.
> Only `info`, `success`, `warning`, `error` are available.

---

### Avatar

**DaisyUI page**: https://daisyui.com/components/avatar/
**HTML element**: `<div class="avatar">` wrapping `<div>` wrapping `<img>`
**Status**: Implemented (`avatar.gleam`).

Avatar is a pure layout/presentation wrapper; all sizing is done with Tailwind utilities.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `avatar` | — | base constructor |
| `src(url)` | `src="{url}"` on inner img | `String` | image URL |
| `alt(t)` | `alt="{t}"` on inner img | `String` | image alt text |
| `size(n)` | `w-{n}` | `Int` | width/height in Tailwind units (e.g. `12` = 48px) |
| `rounded` | `rounded-full` | — | circular avatar |
| `rounded_box` | `rounded-xl` | — | squircle-ish rounded |
| `online` | `avatar-online` | — | green online indicator dot |
| `offline` | `avatar-offline` | — | gray offline indicator dot |
| `placeholder` | `avatar-placeholder` | — | shows text/initials when no image |
| `initials(t)` | — | `String` | text shown when `placeholder` is set |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### AvatarGroup

Renders as `<div class="avatar-group">`.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `group_new()` | `avatar-group` | — | base constructor |
| `avatars(els)` | — | `List(Element(msg))` | list of `avatar.build` elements |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `group_build` | — | — | produces `Element(msg)` |

---

### Tooltip

**DaisyUI page**: https://daisyui.com/components/tooltip/
**HTML element**: `<div class="tooltip">` wrapping the trigger element
**Status**: Implemented (`tooltip.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `tooltip` | — | base constructor |
| `tip(t)` | `data-tip="{t}"` | `String` | tooltip text content |
| `child(el)` | — | `Element(msg)` | the element the tooltip wraps (trigger) |
| `top` | `tooltip-top` | — | placement (default) |
| `bottom` | `tooltip-bottom` | — | placement |
| `left` | `tooltip-left` | — | placement |
| `right` | `tooltip-right` | — | placement |
| `open` | `tooltip-open` | — | force always visible |
| `primary` | `tooltip-primary` | — | color |
| `secondary` | `tooltip-secondary` | — | color |
| `accent` | `tooltip-accent` | — | color |
| `neutral` | `tooltip-neutral` | — | color |
| `info` | `tooltip-info` | — | color |
| `success` | `tooltip-success` | — | color |
| `warning` | `tooltip-warning` | — | color |
| `error` | `tooltip-error` | — | color |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Card

**DaisyUI page**: https://daisyui.com/components/card/
**HTML element**: `<div class="card">`
**Status**: Implemented (`card.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `card` | — | base constructor |
| `title(t)` | `card-title` on inner `<h2>` | `String` | card title |
| `body(els)` | `card-body` wrapper | `List(Element(msg))` | card body content |
| `actions(els)` | `card-actions` wrapper | `List(Element(msg))` | action elements (buttons, etc.) |
| `image(src, alt)` | `<figure><img></figure>` | `String, String` | top image |
| `image_full` | `image-full` | — | image fills card as background |
| `side` | `card-side` | — | image rendered to the side |
| `border` | `card-border` | — | visible border |
| `dash` | `card-dash` | — | dashed border |
| `size(s)` | `card-xs` … `card-xl` | `Size` | card padding/size |
| `primary` | `bg-primary text-primary-content` | — | color (via Tailwind bg/text) |
| `secondary` | `bg-secondary text-secondary-content` | — | color |
| `accent` | `bg-accent text-accent-content` | — | color |
| `neutral` | `bg-neutral text-neutral-content` | — | color |
| `info` | `bg-info text-info-content` | — | color |
| `success` | `bg-success text-success-content` | — | color |
| `warning` | `bg-warning text-warning-content` | — | color |
| `error` | `bg-error text-error-content` | — | color |
| `on_click(msg)` | — | `msg` | click handler |
| `on_mouse_enter(msg)` | — | `msg` | hover handler |
| `on_mouse_leave(msg)` | — | `msg` | hover handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Navbar

**DaisyUI page**: https://daisyui.com/components/navbar/
**HTML element**: `<div class="navbar">`
**Status**: Implemented (`navbar.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `navbar` | — | base constructor |
| `start(els)` | `navbar-start` div | `List(Element(msg))` | left-aligned slot |
| `center(els)` | `navbar-center` div | `List(Element(msg))` | center slot |
| `end_(els)` | `navbar-end` div | `List(Element(msg))` | right-aligned slot |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Tabs

**DaisyUI page**: https://daisyui.com/components/tab/
**HTML element**: `<div class="tabs">` with `<a class="tab">` or `<input type="radio">` items
**Status**: Implemented (`tabs.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `tabs` | — | base constructor |
| `box` | `tabs-box` | — | style: boxed tabs |
| `border` | `tabs-border` | — | style: bottom border (default-ish) |
| `lift` | `tabs-lift` | — | style: lifted/raised tabs |
| `top` | `tabs-top` | — | tabs above content (default) |
| `bottom` | `tabs-bottom` | — | tabs below content |
| `size(s)` | `tabs-xs` … `tabs-xl` | `Size` | tab bar size |
| `items(tabs)` | — | `List(TabItem(msg))` | list of tab items |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### TabItem

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `tab_new()` | `tab` | — | base constructor |
| `tab_label(t)` | — | `String` | tab label text |
| `tab_active` | `tab-active` | — | mark as selected tab |
| `tab_disabled` | `tab-disabled` | — | mark as disabled |
| `tab_content(els)` | `tab-content` div | `List(Element(msg))` | content shown when this tab is active (for radio-input approach) |
| `tab_on_click(msg)` | — | `msg` | click handler |

---

### Breadcrumb

**DaisyUI page**: https://daisyui.com/components/breadcrumb/
**HTML element**: `<div class="breadcrumbs"><ul>` with `<li>` items
**Status**: Implemented (`breadcrumb.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `breadcrumbs` | — | base constructor |
| `items(items)` | — | `List(BreadcrumbItem)` | list of crumb items |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### BreadcrumbItem

| Constructor | Type | Notes |
|---|---|---|
| `crumb(label)` | `String` | text-only crumb |
| `crumb_link(label, href)` | `String, String` | linked crumb (renders as `<a>`) |
| `crumb_icon(label, icon_el)` | `String, Element(msg)` | crumb with leading icon |

---

### Menu

**DaisyUI page**: https://daisyui.com/components/menu/
**HTML element**: `<ul class="menu">`
**Status**: Implemented (`menu.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `menu` | — | base constructor |
| `horizontal` | `menu-horizontal` | — | horizontal layout |
| `size(s)` | `menu-xs` … `menu-xl` | `Size` | menu item size |
| `items(items)` | — | `List(MenuItem(msg))` | list of menu items |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### MenuItem variants

| Constructor | DaisyUI class | Notes |
|---|---|---|
| `item(label, on_click)` | `<li><a>` | standard menu item |
| `item_link(label, href)` | `<li><a href>` | linked item |
| `item_active(label, on_click)` | `menu-active` on `<a>` | highlighted/selected item |
| `item_disabled(label)` | `menu-disabled` on `<li>` | disabled item |
| `title(t)` | `menu-title` on `<li>` | non-interactive section header |
| `submenu(label, items)` | `menu-dropdown` | collapsible submenu; renders nested `<ul>` |
| `item_icon(label, icon, on_click)` | — | item with leading icon |

---

### Pagination

**DaisyUI page**: https://daisyui.com/components/pagination/
**HTML element**: `<div class="join">` wrapping `<button class="join-item btn">`
**Status**: Implemented (`pagination.gleam`).

Pagination in DaisyUI uses the `join` component with buttons. Tidal should provide a
higher-level abstraction.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `join` | — | base constructor |
| `current_page(n)` | `btn-active` on matching item | `Int` | 1-based current page |
| `total_pages(n)` | — | `Int` | total number of pages |
| `on_page(f)` | — | `fn(Int)->msg` | fires when a page is clicked |
| `show_prev` | — | — | include a "«" previous button |
| `show_next` | — | — | include a "»" next button |
| `size(s)` | `btn-xs` … `btn-xl` on items | `Size` | button size |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Dock (Bottom Navigation)

**DaisyUI page**: https://daisyui.com/components/dock/
**HTML element**: `<div class="dock">`
**Status**: Implemented (`dock.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `dock` | — | base constructor |
| `size(s)` | `dock-xs` … `dock-xl` | `Size` | dock size |
| `items(items)` | — | `List(DockItem(msg))` | dock items |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### DockItem

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `dock_item(icon, label, on_click)` | `<button>` with `dock-label` | `Element(msg), String, msg` | dock button |
| `dock_active` | `dock-active` | — | mark as active/current |

---

### Modal

**DaisyUI page**: https://daisyui.com/components/modal/
**HTML element**: `<dialog class="modal">`
**Status**: Implemented (`modal.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `modal` | — | base constructor |
| `open(b)` | `modal-open` | `Bool` | controls visibility |
| `title(t)` | — | `String` | modal heading |
| `body(els)` | `modal-box` content | `List(Element(msg))` | modal body content |
| `actions(els)` | `modal-action` wrapper | `List(Element(msg))` | footer buttons |
| `top` | `modal-top` | — | placement — top of viewport |
| `bottom` | `modal-bottom` | — | placement — bottom of viewport |
| `start` | `modal-start` | — | placement — horizontal start |
| `end_` | `modal-end` | — | placement — horizontal end |
| `on_backdrop_click(msg)` | — | `msg` | fires when backdrop clicked |
| `style(s)` | — | `List(Style)` | applied to `modal-box` |
| `attrs(a)` | — | `List(Attribute(msg))` | applied to `<dialog>` |
| `build` | — | — | produces `Element(msg)` |

---

### Dropdown

**DaisyUI page**: https://daisyui.com/components/dropdown/
**HTML element**: `<details>` or `<div>` with popover
**Status**: Implemented (`dropdown.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `dropdown` | — | base constructor |
| `trigger(el)` | `<summary>` or trigger | `Element(msg)` | the toggle element |
| `content(els)` | `dropdown-content` | `List(Element(msg))` | dropdown menu content |
| `top` | `dropdown-top` | — | placement |
| `bottom` | `dropdown-bottom` | — | placement (default) |
| `left` | `dropdown-left` | — | placement |
| `right` | `dropdown-right` | — | placement |
| `align_start` | `dropdown-start` | — | horizontal alignment |
| `align_end` | `dropdown-end` | — | horizontal alignment |
| `align_center` | `dropdown-center` | — | horizontal alignment |
| `hover` | `dropdown-hover` | — | also opens on hover |
| `force_open` | `dropdown-open` | — | always open |
| `force_close` | `dropdown-close` | — | always closed |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Drawer

**DaisyUI page**: https://daisyui.com/components/drawer/
**HTML element**: `<div class="drawer">` with checkbox toggle
**Status**: Implemented (`drawer.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `drawer` | — | base constructor; default is left-side |
| `open(b)` | `drawer-open` or checkbox state | `Bool` | controls drawer visibility |
| `end_` | `drawer-end` | — | positions drawer on right side |
| `always_open` | `drawer-open` | — | sidebar always visible (use `lg:drawer-open` pattern via `style()`) |
| `content(els)` | `drawer-content` wrapper | `List(Element(msg))` | main page content |
| `sidebar(els)` | `drawer-side` wrapper | `List(Element(msg))` | drawer sidebar content |
| `toggle_id(id)` | `id="{id}"` on checkbox | `String` | ID for the hidden checkbox |
| `on_backdrop_click(msg)` | — | `msg` | fires when overlay clicked |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Loading

**DaisyUI page**: https://daisyui.com/components/loading/
**HTML element**: `<span class="loading">`
**Status**: Implemented (`loading.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `loading` | — | base constructor; defaults to `loading-spinner` |
| `spinner` | `loading-spinner` | — | rotating spinner animation |
| `dots` | `loading-dots` | — | animated dots |
| `ring` | `loading-ring` | — | ring animation |
| `ball` | `loading-ball` | — | ball animation |
| `bars` | `loading-bars` | — | vertical bars animation |
| `infinity` | `loading-infinity` | — | infinity symbol animation |
| `size(s)` | `loading-xs` … `loading-xl` | `Size` | loading size |
| `primary` | `text-primary` | — | color via text-color utility |
| `secondary` | `text-secondary` | — | color |
| `accent` | `text-accent` | — | color |
| `neutral` | `text-neutral` | — | color |
| `info` | `text-info` | — | color |
| `success` | `text-success` | — | color |
| `warning` | `text-warning` | — | color |
| `error` | `text-error` | — | color |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Progress

**DaisyUI page**: https://daisyui.com/components/progress/
**HTML element**: `<progress>`
**Status**: Implemented (`progress.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `progress` | — | base constructor |
| `value(n)` | `value="{n}"` | `Int` | current value (0–100); omit for indeterminate |
| `max(n)` | `max="{n}"` | `Int` | maximum value; defaults to 100 |
| `primary` | `progress-primary` | — | color |
| `secondary` | `progress-secondary` | — | color |
| `accent` | `progress-accent` | — | color |
| `neutral` | `progress-neutral` | — | color |
| `info` | `progress-info` | — | color |
| `success` | `progress-success` | — | color |
| `warning` | `progress-warning` | — | color |
| `error` | `progress-error` | — | color |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### RadialProgress

**DaisyUI page**: https://daisyui.com/components/radial-progress/
**HTML element**: `<div class="radial-progress" role="progressbar">`
**Status**: Implemented (`radial_progress.gleam`).

Styling uses CSS custom properties (`--value`, `--size`, `--thickness`) and Tailwind color
utilities rather than DaisyUI modifier classes.

| Modifier function | CSS variable / TW class | Type | Notes |
|---|---|---|---|
| `new()` | `radial-progress` | — | base constructor |
| `value(n)` | `--value: {n}` | `Int` | progress percentage 0–100; required |
| `size(n)` | `--size: {n}rem` | `Float` | diameter in rem; default 5rem |
| `thickness(n)` | `--thickness: {n}px` | `Int` | stroke width; default 10% of size |
| `label(t)` | — | `String` | text displayed in center |
| `primary` | `text-primary` | — | indicator color |
| `secondary` | `text-secondary` | — | indicator color |
| `accent` | `text-accent` | — | indicator color |
| `neutral` | `text-neutral` | — | indicator color |
| `info` | `text-info` | — | indicator color |
| `success` | `text-success` | — | indicator color |
| `warning` | `text-warning` | — | indicator color |
| `error` | `text-error` | — | indicator color |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Stat

**DaisyUI page**: https://daisyui.com/components/stat/
**HTML element**: `<div class="stats">` wrapping `<div class="stat">` items
**Status**: Implemented (`stat.gleam`).

#### Stats (container)

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `stats` | — | base constructor; horizontal by default |
| `vertical` | `stats-vertical` | — | stacks stats vertically |
| `items(stats)` | — | `List(Element(msg))` | stat items built with `stat_new()` |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### Stat (item)

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `stat_new()` | `stat` | — | base constructor |
| `stat_title(t)` | `stat-title` | `String` | label above value |
| `stat_value(t)` | `stat-value` | `String` | the main big number/value |
| `stat_desc(t)` | `stat-desc` | `String` | description below value |
| `stat_figure(el)` | `stat-figure` | `Element(msg)` | icon/image displayed to the right |
| `stat_actions(els)` | `stat-actions` | `List(Element(msg))` | buttons etc. below desc |
| `stat_build` | — | — | produces `Element(msg)` |

---

### Table

**DaisyUI page**: https://daisyui.com/components/table/
**HTML element**: `<table>`
**Status**: Implemented (`table.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `table` | — | base constructor |
| `zebra` | `table-zebra` | — | alternating row striping |
| `pin_rows` | `table-pin-rows` | — | sticky `<thead>` and `<tfoot>` |
| `pin_cols` | `table-pin-cols` | — | sticky `<th>` columns |
| `size(s)` | `table-xs` … `table-xl` | `Size` | row density |
| `head(cells)` | — | `List(String)` | header row cell strings |
| `rows(rows)` | — | `List(List(Element(msg)))` | data rows |
| `foot(cells)` | — | `List(String)` | footer row cell strings |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Collapse

**DaisyUI page**: https://daisyui.com/components/collapse/
**HTML element**: `<div class="collapse">` with checkbox or tabindex
**Status**: Implemented (`collapse.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `collapse` | — | base constructor |
| `title(t)` | `collapse-title` | `String` | clickable header text |
| `body(els)` | `collapse-content` | `List(Element(msg))` | expandable content |
| `arrow` | `collapse-arrow` | — | show arrow icon |
| `plus` | `collapse-plus` | — | show plus/minus icon |
| `force_open` | `collapse-open` | — | permanently expanded |
| `force_close` | `collapse-close` | — | permanently collapsed |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Chat

**DaisyUI page**: https://daisyui.com/components/chat/
**HTML element**: `<div class="chat chat-start">` or `chat-end`
**Status**: Implemented (`chat.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `chat chat-start` | — | base constructor; left-aligned by default |
| `end_` | `chat-end` | — | right-align chat bubble (sent messages) |
| `bubble(t)` | `chat-bubble` | `String` | message text |
| `bubble_el(el)` | `chat-bubble` | `Element(msg)` | custom bubble content |
| `avatar(el)` | `chat-image` | `Element(msg)` | avatar element shown beside bubble |
| `header(t)` | `chat-header` | `String` | text above bubble (name, time) |
| `footer(t)` | `chat-footer` | `String` | text below bubble (status, time) |
| `primary` | `chat-bubble-primary` | — | bubble color |
| `secondary` | `chat-bubble-secondary` | — | bubble color |
| `accent` | `chat-bubble-accent` | — | bubble color |
| `neutral` | `chat-bubble-neutral` | — | bubble color |
| `info` | `chat-bubble-info` | — | bubble color |
| `success` | `chat-bubble-success` | — | bubble color |
| `warning` | `chat-bubble-warning` | — | bubble color |
| `error` | `chat-bubble-error` | — | bubble color |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Steps

**DaisyUI page**: https://daisyui.com/components/steps/
**HTML element**: `<ul class="steps">` with `<li class="step">` items
**Status**: Implemented (`steps.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `steps` | — | base constructor; default is horizontal |
| `vertical` | `steps-vertical` | — | vertical layout |
| `items(steps)` | — | `List(StepItem)` | list of step items |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### StepItem

| Constructor | DaisyUI class | Type | Notes |
|---|---|---|---|
| `step(label)` | `step` | `String` | default step (incomplete) |
| `step_primary(label)` | `step step-primary` | `String` | completed/active step — primary color |
| `step_secondary(label)` | `step step-secondary` | `String` | color variant |
| `step_accent(label)` | `step step-accent` | `String` | color variant |
| `step_info(label)` | `step step-info` | `String` | color variant |
| `step_success(label)` | `step step-success` | `String` | color variant |
| `step_warning(label)` | `step step-warning` | `String` | color variant |
| `step_error(label)` | `step step-error` | `String` | color variant |
| `step_icon(label, content)` | `step-icon` | `String, String` | custom icon via `data-content` |

---

### Timeline

**DaisyUI page**: https://daisyui.com/components/timeline/
**HTML element**: `<ul class="timeline">` with `<li>` items
**Status**: Implemented (`timeline.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `timeline` | — | base constructor; default is horizontal |
| `vertical` | `timeline-vertical` | — | vertical layout |
| `compact` | `timeline-compact` | — | all items on one side |
| `snap_icon` | `timeline-snap-icon` | — | snaps icon to start instead of middle |
| `items(items)` | — | `List(TimelineItem(msg))` | timeline entries |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### TimelineItem

| Modifier function | DaisyUI class | Type | Notes |
|---|---|---|---|
| `item_new()` | `<li>` | — | base constructor |
| `item_start(el)` | `timeline-start` | `Element(msg)` | content at start |
| `item_middle(el)` | `timeline-middle` | `Element(msg)` | center connector (icon) |
| `item_end(el)` | `timeline-end` | `Element(msg)` | content at end |
| `item_box` | `timeline-box` | — | adds box style to start or end |
| `item_connected` | `<hr>` connector | — | draws connecting line to next item |
| `item_build` | — | — | produces `Element(msg)` |

---

### Countdown

**DaisyUI page**: https://daisyui.com/components/countdown/
**HTML element**: `<span class="countdown">` with inner `<span style="--value:...">` spans
**Status**: Implemented (`countdown.gleam`).

| Modifier function | CSS variable | Type | Notes |
|---|---|---|---|
| `new()` | `countdown` | — | base constructor |
| `days(n)` | `--value: {n}` | `Int` | days digit group |
| `hours(n)` | `--value: {n}` | `Int` | hours digit group |
| `minutes(n)` | `--value: {n}` | `Int` | minutes digit group |
| `seconds(n)` | `--value: {n}` | `Int` | seconds digit group |
| `show_labels` | — | — | include "days/hours/min/sec" labels below digits |
| `two_digits` | `--digits: 2` | — | zero-pad to 2 digits |
| `three_digits` | `--digits: 3` | — | zero-pad to 3 digits |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Diff

**DaisyUI page**: https://daisyui.com/components/diff/
**HTML element**: `<figure class="diff">` with two item divs and resizer
**Status**: Implemented (`diff.gleam`).

| Modifier function | DaisyUI class | Type | Notes |
|---|---|---|---|
| `new()` | `diff` | — | base constructor |
| `item_a(el)` | `diff-item-1` | `Element(msg)` | first comparison item |
| `item_b(el)` | `diff-item-2` | `Element(msg)` | second comparison item |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch (e.g. `w-full`, `aspect-16/9`) |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` with `diff-resizer` included automatically |

---

### Carousel

**DaisyUI page**: https://daisyui.com/components/carousel/
**HTML element**: `<div class="carousel">` with `<div class="carousel-item">` children
**Status**: Implemented (`carousel.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `carousel` | — | base constructor; default snap is start |
| `center` | `carousel-center` | — | snap items to center |
| `end_` | `carousel-end` | — | snap items to end |
| `vertical` | `carousel-vertical` | — | vertical scrolling carousel |
| `items(items)` | — | `List(CarouselItem(msg))` | carousel slides |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### CarouselItem

| Constructor | DaisyUI class | Notes |
|---|---|---|
| `slide(el)` | `carousel-item` | wraps content in a carousel-item div |
| `slide_id(id, el)` | `carousel-item` + `id` | named slide for anchor-link navigation |

---

### Toast

**DaisyUI page**: https://daisyui.com/components/toast/
**HTML element**: `<div class="toast">` — fixed-position notification container
**Status**: Implemented (`toast.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `toast` | — | base constructor; default: bottom-right |
| `top` | `toast-top` | — | vertical placement |
| `middle` | `toast-middle` | — | vertical placement |
| `bottom` | `toast-bottom` | — | vertical placement (default) |
| `start` | `toast-start` | — | horizontal placement — left |
| `center` | `toast-center` | — | horizontal placement — center |
| `end_` | `toast-end` | — | horizontal placement — right (default) |
| `children(els)` | — | `List(Element(msg))` | alert elements to display |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Hero

**DaisyUI page**: https://daisyui.com/components/hero/
**HTML element**: `<div class="hero">`
**Status**: Implemented (`hero.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `hero` | — | base constructor |
| `content(els)` | `hero-content` | `List(Element(msg))` | main hero content |
| `overlay` | `hero-overlay` | — | dark overlay over background image |
| `bg_image(url)` | `style="background-image: url(…)"` | `String` | background image URL |
| `min_h_screen` | `min-h-screen` | — | full viewport height |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Indicator

**DaisyUI page**: https://daisyui.com/components/indicator/
**HTML element**: `<div class="indicator">` wrapping content with `<span class="indicator-item">`
**Status**: Implemented (`indicator.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `indicator` | — | base constructor |
| `child(el)` | — | `Element(msg)` | the element to decorate |
| `badge(el)` | `indicator-item` | `Element(msg)` | the badge/indicator element |
| `top` | `indicator-top` | — | vertical placement (default) |
| `middle` | `indicator-middle` | — | vertical placement |
| `bottom` | `indicator-bottom` | — | vertical placement |
| `start` | `indicator-start` | — | horizontal placement |
| `center` | `indicator-center` | — | horizontal placement |
| `end_` | `indicator-end` | — | horizontal placement (default) |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Join

**DaisyUI page**: https://daisyui.com/components/join/
**HTML element**: `<div class="join">`
**Status**: Implemented (`join.gleam`).

Join groups adjacent components and automatically manages border-radius.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `join` | — | base constructor; default is horizontal |
| `vertical` | `join-vertical` | — | stack items vertically |
| `children(els)` | — | `List(Element(msg))` | items — each must have `join-item` class |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

> **Note:** Each child element must carry `join-item` class. Tidal should expose a helper
> `join.item_class()` returning the class string, or wrap child elements automatically.

---

### Kbd

**DaisyUI page**: https://daisyui.com/components/kbd/
**HTML element**: `<kbd class="kbd">`
**Status**: Implemented (`kbd.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `kbd` | — | base constructor |
| `label(t)` | — | `String` | key label text |
| `size(s)` | `kbd-xs` … `kbd-xl` | `Size` | kbd size |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Skeleton

**DaisyUI page**: https://daisyui.com/components/skeleton/
**HTML element**: `<div class="skeleton">`
**Status**: Implemented (`skeleton.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `skeleton` | — | base constructor; animates background |
| `text` | `skeleton-text` | — | animates text color instead of background |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch — use for w/h sizing |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Swap

**DaisyUI page**: https://daisyui.com/components/swap/
**HTML element**: `<label class="swap">` wrapping checkbox + two content elements
**Status**: Implemented (`swap.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `swap` | — | base constructor; uses checkbox by default |
| `on_el(el)` | `swap-on` | `Element(msg)` | shown when active/checked |
| `off_el(el)` | `swap-off` | `Element(msg)` | shown when inactive/unchecked |
| `indeterminate_el(el)` | `swap-indeterminate` | `Element(msg)` | shown when indeterminate |
| `active(b)` | `swap-active` | `Bool` | toggle via class instead of checkbox |
| `rotate` | `swap-rotate` | — | rotation transition effect |
| `flip` | `swap-flip` | — | flip transition effect |
| `on_change(f)` | — | `fn(Bool)->msg` | fires on toggle |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Link

**DaisyUI page**: https://daisyui.com/components/link/
**HTML element**: `<a class="link">`
**Status**: Implemented (`link.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `link` | — | base constructor; always underlined |
| `label(t)` | — | `String` | link text |
| `href(url)` | `href="{url}"` | `String` | destination URL |
| `hover` | `link-hover` | — | underline only on hover |
| `primary` | `link-primary` | — | color |
| `secondary` | `link-secondary` | — | color |
| `accent` | `link-accent` | — | color |
| `neutral` | `link-neutral` | — | color |
| `info` | `link-info` | — | color |
| `success` | `link-success` | — | color |
| `warning` | `link-warning` | — | color |
| `error` | `link-error` | — | color |
| `children(els)` | — | `List(Element(msg))` | custom link content (icon + text, etc.) |
| `on_click(msg)` | — | `msg` | click handler |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### Footer

**DaisyUI page**: https://daisyui.com/components/footer/
**HTML element**: `<footer class="footer">`
**Status**: Implemented (`footer.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `footer` | — | base constructor; default is vertical |
| `horizontal` | `footer-horizontal` | — | columns side-by-side |
| `centered` | `footer-center` | — | center-aligned content |
| `columns(cols)` | — | `List(FooterColumn(msg))` | footer navigation columns |
| `aside(el)` | — | `Element(msg)` | branding/logo aside section |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### FooterColumn

| Constructor | DaisyUI class | Notes |
|---|---|---|
| `column(title, links)` | `<nav>` with `footer-title` | section title + list of link elements |

---

### Fieldset

**DaisyUI page**: https://daisyui.com/components/fieldset/
**HTML element**: `<fieldset class="fieldset">`
**Status**: Implemented (`fieldset.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `fieldset` | — | base constructor |
| `legend(t)` | `fieldset-legend` | `String` | section heading |
| `children(els)` | — | `List(Element(msg))` | form elements inside fieldset |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### List

**DaisyUI page**: https://daisyui.com/components/list/
**HTML element**: `<ul class="list">` with `<li class="list-row">` items
**Status**: Implemented (`list_display.gleam` — note non-standard module name).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `list` | — | base constructor |
| `rows(rows)` | — | `List(ListRow(msg))` | list row items |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

#### ListRow

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `row_new()` | `list-row` | — | base constructor |
| `row_children(els)` | — | `List(Element(msg))` | row cells |
| `row_grow(el)` | `list-col-grow` | `Element(msg)` | the child that fills remaining space |
| `row_wrap(el)` | `list-col-wrap` | `Element(msg)` | forces a child to wrap to next line |
| `row_build` | — | — | produces `Element(msg)` |

---

### MockupCode

**DaisyUI page**: https://daisyui.com/components/mockup-code/
**HTML element**: `<div class="mockup-code">`
**Status**: Implemented (`mockup_code.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `mockup-code` | — | base constructor |
| `line(t)` | `<pre><code>` | `String` | add a code line |
| `line_prefix(t, prefix)` | `data-prefix="{prefix}"` | `String, String` | code line with custom prefix (e.g. `"$"`, `"1"`) |
| `line_highlight(t, color)` | `bg-{color}` on `<pre>` | `String, Color` | highlighted line |
| `bg(color)` | `bg-{color}` on wrapper | `Color` | background color |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### MockupPhone

**DaisyUI page**: https://daisyui.com/components/mockup-phone/
**HTML element**: `<div class="mockup-phone">`
**Status**: Implemented (`mockup_phone.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `mockup-phone` | — | base constructor |
| `content(els)` | `mockup-phone-display` | `List(Element(msg))` | screen content |
| `border_color(t)` | `border-[{t}]` | `String` | arbitrary border color (e.g. `"#ff8938"`) |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` with camera notch included |

---

### MockupWindow

**DaisyUI page**: https://daisyui.com/components/mockup-window/
**HTML element**: `<div class="mockup-window">`
**Status**: Implemented (`mockup_window.gleam`).

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `mockup-window border border-base-300` | — | base constructor |
| `content(els)` | inner content div | `List(Element(msg))` | window content |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

### ThemeController

**DaisyUI page**: https://daisyui.com/components/theme-controller/
**HTML element**: `<input type="checkbox" class="theme-controller">` (or radio)
**Status**: Implemented (`theme_controller.gleam`).

The theme controller changes the active DaisyUI theme via a CSS-only mechanism: when the
input is checked, the theme named in the `value` attribute becomes active.

| Modifier function | DaisyUI/TW class | Type | Notes |
|---|---|---|---|
| `new()` | `theme-controller` | — | base constructor; renders as checkbox |
| `theme(name)` | `value="{name}"` | `String` | target theme name (e.g. `"synthwave"`) |
| `checked(b)` | `checked` attr | `Bool` | initial checked state |
| `as_radio` | `type="radio"` | — | use radio input instead of checkbox (for theme groups) |
| `name(n)` | `name="{n}"` | `String` | radio group name (when `as_radio` is set) |
| `toggle` | combined with `toggle` class | — | render as a DaisyUI toggle |
| `btn` | combined with `btn` class | — | render as a button |
| `swap` | combined with `swap` class | — | render as a swap button |
| `on_change(f)` | — | `fn(Bool)->msg` | fires when theme changes |
| `style(s)` | — | `List(Style)` | Tailwind escape hatch |
| `attrs(a)` | — | `List(Attribute(msg))` | HTML attribute escape hatch |
| `build` | — | — | produces `Element(msg)` |

---

## Implementation Gaps & Issues

All known implementation gaps have been resolved. The library is fully aligned with this
specification.
