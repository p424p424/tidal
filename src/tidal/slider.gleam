/// Range slider — `<input type="range" class="range">`.
///
/// ```gleam
/// import tidal/slider
///
/// slider.new()
/// |> slider.min(0)
/// |> slider.max(100)
/// |> slider.value(model.volume)
/// |> slider.primary
/// |> slider.on_input(UserChangedVolume)
/// |> slider.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

pub opaque type Slider(msg) {
  Slider(
    min: Option(Int),
    max: Option(Int),
    step: Option(Int),
    value: Option(Int),
    color: Option(String),
    size: Option(Size),
    disabled: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Slider(msg) {
  Slider(min: None, max: None, step: None, value: None, color: None, size: None, disabled: False, styles: [], attrs: [])
}

/// Minimum value.
pub fn min(s: Slider(msg), n: Int) -> Slider(msg) { Slider(..s, min: Some(n)) }
/// Maximum value.
pub fn max(s: Slider(msg), n: Int) -> Slider(msg) { Slider(..s, max: Some(n)) }
/// Step increment.
pub fn step(s: Slider(msg), n: Int) -> Slider(msg) { Slider(..s, step: Some(n)) }
/// Current value (controlled).
pub fn value(s: Slider(msg), n: Int) -> Slider(msg) { Slider(..s, value: Some(n)) }

pub fn primary(s: Slider(msg)) -> Slider(msg) { Slider(..s, color: Some("range-primary")) }
pub fn secondary(s: Slider(msg)) -> Slider(msg) { Slider(..s, color: Some("range-secondary")) }
pub fn accent(s: Slider(msg)) -> Slider(msg) { Slider(..s, color: Some("range-accent")) }
pub fn neutral(s: Slider(msg)) -> Slider(msg) { Slider(..s, color: Some("range-neutral")) }
pub fn info(s: Slider(msg)) -> Slider(msg) { Slider(..s, color: Some("range-info")) }
pub fn success(s: Slider(msg)) -> Slider(msg) { Slider(..s, color: Some("range-success")) }
pub fn warning(s: Slider(msg)) -> Slider(msg) { Slider(..s, color: Some("range-warning")) }
pub fn error(s: Slider(msg)) -> Slider(msg) { Slider(..s, color: Some("range-error")) }

/// Sets the slider size.
pub fn size(s: Slider(msg), sz: Size) -> Slider(msg) { Slider(..s, size: Some(sz)) }

/// Marks the slider as disabled.
pub fn disabled(s: Slider(msg)) -> Slider(msg) { Slider(..s, disabled: True) }

/// Appends Tailwind utility styles.
pub fn style(s: Slider(msg), st: List(Style)) -> Slider(msg) {
  Slider(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes.
pub fn attrs(s: Slider(msg), a: List(Attribute(msg))) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, a))
}

pub fn on_input(s: Slider(msg), f: fn(String) -> msg) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, [event.on_input(f)]))
}
pub fn on_change(s: Slider(msg), f: fn(String) -> msg) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, [event.on_change(f)]))
}
pub fn on_focus(s: Slider(msg), msg: msg) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(s: Slider(msg), msg: msg) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, [event.on_blur(msg)]))
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "range-xs"
    size.Sm -> "range-sm"
    size.Md -> ""
    size.Lg -> "range-lg"
    size.Xl -> "range-xl"
  }
}

pub fn build(s: Slider(msg)) -> Element(msg) {
  let classes =
    [
      Some("range"),
      s.color,
      option.map(s.size, size_class),
      case style.to_class_string(s.styles) { "" -> None st -> Some(st) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let opt_attrs = fn(maybe, to_attr) {
    case maybe { None -> [] Some(v) -> [to_attr(v)] }
  }
  html.input(list.flatten([
    [attribute.class(classes), attribute.type_("range"), attribute.disabled(s.disabled)],
    opt_attrs(s.min, fn(n) { attribute.min(int.to_string(n)) }),
    opt_attrs(s.max, fn(n) { attribute.max(int.to_string(n)) }),
    opt_attrs(s.step, fn(n) { attribute.step(int.to_string(n)) }),
    opt_attrs(s.value, fn(n) { attribute.value(int.to_string(n)) }),
    s.attrs,
  ]))
}
