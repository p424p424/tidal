/// Carousel — horizontal or vertical scroll-snap slide container.
///
/// ```gleam
/// import tidal/carousel
/// import lustre/attribute
/// import lustre/element/html
///
/// carousel.new()
/// |> carousel.vertical
/// |> carousel.items([
///   carousel.slide(html.img([attribute.src("/img/1.jpg")])),
///   carousel.slide(html.img([attribute.src("/img/2.jpg")])),
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
    styles: List(Style),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

/// Create a new carousel — `<div class="carousel">`.
/// Default snap is to the start of each slide.
pub fn new() -> Carousel(msg) {
  Carousel(vertical: False, snap: None, styles: [], attrs: [], items: [])
}

/// Vertical scrolling carousel — `carousel-vertical`.
pub fn vertical(c: Carousel(msg)) -> Carousel(msg) { Carousel(..c, vertical: True) }

/// Snap slides to the center — `carousel-center`.
pub fn center(c: Carousel(msg)) -> Carousel(msg) { Carousel(..c, snap: Some("carousel-center")) }

/// Snap slides to the end — `carousel-end`.
pub fn end_(c: Carousel(msg)) -> Carousel(msg) { Carousel(..c, snap: Some("carousel-end")) }

/// Appends Tailwind utility styles.
pub fn style(c: Carousel(msg), s: List(Style)) -> Carousel(msg) {
  Carousel(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(c: Carousel(msg), a: List(Attribute(msg))) -> Carousel(msg) {
  Carousel(..c, attrs: list.append(c.attrs, a))
}

/// Appends carousel slide elements.
pub fn items(c: Carousel(msg), i: List(Element(msg))) -> Carousel(msg) {
  Carousel(..c, items: list.append(c.items, i))
}

/// Wraps a single element in `<div class="carousel-item">`.
pub fn slide(el: Element(msg)) -> Element(msg) {
  html.div([attribute.class("carousel-item")], [el])
}

/// Named slide — `<div class="carousel-item" id="{id}">` for anchor-link navigation.
pub fn slide_id(id: String, el: Element(msg)) -> Element(msg) {
  html.div([attribute.class("carousel-item"), attribute.id(id)], [el])
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
