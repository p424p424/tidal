/// Radio button — `<input type="radio" class="radio">`.
///
/// Group multiple radio buttons with the same `name` to make them mutually exclusive.
///
/// ```gleam
/// import tidal/radio
///
/// radio.new()
/// |> radio.name(name: "plan")
/// |> radio.value(to: "pro")
/// |> radio.primary
/// |> radio.checked(to: model.plan == "pro")
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

/// Creates a new `Radio` builder with all options at their defaults.
///
/// Chain builder functions to configure the radio input, then call `build`.
/// Use the same `name` value across a group of radio buttons to make them
/// mutually exclusive:
///
/// ```gleam
/// import tidal/radio
///
/// radio.new()
/// |> radio.name(name: "plan")
/// |> radio.value(to: "pro")
/// |> radio.primary
/// |> radio.checked(to: model.plan == "pro")
/// |> radio.on_check(UserSelectedPlan)
/// |> radio.build
/// ```
///
/// See also:
/// - DaisyUI radio docs: https://daisyui.com/components/radio/
pub fn new() -> Radio(msg) {
  Radio(
    name: "",
    value: "",
    checked: False,
    color: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Radio group name — all radios sharing a name are mutually exclusive.
pub fn name(radio: Radio(msg), name name: String) -> Radio(msg) {
  Radio(..radio, name: name)
}

/// Value submitted when this radio is selected.
pub fn value(radio: Radio(msg), to val: String) -> Radio(msg) {
  Radio(..radio, value: val)
}

/// Sets the checked state (controlled).
pub fn checked(radio: Radio(msg), to is_checked: Bool) -> Radio(msg) {
  Radio(..radio, checked: is_checked)
}

pub fn primary(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, color: Some("radio-primary"))
}

pub fn secondary(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, color: Some("radio-secondary"))
}

pub fn accent(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, color: Some("radio-accent"))
}

pub fn neutral(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, color: Some("radio-neutral"))
}

pub fn info(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, color: Some("radio-info"))
}

pub fn success(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, color: Some("radio-success"))
}

pub fn warning(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, color: Some("radio-warning"))
}

pub fn error(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, color: Some("radio-error"))
}

/// Sets the radio size.
pub fn size(radio: Radio(msg), size size: Size) -> Radio(msg) {
  Radio(..radio, size: Some(size))
}

/// Marks the radio as disabled.
pub fn disabled(radio: Radio(msg)) -> Radio(msg) {
  Radio(..radio, disabled: True)
}

/// Appends Tailwind utility styles.
pub fn style(radio: Radio(msg), styles styles: List(Style)) -> Radio(msg) {
  Radio(..radio, styles: list.append(radio.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  radio: Radio(msg),
  attributes attributes: List(Attribute(msg)),
) -> Radio(msg) {
  Radio(..radio, attrs: list.append(radio.attrs, attributes))
}

pub fn on_check(
  radio: Radio(msg),
  handler handler: fn(Bool) -> msg,
) -> Radio(msg) {
  Radio(..radio, attrs: list.append(radio.attrs, [event.on_check(handler)]))
}

pub fn on_focus(radio: Radio(msg), msg: msg) -> Radio(msg) {
  Radio(..radio, attrs: list.append(radio.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(radio: Radio(msg), msg: msg) -> Radio(msg) {
  Radio(..radio, attrs: list.append(radio.attrs, [event.on_blur(msg)]))
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

pub fn build(radio: Radio(msg)) -> Element(msg) {
  let classes =
    [
      Some("radio"),
      radio.color,
      option.map(radio.size, size_class),
      case style.to_class_string(radio.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.input([
    attribute.class(classes),
    attribute.type_("radio"),
    attribute.name(radio.name),
    attribute.value(radio.value),
    attribute.checked(radio.checked),
    attribute.disabled(radio.disabled),
    ..radio.attrs
  ])
}
