/// Button — `<button class="btn">`.
///
/// ```gleam
/// import tidal/button
/// import tidal/size
///
/// button.new()
/// |> button.label(text: "Save changes")
/// |> button.primary
/// |> button.size(size: size.Md)
/// |> button.on_click(UserSaved)
/// |> button.build
/// ```
///
/// For icon-only buttons use `square` or `circle` and pass content via `children`:
///
/// ```gleam
/// button.new()
/// |> button.circle
/// |> button.ghost
/// |> button.children(elements: [icon_el])
/// |> button.on_click(UserOpenedMenu)
/// |> button.build
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

pub opaque type Button(msg) {
  Button(
    label: String,
    color: Option(String),
    style_variant: Option(String),
    size: Option(Size),
    disabled: Bool,
    wide: Bool,
    block: Bool,
    square: Bool,
    circle: Bool,
    active: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

/// Creates a new `Button` builder with all options at their defaults.
///
/// Chain builder functions to configure the button, then call `build` to
/// produce an `Element(msg)`:
///
/// ```gleam
/// import tidal/button
/// import tidal/size
///
/// button.new()
/// |> button.label(text: "Save changes")
/// |> button.primary
/// |> button.size(size: size.Md)
/// |> button.on_click(UserSaved)
/// |> button.build
/// ```
///
/// See also:
/// - DaisyUI button docs: https://daisyui.com/components/button/
/// - Lustre element reference: https://hexdocs.pm/lustre/lustre/element/html.html
pub fn new() -> Button(msg) {
  Button(
    label: "",
    color: None,
    style_variant: None,
    size: None,
    disabled: False,
    wide: False,
    block: False,
    square: False,
    circle: False,
    active: False,
    styles: [],
    attrs: [],
    children: [],
  )
}

/// Button text label.
pub fn label(btn: Button(msg), text text: String) -> Button(msg) {
  Button(..btn, label: text)
}

pub fn primary(btn: Button(msg)) -> Button(msg) {
  Button(..btn, color: Some("btn-primary"))
}

pub fn secondary(btn: Button(msg)) -> Button(msg) {
  Button(..btn, color: Some("btn-secondary"))
}

pub fn accent(btn: Button(msg)) -> Button(msg) {
  Button(..btn, color: Some("btn-accent"))
}

pub fn neutral(btn: Button(msg)) -> Button(msg) {
  Button(..btn, color: Some("btn-neutral"))
}

pub fn info(btn: Button(msg)) -> Button(msg) {
  Button(..btn, color: Some("btn-info"))
}

pub fn success(btn: Button(msg)) -> Button(msg) {
  Button(..btn, color: Some("btn-success"))
}

pub fn warning(btn: Button(msg)) -> Button(msg) {
  Button(..btn, color: Some("btn-warning"))
}

pub fn error(btn: Button(msg)) -> Button(msg) {
  Button(..btn, color: Some("btn-error"))
}

/// Transparent background style.
pub fn ghost(btn: Button(msg)) -> Button(msg) {
  Button(..btn, style_variant: Some("btn-ghost"))
}

/// Looks like a hyperlink.
pub fn link(btn: Button(msg)) -> Button(msg) {
  Button(..btn, style_variant: Some("btn-link"))
}

/// Outlined border, no fill.
pub fn outline(btn: Button(msg)) -> Button(msg) {
  Button(..btn, style_variant: Some("btn-outline"))
}

/// Dashed border.
pub fn dash(btn: Button(msg)) -> Button(msg) {
  Button(..btn, style_variant: Some("btn-dash"))
}

/// Soft/muted fill.
pub fn soft(btn: Button(msg)) -> Button(msg) {
  Button(..btn, style_variant: Some("btn-soft"))
}

/// Sets the button size.
pub fn size(btn: Button(msg), size size: Size) -> Button(msg) {
  Button(..btn, size: Some(size))
}

/// Wider horizontal padding.
pub fn wide(btn: Button(msg)) -> Button(msg) {
  Button(..btn, wide: True)
}

/// Full-width block button.
pub fn block(btn: Button(msg)) -> Button(msg) {
  Button(..btn, block: True)
}

/// Equal width and height — use for icon buttons.
pub fn square(btn: Button(msg)) -> Button(msg) {
  Button(..btn, square: True)
}

/// Equal width and height, fully rounded — use for icon buttons.
pub fn circle(btn: Button(msg)) -> Button(msg) {
  Button(..btn, circle: True)
}

/// Force active/pressed appearance.
pub fn active(btn: Button(msg)) -> Button(msg) {
  Button(..btn, active: True)
}

/// Disabled state.
pub fn disabled(btn: Button(msg)) -> Button(msg) {
  Button(..btn, disabled: True)
}

/// Replaces the label with custom child elements (e.g. icon + text).
pub fn children(
  btn: Button(msg),
  elements elements: List(Element(msg)),
) -> Button(msg) {
  Button(..btn, children: list.append(btn.children, elements))
}

/// Appends Tailwind utility styles.
pub fn style(btn: Button(msg), styles styles: List(Style)) -> Button(msg) {
  Button(..btn, styles: list.append(btn.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  btn: Button(msg),
  attributes attributes: List(Attribute(msg)),
) -> Button(msg) {
  Button(..btn, attrs: list.append(btn.attrs, attributes))
}

pub fn on_click(btn: Button(msg), msg: msg) -> Button(msg) {
  Button(..btn, attrs: list.append(btn.attrs, [event.on_click(msg)]))
}

pub fn on_mouse_enter(btn: Button(msg), msg: msg) -> Button(msg) {
  Button(..btn, attrs: list.append(btn.attrs, [event.on_mouse_enter(msg)]))
}

pub fn on_mouse_leave(btn: Button(msg), msg: msg) -> Button(msg) {
  Button(..btn, attrs: list.append(btn.attrs, [event.on_mouse_leave(msg)]))
}

pub fn on_focus(btn: Button(msg), msg: msg) -> Button(msg) {
  Button(..btn, attrs: list.append(btn.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(btn: Button(msg), msg: msg) -> Button(msg) {
  Button(..btn, attrs: list.append(btn.attrs, [event.on_blur(msg)]))
}

pub fn on_keydown(
  btn: Button(msg),
  handler handler: fn(String) -> msg,
) -> Button(msg) {
  Button(..btn, attrs: list.append(btn.attrs, [event.on_keydown(handler)]))
}

pub fn on_keyup(
  btn: Button(msg),
  handler handler: fn(String) -> msg,
) -> Button(msg) {
  Button(..btn, attrs: list.append(btn.attrs, [event.on_keyup(handler)]))
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "btn-xs"
    size.Sm -> "btn-sm"
    size.Md -> ""
    size.Lg -> "btn-lg"
    size.Xl -> "btn-xl"
  }
}

pub fn build(btn: Button(msg)) -> Element(msg) {
  let classes =
    [
      Some("btn"),
      btn.color,
      btn.style_variant,
      option.map(btn.size, size_class),
      case btn.wide {
        True -> Some("btn-wide")
        False -> None
      },
      case btn.block {
        True -> Some("btn-block")
        False -> None
      },
      case btn.square {
        True -> Some("btn-square")
        False -> None
      },
      case btn.circle {
        True -> Some("btn-circle")
        False -> None
      },
      case btn.active {
        True -> Some("btn-active")
        False -> None
      },
      case btn.disabled {
        True -> Some("btn-disabled")
        False -> None
      },
      case style.to_class_string(btn.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let content = case btn.children {
    [] -> [element.text(btn.label)]
    c -> c
  }
  let disabled_attr = case btn.disabled {
    True -> [attribute.disabled(True)]
    False -> []
  }
  html.button(
    [attribute.class(classes), ..list.append(disabled_attr, btn.attrs)],
    content,
  )
}
