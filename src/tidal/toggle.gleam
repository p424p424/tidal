/// Toggle component — renders as `<input type="checkbox">` with DaisyUI `toggle` classes.
///
/// ```gleam
/// import tidal/toggle
/// import tidal/variant
///
/// toggle.new()
/// |> toggle.variant(variant.Primary)
/// |> toggle.on_check(UserToggledDarkMode)
/// |> toggle.build
/// ```

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

pub opaque type Toggle(msg) {
  Toggle(
    checked: Bool,
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

pub fn new() -> Toggle(msg) {
  Toggle(
    checked: False,
    variant: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the checked state.
pub fn checked(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, checked: True)
}

/// Sets the variant (colour role).
pub fn variant(t: Toggle(msg), v: Variant) -> Toggle(msg) {
  Toggle(..t, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(t: Toggle(msg), s: Size) -> Toggle(msg) {
  Toggle(..t, size: Some(s))
}

/// Marks the toggle as disabled.
pub fn disabled(t: Toggle(msg)) -> Toggle(msg) {
  Toggle(..t, disabled: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(t: Toggle(msg), s: List(Style)) -> Toggle(msg) {
  Toggle(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(t: Toggle(msg), a: List(attribute.Attribute(msg))) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_check(t: Toggle(msg), msg: fn(Bool) -> msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_check(msg)]))
}

pub fn on_focus(t: Toggle(msg), msg: msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(t: Toggle(msg), msg: msg) -> Toggle(msg) {
  Toggle(..t, attrs: list.append(t.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "toggle-primary"
    variant.Secondary -> "toggle-secondary"
    variant.Accent -> "toggle-accent"
    variant.Neutral -> "toggle-neutral"
    variant.Info -> "toggle-info"
    variant.Success -> "toggle-success"
    variant.Warning -> "toggle-warning"
    variant.Error -> "toggle-error"
    variant.Ghost | variant.Link | variant.Outline -> ""
  }
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "toggle-xs"
    size.Sm -> "toggle-sm"
    size.Md -> ""
    size.Lg -> "toggle-lg"
    size.Xl -> "toggle-xl"
  }
}

pub fn build(t: Toggle(msg)) -> Element(msg) {
  let classes =
    [
      Some("toggle"),
      option.map(t.variant, variant_class),
      option.map(t.size, size_class),
      case style.to_class_string(t.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  html.input([
    attribute.class(classes),
    attribute.type_("checkbox"),
    attribute.checked(t.checked),
    attribute.disabled(t.disabled),
    ..t.attrs
  ])
}
