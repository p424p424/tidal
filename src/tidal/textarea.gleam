/// Textarea component — renders as a `<textarea>` with DaisyUI `textarea` classes.
///
/// ```gleam
/// import tidal/textarea
/// import tidal/variant
///
/// textarea.new()
/// |> textarea.placeholder("Write your message…")
/// |> textarea.rows(5)
/// |> textarea.variant(variant.Primary)
/// |> textarea.on_input(UserTyped)
/// |> textarea.build
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

pub opaque type Textarea(msg) {
  Textarea(
    placeholder: String,
    value: Option(String),
    rows: Option(Int),
    variant: Option(Variant),
    size: Option(Size),
    disabled: Bool,
    required: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Textarea(msg) {
  Textarea(
    placeholder: "",
    value: None,
    rows: None,
    variant: None,
    size: None,
    disabled: False,
    required: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the placeholder text.
pub fn placeholder(t: Textarea(msg), text: String) -> Textarea(msg) {
  Textarea(..t, placeholder: text)
}

/// Sets a controlled value.
pub fn value(t: Textarea(msg), v: String) -> Textarea(msg) {
  Textarea(..t, value: Some(v))
}

/// Sets the number of visible rows.
pub fn rows(t: Textarea(msg), n: Int) -> Textarea(msg) {
  Textarea(..t, rows: Some(n))
}

/// Sets the variant (colour role).
pub fn variant(t: Textarea(msg), v: Variant) -> Textarea(msg) {
  Textarea(..t, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(t: Textarea(msg), s: Size) -> Textarea(msg) {
  Textarea(..t, size: Some(s))
}

/// Marks the textarea as disabled.
pub fn disabled(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, disabled: True)
}

/// Marks the textarea as required.
pub fn required(t: Textarea(msg)) -> Textarea(msg) {
  Textarea(..t, required: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(t: Textarea(msg), s: List(Style)) -> Textarea(msg) {
  Textarea(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  t: Textarea(msg),
  a: List(attribute.Attribute(msg)),
) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_input(t: Textarea(msg), msg: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_input(msg)]))
}

pub fn on_change(t: Textarea(msg), msg: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_change(msg)]))
}

pub fn on_focus(t: Textarea(msg), msg: msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(t: Textarea(msg), msg: msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_blur(msg)]))
}

pub fn on_keydown(t: Textarea(msg), msg: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_keydown(msg)]))
}

pub fn on_keyup(t: Textarea(msg), msg: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_keyup(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "textarea-primary"
    variant.Secondary -> "textarea-secondary"
    variant.Accent -> "textarea-accent"
    variant.Neutral -> "textarea-neutral"
    variant.Ghost -> "textarea-ghost"
    variant.Info -> "textarea-info"
    variant.Success -> "textarea-success"
    variant.Warning -> "textarea-warning"
    variant.Error -> "textarea-error"
    variant.Link | variant.Outline -> ""
  }
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "textarea-xs"
    size.Sm -> "textarea-sm"
    size.Md -> ""
    size.Lg -> "textarea-lg"
    size.Xl -> "textarea-xl"
  }
}

pub fn build(t: Textarea(msg)) -> Element(msg) {
  let classes =
    [
      Some("textarea"),
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

  let base_attrs = [
    attribute.class(classes),
    attribute.placeholder(t.placeholder),
    attribute.disabled(t.disabled),
    attribute.required(t.required),
  ]

  let rows_attrs = case t.rows {
    None -> []
    Some(n) -> [attribute.rows(n)]
  }

  let content = case t.value {
    None -> ""
    Some(v) -> v
  }

  html.textarea(list.flatten([base_attrs, rows_attrs, t.attrs]), content)
}
