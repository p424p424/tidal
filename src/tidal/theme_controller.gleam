/// Theme Controller — a checkbox or radio input that drives DaisyUI theme switching.
///
/// Use a checkbox to toggle between two themes:
/// ```gleam
/// import tidal/theme_controller
///
/// theme_controller.new()
/// |> theme_controller.theme(name: "dark")
/// |> theme_controller.build
/// ```
///
/// Use radio inputs to switch among multiple themes:
/// ```gleam
/// theme_controller.new()
/// |> theme_controller.as_radio
/// |> theme_controller.name(name: "theme-radios")
/// |> theme_controller.theme(name: "cupcake")
/// |> theme_controller.checked(to: True)
/// |> theme_controller.build
/// ```
///
/// Render as a DaisyUI toggle, button, or swap:
/// ```gleam
/// theme_controller.new()
/// |> theme_controller.theme(name: "synthwave")
/// |> theme_controller.toggle
/// |> theme_controller.build
/// ```
///
/// See also:
/// - DaisyUI theme controller docs: https://daisyui.com/components/theme-controller/
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

/// Creates a new `ThemeController` — renders as `<input type="checkbox" class="theme-controller">`.
///
/// Chain builder functions to configure it, then call `build`:
///
/// ```gleam
/// import tidal/theme_controller
///
/// theme_controller.new()
/// |> theme_controller.theme(name: "dark")
/// |> theme_controller.toggle
/// |> theme_controller.build
/// ```
///
/// See also:
/// - DaisyUI theme controller docs: https://daisyui.com/components/theme-controller/
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
pub fn theme(
  controller: ThemeController(msg),
  name name: String,
) -> ThemeController(msg) {
  ThemeController(..controller, theme: Some(name))
}

/// Sets the initial checked state.
pub fn checked(
  controller: ThemeController(msg),
  to is_checked: Bool,
) -> ThemeController(msg) {
  ThemeController(..controller, checked: is_checked)
}

/// Use a radio input instead of a checkbox — for theme groups.
pub fn as_radio(controller: ThemeController(msg)) -> ThemeController(msg) {
  ThemeController(..controller, is_radio: True)
}

/// Sets the radio group name (used with `as_radio`).
pub fn name(
  controller: ThemeController(msg),
  name name: String,
) -> ThemeController(msg) {
  ThemeController(..controller, name: Some(name))
}

/// Renders as a DaisyUI toggle — adds `toggle` class.
pub fn toggle(controller: ThemeController(msg)) -> ThemeController(msg) {
  ThemeController(..controller, appearance: Some("toggle"))
}

/// Renders as a button — adds `btn` class.
pub fn btn(controller: ThemeController(msg)) -> ThemeController(msg) {
  ThemeController(..controller, appearance: Some("btn"))
}

/// Renders as a swap — adds `swap` class.
pub fn swap(controller: ThemeController(msg)) -> ThemeController(msg) {
  ThemeController(..controller, appearance: Some("swap"))
}

/// Fires when the theme input changes.
pub fn on_change(
  controller: ThemeController(msg),
  handler handler: fn(Bool) -> msg,
) -> ThemeController(msg) {
  ThemeController(..controller, on_change: Some(handler))
}

/// Appends Tailwind utility styles. May be called multiple times.
pub fn style(
  controller: ThemeController(msg),
  styles styles: List(Style),
) -> ThemeController(msg) {
  ThemeController(..controller, styles: list.append(controller.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  controller: ThemeController(msg),
  attributes attributes: List(Attribute(msg)),
) -> ThemeController(msg) {
  ThemeController(
    ..controller,
    attrs: list.append(controller.attrs, attributes),
  )
}

pub fn build(controller: ThemeController(msg)) -> Element(msg) {
  let input_type = case controller.is_radio {
    True -> "radio"
    False -> "checkbox"
  }

  let cls =
    [
      Some("theme-controller"),
      controller.appearance,
      case style.to_class_string(controller.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> string.join(" ")

  let base_attrs = [
    attribute.type_(input_type),
    attribute.class(cls),
    attribute.checked(controller.checked),
  ]

  let theme_attr = case controller.theme {
    None -> []
    Some(theme_name) -> [attribute.value(theme_name)]
  }

  let name_attr = case controller.name {
    None -> []
    Some(group_name) -> [attribute.name(group_name)]
  }

  let change_attr = case controller.on_change {
    None -> []
    Some(handler) -> [event.on_check(handler)]
  }

  html.input(
    list.flatten([
      base_attrs,
      theme_attr,
      name_attr,
      change_attr,
      controller.attrs,
    ]),
  )
}
