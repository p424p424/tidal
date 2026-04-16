/// Select component — renders as a `<select>` with DaisyUI `select` classes.
///
/// Options are provided as `(value, label)` pairs. An optional placeholder
/// renders as a disabled first option.
///
/// ```gleam
/// import tidal/select
/// import tidal/variant
///
/// select.new()
/// |> select.placeholder("Pick a colour")
/// |> select.options([#("red", "Red"), #("green", "Green"), #("blue", "Blue")])
/// |> select.variant(variant.Primary)
/// |> select.on_change(UserPickedColour)
/// |> select.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}
import tidal/variant.{type Variant}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Select(msg) {
  Select(
    options: List(#(String, String)),
    placeholder: Option(String),
    value: Option(String),
    variant: Option(Variant),
    size: Option(Size),
    disabled: Bool,
    required: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Select(msg) {
  Select(
    options: [],
    placeholder: None,
    value: None,
    variant: None,
    size: None,
    disabled: False,
    required: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the list of `(value, label)` option pairs.
pub fn options(s: Select(msg), opts: List(#(String, String))) -> Select(msg) {
  Select(..s, options: opts)
}

/// Adds a disabled placeholder option shown when no value is selected.
pub fn placeholder(s: Select(msg), text: String) -> Select(msg) {
  Select(..s, placeholder: Some(text))
}

/// Sets the currently selected value.
pub fn value(s: Select(msg), v: String) -> Select(msg) {
  Select(..s, value: Some(v))
}

/// Sets the variant (colour role).
pub fn variant(s: Select(msg), v: Variant) -> Select(msg) {
  Select(..s, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(s: Select(msg), sz: Size) -> Select(msg) {
  Select(..s, size: Some(sz))
}

/// Marks the select as disabled.
pub fn disabled(s: Select(msg)) -> Select(msg) {
  Select(..s, disabled: True)
}

/// Marks the select as required.
pub fn required(s: Select(msg)) -> Select(msg) {
  Select(..s, required: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(s: Select(msg), st: List(Style)) -> Select(msg) {
  Select(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(s: Select(msg), a: List(attribute.Attribute(msg))) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_change(s: Select(msg), msg: fn(String) -> msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_change(msg)]))
}

pub fn on_focus(s: Select(msg), msg: msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(s: Select(msg), msg: msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "select-primary"
    variant.Secondary -> "select-secondary"
    variant.Accent -> "select-accent"
    variant.Neutral -> "select-neutral"
    variant.Ghost -> "select-ghost"
    variant.Info -> "select-info"
    variant.Success -> "select-success"
    variant.Warning -> "select-warning"
    variant.Error -> "select-error"
    variant.Link | variant.Outline -> ""
  }
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "select-xs"
    size.Sm -> "select-sm"
    size.Md -> ""
    size.Lg -> "select-lg"
    size.Xl -> "select-xl"
  }
}

fn option_el(
  selected_value: Option(String),
  pair: #(String, String),
) -> Element(msg) {
  let #(val, label) = pair
  let is_selected = case selected_value {
    Some(v) -> v == val
    None -> False
  }
  html.option([attribute.value(val), attribute.selected(is_selected)], label)
}

pub fn build(s: Select(msg)) -> Element(msg) {
  let classes =
    [
      Some("select"),
      option.map(s.variant, variant_class),
      option.map(s.size, size_class),
      case style.to_class_string(s.styles) {
        "" -> None
        st -> Some(st)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let placeholder_el = case s.placeholder {
    None -> []
    Some(text) -> [
      html.option([attribute.disabled(True), attribute.selected(True)], text),
    ]
  }

  let option_els = list.map(s.options, option_el(s.value, _))

  html.select(
    [
      attribute.class(classes),
      attribute.disabled(s.disabled),
      attribute.required(s.required),
      ..s.attrs
    ],
    list.append(placeholder_el, option_els),
  )
}
