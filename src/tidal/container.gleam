/// Constrained-width centered wrapper — `<div class="container mx-auto">`.
///
/// Uses Tailwind's built-in `container` class which sets responsive `max-width`
/// breakpoint values. Combine with `padding` for comfortable side gutters.
///
/// ```gleam
/// import tidal/container
///
/// container.new()
/// |> container.padding(amount: 6)
/// |> container.children(elements: [page_content])
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

/// Creates a new `Container` builder — a centered `<div class="container mx-auto">`.
///
/// Chain builder functions to configure the container, then call `build`:
///
/// ```gleam
/// import tidal/container
///
/// container.new()
/// |> container.padding(amount: 6)
/// |> container.children(elements: [page_content])
/// |> container.build
/// ```
///
/// See also:
/// - Tailwind container docs: https://tailwindcss.com/docs/container
pub fn new() -> Container(msg) {
  Container(padding: None, styles: [], attrs: [], children: [])
}

/// Horizontal padding in Tailwind spacing units (`px-{n}`).
pub fn padding(container: Container(msg), amount amount: Int) -> Container(msg) {
  Container(..container, padding: Some(amount))
}

/// Appends Tailwind utility styles. May be called multiple times.
pub fn style(
  container: Container(msg),
  styles styles: List(Style),
) -> Container(msg) {
  Container(..container, styles: list.append(container.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  container: Container(msg),
  attributes attributes: List(Attribute(msg)),
) -> Container(msg) {
  Container(..container, attrs: list.append(container.attrs, attributes))
}

/// Sets child elements. May be called multiple times — children accumulate.
pub fn children(
  container: Container(msg),
  elements elements: List(Element(msg)),
) -> Container(msg) {
  Container(..container, children: list.append(container.children, elements))
}

pub fn build(container: Container(msg)) -> Element(msg) {
  let parts =
    [
      Some("container mx-auto"),
      option.map(container.padding, fn(n) { "px-" <> int.to_string(n) }),
      case style.to_class_string(container.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
  let cls = string.join(parts, " ")
  html.div([attribute.class(cls), ..container.attrs], container.children)
}
