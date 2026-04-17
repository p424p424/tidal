/// Swap — toggle between two elements via checkbox or CSS class.
///
/// ```gleam
/// import tidal/swap
///
/// swap.new()
/// |> swap.rotate
/// |> swap.on_el(element: sun_icon)
/// |> swap.off_el(element: moon_icon)
/// |> swap.build
/// ```
///
/// See also:
/// - DaisyUI swap docs: https://daisyui.com/components/swap/
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

/// Creates a new `Swap` toggle.
/// Provide `on_el(element:)` and `off_el(element:)` for the two states, then `build`.
///
/// ```gleam
/// import tidal/swap
///
/// swap.new()
/// |> swap.rotate
/// |> swap.on_el(element: sun_icon)
/// |> swap.off_el(element: moon_icon)
/// |> swap.build
/// ```
///
/// See also:
/// - DaisyUI swap docs: https://daisyui.com/components/swap/
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
pub fn rotate(swap: Swap(msg)) -> Swap(msg) {
  Swap(..swap, effect: Some("swap-rotate"))
}

/// Flip transition effect — `swap-flip`.
pub fn flip(swap: Swap(msg)) -> Swap(msg) {
  Swap(..swap, effect: Some("swap-flip"))
}

/// Control active state via `swap-active` CSS class (pass current model state).
/// When `True` renders the `on_el`; when `False` renders the `off_el`.
pub fn active(swap: Swap(msg), to is_active: Bool) -> Swap(msg) {
  Swap(..swap, active: Some(is_active))
}

/// Element shown when the swap is active/checked — wrapped in `swap-on`.
pub fn on_el(swap: Swap(msg), element element: Element(msg)) -> Swap(msg) {
  Swap(..swap, on_el: Some(element))
}

/// Element shown when the swap is inactive/unchecked — wrapped in `swap-off`.
pub fn off_el(swap: Swap(msg), element element: Element(msg)) -> Swap(msg) {
  Swap(..swap, off_el: Some(element))
}

/// Element shown when the swap is in an indeterminate state — wrapped in `swap-indeterminate`.
pub fn indeterminate_el(
  swap: Swap(msg),
  element element: Element(msg),
) -> Swap(msg) {
  Swap(..swap, indeterminate_el: Some(element))
}

/// Fires when the swap is toggled.
pub fn on_change(swap: Swap(msg), handler handler: fn(Bool) -> msg) -> Swap(msg) {
  Swap(..swap, on_change: Some(handler))
}

/// Appends Tailwind utility styles.
pub fn style(swap: Swap(msg), styles styles: List(Style)) -> Swap(msg) {
  Swap(..swap, styles: list.append(swap.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  swap: Swap(msg),
  attributes attributes: List(Attribute(msg)),
) -> Swap(msg) {
  Swap(..swap, attrs: list.append(swap.attrs, attributes))
}

fn wrap_slot(cls: String, el: Option(Element(msg))) -> Option(Element(msg)) {
  option.map(el, fn(e) { html.div([attribute.class(cls)], [e]) })
}

pub fn build(swap: Swap(msg)) -> Element(msg) {
  let is_active = case swap.active {
    Some(True) -> True
    _ -> False
  }
  let class =
    [
      Some("swap"),
      swap.effect,
      case is_active {
        True -> Some("swap-active")
        False -> None
      },
      case style.to_class_string(swap.styles) {
        "" -> None
        st -> Some(st)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let change_attrs = case swap.on_change {
    None -> []
    Some(handler) -> [event.on_check(handler)]
  }

  let checkbox = case swap.active {
    Some(_) -> []
    None -> [html.input([attribute.type_("checkbox"), ..change_attrs])]
  }

  let slot_children =
    [
      wrap_slot("swap-on", swap.on_el),
      wrap_slot("swap-off", swap.off_el),
      wrap_slot("swap-indeterminate", swap.indeterminate_el),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.label(
    [attribute.class(class), ..swap.attrs],
    list.append(checkbox, slot_children),
  )
}
