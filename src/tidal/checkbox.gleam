/// Checkbox — `<input type="checkbox" class="checkbox">`.
///
/// ```gleam
/// import tidal/checkbox
///
/// checkbox.new()
/// |> checkbox.primary
/// |> checkbox.checked(to: model.agreed)
/// |> checkbox.on_check(UserToggledAgreement)
/// |> checkbox.build
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

pub opaque type Checkbox(msg) {
  Checkbox(
    checked: Bool,
    color: Option(String),
    size: Option(Size),
    disabled: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new `Checkbox` builder with all options at their defaults.
///
/// Chain builder functions to configure the checkbox, then call `build`:
///
/// ```gleam
/// import tidal/checkbox
///
/// checkbox.new()
/// |> checkbox.primary
/// |> checkbox.checked(to: model.agreed)
/// |> checkbox.on_check(UserToggledAgreement)
/// |> checkbox.build
/// ```
///
/// See also:
/// - DaisyUI checkbox docs: https://daisyui.com/components/checkbox/
pub fn new() -> Checkbox(msg) {
  Checkbox(
    checked: False,
    color: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the checked state (controlled).
pub fn checked(checkbox: Checkbox(msg), to is_checked: Bool) -> Checkbox(msg) {
  Checkbox(..checkbox, checked: is_checked)
}

pub fn primary(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, color: Some("checkbox-primary"))
}

pub fn secondary(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, color: Some("checkbox-secondary"))
}

pub fn accent(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, color: Some("checkbox-accent"))
}

pub fn neutral(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, color: Some("checkbox-neutral"))
}

pub fn info(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, color: Some("checkbox-info"))
}

pub fn success(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, color: Some("checkbox-success"))
}

pub fn warning(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, color: Some("checkbox-warning"))
}

pub fn error(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, color: Some("checkbox-error"))
}

/// Sets the checkbox size.
pub fn size(checkbox: Checkbox(msg), size size: Size) -> Checkbox(msg) {
  Checkbox(..checkbox, size: Some(size))
}

/// Marks the checkbox as disabled.
pub fn disabled(checkbox: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..checkbox, disabled: True)
}

/// Appends Tailwind utility styles.
pub fn style(
  checkbox: Checkbox(msg),
  styles styles: List(Style),
) -> Checkbox(msg) {
  Checkbox(..checkbox, styles: list.append(checkbox.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  checkbox: Checkbox(msg),
  attributes attributes: List(Attribute(msg)),
) -> Checkbox(msg) {
  Checkbox(..checkbox, attrs: list.append(checkbox.attrs, attributes))
}

pub fn on_check(
  checkbox: Checkbox(msg),
  handler handler: fn(Bool) -> msg,
) -> Checkbox(msg) {
  Checkbox(
    ..checkbox,
    attrs: list.append(checkbox.attrs, [event.on_check(handler)]),
  )
}

pub fn on_focus(checkbox: Checkbox(msg), msg: msg) -> Checkbox(msg) {
  Checkbox(
    ..checkbox,
    attrs: list.append(checkbox.attrs, [event.on_focus(msg)]),
  )
}

pub fn on_blur(checkbox: Checkbox(msg), msg: msg) -> Checkbox(msg) {
  Checkbox(..checkbox, attrs: list.append(checkbox.attrs, [event.on_blur(msg)]))
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "checkbox-xs"
    size.Sm -> "checkbox-sm"
    size.Md -> ""
    size.Lg -> "checkbox-lg"
    size.Xl -> "checkbox-xl"
  }
}

pub fn build(checkbox: Checkbox(msg)) -> Element(msg) {
  let classes =
    [
      Some("checkbox"),
      checkbox.color,
      option.map(checkbox.size, size_class),
      case style.to_class_string(checkbox.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(cl) { cl != "" })
    |> string.join(" ")
  html.input([
    attribute.class(classes),
    attribute.type_("checkbox"),
    attribute.checked(checkbox.checked),
    attribute.disabled(checkbox.disabled),
    ..checkbox.attrs
  ])
}
