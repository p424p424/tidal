/// Textarea — `<textarea class="textarea">`.
///
/// ```gleam
/// import tidal/textarea
///
/// textarea.new()
/// |> textarea.placeholder("Write your message…")
/// |> textarea.rows(4)
/// |> textarea.primary
/// |> textarea.on_input(UserTyped)
/// |> textarea.build
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

pub opaque type Textarea(msg) {
  Textarea(
    placeholder: String,
    value: Option(String),
    rows: Option(Int),
    color: Option(String),
    ghost: Bool,
    size: Option(Size),
    disabled: Bool,
    required: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Textarea(msg) {
  Textarea(
    placeholder: "",
    value: None,
    rows: None,
    color: None,
    ghost: False,
    size: None,
    disabled: False,
    required: False,
    styles: [],
    attrs: [],
  )
}

/// Placeholder text shown when empty.
pub fn placeholder(t: Textarea(msg), text: String) -> Textarea(msg) { Textarea(..t, placeholder: text) }

/// Controlled value.
pub fn value(t: Textarea(msg), v: String) -> Textarea(msg) { Textarea(..t, value: Some(v)) }

/// Number of visible rows.
pub fn rows(t: Textarea(msg), n: Int) -> Textarea(msg) { Textarea(..t, rows: Some(n)) }

pub fn primary(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, color: Some("textarea-primary")) }
pub fn secondary(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, color: Some("textarea-secondary")) }
pub fn accent(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, color: Some("textarea-accent")) }
pub fn neutral(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, color: Some("textarea-neutral")) }
pub fn info(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, color: Some("textarea-info")) }
pub fn success(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, color: Some("textarea-success")) }
pub fn warning(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, color: Some("textarea-warning")) }
pub fn error(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, color: Some("textarea-error")) }

/// Minimal ghost style.
pub fn ghost(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, ghost: True) }

/// Sets the textarea size.
pub fn size(t: Textarea(msg), s: Size) -> Textarea(msg) { Textarea(..t, size: Some(s)) }

/// Marks the textarea as disabled.
pub fn disabled(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, disabled: True) }

/// Marks the textarea as required.
pub fn required(t: Textarea(msg)) -> Textarea(msg) { Textarea(..t, required: True) }

/// Appends Tailwind utility styles.
pub fn style(t: Textarea(msg), s: List(Style)) -> Textarea(msg) {
  Textarea(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(t: Textarea(msg), a: List(Attribute(msg))) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, a))
}

pub fn on_input(t: Textarea(msg), f: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_input(f)]))
}
pub fn on_change(t: Textarea(msg), f: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_change(f)]))
}
pub fn on_focus(t: Textarea(msg), msg: msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(t: Textarea(msg), msg: msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_blur(msg)]))
}
pub fn on_keydown(t: Textarea(msg), f: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_keydown(f)]))
}
pub fn on_keyup(t: Textarea(msg), f: fn(String) -> msg) -> Textarea(msg) {
  Textarea(..t, attrs: list.append(t.attrs, [event.on_keyup(f)]))
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
      t.color,
      case t.ghost { True -> Some("textarea-ghost") False -> None },
      option.map(t.size, size_class),
      case style.to_class_string(t.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let rows_attrs = case t.rows { None -> [] Some(n) -> [attribute.rows(n)] }
  let content = case t.value { None -> "" Some(v) -> v }
  let base_attrs = [
    attribute.class(classes),
    attribute.placeholder(t.placeholder),
    attribute.disabled(t.disabled),
    attribute.required(t.required),
  ]
  html.textarea(list.flatten([base_attrs, rows_attrs, t.attrs]), content)
}
