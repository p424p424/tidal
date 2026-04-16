/// File input — `<input type="file" class="file-input">`.
///
/// ```gleam
/// import tidal/file_input
///
/// file_input.new()
/// |> file_input.accept(".pdf,.doc")
/// |> file_input.primary
/// |> file_input.on_change(UserSelectedFile)
/// |> file_input.build
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

pub fn new() -> FileInput(msg) {
  FileInput(accept: None, multiple: False, color: None, ghost: False, size: None, disabled: False, styles: [], attrs: [])
}

/// Accepted file types, e.g. `".png,.jpg"` or `"image/*"`.
pub fn accept(f: FileInput(msg), types: String) -> FileInput(msg) {
  FileInput(..f, accept: Some(types))
}

/// Allow multiple file selection.
pub fn multiple(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, multiple: True) }

pub fn primary(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, color: Some("file-input-primary")) }
pub fn secondary(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, color: Some("file-input-secondary")) }
pub fn accent(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, color: Some("file-input-accent")) }
pub fn neutral(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, color: Some("file-input-neutral")) }
pub fn info(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, color: Some("file-input-info")) }
pub fn success(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, color: Some("file-input-success")) }
pub fn warning(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, color: Some("file-input-warning")) }
pub fn error(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, color: Some("file-input-error")) }

/// Minimal ghost style.
pub fn ghost(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, ghost: True) }

/// Sets the file input size.
pub fn size(f: FileInput(msg), s: Size) -> FileInput(msg) { FileInput(..f, size: Some(s)) }

/// Marks the file input as disabled.
pub fn disabled(f: FileInput(msg)) -> FileInput(msg) { FileInput(..f, disabled: True) }

/// Appends Tailwind utility styles.
pub fn style(f: FileInput(msg), s: List(Style)) -> FileInput(msg) {
  FileInput(..f, styles: list.append(f.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(f: FileInput(msg), a: List(Attribute(msg))) -> FileInput(msg) {
  FileInput(..f, attrs: list.append(f.attrs, a))
}

pub fn on_change(f: FileInput(msg), fn_: fn(String) -> msg) -> FileInput(msg) {
  FileInput(..f, attrs: list.append(f.attrs, [event.on_change(fn_)]))
}
pub fn on_focus(f: FileInput(msg), msg: msg) -> FileInput(msg) {
  FileInput(..f, attrs: list.append(f.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(f: FileInput(msg), msg: msg) -> FileInput(msg) {
  FileInput(..f, attrs: list.append(f.attrs, [event.on_blur(msg)]))
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

pub fn build(f: FileInput(msg)) -> Element(msg) {
  let classes =
    [
      Some("file-input"),
      f.color,
      case f.ghost { True -> Some("file-input-ghost") False -> None },
      option.map(f.size, size_class),
      case style.to_class_string(f.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let accept_attrs = case f.accept { None -> [] Some(t) -> [attribute.attribute("accept", t)] }
  html.input(list.flatten([
    [attribute.class(classes), attribute.type_("file"), attribute.multiple(f.multiple), attribute.disabled(f.disabled)],
    accept_attrs,
    f.attrs,
  ]))
}
