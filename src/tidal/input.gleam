/// Text input — `<input class="input">`.
///
/// ```gleam
/// import tidal/input
///
/// input.new()
/// |> input.placeholder("Email address")
/// |> input.type_(input.Email)
/// |> input.primary
/// |> input.on_input(UserTypedEmail)
/// |> input.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

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
    color: Option(String),
    ghost: Bool,
    size: Option(Size),
    disabled: Bool,
    required: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Input(msg) {
  Input(
    type_: Text,
    placeholder: "",
    value: None,
    color: None,
    ghost: False,
    size: None,
    disabled: False,
    required: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the HTML input type. Defaults to `Text`.
pub fn type_(i: Input(msg), t: InputType) -> Input(msg) { Input(..i, type_: t) }

/// Placeholder text shown when empty.
pub fn placeholder(i: Input(msg), text: String) -> Input(msg) { Input(..i, placeholder: text) }

/// Controlled value.
pub fn value(i: Input(msg), v: String) -> Input(msg) { Input(..i, value: Some(v)) }

pub fn primary(i: Input(msg)) -> Input(msg) { Input(..i, color: Some("input-primary")) }
pub fn secondary(i: Input(msg)) -> Input(msg) { Input(..i, color: Some("input-secondary")) }
pub fn accent(i: Input(msg)) -> Input(msg) { Input(..i, color: Some("input-accent")) }
pub fn neutral(i: Input(msg)) -> Input(msg) { Input(..i, color: Some("input-neutral")) }
pub fn info(i: Input(msg)) -> Input(msg) { Input(..i, color: Some("input-info")) }
pub fn success(i: Input(msg)) -> Input(msg) { Input(..i, color: Some("input-success")) }
pub fn warning(i: Input(msg)) -> Input(msg) { Input(..i, color: Some("input-warning")) }
pub fn error(i: Input(msg)) -> Input(msg) { Input(..i, color: Some("input-error")) }

/// Minimal ghost style — no visible border by default.
pub fn ghost(i: Input(msg)) -> Input(msg) { Input(..i, ghost: True) }

/// Sets the input size.
pub fn size(i: Input(msg), s: Size) -> Input(msg) { Input(..i, size: Some(s)) }

/// Marks the input as disabled.
pub fn disabled(i: Input(msg)) -> Input(msg) { Input(..i, disabled: True) }

/// Marks the input as required.
pub fn required(i: Input(msg)) -> Input(msg) { Input(..i, required: True) }

/// Appends Tailwind utility styles.
pub fn style(i: Input(msg), s: List(Style)) -> Input(msg) {
  Input(..i, styles: list.append(i.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(i: Input(msg), a: List(Attribute(msg))) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, a))
}

pub fn on_input(i: Input(msg), f: fn(String) -> msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_input(f)]))
}
pub fn on_change(i: Input(msg), f: fn(String) -> msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_change(f)]))
}
pub fn on_focus(i: Input(msg), msg: msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(i: Input(msg), msg: msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_blur(msg)]))
}
pub fn on_keydown(i: Input(msg), f: fn(String) -> msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_keydown(f)]))
}
pub fn on_keyup(i: Input(msg), f: fn(String) -> msg) -> Input(msg) {
  Input(..i, attrs: list.append(i.attrs, [event.on_keyup(f)]))
}

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
      i.color,
      case i.ghost { True -> Some("input-ghost") False -> None },
      option.map(i.size, size_class),
      case style.to_class_string(i.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let value_attrs = case i.value { None -> [] Some(v) -> [attribute.value(v)] }
  let base_attrs = [
    attribute.class(classes),
    attribute.type_(type_string(i.type_)),
    attribute.placeholder(i.placeholder),
    attribute.disabled(i.disabled),
    attribute.required(i.required),
  ]
  html.input(list.flatten([base_attrs, value_attrs, i.attrs]))
}
