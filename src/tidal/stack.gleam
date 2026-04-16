/// Layered container — renders as a `<div>` with `relative`.
///
/// Children with `layout.absolute()` will be positioned relative to this
/// container, enabling overlapping / layered layouts.
///
/// ```gleam
/// import tidal/stack
/// import tidal/el
/// import tidal/style/layout
/// import tidal/style/sizing
///
/// stack.new()
/// |> stack.style([sizing.w_full(), sizing.h(64)])
/// |> stack.children([
///   background_image,
///   el.new()
///   |> el.style([layout.absolute(), layout.inset(0)])
///   |> el.children([overlay_content])
///   |> el.build,
/// ])
/// |> stack.build
/// ```

import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Stack(msg) {
  Stack(
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Stack(msg) {
  Stack(styles: [], attrs: [], children: [])
}

/// Appends presentation styles. May be called multiple times.
pub fn style(s: Stack(msg), st: List(Style)) -> Stack(msg) {
  Stack(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(s: Stack(msg), a: List(attribute.Attribute(msg))) -> Stack(msg) {
  Stack(..s, attrs: list.append(s.attrs, a))
}

/// Sets the child elements. May be called multiple times — children accumulate.
pub fn children(s: Stack(msg), c: List(Element(msg))) -> Stack(msg) {
  Stack(..s, children: list.append(s.children, c))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(s: Stack(msg)) -> Element(msg) {
  let base = "relative"
  let cls = case style.to_class_string(s.styles) {
    "" -> base
    st -> base <> " " <> st
  }
  html.div([attribute.class(cls), ..s.attrs], s.children)
}
