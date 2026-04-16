/// Diff — side-by-side content comparison with a draggable divider.
///
/// ```gleam
/// import tidal/diff
///
/// diff.new()
/// |> diff.item_a(html.img([attribute.src("/before.png")]))
/// |> diff.item_b(html.img([attribute.src("/after.png")]))
/// |> diff.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Diff(msg) {
  Diff(
    item_a: Option(Element(msg)),
    item_b: Option(Element(msg)),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Diff(msg) {
  Diff(item_a: None, item_b: None, styles: [], attrs: [])
}

/// First (left) item — wraps in `diff-item-1`.
pub fn item_a(d: Diff(msg), el: Element(msg)) -> Diff(msg) {
  Diff(..d, item_a: Some(html.div([attribute.class("diff-item-1")], [el])))
}

/// Second (right) item — wraps in `diff-item-2`.
pub fn item_b(d: Diff(msg), el: Element(msg)) -> Diff(msg) {
  Diff(..d, item_b: Some(html.div([attribute.class("diff-item-2")], [el])))
}

/// Appends Tailwind utility styles. Use for sizing (`w-full`, `aspect-[16/9]` etc.).
pub fn style(d: Diff(msg), s: List(Style)) -> Diff(msg) {
  Diff(..d, styles: list.append(d.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(d: Diff(msg), a: List(Attribute(msg))) -> Diff(msg) {
  Diff(..d, attrs: list.append(d.attrs, a))
}

pub fn build(d: Diff(msg)) -> Element(msg) {
  let class = case style.to_class_string(d.styles) {
    "" -> "diff aspect-[16/9]"
    extra -> "diff aspect-[16/9] " <> extra
  }
  let resizer = html.div([attribute.class("diff-resizer")], [])
  let children =
    [d.item_a, d.item_b]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.append([resizer])
  html.figure([attribute.class(class), ..d.attrs], children)
}
