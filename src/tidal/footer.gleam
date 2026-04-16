/// Footer — site footer with columnar navigation layout.
///
/// ```gleam
/// import tidal/footer
/// import lustre/attribute
/// import lustre/element/html
///
/// footer.new()
/// |> footer.attrs([attribute.class("bg-neutral text-neutral-content p-10")])
/// |> footer.children([
///   html.nav([], [
///     footer.title("Services"),
///     html.a([attribute.class("link link-hover")], [html.text("Branding")]),
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
    center: Bool,
    direction: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

pub fn new() -> Footer(msg) {
  Footer(center: False, direction: None, styles: [], attrs: [], children: [])
}

pub fn horizontal(f: Footer(msg)) -> Footer(msg) { Footer(..f, direction: Some("footer-horizontal")) }
pub fn vertical(f: Footer(msg)) -> Footer(msg) { Footer(..f, direction: Some("footer-vertical")) }
pub fn center(f: Footer(msg)) -> Footer(msg) { Footer(..f, center: True) }

pub fn style(f: Footer(msg), s: List(Style)) -> Footer(msg) {
  Footer(..f, styles: list.append(f.styles, s))
}

pub fn attrs(f: Footer(msg), a: List(Attribute(msg))) -> Footer(msg) {
  Footer(..f, attrs: list.append(f.attrs, a))
}

pub fn children(f: Footer(msg), c: List(Element(msg))) -> Footer(msg) {
  Footer(..f, children: c)
}

/// Renders `<h6 class="footer-title">text</h6>` for use as section heading.
pub fn title(text: String) -> Element(msg) {
  html.h6([attribute.class("footer-title")], [html.text(text)])
}

pub fn build(f: Footer(msg)) -> Element(msg) {
  let center_class = case f.center { True -> Some("footer-center") False -> None }
  let base =
    [Some("footer"), f.direction, center_class]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(f.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.footer([attribute.class(class), ..f.attrs], f.children)
}
