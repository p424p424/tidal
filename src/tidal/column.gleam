/// Vertical flex container — `<div class="flex flex-col">`.
///
/// ```gleam
/// import tidal/column
/// import tidal/align
///
/// column.new()
/// |> column.gap(6)
/// |> column.align(align.Center)
/// |> column.children([header_el, body_el, footer_el])
/// |> column.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/align.{type Align}
import tidal/justify.{type Justify}
import tidal/style.{type Style}
import tidal/wrap.{type Wrap}

pub opaque type Column(msg) {
  Column(
    reverse: Bool,
    grow: Bool,
    align: Option(String),
    justify: Option(String),
    wrap: Option(String),
    gap: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

pub fn new() -> Column(msg) {
  Column(
    reverse: False,
    grow: False,
    align: None,
    justify: None,
    wrap: None,
    gap: None,
    styles: [],
    attrs: [],
    children: [],
  )
}

/// Reverse the direction to `flex-col-reverse`.
pub fn reverse(c: Column(msg)) -> Column(msg) { Column(..c, reverse: True) }

/// Make the column fill available space with `flex-1`.
pub fn grow(c: Column(msg)) -> Column(msg) { Column(..c, grow: True) }

/// Set `align-items` — how children align on the cross axis.
pub fn align(c: Column(msg), a: Align) -> Column(msg) {
  Column(..c, align: Some(align.to_class(a)))
}

/// Set `justify-content` — how children are distributed along the main axis.
pub fn justify(c: Column(msg), j: Justify) -> Column(msg) {
  Column(..c, justify: Some(justify.to_class(j)))
}

/// Set flex wrapping behaviour.
pub fn wrap(c: Column(msg), w: Wrap) -> Column(msg) {
  Column(..c, wrap: Some(wrap.to_class(w)))
}

/// Uniform gap between children.
pub fn gap(c: Column(msg), n: Int) -> Column(msg) {
  Column(..c, gap: Some("gap-" <> int.to_string(n)))
}

/// Horizontal gap only.
pub fn gap_x(c: Column(msg), n: Int) -> Column(msg) {
  Column(..c, gap: Some("gap-x-" <> int.to_string(n)))
}

/// Vertical gap only.
pub fn gap_y(c: Column(msg), n: Int) -> Column(msg) {
  Column(..c, gap: Some("gap-y-" <> int.to_string(n)))
}

/// Appends Tailwind utility styles. May be called multiple times.
pub fn style(c: Column(msg), s: List(Style)) -> Column(msg) {
  Column(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(c: Column(msg), a: List(Attribute(msg))) -> Column(msg) {
  Column(..c, attrs: list.append(c.attrs, a))
}

/// Appends child elements. May be called multiple times.
pub fn children(c: Column(msg), ch: List(Element(msg))) -> Column(msg) {
  Column(..c, children: list.append(c.children, ch))
}

pub fn build(c: Column(msg)) -> Element(msg) {
  let direction = case c.reverse { True -> "flex-col-reverse" False -> "flex-col" }
  let parts =
    [
      Some("flex"),
      Some(direction),
      case c.grow { True -> Some("flex-1") False -> None },
      c.align,
      c.justify,
      c.wrap,
      c.gap,
      case style.to_class_string(c.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
  let cls = string.join(parts, " ")
  html.div([attribute.class(cls), ..c.attrs], c.children)
}
