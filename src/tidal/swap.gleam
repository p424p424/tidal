/// Swap — toggle between two elements via checkbox or CSS class.
///
/// ```gleam
/// import tidal/swap
///
/// swap.new()
/// |> swap.rotate
/// |> swap.on(sun_icon())
/// |> swap.off(moon_icon())
/// |> swap.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

pub opaque type Swap(msg) {
  Swap(
    effect: Option(String),
    active: Bool,
    on_el: Option(Element(msg)),
    off_el: Option(Element(msg)),
    indeterminate_el: Option(Element(msg)),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Swap(msg) {
  Swap(effect: None, active: False, on_el: None, off_el: None, indeterminate_el: None, attrs: [])
}

pub fn rotate(s: Swap(msg)) -> Swap(msg) { Swap(..s, effect: Some("swap-rotate")) }
pub fn flip(s: Swap(msg)) -> Swap(msg) { Swap(..s, effect: Some("swap-flip")) }

/// Control via `swap-active` CSS class rather than a checkbox.
pub fn active(s: Swap(msg)) -> Swap(msg) { Swap(..s, active: True) }

pub fn on(s: Swap(msg), el: Element(msg)) -> Swap(msg) { Swap(..s, on_el: Some(el)) }
pub fn off(s: Swap(msg), el: Element(msg)) -> Swap(msg) { Swap(..s, off_el: Some(el)) }
pub fn indeterminate(s: Swap(msg), el: Element(msg)) -> Swap(msg) {
  Swap(..s, indeterminate_el: Some(el))
}

pub fn attrs(s: Swap(msg), a: List(Attribute(msg))) -> Swap(msg) {
  Swap(..s, attrs: list.append(s.attrs, a))
}

/// Wraps content in `<div class="swap-on">`.
pub fn on_wrap(children: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("swap-on")], children)
}

/// Wraps content in `<div class="swap-off">`.
pub fn off_wrap(children: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("swap-off")], children)
}

pub fn build(s: Swap(msg)) -> Element(msg) {
  let class =
    [
      Some("swap"),
      s.effect,
      case s.active { True -> Some("swap-active") False -> None },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let checkbox = case s.active {
    True -> []
    False -> [html.input([attribute.type_("checkbox")])]
  }

  let slot_children =
    [s.on_el, s.off_el, s.indeterminate_el]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.label(
    [attribute.class(class), ..s.attrs],
    list.append(checkbox, slot_children),
  )
}
