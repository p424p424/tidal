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
/// |> divider.label(text: "OR")
/// |> divider.primary
/// |> divider.build
///
/// // Vertical divider inside a row
/// divider.new()
/// |> divider.horizontal
/// |> divider.build
/// ```
///
/// See also:
/// - DaisyUI divider docs: https://daisyui.com/components/divider/
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

/// Creates a new `Divider` — default is a horizontal line (full-width rule).
///
/// Chain builder functions to configure the divider, then call `build`:
///
/// ```gleam
/// import tidal/divider
///
/// divider.new()
/// |> divider.label(text: "OR")
/// |> divider.primary
/// |> divider.build
/// ```
///
/// See also:
/// - DaisyUI divider docs: https://daisyui.com/components/divider/
pub fn new() -> Divider(msg) {
  Divider(
    label: None,
    horizontal: False,
    color: None,
    align: None,
    styles: [],
    attrs: [],
  )
}

/// Adds a text label centred in the divider line.
pub fn label(divider: Divider(msg), text text: String) -> Divider(msg) {
  Divider(..divider, label: Some(text))
}

/// Switches to a vertical divider (for use inside a horizontal flex row) — adds `divider-horizontal`.
pub fn horizontal(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, horizontal: True)
}

pub fn primary(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, color: Some("divider-primary"))
}

pub fn secondary(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, color: Some("divider-secondary"))
}

pub fn accent(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, color: Some("divider-accent"))
}

pub fn neutral(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, color: Some("divider-neutral"))
}

pub fn info(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, color: Some("divider-info"))
}

pub fn success(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, color: Some("divider-success"))
}

pub fn warning(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, color: Some("divider-warning"))
}

pub fn error(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, color: Some("divider-error"))
}

/// Positions the label text at the start of the divider.
pub fn align_start(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, align: Some("divider-start"))
}

/// Positions the label text at the end of the divider.
pub fn align_end(divider: Divider(msg)) -> Divider(msg) {
  Divider(..divider, align: Some("divider-end"))
}

/// Appends Tailwind utility styles.
pub fn style(divider: Divider(msg), styles styles: List(Style)) -> Divider(msg) {
  Divider(..divider, styles: list.append(divider.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  divider: Divider(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Divider(msg) {
  Divider(..divider, attrs: list.append(divider.attrs, attributes))
}

pub fn build(divider: Divider(msg)) -> Element(msg) {
  let classes =
    [
      Some("divider"),
      case divider.horizontal {
        True -> Some("divider-horizontal")
        False -> None
      },
      divider.color,
      divider.align,
      case style.to_class_string(divider.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let content = case divider.label {
    None -> []
    Some(t) -> [element.text(t)]
  }
  html.div([attribute.class(classes), ..divider.attrs], content)
}
