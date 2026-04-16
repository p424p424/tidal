/// Radial Progress — circular progress indicator using CSS custom properties.
///
/// ```gleam
/// import tidal/radial_progress
/// import tidal/size
///
/// radial_progress.new(75)
/// |> radial_progress.size(size.Lg)
/// |> radial_progress.thickness(4)
/// |> radial_progress.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/size.{type Size}
import tidal/style.{type Style, to_class_string}

pub opaque type RadialProgress(msg) {
  RadialProgress(
    value: Int,
    size: Option(String),
    thickness: Option(Int),
    label: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new(value: Int) -> RadialProgress(msg) {
  RadialProgress(
    value: value,
    size: None,
    thickness: None,
    label: None,
    styles: [],
    attrs: [],
  )
}

pub fn size(r: RadialProgress(msg), s: Size) -> RadialProgress(msg) {
  let cls = case s {
    size.Xs -> Some("radial-progress-xs")
    size.Sm -> Some("radial-progress-sm")
    size.Md -> Some("radial-progress-md")
    size.Lg -> Some("radial-progress-lg")
    size.Xl -> Some("radial-progress-xl")
  }
  RadialProgress(..r, size: cls)
}

/// Thickness of the progress ring in rem units (e.g. `4` → `4px`).
pub fn thickness(r: RadialProgress(msg), t: Int) -> RadialProgress(msg) {
  RadialProgress(..r, thickness: Some(t))
}

/// Text shown inside the circle. Defaults to the percentage value.
pub fn label(r: RadialProgress(msg), text: String) -> RadialProgress(msg) {
  RadialProgress(..r, label: Some(text))
}

pub fn style(r: RadialProgress(msg), s: List(Style)) -> RadialProgress(msg) {
  RadialProgress(..r, styles: list.append(r.styles, s))
}

pub fn attrs(r: RadialProgress(msg), a: List(Attribute(msg))) -> RadialProgress(msg) {
  RadialProgress(..r, attrs: list.append(r.attrs, a))
}

pub fn build(r: RadialProgress(msg)) -> Element(msg) {
  let base =
    [Some("radial-progress"), r.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(r.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }

  let style_parts =
    ["--value:" <> int.to_string(r.value)]
    |> fn(parts) {
      case r.thickness {
        None -> parts
        Some(t) -> list.append(parts, ["--thickness:" <> int.to_string(t) <> "px"])
      }
    }
  let style_val = string.join(style_parts, ";")
  let inner = case r.label {
    None -> int.to_string(r.value) <> "%"
    Some(t) -> t
  }
  html.div(
    [
      attribute.class(class),
      attribute.attribute("role", "progressbar"),
      attribute.attribute("style", style_val),
      ..r.attrs
    ],
    [html.text(inner)],
  )
}
