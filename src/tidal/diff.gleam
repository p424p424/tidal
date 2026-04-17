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
///
/// See also:
/// - DaisyUI diff docs: https://daisyui.com/components/diff/
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

/// Creates a new `Diff` — renders a side-by-side comparison with a draggable divider.
///
/// Chain builder functions to set the two items, then call `build`:
///
/// ```gleam
/// import tidal/diff
///
/// diff.new()
/// |> diff.item_a(element: html.img([attribute.src("/before.png")]))
/// |> diff.item_b(element: html.img([attribute.src("/after.png")]))
/// |> diff.build
/// ```
///
/// See also:
/// - DaisyUI diff docs: https://daisyui.com/components/diff/
pub fn new() -> Diff(msg) {
  Diff(item_a: None, item_b: None, styles: [], attrs: [])
}

/// First (left) item — wraps in `diff-item-1`.
pub fn item_a(diff: Diff(msg), element element: Element(msg)) -> Diff(msg) {
  Diff(
    ..diff,
    item_a: Some(html.div([attribute.class("diff-item-1")], [element])),
  )
}

/// Second (right) item — wraps in `diff-item-2`.
pub fn item_b(diff: Diff(msg), element element: Element(msg)) -> Diff(msg) {
  Diff(
    ..diff,
    item_b: Some(html.div([attribute.class("diff-item-2")], [element])),
  )
}

/// Appends Tailwind utility styles. Use for sizing (`w-full`, `aspect-[16/9]` etc.).
pub fn style(diff: Diff(msg), styles styles: List(Style)) -> Diff(msg) {
  Diff(..diff, styles: list.append(diff.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  diff: Diff(msg),
  attributes attributes: List(Attribute(msg)),
) -> Diff(msg) {
  Diff(..diff, attrs: list.append(diff.attrs, attributes))
}

pub fn build(diff: Diff(msg)) -> Element(msg) {
  let class = case style.to_class_string(diff.styles) {
    "" -> "diff aspect-[16/9]"
    extra -> "diff aspect-[16/9] " <> extra
  }
  let resizer = html.div([attribute.class("diff-resizer")], [])
  let children =
    [diff.item_a, diff.item_b]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.append([resizer])
  html.figure([attribute.class(class), ..diff.attrs], children)
}
