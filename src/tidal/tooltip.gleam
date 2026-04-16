/// Tooltip component — wraps any element with a DaisyUI `tooltip`.
///
/// ```gleam
/// import tidal/tooltip
/// import tidal/button
/// import tidal/variant
///
/// tooltip.new(button.new("Save") |> button.variant(variant.Primary) |> button.build)
/// |> tooltip.text("Save your changes")
/// |> tooltip.position(tooltip.Top)
/// |> tooltip.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}
import tidal/variant.{type Variant}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub type Position {
  Top
  Bottom
  Left
  Right
}

pub opaque type Tooltip(msg) {
  Tooltip(
    child: Element(msg),
    text: String,
    position: Option(Position),
    variant: Option(Variant),
    open: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

/// Creates a new tooltip wrapping the given child element.
pub fn new(child: Element(msg)) -> Tooltip(msg) {
  Tooltip(
    child: child,
    text: "",
    position: None,
    variant: None,
    open: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the tooltip text shown on hover.
pub fn text(t: Tooltip(msg), tip: String) -> Tooltip(msg) {
  Tooltip(..t, text: tip)
}

/// Sets the tooltip position relative to the child. Defaults to `Top`.
pub fn position(t: Tooltip(msg), p: Position) -> Tooltip(msg) {
  Tooltip(..t, position: Some(p))
}

/// Sets the tooltip colour role.
pub fn variant(t: Tooltip(msg), v: Variant) -> Tooltip(msg) {
  Tooltip(..t, variant: Some(v))
}

/// Forces the tooltip open (useful for demos or testing).
pub fn open(t: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..t, open: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(t: Tooltip(msg), s: List(Style)) -> Tooltip(msg) {
  Tooltip(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(t: Tooltip(msg), a: List(attribute.Attribute(msg))) -> Tooltip(msg) {
  Tooltip(..t, attrs: list.append(t.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn position_class(p: Position) -> String {
  case p {
    Top -> "tooltip-top"
    Bottom -> "tooltip-bottom"
    Left -> "tooltip-left"
    Right -> "tooltip-right"
  }
}

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "tooltip-primary"
    variant.Secondary -> "tooltip-secondary"
    variant.Accent -> "tooltip-accent"
    variant.Info -> "tooltip-info"
    variant.Success -> "tooltip-success"
    variant.Warning -> "tooltip-warning"
    variant.Error -> "tooltip-error"
    variant.Neutral | variant.Ghost | variant.Link | variant.Outline -> ""
  }
}

pub fn build(t: Tooltip(msg)) -> Element(msg) {
  let classes =
    [
      Some("tooltip"),
      option.map(t.position, position_class),
      option.map(t.variant, variant_class),
      case t.open { True -> Some("tooltip-open") False -> None },
      case style.to_class_string(t.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  html.div(
    [
      attribute.class(classes),
      attribute.attribute("data-tip", t.text),
      ..t.attrs
    ],
    [t.child],
  )
}
