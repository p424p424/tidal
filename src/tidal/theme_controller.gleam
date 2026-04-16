/// Theme Controller — a checkbox or radio that drives DaisyUI theme switching.
///
/// Use a checkbox to toggle between two themes:
/// ```gleam
/// import tidal/theme_controller
///
/// theme_controller.checkbox("dark")
/// |> theme_controller.build
/// ```
///
/// Use radio inputs to switch among multiple themes:
/// ```gleam
/// theme_controller.radio("theme-radios", "cupcake")
/// |> theme_controller.checked(True)
/// |> theme_controller.build
/// ```

import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

pub opaque type ThemeController(msg) {
  Checkbox(theme: String, checked: Bool, attrs: List(Attribute(msg)))
  Radio(name: String, theme: String, checked: Bool, attrs: List(Attribute(msg)))
}

/// A checkbox input that activates `theme` when checked.
pub fn checkbox(theme: String) -> ThemeController(msg) {
  Checkbox(theme: theme, checked: False, attrs: [])
}

/// A radio input for selecting among multiple themes.
pub fn radio(name: String, theme: String) -> ThemeController(msg) {
  Radio(name: name, theme: theme, checked: False, attrs: [])
}

pub fn checked(t: ThemeController(msg), c: Bool) -> ThemeController(msg) {
  case t {
    Checkbox(theme: theme, attrs: attrs, ..) ->
      Checkbox(theme: theme, checked: c, attrs: attrs)
    Radio(name: name, theme: theme, attrs: attrs, ..) ->
      Radio(name: name, theme: theme, checked: c, attrs: attrs)
  }
}

pub fn attrs(t: ThemeController(msg), a: List(Attribute(msg))) -> ThemeController(msg) {
  case t {
    Checkbox(theme: theme, checked: ch, attrs: existing) ->
      Checkbox(theme: theme, checked: ch, attrs: list.append(existing, a))
    Radio(name: name, theme: theme, checked: ch, attrs: existing) ->
      Radio(name: name, theme: theme, checked: ch, attrs: list.append(existing, a))
  }
}

pub fn build(t: ThemeController(msg)) -> Element(msg) {
  case t {
    Checkbox(theme: theme, checked: ch, attrs: extra) ->
      html.input(list.flatten([
        [
          attribute.type_("checkbox"),
          attribute.class("theme-controller"),
          attribute.value(theme),
          attribute.checked(ch),
        ],
        extra,
      ]))
    Radio(name: name, theme: theme, checked: ch, attrs: extra) ->
      html.input(list.flatten([
        [
          attribute.type_("radio"),
          attribute.name(name),
          attribute.class("theme-controller"),
          attribute.value(theme),
          attribute.checked(ch),
        ],
        extra,
      ]))
  }
}
