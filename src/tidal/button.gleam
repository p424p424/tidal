/// Button — `<button class="btn">`.
///
/// ```gleam
/// import tidal/button
/// import tidal/size
///
/// button.new()
/// |> button.label("Save changes")
/// |> button.primary
/// |> button.size(size.Md)
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
/// |> button.children([icon_el])
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
pub fn label(b: Button(msg), t: String) -> Button(msg) { Button(..b, label: t) }

pub fn primary(b: Button(msg)) -> Button(msg) { Button(..b, color: Some("btn-primary")) }
pub fn secondary(b: Button(msg)) -> Button(msg) { Button(..b, color: Some("btn-secondary")) }
pub fn accent(b: Button(msg)) -> Button(msg) { Button(..b, color: Some("btn-accent")) }
pub fn neutral(b: Button(msg)) -> Button(msg) { Button(..b, color: Some("btn-neutral")) }
pub fn info(b: Button(msg)) -> Button(msg) { Button(..b, color: Some("btn-info")) }
pub fn success(b: Button(msg)) -> Button(msg) { Button(..b, color: Some("btn-success")) }
pub fn warning(b: Button(msg)) -> Button(msg) { Button(..b, color: Some("btn-warning")) }
pub fn error(b: Button(msg)) -> Button(msg) { Button(..b, color: Some("btn-error")) }

/// Transparent background style.
pub fn ghost(b: Button(msg)) -> Button(msg) { Button(..b, style_variant: Some("btn-ghost")) }
/// Looks like a hyperlink.
pub fn link(b: Button(msg)) -> Button(msg) { Button(..b, style_variant: Some("btn-link")) }
/// Outlined border, no fill.
pub fn outline(b: Button(msg)) -> Button(msg) { Button(..b, style_variant: Some("btn-outline")) }
/// Dashed border.
pub fn dash(b: Button(msg)) -> Button(msg) { Button(..b, style_variant: Some("btn-dash")) }
/// Soft/muted fill.
pub fn soft(b: Button(msg)) -> Button(msg) { Button(..b, style_variant: Some("btn-soft")) }

/// Sets the button size.
pub fn size(b: Button(msg), s: Size) -> Button(msg) { Button(..b, size: Some(s)) }

/// Wider horizontal padding.
pub fn wide(b: Button(msg)) -> Button(msg) { Button(..b, wide: True) }
/// Full-width block button.
pub fn block(b: Button(msg)) -> Button(msg) { Button(..b, block: True) }
/// Equal width and height — use for icon buttons.
pub fn square(b: Button(msg)) -> Button(msg) { Button(..b, square: True) }
/// Equal width and height, fully rounded — use for icon buttons.
pub fn circle(b: Button(msg)) -> Button(msg) { Button(..b, circle: True) }
/// Force active/pressed appearance.
pub fn active(b: Button(msg)) -> Button(msg) { Button(..b, active: True) }
/// Disabled state.
pub fn disabled(b: Button(msg)) -> Button(msg) { Button(..b, disabled: True) }

/// Replaces the label with custom child elements (e.g. icon + text).
pub fn children(b: Button(msg), c: List(Element(msg))) -> Button(msg) {
  Button(..b, children: list.append(b.children, c))
}

/// Appends Tailwind utility styles.
pub fn style(b: Button(msg), s: List(Style)) -> Button(msg) {
  Button(..b, styles: list.append(b.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(b: Button(msg), a: List(Attribute(msg))) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, a))
}

pub fn on_click(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_click(msg)]))
}
pub fn on_mouse_enter(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_mouse_enter(msg)]))
}
pub fn on_mouse_leave(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_mouse_leave(msg)]))
}
pub fn on_focus(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(b: Button(msg), msg: msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_blur(msg)]))
}
pub fn on_keydown(b: Button(msg), f: fn(String) -> msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_keydown(f)]))
}
pub fn on_keyup(b: Button(msg), f: fn(String) -> msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_keyup(f)]))
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

pub fn build(b: Button(msg)) -> Element(msg) {
  let classes =
    [
      Some("btn"),
      b.color,
      b.style_variant,
      option.map(b.size, size_class),
      case b.wide { True -> Some("btn-wide") False -> None },
      case b.block { True -> Some("btn-block") False -> None },
      case b.square { True -> Some("btn-square") False -> None },
      case b.circle { True -> Some("btn-circle") False -> None },
      case b.active { True -> Some("btn-active") False -> None },
      case b.disabled { True -> Some("btn-disabled") False -> None },
      case style.to_class_string(b.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let content = case b.children {
    [] -> [element.text(b.label)]
    c -> c
  }
  let disabled_attr = case b.disabled { True -> [attribute.disabled(True)] False -> [] }
  html.button([attribute.class(classes), ..list.append(disabled_attr, b.attrs)], content)
}
