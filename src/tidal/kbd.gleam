/// Kbd — keyboard key display.
///
/// ```gleam
/// import tidal/kbd
/// import tidal/size
///
/// kbd.new("⌘") |> kbd.build
/// kbd.new("ctrl") |> kbd.size(size.Sm) |> kbd.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/size.{type Size}

pub opaque type Kbd(msg) {
  Kbd(content: String, size: Option(String), attrs: List(Attribute(msg)))
}

pub fn new(content: String) -> Kbd(msg) {
  Kbd(content: content, size: None, attrs: [])
}

pub fn size(k: Kbd(msg), s: Size) -> Kbd(msg) {
  let cls = case s {
    size.Xs -> Some("kbd-xs")
    size.Sm -> Some("kbd-sm")
    size.Md -> Some("kbd-md")
    size.Lg -> Some("kbd-lg")
    size.Xl -> Some("kbd-xl")
  }
  Kbd(..k, size: cls)
}

pub fn attrs(k: Kbd(msg), a: List(Attribute(msg))) -> Kbd(msg) {
  Kbd(..k, attrs: list.append(k.attrs, a))
}

pub fn build(k: Kbd(msg)) -> Element(msg) {
  let class =
    [Some("kbd"), k.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.kbd([attribute.class(class), ..k.attrs], [html.text(k.content)])
}
