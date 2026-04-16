/// Horizontal flex container — `<div class="flex flex-row">`.
///
/// ```gleam
/// import tidal/row
/// import tidal/align
/// import tidal/justify
///
/// row.new()
/// |> row.align(align.Center)
/// |> row.justify(justify.Between)
/// |> row.gap(4)
/// |> row.children([left_el, right_el])
/// |> row.build
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

pub opaque type Row(msg) {
  Row(
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

pub fn new() -> Row(msg) {
  Row(
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

/// Reverse the direction to `flex-row-reverse`.
pub fn reverse(r: Row(msg)) -> Row(msg) { Row(..r, reverse: True) }

/// Make the row fill available space with `flex-1`.
pub fn grow(r: Row(msg)) -> Row(msg) { Row(..r, grow: True) }

/// Set `align-items` — how children align on the cross axis.
pub fn align(r: Row(msg), a: Align) -> Row(msg) {
  Row(..r, align: Some(align.to_class(a)))
}

/// Set `justify-content` — how children are distributed along the main axis.
pub fn justify(r: Row(msg), j: Justify) -> Row(msg) {
  Row(..r, justify: Some(justify.to_class(j)))
}

/// Set flex wrapping behaviour.
pub fn wrap(r: Row(msg), w: Wrap) -> Row(msg) {
  Row(..r, wrap: Some(wrap.to_class(w)))
}

/// Uniform gap between children.
pub fn gap(r: Row(msg), n: Int) -> Row(msg) {
  Row(..r, gap: Some("gap-" <> int.to_string(n)))
}

/// Horizontal gap only.
pub fn gap_x(r: Row(msg), n: Int) -> Row(msg) {
  Row(..r, gap: Some("gap-x-" <> int.to_string(n)))
}

/// Vertical gap only.
pub fn gap_y(r: Row(msg), n: Int) -> Row(msg) {
  Row(..r, gap: Some("gap-y-" <> int.to_string(n)))
}

/// Appends Tailwind utility styles. May be called multiple times.
pub fn style(r: Row(msg), s: List(Style)) -> Row(msg) {
  Row(..r, styles: list.append(r.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(r: Row(msg), a: List(Attribute(msg))) -> Row(msg) {
  Row(..r, attrs: list.append(r.attrs, a))
}

/// Appends child elements. May be called multiple times.
pub fn children(r: Row(msg), c: List(Element(msg))) -> Row(msg) {
  Row(..r, children: list.append(r.children, c))
}

pub fn build(r: Row(msg)) -> Element(msg) {
  let direction = case r.reverse { True -> "flex-row-reverse" False -> "flex-row" }
  let parts =
    [
      Some("flex"),
      Some(direction),
      case r.grow { True -> Some("flex-1") False -> None },
      r.align,
      r.justify,
      r.wrap,
      r.gap,
      case style.to_class_string(r.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
  let cls = string.join(parts, " ")
  html.div([attribute.class(cls), ..r.attrs], r.children)
}
