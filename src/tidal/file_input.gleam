/// File input component — renders as `<input type="file">` with DaisyUI `file-input` classes.
///
/// ```gleam
/// import tidal/file_input
/// import tidal/variant
///
/// file_input.new()
/// |> file_input.accept(".pdf,.docx")
/// |> file_input.variant(variant.Primary)
/// |> file_input.on_change(UserSelectedFile)
/// |> file_input.build
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

pub opaque type FileInput(msg) {
  FileInput(
    accept: Option(String),
    multiple: Bool,
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

pub fn new() -> FileInput(msg) {
  FileInput(
    accept: None,
    multiple: False,
    variant: None,
    size: None,
    disabled: False,
    styles: [],
    attrs: [],
  )
}

/// Sets the accepted file types, e.g. `".png,.jpg"` or `"image/*"`.
pub fn accept(f: FileInput(msg), types: String) -> FileInput(msg) {
  FileInput(..f, accept: Some(types))
}

/// Allows multiple files to be selected.
pub fn multiple(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, multiple: True)
}

/// Sets the variant (colour role).
pub fn variant(f: FileInput(msg), v: Variant) -> FileInput(msg) {
  FileInput(..f, variant: Some(v))
}

/// Sets the size. Defaults to `Md` (no extra class).
pub fn size(f: FileInput(msg), s: Size) -> FileInput(msg) {
  FileInput(..f, size: Some(s))
}

/// Marks the file input as disabled.
pub fn disabled(f: FileInput(msg)) -> FileInput(msg) {
  FileInput(..f, disabled: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(f: FileInput(msg), s: List(Style)) -> FileInput(msg) {
  FileInput(..f, styles: list.append(f.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  f: FileInput(msg),
  a: List(attribute.Attribute(msg)),
) -> FileInput(msg) {
  FileInput(..f, attrs: list.append(f.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_change(f: FileInput(msg), msg: fn(String) -> msg) -> FileInput(msg) {
  FileInput(..f, attrs: list.append(f.attrs, [event.on_change(msg)]))
}

pub fn on_focus(f: FileInput(msg), msg: msg) -> FileInput(msg) {
  FileInput(..f, attrs: list.append(f.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(f: FileInput(msg), msg: msg) -> FileInput(msg) {
  FileInput(..f, attrs: list.append(f.attrs, [event.on_blur(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "file-input-primary"
    variant.Secondary -> "file-input-secondary"
    variant.Accent -> "file-input-accent"
    variant.Neutral -> "file-input-neutral"
    variant.Ghost -> "file-input-ghost"
    variant.Info -> "file-input-info"
    variant.Success -> "file-input-success"
    variant.Warning -> "file-input-warning"
    variant.Error -> "file-input-error"
    variant.Link | variant.Outline -> ""
  }
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
      option.map(f.variant, variant_class),
      option.map(f.size, size_class),
      case style.to_class_string(f.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let accept_attrs = case f.accept {
    None -> []
    Some(types) -> [attribute.attribute("accept", types)]
  }

  html.input(list.flatten([
    [
      attribute.class(classes),
      attribute.type_("file"),
      attribute.multiple(f.multiple),
      attribute.disabled(f.disabled),
    ],
    accept_attrs,
    f.attrs,
  ]))
}
