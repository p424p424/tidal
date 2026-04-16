/// Divider element — renders a DaisyUI `divider` with an optional label.
///
/// Horizontal by default; call `vertical()` for a vertical divider inside a
/// flex row.
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
/// |> divider.build
///
/// // Vertical divider inside a row
/// divider.new()
/// |> divider.vertical()
/// |> divider.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Divider(msg) {
  Divider(
    label: Option(String),
    vertical: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Divider(msg) {
  Divider(label: None, vertical: False, styles: [], attrs: [])
}

/// Adds a text label centred in the divider line.
pub fn label(d: Divider(msg), text: String) -> Divider(msg) {
  Divider(..d, label: Some(text))
}

/// Switches to a vertical divider (adds `divider-horizontal`).
pub fn vertical(d: Divider(msg)) -> Divider(msg) {
  Divider(..d, vertical: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(d: Divider(msg), s: List(Style)) -> Divider(msg) {
  Divider(..d, styles: list.append(d.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  d: Divider(msg),
  a: List(attribute.Attribute(msg)),
) -> Divider(msg) {
  Divider(..d, attrs: list.append(d.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(d: Divider(msg)) -> Element(msg) {
  let base = case d.vertical {
    True -> "divider divider-horizontal"
    False -> "divider"
  }
  let cls = case style.to_class_string(d.styles) {
    "" -> base
    s -> base <> " " <> s
  }
  let content = case d.label {
    None -> []
    Some(t) -> [element.text(t)]
  }
  html.div([attribute.class(cls), ..d.attrs], content)
}
