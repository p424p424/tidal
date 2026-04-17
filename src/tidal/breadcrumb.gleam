/// Breadcrumb — navigation trail rendered as `<div class="breadcrumbs"><ul>`.
///
/// ```gleam
/// import tidal/breadcrumb
///
/// breadcrumb.new()
/// |> breadcrumb.crumb_link(label: "Home", href: "/")
/// |> breadcrumb.crumb_link(label: "Docs", href: "/docs")
/// |> breadcrumb.crumb(label: "Components")
/// |> breadcrumb.build
/// ```
///
/// See also:
/// - DaisyUI breadcrumbs docs: https://daisyui.com/components/breadcrumbs/
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

/// Creates a new `Breadcrumb` trail builder.
///
/// Chain builder functions to add crumbs, then call `build`:
///
/// ```gleam
/// import tidal/breadcrumb
///
/// breadcrumb.new()
/// |> breadcrumb.crumb_link(label: "Home", href: "/")
/// |> breadcrumb.crumb_link(label: "Docs", href: "/docs")
/// |> breadcrumb.crumb(label: "Components")
/// |> breadcrumb.build
/// ```
///
/// See also:
/// - DaisyUI breadcrumbs docs: https://daisyui.com/components/breadcrumbs/
pub fn new() -> Breadcrumb(msg) {
  Breadcrumb(items: [], styles: [], attrs: [])
}

/// Plain text crumb — current page (not a link).
pub fn crumb(
  breadcrumb: Breadcrumb(msg),
  label label: String,
) -> Breadcrumb(msg) {
  Breadcrumb(..breadcrumb, items: list.append(breadcrumb.items, [Crumb(label)]))
}

/// Linked crumb — renders as `<a href>`.
pub fn crumb_link(
  breadcrumb: Breadcrumb(msg),
  label label: String,
  href href: String,
) -> Breadcrumb(msg) {
  Breadcrumb(
    ..breadcrumb,
    items: list.append(breadcrumb.items, [CrumbLink(label, href)]),
  )
}

/// Crumb with a leading icon element.
pub fn crumb_icon(
  breadcrumb: Breadcrumb(msg),
  label label: String,
  icon icon: Element(msg),
) -> Breadcrumb(msg) {
  Breadcrumb(
    ..breadcrumb,
    items: list.append(breadcrumb.items, [CrumbIcon(label, icon)]),
  )
}

/// Appends Tailwind utility styles.
pub fn style(
  breadcrumb: Breadcrumb(msg),
  styles styles: List(Style),
) -> Breadcrumb(msg) {
  Breadcrumb(..breadcrumb, styles: list.append(breadcrumb.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  breadcrumb: Breadcrumb(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Breadcrumb(msg) {
  Breadcrumb(..breadcrumb, attrs: list.append(breadcrumb.attrs, attributes))
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

pub fn build(breadcrumb: Breadcrumb(msg)) -> Element(msg) {
  let cls = case style.to_class_string(breadcrumb.styles) {
    "" -> "breadcrumbs"
    s -> "breadcrumbs " <> s
  }
  html.div([attribute.class(cls), ..breadcrumb.attrs], [
    html.ul([], list.map(breadcrumb.items, item_el)),
  ])
}
