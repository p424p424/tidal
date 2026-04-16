/// Radio button — `<input type="radio" class="radio">`.
///
/// Group multiple radio buttons with the same `name` to make them mutually exclusive.
///
/// ```gleam
/// import tidal/radio
///
/// radio.new()
/// |> radio.name("plan")
/// |> radio.value("pro")
/// |> radio.primary
/// |> radio.checked(model.plan == "pro")
/// |> radio.on_check(UserSelectedPlan)
/// |> radio.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

pub opaque type Radio(msg) {
  Radio(
    name: String,
    value: String,
    checked: Bool,
    color: Option(String),
    size: Option(Size),
    disabled: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Radio(msg) {
  Radio(name: "", value: "", checked: False, color: None, size: None, disabled: False, styles: [], attrs: [])
}

/// Radio group name — all radios sharing a name are mutually exclusive.
pub fn name(r: Radio(msg), n: String) -> Radio(msg) { Radio(..r, name: n) }

/// Value submitted when this radio is selected.
pub fn value(r: Radio(msg), v: String) -> Radio(msg) { Radio(..r, value: v) }

/// Sets the checked state (controlled).
pub fn checked(r: Radio(msg), b: Bool) -> Radio(msg) { Radio(..r, checked: b) }

pub fn primary(r: Radio(msg)) -> Radio(msg) { Radio(..r, color: Some("radio-primary")) }
pub fn secondary(r: Radio(msg)) -> Radio(msg) { Radio(..r, color: Some("radio-secondary")) }
pub fn accent(r: Radio(msg)) -> Radio(msg) { Radio(..r, color: Some("radio-accent")) }
pub fn neutral(r: Radio(msg)) -> Radio(msg) { Radio(..r, color: Some("radio-neutral")) }
pub fn info(r: Radio(msg)) -> Radio(msg) { Radio(..r, color: Some("radio-info")) }
pub fn success(r: Radio(msg)) -> Radio(msg) { Radio(..r, color: Some("radio-success")) }
pub fn warning(r: Radio(msg)) -> Radio(msg) { Radio(..r, color: Some("radio-warning")) }
pub fn error(r: Radio(msg)) -> Radio(msg) { Radio(..r, color: Some("radio-error")) }

/// Sets the radio size.
pub fn size(r: Radio(msg), s: Size) -> Radio(msg) { Radio(..r, size: Some(s)) }

/// Marks the radio as disabled.
pub fn disabled(r: Radio(msg)) -> Radio(msg) { Radio(..r, disabled: True) }

/// Appends Tailwind utility styles.
pub fn style(r: Radio(msg), s: List(Style)) -> Radio(msg) {
  Radio(..r, styles: list.append(r.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(r: Radio(msg), a: List(Attribute(msg))) -> Radio(msg) {
  Radio(..r, attrs: list.append(r.attrs, a))
}

pub fn on_check(r: Radio(msg), f: fn(Bool) -> msg) -> Radio(msg) {
  Radio(..r, attrs: list.append(r.attrs, [event.on_check(f)]))
}
pub fn on_focus(r: Radio(msg), msg: msg) -> Radio(msg) {
  Radio(..r, attrs: list.append(r.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(r: Radio(msg), msg: msg) -> Radio(msg) {
  Radio(..r, attrs: list.append(r.attrs, [event.on_blur(msg)]))
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
      r.color,
      option.map(r.size, size_class),
      case style.to_class_string(r.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
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
