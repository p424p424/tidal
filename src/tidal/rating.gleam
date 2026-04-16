/// Star rating input — a group of radio inputs styled as stars.
///
/// ```gleam
/// import tidal/rating
/// import tidal/size
///
/// rating.new()
/// |> rating.name("product-rating")
/// |> rating.value(model.stars)
/// |> rating.max(5)
/// |> rating.size(size.Lg)
/// |> rating.on_change(UserRated)
/// |> rating.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

pub opaque type Rating(msg) {
  Rating(
    name: String,
    value: Int,
    max: Int,
    half: Bool,
    allow_clear: Bool,
    size: Option(String),
    on_change: Option(fn(Int) -> msg),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Rating(msg) {
  Rating(
    name: "rating",
    value: 0,
    max: 5,
    half: False,
    allow_clear: False,
    size: None,
    on_change: None,
    styles: [],
    attrs: [],
  )
}

/// Radio group name — required when multiple ratings appear on the same page.
pub fn name(r: Rating(msg), n: String) -> Rating(msg) { Rating(..r, name: n) }

/// Currently selected star (1-based; 0 = none selected).
pub fn value(r: Rating(msg), n: Int) -> Rating(msg) { Rating(..r, value: n) }

/// Total number of stars. Defaults to 5.
pub fn max(r: Rating(msg), n: Int) -> Rating(msg) { Rating(..r, max: n) }

/// Enable half-star ratings (adds `rating-half` class).
pub fn half(r: Rating(msg)) -> Rating(msg) { Rating(..r, half: True) }

/// Add a hidden first radio that allows the rating to be cleared.
pub fn allow_clear(r: Rating(msg)) -> Rating(msg) { Rating(..r, allow_clear: True) }

/// Sets the rating size.
pub fn size(r: Rating(msg), s: Size) -> Rating(msg) {
  let cls = case s {
    size.Xs -> "rating-xs"
    size.Sm -> "rating-sm"
    size.Md -> "rating-md"
    size.Lg -> "rating-lg"
    size.Xl -> "rating-xl"
  }
  Rating(..r, size: Some(cls))
}

/// Fires when the selected star changes. Receives the 1-based star index.
pub fn on_change(r: Rating(msg), f: fn(Int) -> msg) -> Rating(msg) {
  Rating(..r, on_change: Some(f))
}

/// Appends Tailwind utility styles.
pub fn style(r: Rating(msg), s: List(Style)) -> Rating(msg) {
  Rating(..r, styles: list.append(r.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(r: Rating(msg), a: List(Attribute(msg))) -> Rating(msg) {
  Rating(..r, attrs: list.append(r.attrs, a))
}

fn int_range(from: Int, to: Int) -> List(Int) {
  case from > to {
    True -> []
    False -> [from, ..int_range(from + 1, to)]
  }
}

pub fn build(r: Rating(msg)) -> Element(msg) {
  let base_class =
    [
      Some("rating"),
      case r.half { True -> Some("rating-half") False -> None },
      r.size,
      case style.to_class_string(r.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let clear_el = case r.allow_clear {
    False -> []
    True -> [
      html.input([
        attribute.type_("radio"),
        attribute.name(r.name),
        attribute.class("rating-hidden"),
        attribute.checked(r.value == 0),
      ]),
    ]
  }

  let star_els =
    int_range(1, r.max)
    |> list.map(fn(i) {
      let click_attrs = case r.on_change {
        None -> []
        Some(f) -> [event.on_click(f(i))]
      }
      let base = [
        attribute.type_("radio"),
        attribute.name(r.name),
        attribute.class("mask mask-star-2 bg-orange-400"),
        attribute.checked(i == r.value),
      ]
      html.input(list.append(base, click_attrs))
    })

  html.div([attribute.class(base_class), ..r.attrs], list.append(clear_el, star_els))
}
