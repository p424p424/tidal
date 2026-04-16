/// Radial progress — circular progress indicator.
///
/// Uses CSS custom properties (`--value`, `--size`, `--thickness`).
///
/// ```gleam
/// import tidal/radial_progress
///
/// radial_progress.new()
/// |> radial_progress.value(75)
/// |> radial_progress.primary
/// |> radial_progress.label("75%")
/// |> radial_progress.build
/// ```

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

pub fn new() -> RadialProgress(msg) {
  RadialProgress(value: 0, size: None, thickness: None, label: None, color: None, styles: [], attrs: [])
}

/// Progress percentage 0–100.
pub fn value(r: RadialProgress(msg), n: Int) -> RadialProgress(msg) {
  RadialProgress(..r, value: n)
}

/// Diameter in rem units (e.g. `5.0` = 5rem). Default is 5rem.
pub fn size_rem(r: RadialProgress(msg), rem: String) -> RadialProgress(msg) {
  RadialProgress(..r, size: Some(rem))
}

/// Stroke width in pixels. Default is 10% of size.
pub fn thickness(r: RadialProgress(msg), px: Int) -> RadialProgress(msg) {
  RadialProgress(..r, thickness: Some(px))
}

/// Text shown inside the circle.
pub fn label(r: RadialProgress(msg), text: String) -> RadialProgress(msg) {
  RadialProgress(..r, label: Some(text))
}

pub fn primary(r: RadialProgress(msg)) -> RadialProgress(msg) { RadialProgress(..r, color: Some("text-primary")) }
pub fn secondary(r: RadialProgress(msg)) -> RadialProgress(msg) { RadialProgress(..r, color: Some("text-secondary")) }
pub fn accent(r: RadialProgress(msg)) -> RadialProgress(msg) { RadialProgress(..r, color: Some("text-accent")) }
pub fn neutral(r: RadialProgress(msg)) -> RadialProgress(msg) { RadialProgress(..r, color: Some("text-neutral")) }
pub fn info(r: RadialProgress(msg)) -> RadialProgress(msg) { RadialProgress(..r, color: Some("text-info")) }
pub fn success(r: RadialProgress(msg)) -> RadialProgress(msg) { RadialProgress(..r, color: Some("text-success")) }
pub fn warning(r: RadialProgress(msg)) -> RadialProgress(msg) { RadialProgress(..r, color: Some("text-warning")) }
pub fn error(r: RadialProgress(msg)) -> RadialProgress(msg) { RadialProgress(..r, color: Some("text-error")) }

/// Appends Tailwind utility styles.
pub fn style(r: RadialProgress(msg), s: List(Style)) -> RadialProgress(msg) {
  RadialProgress(..r, styles: list.append(r.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(r: RadialProgress(msg), a: List(Attribute(msg))) -> RadialProgress(msg) {
  RadialProgress(..r, attrs: list.append(r.attrs, a))
}

pub fn build(r: RadialProgress(msg)) -> Element(msg) {
  let base_cls = case r.color {
    None -> "radial-progress"
    Some(c) -> "radial-progress " <> c
  }
  let classes = case style.to_class_string(r.styles) {
    "" -> base_cls
    extra -> base_cls <> " " <> extra
  }

  let style_parts =
    ["--value:" <> int.to_string(r.value)]
    |> fn(parts) {
      case r.size {
        None -> parts
        Some(rem) -> list.append(parts, ["--size:" <> rem <> "rem"])
      }
    }
    |> fn(parts) {
      case r.thickness {
        None -> parts
        Some(t) -> list.append(parts, ["--thickness:" <> int.to_string(t) <> "px"])
      }
    }
  let style_val = string.join(style_parts, ";")
  let inner = case r.label { None -> int.to_string(r.value) <> "%" Some(t) -> t }
  html.div(
    [
      attribute.class(classes),
      attribute.attribute("role", "progressbar"),
      attribute.attribute("style", style_val),
      ..r.attrs
    ],
    [html.text(inner)],
  )
}
