/// Kbd — keyboard key display.
///
/// ```gleam
/// import tidal/kbd
/// import tidal/size
///
/// kbd.new() |> kbd.label(text: "⌘") |> kbd.build
/// kbd.new() |> kbd.label(text: "ctrl") |> kbd.size(size: size.Sm) |> kbd.build
/// ```
///
/// See also:
/// - DaisyUI kbd docs: https://daisyui.com/components/kbd/
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

/// Creates a new `Kbd` builder. Use `label(text:)` to set the key text.
///
/// ```gleam
/// import tidal/kbd
/// import tidal/size
///
/// kbd.new()
/// |> kbd.label(text: "⌘")
/// |> kbd.size(size: size.Sm)
/// |> kbd.build
/// ```
///
/// See also:
/// - DaisyUI kbd docs: https://daisyui.com/components/kbd/
pub fn new() -> Kbd(msg) {
  Kbd(label: "", size: None, styles: [], attrs: [])
}

/// Sets the key label text.
pub fn label(key: Kbd(msg), text text: String) -> Kbd(msg) {
  Kbd(..key, label: text)
}

/// Sets the kbd size.
pub fn size(key: Kbd(msg), size size: Size) -> Kbd(msg) {
  let cls = case size {
    size.Xs -> Some("kbd-xs")
    size.Sm -> Some("kbd-sm")
    size.Md -> None
    size.Lg -> Some("kbd-lg")
    size.Xl -> Some("kbd-xl")
  }
  Kbd(..key, size: cls)
}

/// Appends Tailwind utility styles.
pub fn style(key: Kbd(msg), styles styles: List(Style)) -> Kbd(msg) {
  Kbd(..key, styles: list.append(key.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  key: Kbd(msg),
  attributes attributes: List(Attribute(msg)),
) -> Kbd(msg) {
  Kbd(..key, attrs: list.append(key.attrs, attributes))
}

pub fn build(key: Kbd(msg)) -> Element(msg) {
  let class =
    [
      Some("kbd"),
      key.size,
      case style.to_class_string(key.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.kbd([attribute.class(class), ..key.attrs], [html.text(key.label)])
}
