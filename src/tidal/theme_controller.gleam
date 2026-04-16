/// Theme Controller — a checkbox or radio input that drives DaisyUI theme switching.
///
/// Use a checkbox to toggle between two themes:
/// ```gleam
/// import tidal/theme_controller
///
/// theme_controller.new()
/// |> theme_controller.theme("dark")
/// |> theme_controller.build
/// ```
///
/// Use radio inputs to switch among multiple themes:
/// ```gleam
/// theme_controller.new()
/// |> theme_controller.as_radio
/// |> theme_controller.name("theme-radios")
/// |> theme_controller.theme("cupcake")
/// |> theme_controller.checked(True)
/// |> theme_controller.build
/// ```
///
/// Render as a DaisyUI toggle, button, or swap:
/// ```gleam
/// theme_controller.new()
/// |> theme_controller.theme("synthwave")
/// |> theme_controller.toggle
/// |> theme_controller.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/style.{type Style}

pub opaque type ThemeController(msg) {
  ThemeController(
    theme: Option(String),
    is_radio: Bool,
    name: Option(String),
    checked: Bool,
    appearance: Option(String),
    on_change: Option(fn(Bool) -> msg),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Create a new theme controller — renders as `<input type="checkbox" class="theme-controller">`.
pub fn new() -> ThemeController(msg) {
  ThemeController(
    theme: None,
    is_radio: False,
    name: None,
    checked: False,
    appearance: None,
    on_change: None,
    styles: [],
    attrs: [],
  )
}

/// Sets the target theme name — written as `value="{name}"`.
pub fn theme(t: ThemeController(msg), name: String) -> ThemeController(msg) {
  ThemeController(..t, theme: Some(name))
}

/// Sets the initial checked state.
pub fn checked(t: ThemeController(msg), c: Bool) -> ThemeController(msg) {
  ThemeController(..t, checked: c)
}

/// Use a radio input instead of a checkbox — for theme groups.
pub fn as_radio(t: ThemeController(msg)) -> ThemeController(msg) {
  ThemeController(..t, is_radio: True)
}

/// Sets the radio group name (used with `as_radio`).
pub fn name(t: ThemeController(msg), n: String) -> ThemeController(msg) {
  ThemeController(..t, name: Some(n))
}

/// Renders as a DaisyUI toggle — adds `toggle` class.
pub fn toggle(t: ThemeController(msg)) -> ThemeController(msg) {
  ThemeController(..t, appearance: Some("toggle"))
}

/// Renders as a button — adds `btn` class.
pub fn btn(t: ThemeController(msg)) -> ThemeController(msg) {
  ThemeController(..t, appearance: Some("btn"))
}

/// Renders as a swap — adds `swap` class.
pub fn swap(t: ThemeController(msg)) -> ThemeController(msg) {
  ThemeController(..t, appearance: Some("swap"))
}

/// Fires when the theme input changes.
pub fn on_change(t: ThemeController(msg), handler: fn(Bool) -> msg) -> ThemeController(msg) {
  ThemeController(..t, on_change: Some(handler))
}

/// Appends Tailwind utility styles. May be called multiple times.
pub fn style(t: ThemeController(msg), s: List(Style)) -> ThemeController(msg) {
  ThemeController(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(t: ThemeController(msg), a: List(Attribute(msg))) -> ThemeController(msg) {
  ThemeController(..t, attrs: list.append(t.attrs, a))
}

pub fn build(t: ThemeController(msg)) -> Element(msg) {
  let input_type = case t.is_radio { True -> "radio" False -> "checkbox" }

  let cls =
    [Some("theme-controller"), t.appearance, case style.to_class_string(t.styles) {
      "" -> None
      s -> Some(s)
    }]
    |> option.values
    |> string.join(" ")

  let base_attrs = [
    attribute.type_(input_type),
    attribute.class(cls),
    attribute.checked(t.checked),
  ]

  let theme_attr = case t.theme {
    None -> []
    Some(v) -> [attribute.value(v)]
  }

  let name_attr = case t.name {
    None -> []
    Some(n) -> [attribute.name(n)]
  }

  let change_attr = case t.on_change {
    None -> []
    Some(h) -> [event.on_check(h)]
  }

  html.input(list.flatten([base_attrs, theme_attr, name_attr, change_attr, t.attrs]))
}
