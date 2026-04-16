/// Checkbox component — renders as `<input type="checkbox">` with DaisyUI `checkbox` classes.
///
/// ```gleam
/// import tidal/checkbox
/// import tidal/variant
///
/// checkbox.new()
/// |> checkbox.variant(variant.Primary)
/// |> checkbox.on_check(UserAgreedToTerms)
/// |> checkbox.build
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

pub opaque type Checkbox(msg) {
  Checkbox(
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

pub fn new() -> Checkbox(msg) {
  Checkbox(
    checked: False,
    variant: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the checked state.
pub fn checked(c: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..c, checked: True)
}

/// Sets the variant (colour role).
pub fn variant(c: Checkbox(msg), v: Variant) -> Checkbox(msg) {
  Checkbox(..c, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(c: Checkbox(msg), s: Size) -> Checkbox(msg) {
  Checkbox(..c, size: Some(s))
}

/// Marks the checkbox as disabled.
pub fn disabled(c: Checkbox(msg)) -> Checkbox(msg) {
  Checkbox(..c, disabled: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(c: Checkbox(msg), s: List(Style)) -> Checkbox(msg) {
  Checkbox(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  c: Checkbox(msg),
  a: List(attribute.Attribute(msg)),
) -> Checkbox(msg) {
  Checkbox(..c, attrs: list.append(c.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_check(c: Checkbox(msg), msg: fn(Bool) -> msg) -> Checkbox(msg) {
  Checkbox(..c, attrs: list.append(c.attrs, [event.on_check(msg)]))
}

pub fn on_focus(c: Checkbox(msg), msg: msg) -> Checkbox(msg) {
  Checkbox(..c, attrs: list.append(c.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(c: Checkbox(msg), msg: msg) -> Checkbox(msg) {
  Checkbox(..c, attrs: list.append(c.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "checkbox-primary"
    variant.Secondary -> "checkbox-secondary"
    variant.Accent -> "checkbox-accent"
    variant.Neutral -> "checkbox-neutral"
    variant.Info -> "checkbox-info"
    variant.Success -> "checkbox-success"
    variant.Warning -> "checkbox-warning"
    variant.Error -> "checkbox-error"
    variant.Ghost | variant.Link | variant.Outline -> ""
  }
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "checkbox-xs"
    size.Sm -> "checkbox-sm"
    size.Md -> ""
    size.Lg -> "checkbox-lg"
    size.Xl -> "checkbox-xl"
  }
}

pub fn build(c: Checkbox(msg)) -> Element(msg) {
  let classes =
    [
      Some("checkbox"),
      option.map(c.variant, variant_class),
      option.map(c.size, size_class),
      case style.to_class_string(c.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(cl) { cl != "" })
    |> string.join(" ")

  html.input([
    attribute.class(classes),
    attribute.type_("checkbox"),
    attribute.checked(c.checked),
    attribute.disabled(c.disabled),
    ..c.attrs
  ])
}
