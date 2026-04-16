/// Hero — full-width section for large title, description, and CTA.
///
/// ```gleam
/// import tidal/hero
/// import lustre/element/html
///
/// hero.new()
/// |> hero.min_h_screen
/// |> hero.content([
///   html.div([attribute.class("text-center")], [
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
    min_h_screen: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
    content: List(Element(msg)),
  )
}

/// Create a new hero section — renders `<div class="hero">`.
pub fn new() -> Hero(msg) {
  Hero(bg_image: None, overlay: False, min_h_screen: False, styles: [], attrs: [], content: [])
}

/// Sets a background image URL — `style="background-image: url(…)"`.
pub fn bg_image(h: Hero(msg), url: String) -> Hero(msg) {
  Hero(..h, bg_image: Some(url))
}

/// Adds a dark overlay over the background image — `hero-overlay`.
pub fn overlay(h: Hero(msg)) -> Hero(msg) { Hero(..h, overlay: True) }

/// Makes the hero fill the full viewport height — `min-h-screen`.
pub fn min_h_screen(h: Hero(msg)) -> Hero(msg) { Hero(..h, min_h_screen: True) }

/// Sets the main hero content — wraps `els` in `<div class="hero-content">`.
pub fn content(h: Hero(msg), els: List(Element(msg))) -> Hero(msg) {
  let wrapped = html.div([attribute.class("hero-content")], els)
  Hero(..h, content: list.append(h.content, [wrapped]))
}

/// Appends Tailwind utility styles.
pub fn style(h: Hero(msg), s: List(Style)) -> Hero(msg) {
  Hero(..h, styles: list.append(h.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(h: Hero(msg), a: List(Attribute(msg))) -> Hero(msg) {
  Hero(..h, attrs: list.append(h.attrs, a))
}

pub fn build(h: Hero(msg)) -> Element(msg) {
  let bg_attr = case h.bg_image {
    Some(url) -> [attribute.attribute("style", "background-image: url(" <> url <> ");")]
    None -> []
  }
  let overlay_el = case h.overlay {
    True -> [html.div([attribute.class("hero-overlay")], [])]
    False -> []
  }
  let extra_class = to_class_string(h.styles)
  let class =
    "hero"
    <> case h.min_h_screen { True -> " min-h-screen" False -> "" }
    <> case extra_class { "" -> "" c -> " " <> c }
  html.div(
    [attribute.class(class), ..list.append(bg_attr, h.attrs)],
    list.append(overlay_el, h.content),
  )
}
