/// Countdown — slot-machine style timer display.
///
/// ```gleam
/// import tidal/countdown
///
/// countdown.new()
/// |> countdown.hours(to: model.hours)
/// |> countdown.minutes(to: model.minutes)
/// |> countdown.seconds(to: model.seconds)
/// |> countdown.show_labels
/// |> countdown.build
/// ```
///
/// See also:
/// - DaisyUI countdown docs: https://daisyui.com/components/countdown/
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

/// Creates a new `Countdown` builder. Add `hours(to:)`, `minutes(to:)`, `seconds(to:)` etc., then `build`.
///
/// ```gleam
/// import tidal/countdown
///
/// countdown.new()
/// |> countdown.hours(to: model.hours)
/// |> countdown.minutes(to: model.minutes)
/// |> countdown.seconds(to: model.seconds)
/// |> countdown.show_labels
/// |> countdown.build
/// ```
///
/// See also:
/// - DaisyUI countdown docs: https://daisyui.com/components/countdown/
pub fn new() -> Countdown(msg) {
  Countdown(
    days: None,
    hours: None,
    minutes: None,
    seconds: None,
    show_labels: False,
    digits: None,
    styles: [],
    attrs: [],
  )
}

/// Days digit group.
pub fn days(countdown: Countdown(msg), to value: Int) -> Countdown(msg) {
  Countdown(..countdown, days: Some(value))
}

/// Hours digit group.
pub fn hours(countdown: Countdown(msg), to value: Int) -> Countdown(msg) {
  Countdown(..countdown, hours: Some(value))
}

/// Minutes digit group.
pub fn minutes(countdown: Countdown(msg), to value: Int) -> Countdown(msg) {
  Countdown(..countdown, minutes: Some(value))
}

/// Seconds digit group.
pub fn seconds(countdown: Countdown(msg), to value: Int) -> Countdown(msg) {
  Countdown(..countdown, seconds: Some(value))
}

/// Show "days / hours / min / sec" labels below each digit group.
pub fn show_labels(countdown: Countdown(msg)) -> Countdown(msg) {
  Countdown(..countdown, show_labels: True)
}

/// Zero-pad digits to 2 places — sets `--digits: 2` on each group.
pub fn two_digits(countdown: Countdown(msg)) -> Countdown(msg) {
  Countdown(..countdown, digits: Some(2))
}

/// Zero-pad digits to 3 places — sets `--digits: 3` on each group.
pub fn three_digits(countdown: Countdown(msg)) -> Countdown(msg) {
  Countdown(..countdown, digits: Some(3))
}

/// Appends Tailwind utility styles.
pub fn style(
  countdown: Countdown(msg),
  styles styles: List(Style),
) -> Countdown(msg) {
  Countdown(..countdown, styles: list.append(countdown.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  countdown: Countdown(msg),
  attributes attributes: List(Attribute(msg)),
) -> Countdown(msg) {
  Countdown(..countdown, attrs: list.append(countdown.attrs, attributes))
}

fn digit_group(
  value: Int,
  label: String,
  show_lbl: Bool,
  digits: Option(Int),
) -> Element(msg) {
  let style_val = case digits {
    None -> "--value:" <> int.to_string(value)
    Some(d) ->
      "--value:" <> int.to_string(value) <> ";--digits:" <> int.to_string(d)
  }
  let span_el = html.span([attribute.attribute("style", style_val)], [])
  let count_el = html.span([attribute.class("countdown")], [span_el])
  case show_lbl {
    False -> count_el
    True ->
      html.div([attribute.class("flex flex-col items-center")], [
        count_el,
        html.span([attribute.class("text-xs")], [html.text(label)]),
      ])
  }
}

pub fn build(countdown: Countdown(msg)) -> Element(msg) {
  let groups =
    [
      option.map(countdown.days, fn(n) {
        digit_group(n, "days", countdown.show_labels, countdown.digits)
      }),
      option.map(countdown.hours, fn(n) {
        digit_group(n, "hours", countdown.show_labels, countdown.digits)
      }),
      option.map(countdown.minutes, fn(n) {
        digit_group(n, "min", countdown.show_labels, countdown.digits)
      }),
      option.map(countdown.seconds, fn(n) {
        digit_group(n, "sec", countdown.show_labels, countdown.digits)
      }),
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  let cls = case style.to_class_string(countdown.styles) {
    "" -> "flex gap-4 items-end"
    s -> "flex gap-4 items-end " <> s
  }
  html.div([attribute.class(cls), ..countdown.attrs], groups)
}
