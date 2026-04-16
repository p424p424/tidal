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
/// |> join.children([
///   html.button([attribute.class("btn join-item")], [html.text("One")]),
///   html.button([attribute.class("btn join-item")], [html.text("Two")]),
///   html.button([attribute.class("btn join-item")], [html.text("Three")]),
/// ])
/// |> join.build
/// ```

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

pub fn new() -> Join(msg) {
  Join(direction: None, styles: [], attrs: [], children: [])
}

pub fn vertical(j: Join(msg)) -> Join(msg) { Join(..j, direction: Some("join-vertical")) }
pub fn horizontal(j: Join(msg)) -> Join(msg) { Join(..j, direction: Some("join-horizontal")) }

pub fn style(j: Join(msg), s: List(Style)) -> Join(msg) {
  Join(..j, styles: list.append(j.styles, s))
}

pub fn attrs(j: Join(msg), a: List(Attribute(msg))) -> Join(msg) {
  Join(..j, attrs: list.append(j.attrs, a))
}

pub fn children(j: Join(msg), c: List(Element(msg))) -> Join(msg) {
  Join(..j, children: c)
}

pub fn build(j: Join(msg)) -> Element(msg) {
  let base =
    [Some("join"), j.direction]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(j.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.div([attribute.class(class), ..j.attrs], j.children)
}
