/// Hero — full-width section for large title, description, and CTA.
///
/// ```gleam
/// import tidal/hero
/// import lustre/attribute
///
/// hero.new()
/// |> hero.attrs([attribute.class("bg-base-200 min-h-screen")])
/// |> hero.children([
///   hero.content([attribute.class("text-center")], [
///     html.h1([attribute.class("text-5xl font-bold")], [html.text("Hello")]),
///   ]),
/// ])
/// |> hero.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Hero(msg) {
  Hero(
    bg_image: Option(String),
    overlay: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

pub fn new() -> Hero(msg) {
  Hero(bg_image: None, overlay: False, styles: [], attrs: [], children: [])
}

pub fn bg_image(h: Hero(msg), url: String) -> Hero(msg) {
  Hero(..h, bg_image: Some(url))
}

pub fn overlay(h: Hero(msg)) -> Hero(msg) { Hero(..h, overlay: True) }

pub fn style(h: Hero(msg), s: List(Style)) -> Hero(msg) {
  Hero(..h, styles: list.append(h.styles, s))
}

pub fn attrs(h: Hero(msg), a: List(Attribute(msg))) -> Hero(msg) {
  Hero(..h, attrs: list.append(h.attrs, a))
}

pub fn children(h: Hero(msg), c: List(Element(msg))) -> Hero(msg) {
  Hero(..h, children: c)
}

/// Renders `<div class="hero-content" …attrs>children</div>`.
pub fn content(
  attrs: List(Attribute(msg)),
  children: List(Element(msg)),
) -> Element(msg) {
  html.div([attribute.class("hero-content"), ..attrs], children)
}

pub fn build(h: Hero(msg)) -> Element(msg) {
  let bg_attr = case h.bg_image {
    Some(url) -> [attribute.attribute("style", "background-image: " <> url <> ";")]
    None -> []
  }
  let overlay_el = case h.overlay {
    True -> [html.div([attribute.class("hero-overlay")], [])]
    False -> []
  }
  let extra_class = to_class_string(h.styles)
  let class = case extra_class {
    "" -> "hero"
    c -> "hero " <> c
  }
  html.div(
    [attribute.class(class), ..list.append(bg_attr, h.attrs)],
    list.append(overlay_el, h.children),
  )
}
