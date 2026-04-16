/// Footer — DaisyUI `footer` site navigation.
///
/// Use `column(title, links)` to build each nav section, then `columns()`.
/// Use `children()` for custom raw content.
///
/// ```gleam
/// import tidal/footer
/// import lustre/attribute
/// import lustre/element/html
///
/// footer.new()
/// |> footer.columns([
///   footer.column("Services", [
///     html.a([attribute.class("link link-hover")], [html.text("Branding")]),
///     html.a([attribute.class("link link-hover")], [html.text("Design")]),
///   ]),
/// ])
/// |> footer.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Footer(msg) {
  Footer(
    centered: Bool,
    direction: Option(String),
    aside: Option(Element(msg)),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

/// Create a new footer — `<footer class="footer">`.
pub fn new() -> Footer(msg) {
  Footer(centered: False, direction: None, aside: None, styles: [], attrs: [], children: [])
}

/// Horizontal layout — `footer-horizontal`.
pub fn horizontal(f: Footer(msg)) -> Footer(msg) { Footer(..f, direction: Some("footer-horizontal")) }
/// Center-aligned content — `footer-center`.
pub fn centered(f: Footer(msg)) -> Footer(msg) { Footer(..f, centered: True) }

/// Branding/logo aside section rendered before the nav columns.
pub fn aside(f: Footer(msg), el: Element(msg)) -> Footer(msg) {
  Footer(..f, aside: Some(el))
}

/// Build a nav column: `<nav>` with a `footer-title` heading and link elements.
pub fn column(col_title: String, links: List(Element(msg))) -> Element(msg) {
  html.nav([], list.append(
    [html.h6([attribute.class("footer-title")], [html.text(col_title)])],
    links,
  ))
}

/// Appends nav column elements (built with `column()`).
pub fn columns(f: Footer(msg), cols: List(Element(msg))) -> Footer(msg) {
  Footer(..f, children: list.append(f.children, cols))
}

/// Appends raw child elements (escape hatch).
pub fn children(f: Footer(msg), c: List(Element(msg))) -> Footer(msg) {
  Footer(..f, children: list.append(f.children, c))
}

/// Appends Tailwind utility styles.
pub fn style(f: Footer(msg), s: List(Style)) -> Footer(msg) {
  Footer(..f, styles: list.append(f.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(f: Footer(msg), a: List(Attribute(msg))) -> Footer(msg) {
  Footer(..f, attrs: list.append(f.attrs, a))
}

pub fn build(f: Footer(msg)) -> Element(msg) {
  let class =
    [
      Some("footer"),
      f.direction,
      case f.centered { True -> Some("footer-center") False -> None },
      case to_class_string(f.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let aside_el = case f.aside { None -> [] Some(el) -> [el] }
  html.footer([attribute.class(class), ..f.attrs], list.append(aside_el, f.children))
}
