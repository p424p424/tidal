/// Progress bar — `<progress class="progress">`.
///
/// ```gleam
/// import tidal/progress
///
/// progress.new()
/// |> progress.value(to: model.progress)
/// |> progress.max(to: 100)
/// |> progress.primary
/// |> progress.build
/// ```
///
/// Omit `value` for an indeterminate (animated) progress bar.
///
/// See also:
/// - DaisyUI progress docs: https://daisyui.com/components/progress/
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

/// Creates a new `Progress` builder with all options at their defaults.
///
/// Chain builder functions to configure the progress bar, then call `build`:
///
/// ```gleam
/// import tidal/progress
///
/// progress.new()
/// |> progress.value(to: model.progress)
/// |> progress.max(to: 100)
/// |> progress.primary
/// |> progress.build
/// ```
///
/// Omit `value` for an indeterminate (animated) bar.
///
/// See also:
/// - DaisyUI progress docs: https://daisyui.com/components/progress/
pub fn new() -> Progress(msg) {
  Progress(value: None, max: 100, color: None, styles: [], attrs: [])
}

/// Current progress value. Omit for an indeterminate bar.
pub fn value(progress: Progress(msg), to amount: Int) -> Progress(msg) {
  Progress(..progress, value: Some(amount))
}

/// Maximum value. Defaults to 100.
pub fn max(progress: Progress(msg), to maximum: Int) -> Progress(msg) {
  Progress(..progress, max: maximum)
}

pub fn primary(progress: Progress(msg)) -> Progress(msg) {
  Progress(..progress, color: Some("progress-primary"))
}

pub fn secondary(progress: Progress(msg)) -> Progress(msg) {
  Progress(..progress, color: Some("progress-secondary"))
}

pub fn accent(progress: Progress(msg)) -> Progress(msg) {
  Progress(..progress, color: Some("progress-accent"))
}

pub fn neutral(progress: Progress(msg)) -> Progress(msg) {
  Progress(..progress, color: Some("progress-neutral"))
}

pub fn info(progress: Progress(msg)) -> Progress(msg) {
  Progress(..progress, color: Some("progress-info"))
}

pub fn success(progress: Progress(msg)) -> Progress(msg) {
  Progress(..progress, color: Some("progress-success"))
}

pub fn warning(progress: Progress(msg)) -> Progress(msg) {
  Progress(..progress, color: Some("progress-warning"))
}

pub fn error(progress: Progress(msg)) -> Progress(msg) {
  Progress(..progress, color: Some("progress-error"))
}

/// Appends Tailwind utility styles.
pub fn style(
  progress: Progress(msg),
  styles styles: List(Style),
) -> Progress(msg) {
  Progress(..progress, styles: list.append(progress.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  progress: Progress(msg),
  attributes attributes: List(Attribute(msg)),
) -> Progress(msg) {
  Progress(..progress, attrs: list.append(progress.attrs, attributes))
}

pub fn build(progress: Progress(msg)) -> Element(msg) {
  let classes =
    [
      Some("progress"),
      progress.color,
      case style.to_class_string(progress.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  let value_attrs = case progress.value {
    None -> []
    Some(v) -> [attribute.value(int.to_string(v))]
  }
  html.progress(
    [
      attribute.class(classes),
      attribute.max(int.to_string(progress.max)),
      ..list.append(value_attrs, progress.attrs)
    ],
    [],
  )
}
