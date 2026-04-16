/// Rating — star/heart rating input.
///
/// ```gleam
/// import tidal/rating
/// import tidal/size
///
/// rating.new()
/// |> rating.size(size.Lg)
/// |> rating.stars("product-rating", 5, 3, "mask-star-2", "bg-orange-400")
/// |> rating.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/size.{type Size}

pub opaque type Rating(msg) {
  Rating(
    size: Option(String),
    half: Bool,
    gap: Bool,
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

pub fn new() -> Rating(msg) {
  Rating(size: None, half: False, gap: False, attrs: [], children: [])
}

pub fn size(r: Rating(msg), s: Size) -> Rating(msg) {
  let cls = case s {
    size.Xs -> Some("rating-xs")
    size.Sm -> Some("rating-sm")
    size.Md -> Some("rating-md")
    size.Lg -> Some("rating-lg")
    size.Xl -> Some("rating-xl")
  }
  Rating(..r, size: cls)
}

/// Enable half-star mode.
pub fn half(r: Rating(msg)) -> Rating(msg) { Rating(..r, half: True) }

/// Add `gap-1` spacing between items.
pub fn gap(r: Rating(msg)) -> Rating(msg) { Rating(..r, gap: True) }

pub fn attrs(r: Rating(msg), a: List(Attribute(msg))) -> Rating(msg) {
  Rating(..r, attrs: list.append(r.attrs, a))
}

/// Generate `count` uniform star inputs sharing `name`.
/// `checked_index` is 1-based (0 = none checked).
/// `mask_class` e.g. `"mask-star-2"`, `color_class` e.g. `"bg-orange-400"`.
pub fn stars(
  r: Rating(msg),
  name: String,
  count: Int,
  checked_index: Int,
  mask_class: String,
  color_class: String,
) -> Rating(msg) {
  let inputs =
    int_range(1, count)
    |> list.map(fn(i) {
      let extra = case color_class {
        "" -> mask_class
        c -> mask_class <> " " <> c
      }
      let base_attrs = [
        attribute.type_("radio"),
        attribute.name(name),
        attribute.class("mask " <> extra),
      ]
      let all_attrs = case i == checked_index {
        True -> list.append(base_attrs, [attribute.checked(True)])
        False -> base_attrs
      }
      html.input(all_attrs)
    })
  Rating(..r, children: inputs)
}

pub fn build(r: Rating(msg)) -> Element(msg) {
  let class =
    [
      Some("rating"),
      r.size,
      case r.half { True -> Some("rating-half") False -> None },
      case r.gap { True -> Some("gap-1") False -> None },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.div([attribute.class(class), ..r.attrs], r.children)
}

fn int_range(from: Int, to: Int) -> List(Int) {
  int_range_acc(from, to, [])
}

fn int_range_acc(from: Int, to: Int, acc: List(Int)) -> List(Int) {
  case from > to {
    True -> list.reverse(acc)
    False -> int_range_acc(from + 1, to, [from, ..acc])
  }
}

