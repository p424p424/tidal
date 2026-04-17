/// Loading indicator — `<span class="loading loading-spinner">`.
///
/// ```gleam
/// import tidal/loading
/// import tidal/size
///
/// loading.new()
/// |> loading.spinner
/// |> loading.primary
/// |> loading.size(size: size.Lg)
/// |> loading.build
/// ```
///
/// See also:
/// - DaisyUI loading docs: https://daisyui.com/components/loading/
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

/// Creates a new `Loading` builder with spinner style by default.
///
/// Chain builder functions to configure the indicator, then call `build`:
///
/// ```gleam
/// import tidal/loading
/// import tidal/size
///
/// loading.new()
/// |> loading.spinner
/// |> loading.primary
/// |> loading.size(size: size.Lg)
/// |> loading.build
/// ```
///
/// See also:
/// - DaisyUI loading docs: https://daisyui.com/components/loading/
pub fn new() -> Loading(msg) {
  Loading(style_: Spinner, color: None, size: None, styles: [], attrs: [])
}

/// Rotating spinner animation (default).
pub fn spinner(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, style_: Spinner)
}

/// Animated dots.
pub fn dots(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, style_: Dots)
}

/// Ring animation.
pub fn ring(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, style_: Ring)
}

/// Ball animation.
pub fn ball(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, style_: Ball)
}

/// Vertical bars animation.
pub fn bars(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, style_: Bars)
}

/// Infinity symbol animation.
pub fn infinity(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, style_: Infinity)
}

pub fn primary(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, color: Some("text-primary"))
}

pub fn secondary(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, color: Some("text-secondary"))
}

pub fn accent(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, color: Some("text-accent"))
}

pub fn neutral(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, color: Some("text-neutral"))
}

pub fn info(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, color: Some("text-info"))
}

pub fn success(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, color: Some("text-success"))
}

pub fn warning(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, color: Some("text-warning"))
}

pub fn error(loading: Loading(msg)) -> Loading(msg) {
  Loading(..loading, color: Some("text-error"))
}

/// Sets the loading indicator size.
pub fn size(loading: Loading(msg), size size: Size) -> Loading(msg) {
  Loading(..loading, size: Some(size))
}

/// Appends Tailwind utility styles.
pub fn style(loading: Loading(msg), styles styles: List(Style)) -> Loading(msg) {
  Loading(..loading, styles: list.append(loading.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  loading: Loading(msg),
  attributes attributes: List(Attribute(msg)),
) -> Loading(msg) {
  Loading(..loading, attrs: list.append(loading.attrs, attributes))
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

pub fn build(loading: Loading(msg)) -> Element(msg) {
  let classes =
    [
      Some("loading"),
      Some(style_class(loading.style_)),
      loading.color,
      option.map(loading.size, size_class),
      case style.to_class_string(loading.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.span([attribute.class(classes), ..loading.attrs], [])
}
