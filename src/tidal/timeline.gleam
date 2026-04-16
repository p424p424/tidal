/// Timeline — vertical or horizontal sequence of events.
///
/// ```gleam
/// import tidal/timeline
/// import lustre/element/html
///
/// timeline.new()
/// |> timeline.vertical
/// |> timeline.items([
///   timeline.item(
///     start: [html.text("2020")],
///     middle: [timeline.dot()],
///     end: [html.p([], [html.text("Founded")])],
///   ),
/// ])
/// |> timeline.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Timeline(msg) {
  Timeline(
    vertical: Bool,
    compact: Bool,
    snap: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

pub fn new() -> Timeline(msg) {
  Timeline(vertical: False, compact: False, snap: False, styles: [], attrs: [], items: [])
}

pub fn vertical(t: Timeline(msg)) -> Timeline(msg) { Timeline(..t, vertical: True) }
pub fn compact(t: Timeline(msg)) -> Timeline(msg) { Timeline(..t, compact: True) }
pub fn snap(t: Timeline(msg)) -> Timeline(msg) { Timeline(..t, snap: True) }

pub fn style(t: Timeline(msg), s: List(Style)) -> Timeline(msg) {
  Timeline(..t, styles: list.append(t.styles, s))
}

pub fn attrs(t: Timeline(msg), a: List(Attribute(msg))) -> Timeline(msg) {
  Timeline(..t, attrs: list.append(t.attrs, a))
}

pub fn items(t: Timeline(msg), i: List(Element(msg))) -> Timeline(msg) {
  Timeline(..t, items: i)
}

/// Build a single timeline `<li>` with start, middle, and end slots.
pub fn item(
  start start_children: List(Element(msg)),
  middle middle_children: List(Element(msg)),
  end end_children: List(Element(msg)),
) -> Element(msg) {
  let start_el = html.div([attribute.class("timeline-start")], start_children)
  let middle_el = html.div([attribute.class("timeline-middle")], middle_children)
  let end_el = html.div([attribute.class("timeline-end")], end_children)
  html.li([], [start_el, middle_el, end_el])
}

/// Default circular dot for the middle slot.
pub fn dot() -> Element(msg) {
  html.div([attribute.class("timeline-dot")], [])
}

/// Horizontal rule connector between items — use `<hr>` elements inside `<li>`.
pub fn connector() -> Element(msg) {
  html.hr([])
}

pub fn build(t: Timeline(msg)) -> Element(msg) {
  let classes: List(Option(String)) = [
    Some("timeline"),
    case t.vertical { True -> Some("timeline-vertical") False -> None },
    case t.compact { True -> Some("timeline-compact") False -> None },
    case t.snap { True -> Some("timeline-snap-icon") False -> None },
  ]
  let base =
    classes
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
    |> fn(parts) {
      case parts {
        [] -> "timeline"
        _ -> list.fold(parts, "", fn(acc, s) {
          case acc {
            "" -> s
            _ -> acc <> " " <> s
          }
        })
      }
    }
  let class = case to_class_string(t.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.ul([attribute.class(class), ..t.attrs], t.items)
}
