/// Stack — DaisyUI `stack` component for overlapping layered children.
///
/// Each child is stacked on top of the previous, offset slightly to create a
/// card-stack visual effect.
///
/// ```gleam
/// import tidal/stack
///
/// stack.new()
/// |> stack.children([card1, card2, card3])
/// |> stack.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Stack(msg) {
  Stack(
    align_v: Option(String),
    align_h: Option(String),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
    children: List(Element(msg)),
  )
}

/// Create a new stack container — renders `<div class="stack">`.
pub fn new() -> Stack(msg) {
  Stack(align_v: None, align_h: None, styles: [], attrs: [], children: [])
}

/// Align children to the top — `stack-top`.
pub fn top(s: Stack(msg)) -> Stack(msg) { Stack(..s, align_v: Some("stack-top")) }
/// Align children to the bottom (default) — `stack-bottom`.
pub fn bottom(s: Stack(msg)) -> Stack(msg) { Stack(..s, align_v: Some("stack-bottom")) }
/// Align children to the start (horizontal) — `stack-start`.
pub fn align_start(s: Stack(msg)) -> Stack(msg) { Stack(..s, align_h: Some("stack-start")) }
/// Align children to the end (horizontal) — `stack-end`.
pub fn align_end(s: Stack(msg)) -> Stack(msg) { Stack(..s, align_h: Some("stack-end")) }

/// Appends Tailwind utility styles.
pub fn style(s: Stack(msg), st: List(Style)) -> Stack(msg) {
  Stack(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes.
pub fn attrs(s: Stack(msg), a: List(attribute.Attribute(msg))) -> Stack(msg) {
  Stack(..s, attrs: list.append(s.attrs, a))
}

/// Appends child elements to the stack.
pub fn children(s: Stack(msg), c: List(Element(msg))) -> Stack(msg) {
  Stack(..s, children: list.append(s.children, c))
}

pub fn build(s: Stack(msg)) -> Element(msg) {
  let classes =
    [
      Some("stack"),
      s.align_v,
      s.align_h,
      case style.to_class_string(s.styles) { "" -> None st -> Some(st) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.div([attribute.class(classes), ..s.attrs], s.children)
}
