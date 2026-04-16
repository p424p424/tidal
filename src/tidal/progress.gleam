/// Progress bar — `<progress class="progress">`.
///
/// ```gleam
/// import tidal/progress
///
/// progress.new()
/// |> progress.value(model.progress)
/// |> progress.max(100)
/// |> progress.primary
/// |> progress.build
/// ```
///
/// Omit `value` for an indeterminate (animated) progress bar.

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Progress(msg) {
  Progress(
    value: Option(Int),
    max: Int,
    color: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Progress(msg) {
  Progress(value: None, max: 100, color: None, styles: [], attrs: [])
}

/// Current progress value. Omit for an indeterminate bar.
pub fn value(p: Progress(msg), n: Int) -> Progress(msg) { Progress(..p, value: Some(n)) }

/// Maximum value. Defaults to 100.
pub fn max(p: Progress(msg), n: Int) -> Progress(msg) { Progress(..p, max: n) }

pub fn primary(p: Progress(msg)) -> Progress(msg) { Progress(..p, color: Some("progress-primary")) }
pub fn secondary(p: Progress(msg)) -> Progress(msg) { Progress(..p, color: Some("progress-secondary")) }
pub fn accent(p: Progress(msg)) -> Progress(msg) { Progress(..p, color: Some("progress-accent")) }
pub fn neutral(p: Progress(msg)) -> Progress(msg) { Progress(..p, color: Some("progress-neutral")) }
pub fn info(p: Progress(msg)) -> Progress(msg) { Progress(..p, color: Some("progress-info")) }
pub fn success(p: Progress(msg)) -> Progress(msg) { Progress(..p, color: Some("progress-success")) }
pub fn warning(p: Progress(msg)) -> Progress(msg) { Progress(..p, color: Some("progress-warning")) }
pub fn error(p: Progress(msg)) -> Progress(msg) { Progress(..p, color: Some("progress-error")) }

/// Appends Tailwind utility styles.
pub fn style(p: Progress(msg), s: List(Style)) -> Progress(msg) {
  Progress(..p, styles: list.append(p.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(p: Progress(msg), a: List(Attribute(msg))) -> Progress(msg) {
  Progress(..p, attrs: list.append(p.attrs, a))
}

pub fn build(p: Progress(msg)) -> Element(msg) {
  let classes =
    [
      Some("progress"),
      p.color,
      case style.to_class_string(p.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  let value_attrs = case p.value { None -> [] Some(v) -> [attribute.value(int.to_string(v))] }
  html.progress(
    [attribute.class(classes), attribute.max(int.to_string(p.max)), ..list.append(value_attrs, p.attrs)],
    [],
  )
}
