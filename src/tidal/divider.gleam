/// Divider — horizontal or vertical rule with optional label.
///
/// ```gleam
/// import tidal/divider
///
/// // Plain horizontal rule
/// divider.new() |> divider.build
///
/// // Labelled section break
/// divider.new()
/// |> divider.label("OR")
/// |> divider.primary
/// |> divider.build
///
/// // Vertical divider inside a row
/// divider.new()
/// |> divider.horizontal
/// |> divider.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Divider(msg) {
  Divider(
    label: Option(String),
    horizontal: Bool,
    color: Option(String),
    align: Option(String),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

/// Create a new divider. Default is a horizontal line (vertical in the DOM sense — a full-width `<hr>`-style rule).
pub fn new() -> Divider(msg) {
  Divider(label: None, horizontal: False, color: None, align: None, styles: [], attrs: [])
}

/// Adds a text label centred in the divider line.
pub fn label(d: Divider(msg), text: String) -> Divider(msg) {
  Divider(..d, label: Some(text))
}

/// Switches to a vertical divider (for use inside a horizontal flex row) — adds `divider-horizontal`.
pub fn horizontal(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, horizontal: True)
}

pub fn primary(d: Divider(msg)) -> Divider(msg) { Divider(..d, color: Some("divider-primary")) }
pub fn secondary(d: Divider(msg)) -> Divider(msg) { Divider(..d, color: Some("divider-secondary")) }
pub fn accent(d: Divider(msg)) -> Divider(msg) { Divider(..d, color: Some("divider-accent")) }
pub fn neutral(d: Divider(msg)) -> Divider(msg) { Divider(..d, color: Some("divider-neutral")) }
pub fn info(d: Divider(msg)) -> Divider(msg) { Divider(..d, color: Some("divider-info")) }
pub fn success(d: Divider(msg)) -> Divider(msg) { Divider(..d, color: Some("divider-success")) }
pub fn warning(d: Divider(msg)) -> Divider(msg) { Divider(..d, color: Some("divider-warning")) }
pub fn error(d: Divider(msg)) -> Divider(msg) { Divider(..d, color: Some("divider-error")) }

/// Positions the label text at the start of the divider.
pub fn align_start(d: Divider(msg)) -> Divider(msg) { Divider(..d, align: Some("divider-start")) }
/// Positions the label text at the end of the divider.
pub fn align_end(d: Divider(msg)) -> Divider(msg) { Divider(..d, align: Some("divider-end")) }

/// Appends Tailwind utility styles.
pub fn style(d: Divider(msg), s: List(Style)) -> Divider(msg) {
  Divider(..d, styles: list.append(d.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(d: Divider(msg), a: List(attribute.Attribute(msg))) -> Divider(msg) {
  Divider(..d, attrs: list.append(d.attrs, a))
}

pub fn build(d: Divider(msg)) -> Element(msg) {
  let classes =
    [
      Some("divider"),
      case d.horizontal { True -> Some("divider-horizontal") False -> None },
      d.color,
      d.align,
      case style.to_class_string(d.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let content = case d.label {
    None -> []
    Some(t) -> [element.text(t)]
  }
  html.div([attribute.class(classes), ..d.attrs], content)
}
