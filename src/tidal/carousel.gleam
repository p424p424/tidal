/// Carousel — horizontal or vertical scroll-snap slide container.
///
/// ```gleam
/// import tidal/carousel
/// import lustre/attribute
/// import lustre/element/html
///
/// carousel.new()
/// |> carousel.vertical
/// |> carousel.items(elements: [
///   carousel.slide(html.img([attribute.src("/img/1.jpg")])),
///   carousel.slide(html.img([attribute.src("/img/2.jpg")])),
/// ])
/// |> carousel.build
/// ```
///
/// See also:
/// - DaisyUI carousel docs: https://daisyui.com/components/carousel/
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

/// Creates a new `Carousel` — `<div class="carousel">`.
/// Default snap is to the start of each slide.
///
/// Chain builder functions to configure the carousel, then call `build`:
///
/// ```gleam
/// import tidal/carousel
///
/// carousel.new()
/// |> carousel.items(elements: [
///   carousel.slide(img1),
///   carousel.slide(img2),
/// ])
/// |> carousel.build
/// ```
///
/// See also:
/// - DaisyUI carousel docs: https://daisyui.com/components/carousel/
pub fn new() -> Carousel(msg) {
  Carousel(vertical: False, snap: None, styles: [], attrs: [], items: [])
}

/// Vertical scrolling carousel — `carousel-vertical`.
pub fn vertical(carousel: Carousel(msg)) -> Carousel(msg) {
  Carousel(..carousel, vertical: True)
}

/// Snap slides to the center — `carousel-center`.
pub fn center(carousel: Carousel(msg)) -> Carousel(msg) {
  Carousel(..carousel, snap: Some("carousel-center"))
}

/// Snap slides to the end — `carousel-end`.
pub fn end_(carousel: Carousel(msg)) -> Carousel(msg) {
  Carousel(..carousel, snap: Some("carousel-end"))
}

/// Appends Tailwind utility styles.
pub fn style(
  carousel: Carousel(msg),
  styles styles: List(Style),
) -> Carousel(msg) {
  Carousel(..carousel, styles: list.append(carousel.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  carousel: Carousel(msg),
  attributes attributes: List(Attribute(msg)),
) -> Carousel(msg) {
  Carousel(..carousel, attrs: list.append(carousel.attrs, attributes))
}

/// Appends carousel slide elements.
pub fn items(
  carousel: Carousel(msg),
  elements elements: List(Element(msg)),
) -> Carousel(msg) {
  Carousel(..carousel, items: list.append(carousel.items, elements))
}

/// Wraps a single element in `<div class="carousel-item">`.
pub fn slide(el: Element(msg)) -> Element(msg) {
  html.div([attribute.class("carousel-item")], [el])
}

/// Named slide — `<div class="carousel-item" id="{id}">` for anchor-link navigation.
pub fn slide_id(id: String, el: Element(msg)) -> Element(msg) {
  html.div([attribute.class("carousel-item"), attribute.id(id)], [el])
}

pub fn build(carousel: Carousel(msg)) -> Element(msg) {
  let base =
    [
      Some("carousel"),
      case carousel.vertical {
        True -> Some("carousel-vertical")
        False -> None
      },
      carousel.snap,
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(carousel.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.div([attribute.class(class), ..carousel.attrs], carousel.items)
}
