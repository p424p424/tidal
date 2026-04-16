/// Breadcrumb — navigation trail rendered as `<div class="breadcrumbs"><ul>`.
///
/// ```gleam
/// import tidal/breadcrumb
///
/// breadcrumb.new()
/// |> breadcrumb.crumb_link("Home", "/")
/// |> breadcrumb.crumb_link("Docs", "/docs")
/// |> breadcrumb.crumb("Components")
/// |> breadcrumb.build
/// ```

import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub type BreadcrumbItem(msg) {
  Crumb(label: String)
  CrumbLink(label: String, href: String)
  CrumbIcon(label: String, icon: Element(msg))
}

pub opaque type Breadcrumb(msg) {
  Breadcrumb(
    items: List(BreadcrumbItem(msg)),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

/// Create a new breadcrumb trail.
pub fn new() -> Breadcrumb(msg) {
  Breadcrumb(items: [], styles: [], attrs: [])
}

/// Plain text crumb — current page (not a link).
pub fn crumb(b: Breadcrumb(msg), label: String) -> Breadcrumb(msg) {
  Breadcrumb(..b, items: list.append(b.items, [Crumb(label)]))
}

/// Linked crumb — renders as `<a href>`.
pub fn crumb_link(b: Breadcrumb(msg), label: String, href: String) -> Breadcrumb(msg) {
  Breadcrumb(..b, items: list.append(b.items, [CrumbLink(label, href)]))
}

/// Crumb with a leading icon element.
pub fn crumb_icon(b: Breadcrumb(msg), label: String, icon: Element(msg)) -> Breadcrumb(msg) {
  Breadcrumb(..b, items: list.append(b.items, [CrumbIcon(label, icon)]))
}

/// Appends Tailwind utility styles.
pub fn style(b: Breadcrumb(msg), s: List(Style)) -> Breadcrumb(msg) {
  Breadcrumb(..b, styles: list.append(b.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(b: Breadcrumb(msg), a: List(attribute.Attribute(msg))) -> Breadcrumb(msg) {
  Breadcrumb(..b, attrs: list.append(b.attrs, a))
}

fn item_el(bc: BreadcrumbItem(msg)) -> Element(msg) {
  case bc {
    Crumb(label) -> html.li([], [element.text(label)])
    CrumbLink(label, href) ->
      html.li([], [html.a([attribute.href(href)], [element.text(label)])])
    CrumbIcon(label, icon) ->
      html.li([], [
        html.a([], [icon, element.text(label)]),
      ])
  }
}

pub fn build(b: Breadcrumb(msg)) -> Element(msg) {
  let cls = case style.to_class_string(b.styles) {
    "" -> "breadcrumbs"
    s -> "breadcrumbs " <> s
  }
  html.div(
    [attribute.class(cls), ..b.attrs],
    [html.ul([], list.map(b.items, item_el))],
  )
}
