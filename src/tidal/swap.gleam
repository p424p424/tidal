/// Swap — toggle between two elements via checkbox or CSS class.
///
/// ```gleam
/// import tidal/swap
///
/// swap.new()
/// |> swap.rotate
/// |> swap.on_el(sun_icon)
/// |> swap.off_el(moon_icon)
/// |> swap.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/style.{type Style}

pub opaque type Swap(msg) {
  Swap(
    effect: Option(String),
    active: Option(Bool),
    on_el: Option(Element(msg)),
    off_el: Option(Element(msg)),
    indeterminate_el: Option(Element(msg)),
    on_change: Option(fn(Bool) -> msg),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Create a new swap toggle.
/// Provide `on_el(el)` and `off_el(el)` for the two states, then `build`.
pub fn new() -> Swap(msg) {
  Swap(
    effect: None,
    active: None,
    on_el: None,
    off_el: None,
    indeterminate_el: None,
    on_change: None,
    styles: [],
    attrs: [],
  )
}

/// Rotation transition effect — `swap-rotate`.
pub fn rotate(s: Swap(msg)) -> Swap(msg) { Swap(..s, effect: Some("swap-rotate")) }
/// Flip transition effect — `swap-flip`.
pub fn flip(s: Swap(msg)) -> Swap(msg) { Swap(..s, effect: Some("swap-flip")) }

/// Control active state via `swap-active` CSS class (pass current model state).
/// When `True` renders the `on_el`; when `False` renders the `off_el`.
pub fn active(s: Swap(msg), b: Bool) -> Swap(msg) { Swap(..s, active: Some(b)) }

/// Element shown when the swap is active/checked — wrapped in `swap-on`.
pub fn on_el(s: Swap(msg), el: Element(msg)) -> Swap(msg) { Swap(..s, on_el: Some(el)) }
/// Element shown when the swap is inactive/unchecked — wrapped in `swap-off`.
pub fn off_el(s: Swap(msg), el: Element(msg)) -> Swap(msg) { Swap(..s, off_el: Some(el)) }
/// Element shown when the swap is in an indeterminate state — wrapped in `swap-indeterminate`.
pub fn indeterminate_el(s: Swap(msg), el: Element(msg)) -> Swap(msg) {
  Swap(..s, indeterminate_el: Some(el))
}

/// Fires when the swap is toggled.
pub fn on_change(s: Swap(msg), handler: fn(Bool) -> msg) -> Swap(msg) {
  Swap(..s, on_change: Some(handler))
}

/// Appends Tailwind utility styles.
pub fn style(s: Swap(msg), st: List(Style)) -> Swap(msg) {
  Swap(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes.
pub fn attrs(s: Swap(msg), a: List(Attribute(msg))) -> Swap(msg) {
  Swap(..s, attrs: list.append(s.attrs, a))
}

fn wrap_slot(cls: String, el: Option(Element(msg))) -> Option(Element(msg)) {
  option.map(el, fn(e) { html.div([attribute.class(cls)], [e]) })
}

pub fn build(s: Swap(msg)) -> Element(msg) {
  let is_active = case s.active { Some(True) -> True _ -> False }
  let class =
    [
      Some("swap"),
      s.effect,
      case is_active { True -> Some("swap-active") False -> None },
      case style.to_class_string(s.styles) { "" -> None st -> Some(st) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let change_attrs = case s.on_change {
    None -> []
    Some(handler) -> [event.on_check(handler)]
  }

  let checkbox = case s.active {
    Some(_) -> []
    None -> [html.input([attribute.type_("checkbox"), ..change_attrs])]
  }

  let slot_children =
    [
      wrap_slot("swap-on", s.on_el),
      wrap_slot("swap-off", s.off_el),
      wrap_slot("swap-indeterminate", s.indeterminate_el),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.label(
    [attribute.class(class), ..s.attrs],
    list.append(checkbox, slot_children),
  )
}
