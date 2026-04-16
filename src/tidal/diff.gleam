/// Diff — side-by-side content comparison with a draggable divider.
///
/// ```gleam
/// import tidal/diff
/// import lustre/attribute
/// import lustre/element/html
///
/// diff.new()
/// |> diff.first([html.img([attribute.src("/before.png")])])
/// |> diff.second([html.img([attribute.src("/after.png")])])
/// |> diff.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Diff(msg) {
  Diff(
    first: Option(Element(msg)),
    second: Option(Element(msg)),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Diff(msg) {
  Diff(first: None, second: None, styles: [], attrs: [])
}

pub fn first(d: Diff(msg), children: List(Element(msg))) -> Diff(msg) {
  Diff(..d, first: Some(html.div([attribute.class("diff-item-1")], children)))
}

pub fn second(d: Diff(msg), children: List(Element(msg))) -> Diff(msg) {
  Diff(..d, second: Some(html.div([attribute.class("diff-item-2")], children)))
}

pub fn style(d: Diff(msg), s: List(Style)) -> Diff(msg) {
  Diff(..d, styles: list.append(d.styles, s))
}

pub fn attrs(d: Diff(msg), a: List(Attribute(msg))) -> Diff(msg) {
  Diff(..d, attrs: list.append(d.attrs, a))
}

pub fn build(d: Diff(msg)) -> Element(msg) {
  let class = case to_class_string(d.styles) {
    "" -> "diff aspect-[16/9]"
    extra -> "diff aspect-[16/9] " <> extra
  }
  let resizer = html.div([attribute.class("diff-resizer")], [])
  let children =
    [d.first, d.second]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.append([resizer])
  html.div([attribute.class(class), ..d.attrs], children)
}
