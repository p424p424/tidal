/// List — styled list with optional row borders.
///
/// ```gleam
/// import tidal/list_display
/// import lustre/attribute
/// import lustre/element/html
///
/// list_display.new()
/// |> list_display.items(elements: [
///   list_display.item([html.text("Item one")]),
///   list_display.item([html.text("Item two")]),
/// ])
/// |> list_display.build
/// ```
///
/// See also:
/// - DaisyUI list docs: https://daisyui.com/components/list/
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

/// Creates a new `ListDisplay` builder.
///
/// Chain builder functions to configure the list, then call `build`:
///
/// ```gleam
/// import tidal/list_display
///
/// list_display.new()
/// |> list_display.items(elements: [
///   list_display.item([html.text("Item one")]),
///   list_display.item([html.text("Item two")]),
/// ])
/// |> list_display.build
/// ```
///
/// See also:
/// - DaisyUI list docs: https://daisyui.com/components/list/
pub fn new() -> ListDisplay(msg) {
  ListDisplay(styles: [], attrs: [], items: [])
}

pub fn style(
  lst: ListDisplay(msg),
  styles styles: List(Style),
) -> ListDisplay(msg) {
  ListDisplay(..lst, styles: list.append(lst.styles, styles))
}

pub fn attrs(
  lst: ListDisplay(msg),
  attributes attributes: List(Attribute(msg)),
) -> ListDisplay(msg) {
  ListDisplay(..lst, attrs: list.append(lst.attrs, attributes))
}

pub fn items(
  lst: ListDisplay(msg),
  elements elements: List(Element(msg)),
) -> ListDisplay(msg) {
  ListDisplay(..lst, items: list.append(lst.items, elements))
}

/// A single list row.
pub fn item(children: List(Element(msg))) -> Element(msg) {
  html.li([attribute.class("list-row")], children)
}

pub fn build(lst: ListDisplay(msg)) -> Element(msg) {
  let class = case to_class_string(lst.styles) {
    "" -> "list"
    extra -> "list " <> extra
  }
  html.ul([attribute.class(class), ..lst.attrs], lst.items)
}
