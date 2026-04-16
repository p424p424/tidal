/// Breadcrumb component — renders a DaisyUI `breadcrumbs` trail.
///
/// Items without an `href` render as plain text (suitable for the current page).
///
/// ```gleam
/// import tidal/breadcrumb
///
/// breadcrumb.new()
/// |> breadcrumb.item("Home", Some("/"))
/// |> breadcrumb.item("Docs", Some("/docs"))
/// |> breadcrumb.item("Components", None)
/// |> breadcrumb.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

type BreadcrumbItem {
  BreadcrumbItem(label: String, href: Option(String))
}

pub opaque type Breadcrumb(msg) {
  Breadcrumb(
    items: List(BreadcrumbItem),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Breadcrumb(msg) {
  Breadcrumb(items: [], styles: [], attrs: [])
}

/// Adds a breadcrumb item. Pass `Some("/path")` for a link, `None` for plain text.
pub fn item(b: Breadcrumb(msg), label: String, href: Option(String)) -> Breadcrumb(msg) {
  Breadcrumb(..b, items: list.append(b.items, [BreadcrumbItem(label, href)]))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(b: Breadcrumb(msg), s: List(Style)) -> Breadcrumb(msg) {
  Breadcrumb(..b, styles: list.append(b.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  b: Breadcrumb(msg),
  a: List(attribute.Attribute(msg)),
) -> Breadcrumb(msg) {
  Breadcrumb(..b, attrs: list.append(b.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn item_el(bc: BreadcrumbItem) -> Element(msg) {
  let content = case bc.href {
    Some(href) ->
      html.a([attribute.href(href)], [element.text(bc.label)])
    None -> element.text(bc.label)
  }
  html.li([], [content])
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
