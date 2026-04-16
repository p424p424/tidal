/// List — styled list with optional row borders.
///
/// ```gleam
/// import tidal/list_display
/// import lustre/attribute
/// import lustre/element/html
///
/// list_display.new()
/// |> list_display.items([
///   list_display.item([html.text("Item one")]),
///   list_display.item([html.text("Item two")]),
/// ])
/// |> list_display.build
/// ```

import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type ListDisplay(msg) {
  ListDisplay(
    styles: List(Style),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

pub fn new() -> ListDisplay(msg) {
  ListDisplay(styles: [], attrs: [], items: [])
}

pub fn style(l: ListDisplay(msg), s: List(Style)) -> ListDisplay(msg) {
  ListDisplay(..l, styles: list.append(l.styles, s))
}

pub fn attrs(l: ListDisplay(msg), a: List(Attribute(msg))) -> ListDisplay(msg) {
  ListDisplay(..l, attrs: list.append(l.attrs, a))
}

pub fn items(l: ListDisplay(msg), i: List(Element(msg))) -> ListDisplay(msg) {
  ListDisplay(..l, items: i)
}

/// A single list row.
pub fn item(children: List(Element(msg))) -> Element(msg) {
  html.li([attribute.class("list-row")], children)
}

pub fn build(l: ListDisplay(msg)) -> Element(msg) {
  let class = case to_class_string(l.styles) {
    "" -> "list"
    extra -> "list " <> extra
  }
  html.ul([attribute.class(class), ..l.attrs], l.items)
}
