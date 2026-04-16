/// Loading indicator — `<span class="loading loading-spinner">`.
///
/// ```gleam
/// import tidal/loading
/// import tidal/size
///
/// loading.new()
/// |> loading.spinner
/// |> loading.primary
/// |> loading.size(size.Lg)
/// |> loading.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/size.{type Size}
import tidal/style.{type Style}

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
    color: Option(String),
    size: Option(Size),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Loading(msg) {
  Loading(style_: Spinner, color: None, size: None, styles: [], attrs: [])
}

/// Rotating spinner animation (default).
pub fn spinner(l: Loading(msg)) -> Loading(msg) { Loading(..l, style_: Spinner) }
/// Animated dots.
pub fn dots(l: Loading(msg)) -> Loading(msg) { Loading(..l, style_: Dots) }
/// Ring animation.
pub fn ring(l: Loading(msg)) -> Loading(msg) { Loading(..l, style_: Ring) }
/// Ball animation.
pub fn ball(l: Loading(msg)) -> Loading(msg) { Loading(..l, style_: Ball) }
/// Vertical bars animation.
pub fn bars(l: Loading(msg)) -> Loading(msg) { Loading(..l, style_: Bars) }
/// Infinity symbol animation.
pub fn infinity(l: Loading(msg)) -> Loading(msg) { Loading(..l, style_: Infinity) }

pub fn primary(l: Loading(msg)) -> Loading(msg) { Loading(..l, color: Some("text-primary")) }
pub fn secondary(l: Loading(msg)) -> Loading(msg) { Loading(..l, color: Some("text-secondary")) }
pub fn accent(l: Loading(msg)) -> Loading(msg) { Loading(..l, color: Some("text-accent")) }
pub fn neutral(l: Loading(msg)) -> Loading(msg) { Loading(..l, color: Some("text-neutral")) }
pub fn info(l: Loading(msg)) -> Loading(msg) { Loading(..l, color: Some("text-info")) }
pub fn success(l: Loading(msg)) -> Loading(msg) { Loading(..l, color: Some("text-success")) }
pub fn warning(l: Loading(msg)) -> Loading(msg) { Loading(..l, color: Some("text-warning")) }
pub fn error(l: Loading(msg)) -> Loading(msg) { Loading(..l, color: Some("text-error")) }

/// Sets the loading indicator size.
pub fn size(l: Loading(msg), s: Size) -> Loading(msg) { Loading(..l, size: Some(s)) }

/// Appends Tailwind utility styles.
pub fn style(l: Loading(msg), s: List(Style)) -> Loading(msg) {
  Loading(..l, styles: list.append(l.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(l: Loading(msg), a: List(Attribute(msg))) -> Loading(msg) {
  Loading(..l, attrs: list.append(l.attrs, a))
}

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
      l.color,
      option.map(l.size, size_class),
      case style.to_class_string(l.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.span([attribute.class(classes), ..l.attrs], [])
}
