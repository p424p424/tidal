/// Countdown — slot-machine style timer display.
///
/// ```gleam
/// import tidal/countdown
///
/// countdown.new()
/// |> countdown.hours(model.hours)
/// |> countdown.minutes(model.minutes)
/// |> countdown.seconds(model.seconds)
/// |> countdown.show_labels
/// |> countdown.build
/// ```

import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Countdown(msg) {
  Countdown(
    days: Option(Int),
    hours: Option(Int),
    minutes: Option(Int),
    seconds: Option(Int),
    show_labels: Bool,
    digits: Option(Int),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Create a new countdown. Add `hours(n)`, `minutes(n)`, `seconds(n)` etc., then `build`.
pub fn new() -> Countdown(msg) {
  Countdown(days: None, hours: None, minutes: None, seconds: None, show_labels: False, digits: None, styles: [], attrs: [])
}

/// Days digit group.
pub fn days(c: Countdown(msg), n: Int) -> Countdown(msg) { Countdown(..c, days: Some(n)) }
/// Hours digit group.
pub fn hours(c: Countdown(msg), n: Int) -> Countdown(msg) { Countdown(..c, hours: Some(n)) }
/// Minutes digit group.
pub fn minutes(c: Countdown(msg), n: Int) -> Countdown(msg) { Countdown(..c, minutes: Some(n)) }
/// Seconds digit group.
pub fn seconds(c: Countdown(msg), n: Int) -> Countdown(msg) { Countdown(..c, seconds: Some(n)) }

/// Show "days / hours / min / sec" labels below each digit group.
pub fn show_labels(c: Countdown(msg)) -> Countdown(msg) { Countdown(..c, show_labels: True) }

/// Zero-pad digits to 2 places — sets `--digits: 2` on each group.
pub fn two_digits(c: Countdown(msg)) -> Countdown(msg) { Countdown(..c, digits: Some(2)) }
/// Zero-pad digits to 3 places — sets `--digits: 3` on each group.
pub fn three_digits(c: Countdown(msg)) -> Countdown(msg) { Countdown(..c, digits: Some(3)) }

/// Appends Tailwind utility styles.
pub fn style(c: Countdown(msg), s: List(Style)) -> Countdown(msg) {
  Countdown(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(c: Countdown(msg), a: List(Attribute(msg))) -> Countdown(msg) {
  Countdown(..c, attrs: list.append(c.attrs, a))
}

fn digit_group(value: Int, label: String, show_lbl: Bool, digits: Option(Int)) -> Element(msg) {
  let style_val = case digits {
    None -> "--value:" <> int.to_string(value)
    Some(d) -> "--value:" <> int.to_string(value) <> ";--digits:" <> int.to_string(d)
  }
  let span_el = html.span([attribute.attribute("style", style_val)], [])
  let count_el = html.span([attribute.class("countdown")], [span_el])
  case show_lbl {
    False -> count_el
    True ->
      html.div(
        [attribute.class("flex flex-col items-center")],
        [count_el, html.span([attribute.class("text-xs")], [html.text(label)])],
      )
  }
}

pub fn build(c: Countdown(msg)) -> Element(msg) {
  let groups =
    [
      option.map(c.days, fn(n) { digit_group(n, "days", c.show_labels, c.digits) }),
      option.map(c.hours, fn(n) { digit_group(n, "hours", c.show_labels, c.digits) }),
      option.map(c.minutes, fn(n) { digit_group(n, "min", c.show_labels, c.digits) }),
      option.map(c.seconds, fn(n) { digit_group(n, "sec", c.show_labels, c.digits) }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  let cls = case style.to_class_string(c.styles) {
    "" -> "flex gap-4 items-end"
    s -> "flex gap-4 items-end " <> s
  }
  html.div([attribute.class(cls), ..c.attrs], groups)
}
