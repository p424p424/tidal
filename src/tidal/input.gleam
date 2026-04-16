/// Text input component — renders as an `<input>` with DaisyUI `input` classes.
///
/// ```gleam
/// import tidal/input
/// import tidal/variant
/// import tidal/size
///
/// input.new()
/// |> input.placeholder("Email address")
/// |> input.type_(input.Email)
/// |> input.variant(variant.Primary)
/// |> input.on_input(UserTyped)
/// |> input.build
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
// Types
// ---------------------------------------------------------------------------

pub type InputType {
  Text
  Email
  Password
  Number
  Tel
  Url
  Search
}

pub opaque type Input(msg) {
  Input(
    type_: InputType,
    placeholder: String,
    value: Option(String),
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

pub fn new() -> Input(msg) {
  Input(
    type_: Text,
    placeholder: "",
    value: None,
    variant: None,
    size: None,
    disabled: False,
    required: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the HTML input type. Defaults to `Text`.
pub fn type_(i: Input(msg), t: InputType) -> Input(msg) {
  Input(..i, type_: t)
}

/// Sets the placeholder text.
pub fn placeholder(i: Input(msg), text: String) -> Input(msg) {
  Input(..i, placeholder: text)
}

/// Sets a controlled value.
pub fn value(i: Input(msg), v: String) -> Input(msg) {
  Input(..i, value: Some(v))
}

/// Sets the variant (colour role).
pub fn variant(i: Input(msg), v: Variant) -> Input(msg) {
  Input(..i, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(i: Input(msg), s: Size) -> Input(msg) {
  Input(..i, size: Some(s))
}

/// Marks the input as disabled.
pub fn disabled(i: Input(msg)) -> Input(msg) {
  Input(..i, disabled: True)
}

/// Marks the input as required.
pub fn required(i: Input(msg)) -> Input(msg) {
  Input(..i, required: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(i: Input(msg), s: List(Style)) -> Input(msg) {
  Input(..i, styles: list.append(i.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(i: Input(msg), a: List(attribute.Attribute(msg))) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_input(i: Input(msg), msg: fn(String) -> msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_input(msg)]))
}

pub fn on_change(i: Input(msg), msg: fn(String) -> msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_change(msg)]))
}

pub fn on_focus(i: Input(msg), msg: msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(i: Input(msg), msg: msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_blur(msg)]))
}

pub fn on_keydown(i: Input(msg), msg: fn(String) -> msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_keydown(msg)]))
}

pub fn on_keyup(i: Input(msg), msg: fn(String) -> msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_keyup(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn type_string(t: InputType) -> String {
  case t {
    Text -> "text"
    Email -> "email"
    Password -> "password"
    Number -> "number"
    Tel -> "tel"
    Url -> "url"
    Search -> "search"
  }
}

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "input-primary"
    variant.Secondary -> "input-secondary"
    variant.Accent -> "input-accent"
    variant.Neutral -> "input-neutral"
    variant.Ghost -> "input-ghost"
    variant.Info -> "input-info"
    variant.Success -> "input-success"
    variant.Warning -> "input-warning"
    variant.Error -> "input-error"
    variant.Link | variant.Outline -> ""
  }
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "input-xs"
    size.Sm -> "input-sm"
    size.Md -> ""
    size.Lg -> "input-lg"
    size.Xl -> "input-xl"
  }
}

pub fn build(i: Input(msg)) -> Element(msg) {
  let classes =
    [
      Some("input"),
      option.map(i.variant, variant_class),
      option.map(i.size, size_class),
      case style.to_class_string(i.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let base_attrs = [
    attribute.class(classes),
    attribute.type_(type_string(i.type_)),
    attribute.placeholder(i.placeholder),
    attribute.disabled(i.disabled),
    attribute.required(i.required),
  ]

  let value_attrs = case i.value {
    None -> []
    Some(v) -> [attribute.value(v)]
  }

  html.input(list.flatten([base_attrs, value_attrs, i.attrs]))
}
