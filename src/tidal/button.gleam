/// Button component — renders as a `<button>` with DaisyUI `btn` classes.
///
/// ```gleam
/// import tidal/button
/// import tidal/variant
/// import tidal/size
///
/// button.new("Save")
/// |> button.variant(variant.Primary)
/// |> button.size(size.Lg)
/// |> button.on_click(UserClickedSave)
/// |> button.build
/// ```
///
/// For icon buttons or custom content, use `children` instead of the string label:
///
/// ```gleam
/// button.new("")
/// |> button.children([icon, label_el])
/// |> button.on_click(UserClickedSave)
/// |> button.build
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

pub opaque type Button(msg) {
  Button(
    label: String,
    variant: Option(Variant),
    size: Option(Size),
    disabled: Bool,
    wide: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
    children: List(Element(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new(label: String) -> Button(msg) {
  Button(
    label: label,
    variant: None,
    size: None,
    disabled: False,
    wide: False,
    styles: [],
    attrs: [],
    children: [],
  )
}

/// Sets the button variant (colour role).
pub fn variant(b: Button(msg), v: Variant) -> Button(msg) {
  Button(..b, variant: Some(v))
}

/// Sets the button size. Defaults to `Md` (no extra class).
pub fn size(b: Button(msg), s: Size) -> Button(msg) {
  Button(..b, size: Some(s))
}

/// Marks the button as disabled.
pub fn disabled(b: Button(msg)) -> Button(msg) {
  Button(..b, disabled: True)
}

/// Adds `btn-wide` for a wider minimum width.
pub fn wide(b: Button(msg)) -> Button(msg) {
  Button(..b, wide: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(b: Button(msg), s: List(Style)) -> Button(msg) {
  Button(..b, styles: list.append(b.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(b: Button(msg), a: List(attribute.Attribute(msg))) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, a))
}

/// Replaces the string label with custom child elements (e.g. icons + text).
/// May be called multiple times — children accumulate.
pub fn children(b: Button(msg), c: List(Element(msg))) -> Button(msg) {
  Button(..b, children: list.append(b.children, c))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

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

pub fn on_keydown(b: Button(msg), msg: fn(String) -> msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_keydown(msg)]))
}

pub fn on_keyup(b: Button(msg), msg: fn(String) -> msg) -> Button(msg) {
  Button(..b, attrs: list.append(b.attrs, [event.on_keyup(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "btn-primary"
    variant.Secondary -> "btn-secondary"
    variant.Accent -> "btn-accent"
    variant.Neutral -> "btn-neutral"
    variant.Ghost -> "btn-ghost"
    variant.Link -> "btn-link"
    variant.Outline -> "btn-outline"
    variant.Info -> "btn-info"
    variant.Success -> "btn-success"
    variant.Warning -> "btn-warning"
    variant.Error -> "btn-error"
  }
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
      option.map(b.variant, variant_class),
      option.map(b.size, size_class),
      case b.wide { True -> Some("btn-wide") False -> None },
      case b.disabled { True -> Some("btn-disabled") False -> None },
      case style.to_class_string(b.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let content = case b.children {
    [] -> [element.text(b.label)]
    c -> c
  }

  let disabled_attr = case b.disabled {
    True -> [attribute.disabled(True)]
    False -> []
  }

  html.button(
    [attribute.class(classes), ..list.append(disabled_attr, b.attrs)],
    content,
  )
}

