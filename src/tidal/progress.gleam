/// Progress bar component — renders a DaisyUI `progress` element.
///
/// ```gleam
/// import tidal/progress
/// import tidal/variant
///
/// progress.new()
/// |> progress.value(70)
/// |> progress.max(100)
/// |> progress.variant(variant.Primary)
/// |> progress.build
/// ```
///
/// Omitting `value` renders an indeterminate (animated) progress bar:
///
/// ```gleam
/// progress.new()
/// |> progress.variant(variant.Accent)
/// |> progress.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}
import tidal/variant.{type Variant}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Progress(msg) {
  Progress(
    value: Option(Int),
    max: Int,
    variant: Option(Variant),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Progress(msg) {
  Progress(value: None, max: 100, variant: None, styles: [], attrs: [])
}

/// Sets the current progress value. Omit for an indeterminate bar.
pub fn value(p: Progress(msg), n: Int) -> Progress(msg) {
  Progress(..p, value: Some(n))
}

/// Sets the maximum value. Defaults to 100.
pub fn max(p: Progress(msg), n: Int) -> Progress(msg) {
  Progress(..p, max: n)
}

/// Sets the variant (colour role).
pub fn variant(p: Progress(msg), v: Variant) -> Progress(msg) {
  Progress(..p, variant: Some(v))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(p: Progress(msg), s: List(Style)) -> Progress(msg) {
  Progress(..p, styles: list.append(p.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(p: Progress(msg), a: List(attribute.Attribute(msg))) -> Progress(msg) {
  Progress(..p, attrs: list.append(p.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "progress-primary"
    variant.Secondary -> "progress-secondary"
    variant.Accent -> "progress-accent"
    variant.Neutral -> "progress-neutral"
    variant.Info -> "progress-info"
    variant.Success -> "progress-success"
    variant.Warning -> "progress-warning"
    variant.Error -> "progress-error"
    variant.Ghost | variant.Link | variant.Outline -> ""
  }
}

pub fn build(p: Progress(msg)) -> Element(msg) {
  let classes =
    [
      Some("progress"),
      option.map(p.variant, variant_class),
      case style.to_class_string(p.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let value_attrs = case p.value {
    None -> []
    Some(v) -> [attribute.value(int.to_string(v))]
  }

  html.progress(
    [
      attribute.class(classes),
      attribute.max(int.to_string(p.max)),
      ..list.append(value_attrs, p.attrs)
    ],
    [],
  )
}
