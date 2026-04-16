/// Vertical flex container — renders as a `<div>` with `flex flex-col`.
///
/// ```gleam
/// import tidal/column
/// import tidal/style/flexbox as fx
/// import tidal/style/spacing
///
/// column.new()
/// |> column.style([fx.items_start(), fx.gap(6), spacing.p(4)])
/// |> column.children([...])
/// |> column.build
/// ```

import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Column(msg) {
  Column(
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Column(msg) {
  Column(styles: [], attrs: [], children: [])
}

/// Appends presentation styles. May be called multiple times.
pub fn style(c: Column(msg), s: List(Style)) -> Column(msg) {
  Column(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(c: Column(msg), a: List(attribute.Attribute(msg))) -> Column(msg) {
  Column(..c, attrs: list.append(c.attrs, a))
}

/// Sets the child elements. May be called multiple times — children accumulate.
pub fn children(c: Column(msg), ch: List(Element(msg))) -> Column(msg) {
  Column(..c, children: list.append(c.children, ch))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(c: Column(msg)) -> Element(msg) {
  let base = "flex flex-col"
  let cls = case style.to_class_string(c.styles) {
    "" -> base
    s -> base <> " " <> s
  }
  html.div([attribute.class(cls), ..c.attrs], c.children)
}
