/// Countdown — slot-machine style number display.
///
/// ```gleam
/// import tidal/countdown
/// import tidal/size
///
/// countdown.new(42)
/// |> countdown.size(size.Lg)
/// |> countdown.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/size.{type Size}
import tidal/style.{type Style, to_class_string}

pub opaque type Countdown(msg) {
  Countdown(
    value: Int,
    size: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new(value: Int) -> Countdown(msg) {
  Countdown(value: value, size: None, styles: [], attrs: [])
}

pub fn size(c: Countdown(msg), s: Size) -> Countdown(msg) {
  let cls = case s {
    size.Xs -> Some("countdown-xs")
    size.Sm -> Some("countdown-sm")
    size.Md -> Some("countdown-md")
    size.Lg -> Some("countdown-lg")
    size.Xl -> Some("countdown-xl")
  }
  Countdown(..c, size: cls)
}

pub fn style(c: Countdown(msg), s: List(Style)) -> Countdown(msg) {
  Countdown(..c, styles: list.append(c.styles, s))
}

pub fn attrs(c: Countdown(msg), a: List(Attribute(msg))) -> Countdown(msg) {
  Countdown(..c, attrs: list.append(c.attrs, a))
}

pub fn build(c: Countdown(msg)) -> Element(msg) {
  let base =
    [Some("countdown"), c.size]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(c.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  let span_el =
    html.span(
      [attribute.attribute("style", "--value:" <> int.to_string(c.value))],
      [],
    )
  html.span([attribute.class(class), ..c.attrs], [span_el])
}
