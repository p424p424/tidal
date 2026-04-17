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
/// |> footer.columns(elements: [
///   footer.column("Services", [
///     html.a([attribute.class("link link-hover")], [html.text("Branding")]),
///     html.a([attribute.class("link link-hover")], [html.text("Design")]),
///   ]),
/// ])
/// |> footer.build
/// ```
///
/// See also:
/// - DaisyUI footer docs: https://daisyui.com/components/footer/
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

/// Creates a new `Footer` builder — `<footer class="footer">`.
///
/// Chain builder functions to configure the footer, then call `build`:
///
/// ```gleam
/// import tidal/footer
///
/// footer.new()
/// |> footer.columns(elements: [
///   footer.column("Services", [branding_link, design_link]),
/// ])
/// |> footer.build
/// ```
///
/// See also:
/// - DaisyUI footer docs: https://daisyui.com/components/footer/
pub fn new() -> Footer(msg) {
  Footer(
    centered: False,
    direction: None,
    aside: None,
    styles: [],
    attrs: [],
    children: [],
  )
}

/// Horizontal layout — `footer-horizontal`.
pub fn horizontal(ftr: Footer(msg)) -> Footer(msg) {
  Footer(..ftr, direction: Some("footer-horizontal"))
}

/// Center-aligned content — `footer-center`.
pub fn centered(ftr: Footer(msg)) -> Footer(msg) {
  Footer(..ftr, centered: True)
}

/// Branding/logo aside section rendered before the nav columns.
pub fn aside(ftr: Footer(msg), element element: Element(msg)) -> Footer(msg) {
  Footer(..ftr, aside: Some(element))
}

/// Build a nav column: `<nav>` with a `footer-title` heading and link elements.
pub fn column(col_title: String, links: List(Element(msg))) -> Element(msg) {
  html.nav(
    [],
    list.append(
      [html.h6([attribute.class("footer-title")], [html.text(col_title)])],
      links,
    ),
  )
}

/// Appends nav column elements (built with `column()`).
pub fn columns(
  ftr: Footer(msg),
  elements elements: List(Element(msg)),
) -> Footer(msg) {
  Footer(..ftr, children: list.append(ftr.children, elements))
}

/// Appends raw child elements (escape hatch).
pub fn children(
  ftr: Footer(msg),
  elements elements: List(Element(msg)),
) -> Footer(msg) {
  Footer(..ftr, children: list.append(ftr.children, elements))
}

/// Appends Tailwind utility styles.
pub fn style(ftr: Footer(msg), styles styles: List(Style)) -> Footer(msg) {
  Footer(..ftr, styles: list.append(ftr.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  ftr: Footer(msg),
  attributes attributes: List(Attribute(msg)),
) -> Footer(msg) {
  Footer(..ftr, attrs: list.append(ftr.attrs, attributes))
}

pub fn build(ftr: Footer(msg)) -> Element(msg) {
  let class =
    [
      Some("footer"),
      ftr.direction,
      case ftr.centered {
        True -> Some("footer-center")
        False -> None
      },
      case to_class_string(ftr.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let aside_el = case ftr.aside {
    None -> []
    Some(el) -> [el]
  }
  html.footer(
    [attribute.class(class), ..ftr.attrs],
    list.append(aside_el, ftr.children),
  )
}
