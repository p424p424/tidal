/// Alert component — renders a DaisyUI `alert` with an optional icon and actions.
///
/// ```gleam
/// import tidal/alert
/// import tidal/variant
///
/// alert.new()
/// |> alert.message("Your changes have been saved.")
/// |> alert.variant(variant.Success)
/// |> alert.build
/// ```
///
/// With an icon and action:
///
/// ```gleam
/// alert.new()
/// |> alert.message("Are you sure you want to delete this?")
/// |> alert.variant(variant.Warning)
/// |> alert.icon(warning_icon_el)
/// |> alert.actions([confirm_button, cancel_button])
/// |> alert.build
/// ```

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

pub opaque type Alert(msg) {
  Alert(
    message: String,
    variant: Option(Variant),
    icon: Option(Element(msg)),
    actions: List(Element(msg)),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Alert(msg) {
  Alert(
    message: "",
    variant: None,
    icon: None,
    actions: [],
    styles: [],
    attrs: [],
  )
}

/// Sets the alert message text.
pub fn message(a: Alert(msg), text: String) -> Alert(msg) {
  Alert(..a, message: text)
}

/// Sets the variant (colour role): `Info`, `Success`, `Warning`, or `Error`.
pub fn variant(a: Alert(msg), v: Variant) -> Alert(msg) {
  Alert(..a, variant: Some(v))
}

/// Adds an icon element displayed before the message.
pub fn icon(a: Alert(msg), el: Element(msg)) -> Alert(msg) {
  Alert(..a, icon: Some(el))
}

/// Adds action elements (e.g. buttons) displayed after the message.
/// May be called multiple times — actions accumulate.
pub fn actions(a: Alert(msg), els: List(Element(msg))) -> Alert(msg) {
  Alert(..a, actions: list.append(a.actions, els))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(a: Alert(msg), s: List(Style)) -> Alert(msg) {
  Alert(..a, styles: list.append(a.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(a: Alert(msg), at: List(attribute.Attribute(msg))) -> Alert(msg) {
  Alert(..a, attrs: list.append(a.attrs, at))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Info -> "alert-info"
    variant.Success -> "alert-success"
    variant.Warning -> "alert-warning"
    variant.Error -> "alert-error"
    variant.Primary -> "alert-primary"
    variant.Secondary -> "alert-secondary"
    variant.Accent -> "alert-accent"
    variant.Neutral | variant.Ghost | variant.Link | variant.Outline -> ""
  }
}

pub fn build(a: Alert(msg)) -> Element(msg) {
  let classes =
    [
      Some("alert"),
      option.map(a.variant, variant_class),
      case style.to_class_string(a.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let icon_els = case a.icon {
    None -> []
    Some(el) -> [el]
  }

  let action_els = case a.actions {
    [] -> []
    els -> [html.div([attribute.class("alert-actions")], els)]
  }

  html.div(
    [attribute.class(classes), attribute.attribute("role", "alert"), ..a.attrs],
    list.flatten([icon_els, [html.span([], [element.text(a.message)])], action_els]),
  )
}
