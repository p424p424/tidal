/// Generic container element — renders as a `<div>`.
///
/// Use `el` when you need a plain block container without any built-in layout
/// behaviour. For flex layouts use `row` or `column` instead.
///
/// ```gleam
/// import tidal/el
/// import tidal/style/spacing
/// import tidal/style/background as bg
/// import tidal/style/color
///
/// el.new()
/// |> el.style([bg.bg(color.Base200), spacing.p(4)])
/// |> el.children([...])
/// |> el.build
/// ```

import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type El(msg) {
  El(
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> El(msg) {
  El(styles: [], attrs: [], children: [])
}

/// Appends presentation styles. May be called multiple times.
pub fn style(el: El(msg), s: List(Style)) -> El(msg) {
  El(..el, styles: list.append(el.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
///
/// Use this as an escape hatch for attributes not covered by the builder
/// (e.g. `attribute.id("main")`, `event.on_click(msg)`).
pub fn attrs(el: El(msg), a: List(attribute.Attribute(msg))) -> El(msg) {
  El(..el, attrs: list.append(el.attrs, a))
}

/// Sets the child elements. May be called multiple times — children accumulate.
pub fn children(el: El(msg), c: List(Element(msg))) -> El(msg) {
  El(..el, children: list.append(el.children, c))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(el: El(msg)) -> Element(msg) {
  html.div(
    [attribute.class(style.to_class_string(el.styles)), ..el.attrs],
    el.children,
  )
}
