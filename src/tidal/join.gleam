/// Join — group adjacent elements into a seamless connected unit.
///
/// Apply `class="join-item"` to each child to opt into the grouped styling.
///
/// ```gleam
/// import tidal/join
/// import lustre/attribute
/// import lustre/element/html
///
/// join.new()
/// |> join.children(elements: [
///   html.button([attribute.class("btn join-item")], [html.text("One")]),
///   html.button([attribute.class("btn join-item")], [html.text("Two")]),
///   html.button([attribute.class("btn join-item")], [html.text("Three")]),
/// ])
/// |> join.build
/// ```
///
/// See also:
/// - DaisyUI join docs: https://daisyui.com/components/join/
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Join(msg) {
  Join(
    direction: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

/// Creates a new `Join` container — groups children into a connected unit.
///
/// Chain builder functions to configure the join, then call `build`:
///
/// ```gleam
/// import tidal/join
///
/// join.new()
/// |> join.children(elements: [btn1, btn2, btn3])
/// |> join.build
/// ```
///
/// See also:
/// - DaisyUI join docs: https://daisyui.com/components/join/
pub fn new() -> Join(msg) {
  Join(direction: None, styles: [], attrs: [], children: [])
}

pub fn vertical(jn: Join(msg)) -> Join(msg) {
  Join(..jn, direction: Some("join-vertical"))
}

pub fn horizontal(jn: Join(msg)) -> Join(msg) {
  Join(..jn, direction: Some("join-horizontal"))
}

pub fn style(jn: Join(msg), styles styles: List(Style)) -> Join(msg) {
  Join(..jn, styles: list.append(jn.styles, styles))
}

pub fn attrs(
  jn: Join(msg),
  attributes attributes: List(Attribute(msg)),
) -> Join(msg) {
  Join(..jn, attrs: list.append(jn.attrs, attributes))
}

pub fn children(
  jn: Join(msg),
  elements elements: List(Element(msg)),
) -> Join(msg) {
  Join(..jn, children: list.append(jn.children, elements))
}

pub fn build(jn: Join(msg)) -> Element(msg) {
  let base =
    [Some("join"), jn.direction]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(jn.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.div([attribute.class(class), ..jn.attrs], jn.children)
}
