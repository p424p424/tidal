/// Constrained-width centered wrapper — `<div class="container mx-auto">`.
///
/// Uses Tailwind's built-in `container` class which sets responsive `max-width`
/// breakpoint values. Combine with `padding` for comfortable side gutters.
///
/// ```gleam
/// import tidal/container
///
/// container.new()
/// |> container.padding(6)
/// |> container.children([page_content])
/// |> container.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Container(msg) {
  Container(
    padding: Option(Int),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

pub fn new() -> Container(msg) {
  Container(padding: None, styles: [], attrs: [], children: [])
}

/// Horizontal padding in Tailwind spacing units (`px-{n}`).
pub fn padding(c: Container(msg), n: Int) -> Container(msg) {
  Container(..c, padding: Some(n))
}

/// Appends Tailwind utility styles. May be called multiple times.
pub fn style(c: Container(msg), s: List(Style)) -> Container(msg) {
  Container(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(c: Container(msg), a: List(Attribute(msg))) -> Container(msg) {
  Container(..c, attrs: list.append(c.attrs, a))
}

/// Sets child elements. May be called multiple times — children accumulate.
pub fn children(c: Container(msg), ch: List(Element(msg))) -> Container(msg) {
  Container(..c, children: list.append(c.children, ch))
}

pub fn build(c: Container(msg)) -> Element(msg) {
  let parts =
    [
      Some("container mx-auto"),
      option.map(c.padding, fn(n) { "px-" <> int.to_string(n) }),
      case style.to_class_string(c.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
  let cls = string.join(parts, " ")
  html.div([attribute.class(cls), ..c.attrs], c.children)
}
