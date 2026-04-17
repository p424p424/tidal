/// Stack — DaisyUI `stack` component for overlapping layered children.
///
/// Each child is stacked on top of the previous, offset slightly to create a
/// card-stack visual effect.
///
/// ```gleam
/// import tidal/stack
///
/// stack.new()
/// |> stack.children(elements: [card1, card2, card3])
/// |> stack.build
/// ```
///
/// See also:
/// - DaisyUI stack docs: https://daisyui.com/components/stack/
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

/// Creates a new `Stack` container — renders `<div class="stack">`.
///
/// Chain builder functions to configure the stack, then call `build`:
///
/// ```gleam
/// import tidal/stack
///
/// stack.new()
/// |> stack.children(elements: [card1, card2, card3])
/// |> stack.build
/// ```
///
/// See also:
/// - DaisyUI stack docs: https://daisyui.com/components/stack/
pub fn new() -> Stack(msg) {
  Stack(align_v: None, align_h: None, styles: [], attrs: [], children: [])
}

/// Align children to the top — `stack-top`.
pub fn top(stk: Stack(msg)) -> Stack(msg) {
  Stack(..stk, align_v: Some("stack-top"))
}

/// Align children to the bottom (default) — `stack-bottom`.
pub fn bottom(stk: Stack(msg)) -> Stack(msg) {
  Stack(..stk, align_v: Some("stack-bottom"))
}

/// Align children to the start (horizontal) — `stack-start`.
pub fn align_start(stk: Stack(msg)) -> Stack(msg) {
  Stack(..stk, align_h: Some("stack-start"))
}

/// Align children to the end (horizontal) — `stack-end`.
pub fn align_end(stk: Stack(msg)) -> Stack(msg) {
  Stack(..stk, align_h: Some("stack-end"))
}

/// Appends Tailwind utility styles.
pub fn style(stk: Stack(msg), styles styles: List(Style)) -> Stack(msg) {
  Stack(..stk, styles: list.append(stk.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  stk: Stack(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Stack(msg) {
  Stack(..stk, attrs: list.append(stk.attrs, attributes))
}

/// Appends child elements to the stack.
pub fn children(
  stk: Stack(msg),
  elements elements: List(Element(msg)),
) -> Stack(msg) {
  Stack(..stk, children: list.append(stk.children, elements))
}

pub fn build(stk: Stack(msg)) -> Element(msg) {
  let classes =
    [
      Some("stack"),
      stk.align_v,
      stk.align_h,
      case style.to_class_string(stk.styles) {
        "" -> None
        st -> Some(st)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.div([attribute.class(classes), ..stk.attrs], stk.children)
}
