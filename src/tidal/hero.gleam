/// Hero — full-width section for large title, description, and CTA.
///
/// ```gleam
/// import tidal/hero
/// import lustre/element/html
///
/// hero.new()
/// |> hero.min_h_screen
/// |> hero.content(elements: [
///   html.div([attribute.class("text-center")], [
///     html.h1([attribute.class("text-5xl font-bold")], [html.text("Hello")]),
///   ]),
/// ])
/// |> hero.build
/// ```
///
/// See also:
/// - DaisyUI hero docs: https://daisyui.com/components/hero/
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

/// Creates a new `Hero` section — renders `<div class="hero">`.
///
/// Chain builder functions to configure the hero, then call `build`:
///
/// ```gleam
/// import tidal/hero
///
/// hero.new()
/// |> hero.min_h_screen
/// |> hero.content(elements: [title_el, cta_btn])
/// |> hero.build
/// ```
///
/// See also:
/// - DaisyUI hero docs: https://daisyui.com/components/hero/
pub fn new() -> Hero(msg) {
  Hero(
    bg_image: None,
    overlay: False,
    min_h_screen: False,
    styles: [],
    attrs: [],
    content: [],
  )
}

/// Sets a background image URL — `style="background-image: url(…)"`.
pub fn bg_image(hero: Hero(msg), url url: String) -> Hero(msg) {
  Hero(..hero, bg_image: Some(url))
}

/// Adds a dark overlay over the background image — `hero-overlay`.
pub fn overlay(hero: Hero(msg)) -> Hero(msg) {
  Hero(..hero, overlay: True)
}

/// Makes the hero fill the full viewport height — `min-h-screen`.
pub fn min_h_screen(hero: Hero(msg)) -> Hero(msg) {
  Hero(..hero, min_h_screen: True)
}

/// Sets the main hero content — wraps `elements` in `<div class="hero-content">`.
pub fn content(
  hero: Hero(msg),
  elements elements: List(Element(msg)),
) -> Hero(msg) {
  let wrapped = html.div([attribute.class("hero-content")], elements)
  Hero(..hero, content: list.append(hero.content, [wrapped]))
}

/// Appends Tailwind utility styles.
pub fn style(hero: Hero(msg), styles styles: List(Style)) -> Hero(msg) {
  Hero(..hero, styles: list.append(hero.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  hero: Hero(msg),
  attributes attributes: List(Attribute(msg)),
) -> Hero(msg) {
  Hero(..hero, attrs: list.append(hero.attrs, attributes))
}

pub fn build(hero: Hero(msg)) -> Element(msg) {
  let bg_attr = case hero.bg_image {
    Some(url) -> [
      attribute.attribute("style", "background-image: url(" <> url <> ");"),
    ]
    None -> []
  }
  let overlay_el = case hero.overlay {
    True -> [html.div([attribute.class("hero-overlay")], [])]
    False -> []
  }
  let extra_class = to_class_string(hero.styles)
  let class =
    "hero"
    <> case hero.min_h_screen {
      True -> " min-h-screen"
      False -> ""
    }
    <> case extra_class {
      "" -> ""
      c -> " " <> c
    }
  html.div(
    [attribute.class(class), ..list.append(bg_attr, hero.attrs)],
    list.append(overlay_el, hero.content),
  )
}
