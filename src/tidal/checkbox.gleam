/// Checkbox — `<input type="checkbox" class="checkbox">`.
///
/// ```gleam
/// import tidal/checkbox
///
/// checkbox.new()
/// |> checkbox.primary
/// |> checkbox.checked(model.agreed)
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

pub fn new() -> Checkbox(msg) {
  Checkbox(checked: False, color: None, size: None, disabled: False, styles: [], attrs: [])
}

/// Sets the checked state (controlled).
pub fn checked(c: Checkbox(msg), b: Bool) -> Checkbox(msg) { Checkbox(..c, checked: b) }

pub fn primary(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, color: Some("checkbox-primary")) }
pub fn secondary(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, color: Some("checkbox-secondary")) }
pub fn accent(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, color: Some("checkbox-accent")) }
pub fn neutral(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, color: Some("checkbox-neutral")) }
pub fn info(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, color: Some("checkbox-info")) }
pub fn success(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, color: Some("checkbox-success")) }
pub fn warning(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, color: Some("checkbox-warning")) }
pub fn error(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, color: Some("checkbox-error")) }

/// Sets the checkbox size.
pub fn size(c: Checkbox(msg), s: Size) -> Checkbox(msg) { Checkbox(..c, size: Some(s)) }

/// Marks the checkbox as disabled.
pub fn disabled(c: Checkbox(msg)) -> Checkbox(msg) { Checkbox(..c, disabled: True) }

/// Appends Tailwind utility styles.
pub fn style(c: Checkbox(msg), s: List(Style)) -> Checkbox(msg) {
  Checkbox(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(c: Checkbox(msg), a: List(Attribute(msg))) -> Checkbox(msg) {
  Checkbox(..c, attrs: list.append(c.attrs, a))
}

pub fn on_check(c: Checkbox(msg), f: fn(Bool) -> msg) -> Checkbox(msg) {
  Checkbox(..c, attrs: list.append(c.attrs, [event.on_check(f)]))
}
pub fn on_focus(c: Checkbox(msg), msg: msg) -> Checkbox(msg) {
  Checkbox(..c, attrs: list.append(c.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(c: Checkbox(msg), msg: msg) -> Checkbox(msg) {
  Checkbox(..c, attrs: list.append(c.attrs, [event.on_blur(msg)]))
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

pub fn build(c: Checkbox(msg)) -> Element(msg) {
  let classes =
    [
      Some("checkbox"),
      c.color,
      option.map(c.size, size_class),
      case style.to_class_string(c.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(cl) { cl != "" })
    |> string.join(" ")
  html.input([
    attribute.class(classes),
    attribute.type_("checkbox"),
    attribute.checked(c.checked),
    attribute.disabled(c.disabled),
    ..c.attrs
  ])
}
