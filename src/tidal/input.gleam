/// Text input — `<input class="input">`.
///
/// ```gleam
/// import tidal/input
///
/// input.new()
/// |> input.placeholder(text: "Email address")
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

/// Creates a new `Input` builder with all options at their defaults.
///
/// Chain builder functions to configure the input, then call `build`:
///
/// ```gleam
/// import tidal/input
///
/// input.new()
/// |> input.placeholder(text: "Email address")
/// |> input.type_(input.Email)
/// |> input.primary
/// |> input.on_input(UserTypedEmail)
/// |> input.build
/// ```
///
/// See also:
/// - DaisyUI input docs: https://daisyui.com/components/input/
/// - Lustre events: https://hexdocs.pm/lustre/lustre/event.html
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
pub fn type_(input: Input(msg), kind: InputType) -> Input(msg) {
  Input(..input, type_: kind)
}

/// Placeholder text shown when empty.
pub fn placeholder(input: Input(msg), text text: String) -> Input(msg) {
  Input(..input, placeholder: text)
}

/// Controlled value.
pub fn value(input: Input(msg), to to: String) -> Input(msg) {
  Input(..input, value: Some(to))
}

pub fn primary(input: Input(msg)) -> Input(msg) {
  Input(..input, color: Some("input-primary"))
}

pub fn secondary(input: Input(msg)) -> Input(msg) {
  Input(..input, color: Some("input-secondary"))
}

pub fn accent(input: Input(msg)) -> Input(msg) {
  Input(..input, color: Some("input-accent"))
}

pub fn neutral(input: Input(msg)) -> Input(msg) {
  Input(..input, color: Some("input-neutral"))
}

pub fn info(input: Input(msg)) -> Input(msg) {
  Input(..input, color: Some("input-info"))
}

pub fn success(input: Input(msg)) -> Input(msg) {
  Input(..input, color: Some("input-success"))
}

pub fn warning(input: Input(msg)) -> Input(msg) {
  Input(..input, color: Some("input-warning"))
}

pub fn error(input: Input(msg)) -> Input(msg) {
  Input(..input, color: Some("input-error"))
}

/// Minimal ghost style — no visible border by default.
pub fn ghost(input: Input(msg)) -> Input(msg) {
  Input(..input, ghost: True)
}

/// Sets the input size.
pub fn size(input: Input(msg), size size: Size) -> Input(msg) {
  Input(..input, size: Some(size))
}

/// Marks the input as disabled.
pub fn disabled(input: Input(msg)) -> Input(msg) {
  Input(..input, disabled: True)
}

/// Marks the input as required.
pub fn required(input: Input(msg)) -> Input(msg) {
  Input(..input, required: True)
}

/// Appends Tailwind utility styles.
pub fn style(input: Input(msg), styles styles: List(Style)) -> Input(msg) {
  Input(..input, styles: list.append(input.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  input: Input(msg),
  attributes attributes: List(Attribute(msg)),
) -> Input(msg) {
  Input(..input, attrs: list.append(input.attrs, attributes))
}

pub fn on_input(
  input: Input(msg),
  handler handler: fn(String) -> msg,
) -> Input(msg) {
  Input(..input, attrs: list.append(input.attrs, [event.on_input(handler)]))
}

pub fn on_change(
  input: Input(msg),
  handler handler: fn(String) -> msg,
) -> Input(msg) {
  Input(..input, attrs: list.append(input.attrs, [event.on_change(handler)]))
}

pub fn on_focus(input: Input(msg), msg: msg) -> Input(msg) {
  Input(..input, attrs: list.append(input.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(input: Input(msg), msg: msg) -> Input(msg) {
  Input(..input, attrs: list.append(input.attrs, [event.on_blur(msg)]))
}

pub fn on_keydown(
  input: Input(msg),
  handler handler: fn(String) -> msg,
) -> Input(msg) {
  Input(..input, attrs: list.append(input.attrs, [event.on_keydown(handler)]))
}

pub fn on_keyup(
  input: Input(msg),
  handler handler: fn(String) -> msg,
) -> Input(msg) {
  Input(..input, attrs: list.append(input.attrs, [event.on_keyup(handler)]))
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

pub fn build(input: Input(msg)) -> Element(msg) {
  let classes =
    [
      Some("input"),
      input.color,
      case input.ghost {
        True -> Some("input-ghost")
        False -> None
      },
      option.map(input.size, size_class),
      case style.to_class_string(input.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let value_attrs = case input.value {
    None -> []
    Some(v) -> [attribute.value(v)]
  }
  let base_attrs = [
    attribute.class(classes),
    attribute.type_(type_string(input.type_)),
    attribute.placeholder(input.placeholder),
    attribute.disabled(input.disabled),
    attribute.required(input.required),
  ]
  html.input(list.flatten([base_attrs, value_attrs, input.attrs]))
}
