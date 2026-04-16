/// Radio button component — renders as `<input type="radio">` with DaisyUI `radio` classes.
///
/// Group multiple radio buttons with the same `name` to make them mutually exclusive.
///
/// ```gleam
/// import tidal/radio
/// import tidal/variant
///
/// radio.new()
/// |> radio.name("theme")
/// |> radio.value("dark")
/// |> radio.variant(variant.Primary)
/// |> radio.on_check(fn(_) { UserSelectedDark })
/// |> radio.build
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

pub opaque type Radio(msg) {
  Radio(
    name: String,
    value: String,
    checked: Bool,
    variant: Option(Variant),
    size: Option(Size),
    disabled: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Radio(msg) {
  Radio(
    name: "",
    value: "",
    checked: False,
    variant: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the radio group name. All radios sharing a name are mutually exclusive.
pub fn name(r: Radio(msg), n: String) -> Radio(msg) {
  Radio(..r, name: n)
}

/// Sets the value submitted when this radio is selected.
pub fn value(r: Radio(msg), v: String) -> Radio(msg) {
  Radio(..r, value: v)
}

/// Marks this radio as the selected option.
pub fn checked(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, checked: True)
}

/// Sets the variant (colour role).
pub fn variant(r: Radio(msg), v: Variant) -> Radio(msg) {
  Radio(..r, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(r: Radio(msg), s: Size) -> Radio(msg) {
  Radio(..r, size: Some(s))
}

/// Marks the radio as disabled.
pub fn disabled(r: Radio(msg)) -> Radio(msg) {
  Radio(..r, disabled: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(r: Radio(msg), s: List(Style)) -> Radio(msg) {
  Radio(..r, styles: list.append(r.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(r: Radio(msg), a: List(attribute.Attribute(msg))) -> Radio(msg) {
  Radio(..r, attrs: list.append(r.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_check(r: Radio(msg), msg: fn(Bool) -> msg) -> Radio(msg) {
  Radio(..r, attrs: list.append(r.attrs, [event.on_check(msg)]))
}

pub fn on_focus(r: Radio(msg), msg: msg) -> Radio(msg) {
  Radio(..r, attrs: list.append(r.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(r: Radio(msg), msg: msg) -> Radio(msg) {
  Radio(..r, attrs: list.append(r.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "radio-primary"
    variant.Secondary -> "radio-secondary"
    variant.Accent -> "radio-accent"
    variant.Neutral -> "radio-neutral"
    variant.Info -> "radio-info"
    variant.Success -> "radio-success"
    variant.Warning -> "radio-warning"
    variant.Error -> "radio-error"
    variant.Ghost | variant.Link | variant.Outline -> ""
  }
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "radio-xs"
    size.Sm -> "radio-sm"
    size.Md -> ""
    size.Lg -> "radio-lg"
    size.Xl -> "radio-xl"
  }
}

pub fn build(r: Radio(msg)) -> Element(msg) {
  let classes =
    [
      Some("radio"),
      option.map(r.variant, variant_class),
      option.map(r.size, size_class),
      case style.to_class_string(r.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  html.input([
    attribute.class(classes),
    attribute.type_("radio"),
    attribute.name(r.name),
    attribute.value(r.value),
    attribute.checked(r.checked),
    attribute.disabled(r.disabled),
    ..r.attrs
  ])
}
