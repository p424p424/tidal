/// Carousel — horizontal or vertical scroll-snap slide container.
///
/// ```gleam
/// import tidal/carousel
/// import lustre/attribute
/// import lustre/element/html
///
/// carousel.new()
/// |> carousel.vertical
/// |> carousel.full_width
/// |> carousel.items([
///   carousel.item([html.img([attribute.src("/img/1.jpg")])]),
///   carousel.item([html.img([attribute.src("/img/2.jpg")])]),
/// ])
/// |> carousel.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Carousel(msg) {
  Carousel(
    vertical: Bool,
    snap: Option(String),
    full: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

pub fn new() -> Carousel(msg) {
  Carousel(vertical: False, snap: None, full: False, styles: [], attrs: [], items: [])
}

pub fn vertical(c: Carousel(msg)) -> Carousel(msg) { Carousel(..c, vertical: True) }

/// Snap items to the start (default behaviour).
pub fn snap_start(c: Carousel(msg)) -> Carousel(msg) {
  Carousel(..c, snap: Some("carousel-center"))
}

/// Snap items to the centre.
pub fn snap_center(c: Carousel(msg)) -> Carousel(msg) {
  Carousel(..c, snap: Some("carousel-center"))
}

/// Snap items to the end.
pub fn snap_end(c: Carousel(msg)) -> Carousel(msg) {
  Carousel(..c, snap: Some("carousel-end"))
}

/// Each slide takes 100% width of the container.
pub fn full_width(c: Carousel(msg)) -> Carousel(msg) { Carousel(..c, full: True) }

pub fn style(c: Carousel(msg), s: List(Style)) -> Carousel(msg) {
  Carousel(..c, styles: list.append(c.styles, s))
}

pub fn attrs(c: Carousel(msg), a: List(Attribute(msg))) -> Carousel(msg) {
  Carousel(..c, attrs: list.append(c.attrs, a))
}

pub fn items(c: Carousel(msg), i: List(Element(msg))) -> Carousel(msg) {
  Carousel(..c, items: i)
}

/// Wraps children in a `<div class="carousel-item">`.
pub fn item(children: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("carousel-item")], children)
}

/// Like `item` but stretched to fill the container width.
pub fn item_full(children: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("carousel-item w-full")], children)
}

pub fn build(c: Carousel(msg)) -> Element(msg) {
  let base =
    [
      Some("carousel"),
      case c.vertical { True -> Some("carousel-vertical") False -> None },
      c.snap,
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(c.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.div([attribute.class(class), ..c.attrs], c.items)
}
