/// Radial progress — circular progress indicator.
///
/// Uses CSS custom properties (`--value`, `--size`, `--thickness`).
///
/// ```gleam
/// import tidal/radial_progress
///
/// radial_progress.new()
/// |> radial_progress.value(to: 75)
/// |> radial_progress.primary
/// |> radial_progress.label(text: "75%")
/// |> radial_progress.build
/// ```
///
/// See also:
/// - DaisyUI radial progress docs: https://daisyui.com/components/radial-progress/
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type RadialProgress(msg) {
  RadialProgress(
    value: Int,
    size: Option(String),
    thickness: Option(Int),
    label: Option(String),
    color: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new `RadialProgress` — renders a circular progress ring.
///
/// Chain builder functions to configure it, then call `build`:
///
/// ```gleam
/// import tidal/radial_progress
///
/// radial_progress.new()
/// |> radial_progress.value(to: 75)
/// |> radial_progress.primary
/// |> radial_progress.label(text: "75%")
/// |> radial_progress.build
/// ```
///
/// See also:
/// - DaisyUI radial progress docs: https://daisyui.com/components/radial-progress/
pub fn new() -> RadialProgress(msg) {
  RadialProgress(
    value: 0,
    size: None,
    thickness: None,
    label: None,
    color: None,
    styles: [],
    attrs: [],
  )
}

/// Progress percentage 0–100.
pub fn value(radial: RadialProgress(msg), to amount: Int) -> RadialProgress(msg) {
  RadialProgress(..radial, value: amount)
}

/// Diameter in rem units (e.g. `"5"` = 5rem). Default is 5rem.
pub fn size_rem(
  radial: RadialProgress(msg),
  rem rem: String,
) -> RadialProgress(msg) {
  RadialProgress(..radial, size: Some(rem))
}

/// Stroke width in pixels. Default is 10% of size.
pub fn thickness(radial: RadialProgress(msg), px px: Int) -> RadialProgress(msg) {
  RadialProgress(..radial, thickness: Some(px))
}

/// Text shown inside the circle.
pub fn label(
  radial: RadialProgress(msg),
  text text: String,
) -> RadialProgress(msg) {
  RadialProgress(..radial, label: Some(text))
}

pub fn primary(radial: RadialProgress(msg)) -> RadialProgress(msg) {
  RadialProgress(..radial, color: Some("text-primary"))
}

pub fn secondary(radial: RadialProgress(msg)) -> RadialProgress(msg) {
  RadialProgress(..radial, color: Some("text-secondary"))
}

pub fn accent(radial: RadialProgress(msg)) -> RadialProgress(msg) {
  RadialProgress(..radial, color: Some("text-accent"))
}

pub fn neutral(radial: RadialProgress(msg)) -> RadialProgress(msg) {
  RadialProgress(..radial, color: Some("text-neutral"))
}

pub fn info(radial: RadialProgress(msg)) -> RadialProgress(msg) {
  RadialProgress(..radial, color: Some("text-info"))
}

pub fn success(radial: RadialProgress(msg)) -> RadialProgress(msg) {
  RadialProgress(..radial, color: Some("text-success"))
}

pub fn warning(radial: RadialProgress(msg)) -> RadialProgress(msg) {
  RadialProgress(..radial, color: Some("text-warning"))
}

pub fn error(radial: RadialProgress(msg)) -> RadialProgress(msg) {
  RadialProgress(..radial, color: Some("text-error"))
}

/// Appends Tailwind utility styles.
pub fn style(
  radial: RadialProgress(msg),
  styles styles: List(Style),
) -> RadialProgress(msg) {
  RadialProgress(..radial, styles: list.append(radial.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  radial: RadialProgress(msg),
  attributes attributes: List(Attribute(msg)),
) -> RadialProgress(msg) {
  RadialProgress(..radial, attrs: list.append(radial.attrs, attributes))
}

pub fn build(radial: RadialProgress(msg)) -> Element(msg) {
  let base_cls = case radial.color {
    None -> "radial-progress"
    Some(color) -> "radial-progress " <> color
  }
  let classes = case style.to_class_string(radial.styles) {
    "" -> base_cls
    extra -> base_cls <> " " <> extra
  }

  let style_parts =
    ["--value:" <> int.to_string(radial.value)]
    |> fn(parts) {
      case radial.size {
        None -> parts
        Some(rem) -> list.append(parts, ["--size:" <> rem <> "rem"])
      }
    }
    |> fn(parts) {
      case radial.thickness {
        None -> parts
        Some(px) ->
          list.append(parts, ["--thickness:" <> int.to_string(px) <> "px"])
      }
    }
  let style_val = string.join(style_parts, ";")
  let inner = case radial.label {
    None -> int.to_string(radial.value) <> "%"
    Some(text) -> text
  }
  html.div(
    [
      attribute.class(classes),
      attribute.attribute("role", "progressbar"),
      attribute.attribute("style", style_val),
      ..radial.attrs
    ],
    [html.text(inner)],
  )
}
