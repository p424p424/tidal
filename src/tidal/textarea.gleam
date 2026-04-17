/// Textarea — `<textarea class="textarea">`.
///
/// ```gleam
/// import tidal/textarea
///
/// textarea.new()
/// |> textarea.placeholder(text: "Write your message…")
/// |> textarea.rows(count: 4)
/// |> textarea.primary
/// |> textarea.on_input(UserTyped)
/// |> textarea.build
/// ```
///
/// See also:
/// - DaisyUI textarea docs: https://daisyui.com/components/textarea/
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

/// Creates a new `Textarea` builder with all options at their defaults.
///
/// Chain builder functions to configure the textarea, then call `build`:
///
/// ```gleam
/// import tidal/textarea
///
/// textarea.new()
/// |> textarea.placeholder(text: "Write your message…")
/// |> textarea.rows(count: 4)
/// |> textarea.primary
/// |> textarea.on_input(UserTyped)
/// |> textarea.build
/// ```
///
/// See also:
/// - DaisyUI textarea docs: https://daisyui.com/components/textarea/
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
pub fn placeholder(textarea: Textarea(msg), text text: String) -> Textarea(msg) {
  Textarea(..textarea, placeholder: text)
}

/// Controlled value.
pub fn value(textarea: Textarea(msg), to content: String) -> Textarea(msg) {
  Textarea(..textarea, value: Some(content))
}

/// Number of visible rows.
pub fn rows(textarea: Textarea(msg), count count: Int) -> Textarea(msg) {
  Textarea(..textarea, rows: Some(count))
}

pub fn primary(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, color: Some("textarea-primary"))
}

pub fn secondary(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, color: Some("textarea-secondary"))
}

pub fn accent(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, color: Some("textarea-accent"))
}

pub fn neutral(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, color: Some("textarea-neutral"))
}

pub fn info(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, color: Some("textarea-info"))
}

pub fn success(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, color: Some("textarea-success"))
}

pub fn warning(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, color: Some("textarea-warning"))
}

pub fn error(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, color: Some("textarea-error"))
}

/// Minimal ghost style.
pub fn ghost(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, ghost: True)
}

/// Sets the textarea size.
pub fn size(textarea: Textarea(msg), size size: Size) -> Textarea(msg) {
  Textarea(..textarea, size: Some(size))
}

/// Marks the textarea as disabled.
pub fn disabled(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, disabled: True)
}

/// Marks the textarea as required.
pub fn required(textarea: Textarea(msg)) -> Textarea(msg) {
  Textarea(..textarea, required: True)
}

/// Appends Tailwind utility styles.
pub fn style(
  textarea: Textarea(msg),
  styles styles: List(Style),
) -> Textarea(msg) {
  Textarea(..textarea, styles: list.append(textarea.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  textarea: Textarea(msg),
  attributes attributes: List(Attribute(msg)),
) -> Textarea(msg) {
  Textarea(..textarea, attrs: list.append(textarea.attrs, attributes))
}

pub fn on_input(
  textarea: Textarea(msg),
  handler handler: fn(String) -> msg,
) -> Textarea(msg) {
  Textarea(
    ..textarea,
    attrs: list.append(textarea.attrs, [event.on_input(handler)]),
  )
}

pub fn on_change(
  textarea: Textarea(msg),
  handler handler: fn(String) -> msg,
) -> Textarea(msg) {
  Textarea(
    ..textarea,
    attrs: list.append(textarea.attrs, [event.on_change(handler)]),
  )
}

pub fn on_focus(textarea: Textarea(msg), msg: msg) -> Textarea(msg) {
  Textarea(
    ..textarea,
    attrs: list.append(textarea.attrs, [event.on_focus(msg)]),
  )
}

pub fn on_blur(textarea: Textarea(msg), msg: msg) -> Textarea(msg) {
  Textarea(..textarea, attrs: list.append(textarea.attrs, [event.on_blur(msg)]))
}

pub fn on_keydown(
  textarea: Textarea(msg),
  handler handler: fn(String) -> msg,
) -> Textarea(msg) {
  Textarea(
    ..textarea,
    attrs: list.append(textarea.attrs, [event.on_keydown(handler)]),
  )
}

pub fn on_keyup(
  textarea: Textarea(msg),
  handler handler: fn(String) -> msg,
) -> Textarea(msg) {
  Textarea(
    ..textarea,
    attrs: list.append(textarea.attrs, [event.on_keyup(handler)]),
  )
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

pub fn build(textarea: Textarea(msg)) -> Element(msg) {
  let classes =
    [
      Some("textarea"),
      textarea.color,
      case textarea.ghost {
        True -> Some("textarea-ghost")
        False -> None
      },
      option.map(textarea.size, size_class),
      case style.to_class_string(textarea.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let rows_attrs = case textarea.rows {
    None -> []
    Some(n) -> [attribute.rows(n)]
  }
  let content = case textarea.value {
    None -> ""
    Some(v) -> v
  }
  let base_attrs = [
    attribute.class(classes),
    attribute.placeholder(textarea.placeholder),
    attribute.disabled(textarea.disabled),
    attribute.required(textarea.required),
  ]
  html.textarea(list.flatten([base_attrs, rows_attrs, textarea.attrs]), content)
}
