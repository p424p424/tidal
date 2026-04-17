/// Star rating input — a group of radio inputs styled as stars.
///
/// ```gleam
/// import tidal/rating
/// import tidal/size
///
/// rating.new()
/// |> rating.name(name: "product-rating")
/// |> rating.value(to: model.stars)
/// |> rating.max(to: 5)
/// |> rating.size(size: size.Lg)
/// |> rating.on_change(UserRated)
/// |> rating.build
/// ```
///
/// See also:
/// - DaisyUI rating docs: https://daisyui.com/components/rating/
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

/// Creates a new `Rating` builder with all options at their defaults.
///
/// Chain builder functions to configure the rating, then call `build`:
///
/// ```gleam
/// import tidal/rating
/// import tidal/size
///
/// rating.new()
/// |> rating.name(name: "product-rating")
/// |> rating.value(to: model.stars)
/// |> rating.max(to: 5)
/// |> rating.size(size: size.Lg)
/// |> rating.on_change(UserRated)
/// |> rating.build
/// ```
///
/// See also:
/// - DaisyUI rating docs: https://daisyui.com/components/rating/
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
pub fn name(rating: Rating(msg), name name: String) -> Rating(msg) {
  Rating(..rating, name: name)
}

/// Currently selected star (1-based; 0 = none selected).
pub fn value(rating: Rating(msg), to selected: Int) -> Rating(msg) {
  Rating(..rating, value: selected)
}

/// Total number of stars. Defaults to 5.
pub fn max(rating: Rating(msg), to maximum: Int) -> Rating(msg) {
  Rating(..rating, max: maximum)
}

/// Enable half-star ratings (adds `rating-half` class).
pub fn half(rating: Rating(msg)) -> Rating(msg) {
  Rating(..rating, half: True)
}

/// Add a hidden first radio that allows the rating to be cleared.
pub fn allow_clear(rating: Rating(msg)) -> Rating(msg) {
  Rating(..rating, allow_clear: True)
}

/// Sets the rating size.
pub fn size(rating: Rating(msg), size size: Size) -> Rating(msg) {
  let cls = case size {
    size.Xs -> "rating-xs"
    size.Sm -> "rating-sm"
    size.Md -> "rating-md"
    size.Lg -> "rating-lg"
    size.Xl -> "rating-xl"
  }
  Rating(..rating, size: Some(cls))
}

/// Fires when the selected star changes. Receives the 1-based star index.
pub fn on_change(
  rating: Rating(msg),
  handler handler: fn(Int) -> msg,
) -> Rating(msg) {
  Rating(..rating, on_change: Some(handler))
}

/// Appends Tailwind utility styles.
pub fn style(rating: Rating(msg), styles styles: List(Style)) -> Rating(msg) {
  Rating(..rating, styles: list.append(rating.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  rating: Rating(msg),
  attributes attributes: List(Attribute(msg)),
) -> Rating(msg) {
  Rating(..rating, attrs: list.append(rating.attrs, attributes))
}

fn int_range(from: Int, to: Int) -> List(Int) {
  case from > to {
    True -> []
    False -> [from, ..int_range(from + 1, to)]
  }
}

pub fn build(rating: Rating(msg)) -> Element(msg) {
  let base_class =
    [
      Some("rating"),
      case rating.half {
        True -> Some("rating-half")
        False -> None
      },
      rating.size,
      case style.to_class_string(rating.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let clear_el = case rating.allow_clear {
    False -> []
    True -> [
      html.input([
        attribute.type_("radio"),
        attribute.name(rating.name),
        attribute.class("rating-hidden"),
        attribute.checked(rating.value == 0),
      ]),
    ]
  }

  let star_els =
    int_range(1, rating.max)
    |> list.map(fn(i) {
      let click_attrs = case rating.on_change {
        None -> []
        Some(handler) -> [event.on_click(handler(i))]
      }
      let base = [
        attribute.type_("radio"),
        attribute.name(rating.name),
        attribute.class("mask mask-star-2 bg-orange-400"),
        attribute.checked(i == rating.value),
      ]
      html.input(list.append(base, click_attrs))
    })

  html.div(
    [attribute.class(base_class), ..rating.attrs],
    list.append(clear_el, star_els),
  )
}
