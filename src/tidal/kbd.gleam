/// Kbd — keyboard key display.
///
/// ```gleam
/// import tidal/kbd
/// import tidal/size
///
/// kbd.new() |> kbd.label("⌘") |> kbd.build
/// kbd.new() |> kbd.label("ctrl") |> kbd.size(size.Sm) |> kbd.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/size.{type Size}
import tidal/style.{type Style}

pub opaque type Kbd(msg) {
  Kbd(
    label: String,
    size: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Create a new keyboard key. Use `label(t)` to set the key text.
pub fn new() -> Kbd(msg) {
  Kbd(label: "", size: None, styles: [], attrs: [])
}

/// Sets the key label text.
pub fn label(k: Kbd(msg), text: String) -> Kbd(msg) { Kbd(..k, label: text) }

/// Sets the kbd size.
pub fn size(k: Kbd(msg), s: Size) -> Kbd(msg) {
  let cls = case s {
    size.Xs -> Some("kbd-xs")
    size.Sm -> Some("kbd-sm")
    size.Md -> None
    size.Lg -> Some("kbd-lg")
    size.Xl -> Some("kbd-xl")
  }
  Kbd(..k, size: cls)
}

/// Appends Tailwind utility styles.
pub fn style(k: Kbd(msg), s: List(Style)) -> Kbd(msg) {
  Kbd(..k, styles: list.append(k.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(k: Kbd(msg), a: List(Attribute(msg))) -> Kbd(msg) {
  Kbd(..k, attrs: list.append(k.attrs, a))
}

pub fn build(k: Kbd(msg)) -> Element(msg) {
  let class =
    [Some("kbd"), k.size, case style.to_class_string(k.styles) { "" -> None s -> Some(s) }]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.kbd([attribute.class(class), ..k.attrs], [html.text(k.label)])
}
