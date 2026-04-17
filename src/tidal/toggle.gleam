/// Toggle switch — `<input type="checkbox" class="toggle">`.
///
/// ```gleam
/// import tidal/toggle
///
/// toggle.new()
/// |> toggle.primary
/// |> toggle.checked(to: model.dark_mode)
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

/// Creates a new `Toggle` builder with all options at their defaults.
///
/// Chain builder functions to configure the toggle, then call `build`:
///
/// ```gleam
/// import tidal/toggle
///
/// toggle.new()
/// |> toggle.primary
/// |> toggle.checked(to: model.dark_mode)
/// |> toggle.on_check(UserToggledDarkMode)
/// |> toggle.build
/// ```
///
/// See also:
/// - DaisyUI toggle docs: https://daisyui.com/components/toggle/
pub fn new() -> Toggle(msg) {
  Toggle(
    checked: False,
    color: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the checked state (controlled).
pub fn checked(toggle: Toggle(msg), to is_checked: Bool) -> Toggle(msg) {
  Toggle(..toggle, checked: is_checked)
}

pub fn primary(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, color: Some("toggle-primary"))
}

pub fn secondary(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, color: Some("toggle-secondary"))
}

pub fn accent(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, color: Some("toggle-accent"))
}

pub fn neutral(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, color: Some("toggle-neutral"))
}

pub fn info(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, color: Some("toggle-info"))
}

pub fn success(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, color: Some("toggle-success"))
}

pub fn warning(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, color: Some("toggle-warning"))
}

pub fn error(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, color: Some("toggle-error"))
}

/// Sets the toggle size.
pub fn size(toggle: Toggle(msg), size size: Size) -> Toggle(msg) {
  Toggle(..toggle, size: Some(size))
}

/// Marks the toggle as disabled.
pub fn disabled(toggle: Toggle(msg)) -> Toggle(msg) {
  Toggle(..toggle, disabled: True)
}

/// Appends Tailwind utility styles.
pub fn style(toggle: Toggle(msg), styles styles: List(Style)) -> Toggle(msg) {
  Toggle(..toggle, styles: list.append(toggle.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  toggle: Toggle(msg),
  attributes attributes: List(Attribute(msg)),
) -> Toggle(msg) {
  Toggle(..toggle, attrs: list.append(toggle.attrs, attributes))
}

pub fn on_check(
  toggle: Toggle(msg),
  handler handler: fn(Bool) -> msg,
) -> Toggle(msg) {
  Toggle(..toggle, attrs: list.append(toggle.attrs, [event.on_check(handler)]))
}

pub fn on_focus(toggle: Toggle(msg), msg: msg) -> Toggle(msg) {
  Toggle(..toggle, attrs: list.append(toggle.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(toggle: Toggle(msg), msg: msg) -> Toggle(msg) {
  Toggle(..toggle, attrs: list.append(toggle.attrs, [event.on_blur(msg)]))
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

pub fn build(toggle: Toggle(msg)) -> Element(msg) {
  let classes =
    [
      Some("toggle"),
      toggle.color,
      option.map(toggle.size, size_class),
      case style.to_class_string(toggle.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.input([
    attribute.class(classes),
    attribute.type_("checkbox"),
    attribute.checked(toggle.checked),
    attribute.disabled(toggle.disabled),
    ..toggle.attrs
  ])
}
