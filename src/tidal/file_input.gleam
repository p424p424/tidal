/// File input — `<input type="file" class="file-input">`.
///
/// ```gleam
/// import tidal/file_input
///
/// file_input.new()
/// |> file_input.accept(types: ".pdf,.doc")
/// |> file_input.primary
/// |> file_input.on_change(UserSelectedFile)
/// |> file_input.build
/// ```
///
/// See also:
/// - DaisyUI file-input docs: https://daisyui.com/components/file-input/
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

pub opaque type FileInput(msg) {
  FileInput(
    accept: Option(String),
    multiple: Bool,
    color: Option(String),
    ghost: Bool,
    size: Option(Size),
    disabled: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new `FileInput` builder with all options at their defaults.
///
/// Chain builder functions to configure the file input, then call `build`:
///
/// ```gleam
/// import tidal/file_input
///
/// file_input.new()
/// |> file_input.accept(types: ".pdf,.doc")
/// |> file_input.primary
/// |> file_input.on_change(UserSelectedFile)
/// |> file_input.build
/// ```
///
/// See also:
/// - DaisyUI file-input docs: https://daisyui.com/components/file-input/
pub fn new() -> FileInput(msg) {
  FileInput(
    accept: None,
    multiple: False,
    color: None,
    ghost: False,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Accepted file types, e.g. `".png,.jpg"` or `"image/*"`.
pub fn accept(file_input: FileInput(msg), types types: String) -> FileInput(msg) {
  FileInput(..file_input, accept: Some(types))
}

/// Allow multiple file selection.
pub fn multiple(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, multiple: True)
}

pub fn primary(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, color: Some("file-input-primary"))
}

pub fn secondary(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, color: Some("file-input-secondary"))
}

pub fn accent(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, color: Some("file-input-accent"))
}

pub fn neutral(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, color: Some("file-input-neutral"))
}

pub fn info(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, color: Some("file-input-info"))
}

pub fn success(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, color: Some("file-input-success"))
}

pub fn warning(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, color: Some("file-input-warning"))
}

pub fn error(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, color: Some("file-input-error"))
}

/// Minimal ghost style.
pub fn ghost(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, ghost: True)
}

/// Sets the file input size.
pub fn size(file_input: FileInput(msg), size size: Size) -> FileInput(msg) {
  FileInput(..file_input, size: Some(size))
}

/// Marks the file input as disabled.
pub fn disabled(file_input: FileInput(msg)) -> FileInput(msg) {
  FileInput(..file_input, disabled: True)
}

/// Appends Tailwind utility styles.
pub fn style(
  file_input: FileInput(msg),
  styles styles: List(Style),
) -> FileInput(msg) {
  FileInput(..file_input, styles: list.append(file_input.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  file_input: FileInput(msg),
  attributes attributes: List(Attribute(msg)),
) -> FileInput(msg) {
  FileInput(..file_input, attrs: list.append(file_input.attrs, attributes))
}

pub fn on_change(
  file_input: FileInput(msg),
  handler handler: fn(String) -> msg,
) -> FileInput(msg) {
  FileInput(
    ..file_input,
    attrs: list.append(file_input.attrs, [event.on_change(handler)]),
  )
}

pub fn on_focus(file_input: FileInput(msg), msg: msg) -> FileInput(msg) {
  FileInput(
    ..file_input,
    attrs: list.append(file_input.attrs, [event.on_focus(msg)]),
  )
}

pub fn on_blur(file_input: FileInput(msg), msg: msg) -> FileInput(msg) {
  FileInput(
    ..file_input,
    attrs: list.append(file_input.attrs, [event.on_blur(msg)]),
  )
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "file-input-xs"
    size.Sm -> "file-input-sm"
    size.Md -> ""
    size.Lg -> "file-input-lg"
    size.Xl -> "file-input-xl"
  }
}

pub fn build(file_input: FileInput(msg)) -> Element(msg) {
  let classes =
    [
      Some("file-input"),
      file_input.color,
      case file_input.ghost {
        True -> Some("file-input-ghost")
        False -> None
      },
      option.map(file_input.size, size_class),
      case style.to_class_string(file_input.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let accept_attrs = case file_input.accept {
    None -> []
    Some(t) -> [attribute.attribute("accept", t)]
  }
  html.input(
    list.flatten([
      [
        attribute.class(classes),
        attribute.type_("file"),
        attribute.multiple(file_input.multiple),
        attribute.disabled(file_input.disabled),
      ],
      accept_attrs,
      file_input.attrs,
    ]),
  )
}
