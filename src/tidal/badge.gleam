/// Badge — inline label/tag rendered as `<span class="badge">`.
///
/// ```gleam
/// import tidal/badge
/// import tidal/size
///
/// badge.new()
/// |> badge.label("New")
/// |> badge.primary
/// |> badge.size(size.Sm)
/// |> badge.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/size.{type Size}
import tidal/style.{type Style}

pub opaque type Badge(msg) {
  Badge(
    label: String,
    color: Option(String),
    style_variant: Option(String),
    size: Option(Size),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Badge(msg) {
  Badge(label: "", color: None, style_variant: None, size: None, styles: [], attrs: [])
}

/// Badge text content.
pub fn label(b: Badge(msg), t: String) -> Badge(msg) { Badge(..b, label: t) }

pub fn primary(b: Badge(msg)) -> Badge(msg) { Badge(..b, color: Some("badge-primary")) }
pub fn secondary(b: Badge(msg)) -> Badge(msg) { Badge(..b, color: Some("badge-secondary")) }
pub fn accent(b: Badge(msg)) -> Badge(msg) { Badge(..b, color: Some("badge-accent")) }
pub fn neutral(b: Badge(msg)) -> Badge(msg) { Badge(..b, color: Some("badge-neutral")) }
pub fn info(b: Badge(msg)) -> Badge(msg) { Badge(..b, color: Some("badge-info")) }
pub fn success(b: Badge(msg)) -> Badge(msg) { Badge(..b, color: Some("badge-success")) }
pub fn warning(b: Badge(msg)) -> Badge(msg) { Badge(..b, color: Some("badge-warning")) }
pub fn error(b: Badge(msg)) -> Badge(msg) { Badge(..b, color: Some("badge-error")) }

/// Outlined border, no fill.
pub fn outline(b: Badge(msg)) -> Badge(msg) { Badge(..b, style_variant: Some("badge-outline")) }
/// Dashed border.
pub fn dash(b: Badge(msg)) -> Badge(msg) { Badge(..b, style_variant: Some("badge-dash")) }
/// Soft/muted fill.
pub fn soft(b: Badge(msg)) -> Badge(msg) { Badge(..b, style_variant: Some("badge-soft")) }
/// Minimal ghost style.
pub fn ghost(b: Badge(msg)) -> Badge(msg) { Badge(..b, style_variant: Some("badge-ghost")) }

/// Sets the badge size.
pub fn size(b: Badge(msg), s: Size) -> Badge(msg) { Badge(..b, size: Some(s)) }

/// Appends Tailwind utility styles.
pub fn style(b: Badge(msg), s: List(Style)) -> Badge(msg) {
  Badge(..b, styles: list.append(b.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(b: Badge(msg), a: List(Attribute(msg))) -> Badge(msg) {
  Badge(..b, attrs: list.append(b.attrs, a))
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "badge-xs"
    size.Sm -> "badge-sm"
    size.Md -> ""
    size.Lg -> "badge-lg"
    size.Xl -> "badge-xl"
  }
}

pub fn build(b: Badge(msg)) -> Element(msg) {
  let classes =
    [
      Some("badge"),
      b.color,
      b.style_variant,
      option.map(b.size, size_class),
      case style.to_class_string(b.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.span([attribute.class(classes), ..b.attrs], [element.text(b.label)])
}
