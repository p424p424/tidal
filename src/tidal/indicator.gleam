/// Indicator — overlay a badge or dot on the corner of another element.
///
/// ```gleam
/// import tidal/indicator
/// import lustre/attribute
/// import lustre/element/html
///
/// indicator.new()
/// |> indicator.children([
///   indicator.item([html.text("3")])
///   |> indicator.item_attrs([attribute.class("badge badge-primary")])
///   |> indicator.item_build,
///   html.button([attribute.class("btn")], [html.text("Inbox")]),
/// ])
/// |> indicator.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Indicator(msg) {
  Indicator(styles: List(Style), attrs: List(Attribute(msg)), children: List(Element(msg)))
}

pub opaque type IndicatorItem(msg) {
  IndicatorItem(
    h: Option(String),
    v: Option(String),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

pub fn new() -> Indicator(msg) {
  Indicator(styles: [], attrs: [], children: [])
}

pub fn style(ind: Indicator(msg), s: List(Style)) -> Indicator(msg) {
  Indicator(..ind, styles: list.append(ind.styles, s))
}

pub fn attrs(ind: Indicator(msg), a: List(Attribute(msg))) -> Indicator(msg) {
  Indicator(..ind, attrs: list.append(ind.attrs, a))
}

pub fn children(ind: Indicator(msg), c: List(Element(msg))) -> Indicator(msg) {
  Indicator(..ind, children: c)
}

pub fn build(ind: Indicator(msg)) -> Element(msg) {
  let class = case to_class_string(ind.styles) {
    "" -> "indicator"
    extra -> "indicator " <> extra
  }
  html.div([attribute.class(class), ..ind.attrs], ind.children)
}

// ---------------------------------------------------------------------------
// Indicator item
// ---------------------------------------------------------------------------

pub fn item(children: List(Element(msg))) -> IndicatorItem(msg) {
  IndicatorItem(h: None, v: None, attrs: [], children: children)
}

pub fn item_start(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, h: Some("indicator-start"))
}
pub fn item_center(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, h: Some("indicator-center"))
}
pub fn item_end(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, h: Some("indicator-end"))
}
pub fn item_top(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, v: Some("indicator-top"))
}
pub fn item_middle(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, v: Some("indicator-middle"))
}
pub fn item_bottom(i: IndicatorItem(msg)) -> IndicatorItem(msg) {
  IndicatorItem(..i, v: Some("indicator-bottom"))
}

pub fn item_attrs(i: IndicatorItem(msg), a: List(Attribute(msg))) -> IndicatorItem(msg) {
  IndicatorItem(..i, attrs: list.append(i.attrs, a))
}

pub fn item_build(i: IndicatorItem(msg)) -> Element(msg) {
  let class =
    [Some("indicator-item"), i.v, i.h]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.span([attribute.class(class), ..i.attrs], i.children)
}
