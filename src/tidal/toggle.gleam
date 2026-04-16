/// Toggle switch — `<input type="checkbox" class="toggle">`.
///
/// ```gleam
/// import tidal/toggle
///
/// toggle.new()
/// |> toggle.primary
/// |> toggle.checked(model.dark_mode)
/// |> toggle.on_check(UserToggledDarkMode)
/// |> toggle.build
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

pub opaque type Toggle(msg) {
  Toggle(
    checked: Bool,
    color: Option(String),
    size: Option(Size),
    disabled: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Toggle(msg) {
  Toggle(checked: False, color: None, size: None, disabled: False, styles: [], attrs: [])
}

/// Sets the checked state (controlled).
pub fn checked(t: Toggle(msg), b: Bool) -> Toggle(msg) { Toggle(..t, checked: b) }

pub fn primary(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, color: Some("toggle-primary")) }
pub fn secondary(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, color: Some("toggle-secondary")) }
pub fn accent(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, color: Some("toggle-accent")) }
pub fn neutral(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, color: Some("toggle-neutral")) }
pub fn info(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, color: Some("toggle-info")) }
pub fn success(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, color: Some("toggle-success")) }
pub fn warning(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, color: Some("toggle-warning")) }
pub fn error(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, color: Some("toggle-error")) }

/// Sets the toggle size.
pub fn size(t: Toggle(msg), s: Size) -> Toggle(msg) { Toggle(..t, size: Some(s)) }

/// Marks the toggle as disabled.
pub fn disabled(t: Toggle(msg)) -> Toggle(msg) { Toggle(..t, disabled: True) }

/// Appends Tailwind utility styles.
pub fn style(t: Toggle(msg), s: List(Style)) -> Toggle(msg) {
  Toggle(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(t: Toggle(msg), a: List(Attribute(msg))) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, a))
}

pub fn on_check(t: Toggle(msg), f: fn(Bool) -> msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_check(f)]))
}
pub fn on_focus(t: Toggle(msg), msg: msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(t: Toggle(msg), msg: msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_blur(msg)]))
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "toggle-xs"
    size.Sm -> "toggle-sm"
    size.Md -> ""
    size.Lg -> "toggle-lg"
    size.Xl -> "toggle-xl"
  }
}

pub fn build(t: Toggle(msg)) -> Element(msg) {
  let classes =
    [
      Some("toggle"),
      t.color,
      option.map(t.size, size_class),
      case style.to_class_string(t.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.input([
    attribute.class(classes),
    attribute.type_("checkbox"),
    attribute.checked(t.checked),
    attribute.disabled(t.disabled),
    ..t.attrs
  ])
}
