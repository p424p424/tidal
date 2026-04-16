/// Horizontal flex container — renders as a `<div>` with `flex flex-row`.
///
/// ```gleam
/// import tidal/row
/// import tidal/style/flexbox as fx
/// import tidal/style/spacing
///
/// row.new()
/// |> row.style([fx.items_center(), fx.gap(4), spacing.p(4)])
/// |> row.children([...])
/// |> row.build
/// ```

import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Row(msg) {
  Row(
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Row(msg) {
  Row(styles: [], attrs: [], children: [])
}

/// Appends presentation styles. May be called multiple times.
pub fn style(r: Row(msg), s: List(Style)) -> Row(msg) {
  Row(..r, styles: list.append(r.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(r: Row(msg), a: List(attribute.Attribute(msg))) -> Row(msg) {
  Row(..r, attrs: list.append(r.attrs, a))
}

/// Sets the child elements. May be called multiple times — children accumulate.
pub fn children(r: Row(msg), c: List(Element(msg))) -> Row(msg) {
  Row(..r, children: list.append(r.children, c))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(r: Row(msg)) -> Element(msg) {
  let base = "flex flex-row"
  let cls = case style.to_class_string(r.styles) {
    "" -> base
    s -> base <> " " <> s
  }
  html.div([attribute.class(cls), ..r.attrs], r.children)
}
