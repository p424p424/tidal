/// Loading spinner component — renders a DaisyUI `loading` indicator.
///
/// ```gleam
/// import tidal/loading
/// import tidal/variant
/// import tidal/size
///
/// loading.new()
/// |> loading.spinner()
/// |> loading.variant(variant.Primary)
/// |> loading.size(size.Lg)
/// |> loading.build
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
// Types
// ---------------------------------------------------------------------------

pub type LoadingStyle {
  Spinner
  Dots
  Ring
  Ball
  Bars
  Infinity
}

pub opaque type Loading(msg) {
  Loading(
    style_: LoadingStyle,
    variant: Option(Variant),
    size: Option(Size),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Loading(msg) {
  Loading(style_: Spinner, variant: None, size: None, styles: [], attrs: [])
}

/// Sets the loading animation style to a spinner (default).
pub fn spinner(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style_: Spinner)
}

/// Sets the loading animation style to dots.
pub fn dots(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style_: Dots)
}

/// Sets the loading animation style to a ring.
pub fn ring(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style_: Ring)
}

/// Sets the loading animation style to a ball.
pub fn ball(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style_: Ball)
}

/// Sets the loading animation style to bars.
pub fn bars(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style_: Bars)
}

/// Sets the loading animation style to infinity.
pub fn infinity(l: Loading(msg)) -> Loading(msg) {
  Loading(..l, style_: Infinity)
}

/// Sets the variant (colour role).
pub fn variant(l: Loading(msg), v: Variant) -> Loading(msg) {
  Loading(..l, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(l: Loading(msg), s: Size) -> Loading(msg) {
  Loading(..l, size: Some(s))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(l: Loading(msg), s: List(Style)) -> Loading(msg) {
  Loading(..l, styles: list.append(l.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(l: Loading(msg), a: List(attribute.Attribute(msg))) -> Loading(msg) {
  Loading(..l, attrs: list.append(l.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn style_class(s: LoadingStyle) -> String {
  case s {
    Spinner -> "loading-spinner"
    Dots -> "loading-dots"
    Ring -> "loading-ring"
    Ball -> "loading-ball"
    Bars -> "loading-bars"
    Infinity -> "loading-infinity"
  }
}

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "text-primary"
    variant.Secondary -> "text-secondary"
    variant.Accent -> "text-accent"
    variant.Neutral -> "text-neutral"
    variant.Info -> "text-info"
    variant.Success -> "text-success"
    variant.Warning -> "text-warning"
    variant.Error -> "text-error"
    variant.Ghost | variant.Link | variant.Outline -> ""
  }
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "loading-xs"
    size.Sm -> "loading-sm"
    size.Md -> ""
    size.Lg -> "loading-lg"
    size.Xl -> "loading-xl"
  }
}

pub fn build(l: Loading(msg)) -> Element(msg) {
  let classes =
    [
      Some("loading"),
      Some(style_class(l.style_)),
      option.map(l.variant, variant_class),
      option.map(l.size, size_class),
      case style.to_class_string(l.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  html.span([attribute.class(classes), ..l.attrs], [])
}
