/// Slider component — renders as `<input type="range">` with DaisyUI `range` classes.
///
/// ```gleam
/// import tidal/slider
/// import tidal/variant
///
/// slider.new()
/// |> slider.min(0)
/// |> slider.max(100)
/// |> slider.value(50)
/// |> slider.variant(variant.Primary)
/// |> slider.on_input(UserMovedSlider)
/// |> slider.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}
import tidal/variant.{type Variant}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Slider(msg) {
  Slider(
    min: Option(Int),
    max: Option(Int),
    step: Option(Int),
    value: Option(Int),
    variant: Option(Variant),
    size: Option(Size),
    disabled: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Slider(msg) {
  Slider(
    min: None,
    max: None,
    step: None,
    value: None,
    variant: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the minimum value.
pub fn min(s: Slider(msg), n: Int) -> Slider(msg) {
  Slider(..s, min: Some(n))
}

/// Sets the maximum value.
pub fn max(s: Slider(msg), n: Int) -> Slider(msg) {
  Slider(..s, max: Some(n))
}

/// Sets the step increment.
pub fn step(s: Slider(msg), n: Int) -> Slider(msg) {
  Slider(..s, step: Some(n))
}

/// Sets the current value.
pub fn value(s: Slider(msg), n: Int) -> Slider(msg) {
  Slider(..s, value: Some(n))
}

/// Sets the variant (colour role).
pub fn variant(s: Slider(msg), v: Variant) -> Slider(msg) {
  Slider(..s, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(s: Slider(msg), sz: Size) -> Slider(msg) {
  Slider(..s, size: Some(sz))
}

/// Marks the slider as disabled.
pub fn disabled(s: Slider(msg)) -> Slider(msg) {
  Slider(..s, disabled: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(s: Slider(msg), st: List(Style)) -> Slider(msg) {
  Slider(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(s: Slider(msg), a: List(attribute.Attribute(msg))) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_input(s: Slider(msg), msg: fn(String) -> msg) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, [event.on_input(msg)]))
}

pub fn on_change(s: Slider(msg), msg: fn(String) -> msg) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, [event.on_change(msg)]))
}

pub fn on_focus(s: Slider(msg), msg: msg) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(s: Slider(msg), msg: msg) -> Slider(msg) {
  Slider(..s, attrs: list.append(s.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "range-primary"
    variant.Secondary -> "range-secondary"
    variant.Accent -> "range-accent"
    variant.Neutral -> "range-neutral"
    variant.Info -> "range-info"
    variant.Success -> "range-success"
    variant.Warning -> "range-warning"
    variant.Error -> "range-error"
    variant.Ghost | variant.Link | variant.Outline -> ""
  }
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
      option.map(s.variant, variant_class),
      option.map(s.size, size_class),
      case style.to_class_string(s.styles) {
        "" -> None
        st -> Some(st)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let opt_attr = fn(maybe, to_attr) {
    case maybe {
      None -> []
      Some(v) -> [to_attr(v)]
    }
  }

  html.input(list.flatten([
    [
      attribute.class(classes),
      attribute.type_("range"),
      attribute.disabled(s.disabled),
    ],
    opt_attr(s.min, fn(n) { attribute.min(int.to_string(n)) }),
    opt_attr(s.max, fn(n) { attribute.max(int.to_string(n)) }),
    opt_attr(s.step, fn(n) { attribute.step(int.to_string(n)) }),
    opt_attr(s.value, fn(n) { attribute.value(int.to_string(n)) }),
    s.attrs,
  ]))
}
