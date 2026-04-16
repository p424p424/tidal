/// Badge component — renders as a `<span>` with DaisyUI `badge` classes.
///
/// ```gleam
/// import tidal/badge
/// import tidal/variant
/// import tidal/size
///
/// badge.new("New")
/// |> badge.variant(variant.Primary)
/// |> badge.size(size.Sm)
/// |> badge.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/size.{type Size}
import tidal/style.{type Style}
import tidal/variant.{type Variant}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Badge(msg) {
  Badge(
    content: String,
    variant: Option(Variant),
    size: Option(Size),
    outline: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new(content: String) -> Badge(msg) {
  Badge(
    content: content,
    variant: None,
    size: None,
    outline: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the variant (colour role).
pub fn variant(b: Badge(msg), v: Variant) -> Badge(msg) {
  Badge(..b, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(b: Badge(msg), s: Size) -> Badge(msg) {
  Badge(..b, size: Some(s))
}

/// Adds the `badge-outline` modifier.
pub fn outline(b: Badge(msg)) -> Badge(msg) {
  Badge(..b, outline: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(b: Badge(msg), s: List(Style)) -> Badge(msg) {
  Badge(..b, styles: list.append(b.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(b: Badge(msg), a: List(attribute.Attribute(msg))) -> Badge(msg) {
  Badge(..b, attrs: list.append(b.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "badge-primary"
    variant.Secondary -> "badge-secondary"
    variant.Accent -> "badge-accent"
    variant.Neutral -> "badge-neutral"
    variant.Ghost -> "badge-ghost"
    variant.Info -> "badge-info"
    variant.Success -> "badge-success"
    variant.Warning -> "badge-warning"
    variant.Error -> "badge-error"
    variant.Link | variant.Outline -> ""
  }
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
      option.map(b.variant, variant_class),
      option.map(b.size, size_class),
      case b.outline { True -> Some("badge-outline") False -> None },
      case style.to_class_string(b.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  html.span([attribute.class(classes), ..b.attrs], [element.text(b.content)])
}
