/// Badge — inline label/tag rendered as `<span class="badge">`.
///
/// ```gleam
/// import tidal/badge
/// import tidal/size
///
/// badge.new()
/// |> badge.label(text: "New")
/// |> badge.primary
/// |> badge.size(size: size.Sm)
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

/// Creates a new `Badge` builder with all options at their defaults.
///
/// Chain builder functions to configure the badge, then call `build`:
///
/// ```gleam
/// import tidal/badge
/// import tidal/size
///
/// badge.new()
/// |> badge.label(text: "New")
/// |> badge.primary
/// |> badge.size(size: size.Sm)
/// |> badge.build
/// ```
///
/// See also:
/// - DaisyUI badge docs: https://daisyui.com/components/badge/
pub fn new() -> Badge(msg) {
  Badge(
    label: "",
    color: None,
    style_variant: None,
    size: None,
    styles: [],
    attrs: [],
  )
}

/// Badge text content.
pub fn label(badge: Badge(msg), text text: String) -> Badge(msg) {
  Badge(..badge, label: text)
}

pub fn primary(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, color: Some("badge-primary"))
}

pub fn secondary(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, color: Some("badge-secondary"))
}

pub fn accent(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, color: Some("badge-accent"))
}

pub fn neutral(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, color: Some("badge-neutral"))
}

pub fn info(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, color: Some("badge-info"))
}

pub fn success(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, color: Some("badge-success"))
}

pub fn warning(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, color: Some("badge-warning"))
}

pub fn error(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, color: Some("badge-error"))
}

/// Outlined border, no fill.
pub fn outline(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, style_variant: Some("badge-outline"))
}

/// Dashed border.
pub fn dash(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, style_variant: Some("badge-dash"))
}

/// Soft/muted fill.
pub fn soft(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, style_variant: Some("badge-soft"))
}

/// Minimal ghost style.
pub fn ghost(badge: Badge(msg)) -> Badge(msg) {
  Badge(..badge, style_variant: Some("badge-ghost"))
}

/// Sets the badge size.
pub fn size(badge: Badge(msg), size size: Size) -> Badge(msg) {
  Badge(..badge, size: Some(size))
}

/// Appends Tailwind utility styles.
pub fn style(badge: Badge(msg), styles styles: List(Style)) -> Badge(msg) {
  Badge(..badge, styles: list.append(badge.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  badge: Badge(msg),
  attributes attributes: List(Attribute(msg)),
) -> Badge(msg) {
  Badge(..badge, attrs: list.append(badge.attrs, attributes))
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

pub fn build(badge: Badge(msg)) -> Element(msg) {
  let classes =
    [
      Some("badge"),
      badge.color,
      badge.style_variant,
      option.map(badge.size, size_class),
      case style.to_class_string(badge.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.span([attribute.class(classes), ..badge.attrs], [
    element.text(badge.label),
  ])
}
