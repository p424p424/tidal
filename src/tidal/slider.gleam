/// Range slider — `<input type="range" class="range">`.
///
/// ```gleam
/// import tidal/slider
///
/// slider.new()
/// |> slider.min(to: 0)
/// |> slider.max(to: 100)
/// |> slider.value(to: model.volume)
/// |> slider.primary
/// |> slider.on_input(UserChangedVolume)
/// |> slider.build
/// ```
///
/// See also:
/// - DaisyUI range docs: https://daisyui.com/components/range/
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

/// Creates a new `Slider` builder with all options at their defaults.
///
/// Chain builder functions to configure the slider, then call `build`:
///
/// ```gleam
/// import tidal/slider
///
/// slider.new()
/// |> slider.min(to: 0)
/// |> slider.max(to: 100)
/// |> slider.value(to: model.volume)
/// |> slider.primary
/// |> slider.on_input(UserChangedVolume)
/// |> slider.build
/// ```
///
/// See also:
/// - DaisyUI range docs: https://daisyui.com/components/range/
pub fn new() -> Slider(msg) {
  Slider(
    min: None,
    max: None,
    step: None,
    value: None,
    color: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Minimum value.
pub fn min(slider: Slider(msg), to minimum: Int) -> Slider(msg) {
  Slider(..slider, min: Some(minimum))
}

/// Maximum value.
pub fn max(slider: Slider(msg), to maximum: Int) -> Slider(msg) {
  Slider(..slider, max: Some(maximum))
}

/// Step increment.
pub fn step(slider: Slider(msg), to increment: Int) -> Slider(msg) {
  Slider(..slider, step: Some(increment))
}

/// Current value (controlled).
pub fn value(slider: Slider(msg), to amount: Int) -> Slider(msg) {
  Slider(..slider, value: Some(amount))
}

pub fn primary(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, color: Some("range-primary"))
}

pub fn secondary(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, color: Some("range-secondary"))
}

pub fn accent(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, color: Some("range-accent"))
}

pub fn neutral(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, color: Some("range-neutral"))
}

pub fn info(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, color: Some("range-info"))
}

pub fn success(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, color: Some("range-success"))
}

pub fn warning(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, color: Some("range-warning"))
}

pub fn error(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, color: Some("range-error"))
}

/// Sets the slider size.
pub fn size(slider: Slider(msg), size size: Size) -> Slider(msg) {
  Slider(..slider, size: Some(size))
}

/// Marks the slider as disabled.
pub fn disabled(slider: Slider(msg)) -> Slider(msg) {
  Slider(..slider, disabled: True)
}

/// Appends Tailwind utility styles.
pub fn style(slider: Slider(msg), styles styles: List(Style)) -> Slider(msg) {
  Slider(..slider, styles: list.append(slider.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  slider: Slider(msg),
  attributes attributes: List(Attribute(msg)),
) -> Slider(msg) {
  Slider(..slider, attrs: list.append(slider.attrs, attributes))
}

pub fn on_input(
  slider: Slider(msg),
  handler handler: fn(String) -> msg,
) -> Slider(msg) {
  Slider(..slider, attrs: list.append(slider.attrs, [event.on_input(handler)]))
}

pub fn on_change(
  slider: Slider(msg),
  handler handler: fn(String) -> msg,
) -> Slider(msg) {
  Slider(..slider, attrs: list.append(slider.attrs, [event.on_change(handler)]))
}

pub fn on_focus(slider: Slider(msg), msg: msg) -> Slider(msg) {
  Slider(..slider, attrs: list.append(slider.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(slider: Slider(msg), msg: msg) -> Slider(msg) {
  Slider(..slider, attrs: list.append(slider.attrs, [event.on_blur(msg)]))
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

pub fn build(slider: Slider(msg)) -> Element(msg) {
  let classes =
    [
      Some("range"),
      slider.color,
      option.map(slider.size, size_class),
      case style.to_class_string(slider.styles) {
        "" -> None
        st -> Some(st)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let opt_attrs = fn(maybe, to_attr) {
    case maybe {
      None -> []
      Some(v) -> [to_attr(v)]
    }
  }
  html.input(
    list.flatten([
      [
        attribute.class(classes),
        attribute.type_("range"),
        attribute.disabled(slider.disabled),
      ],
      opt_attrs(slider.min, fn(n) { attribute.min(int.to_string(n)) }),
      opt_attrs(slider.max, fn(n) { attribute.max(int.to_string(n)) }),
      opt_attrs(slider.step, fn(n) { attribute.step(int.to_string(n)) }),
      opt_attrs(slider.value, fn(n) { attribute.value(int.to_string(n)) }),
      slider.attrs,
    ]),
  )
}
