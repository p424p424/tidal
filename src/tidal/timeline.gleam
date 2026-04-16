/// Timeline — vertical or horizontal sequence of events.
///
/// Build entries with `item_new()` → slot modifiers → `item_build`,
/// then pass the list to the container.
///
/// ```gleam
/// import tidal/timeline
/// import lustre/element/html
///
/// timeline.new()
/// |> timeline.vertical
/// |> timeline.items([
///   timeline.item_new()
///   |> timeline.item_start(html.text("2020"))
///   |> timeline.item_middle(timeline.dot())
///   |> timeline.item_end(html.p([], [html.text("Founded")]))
///   |> timeline.item_connected
///   |> timeline.item_build,
/// ])
/// |> timeline.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

// ---------------------------------------------------------------------------
// TimelineItem sub-builder
// ---------------------------------------------------------------------------

pub opaque type TimelineItem(msg) {
  TimelineItem(
    start: Option(Element(msg)),
    middle: Option(Element(msg)),
    end: Option(Element(msg)),
    box: Bool,
    connected: Bool,
  )
}

/// Create a new timeline entry.
pub fn item_new() -> TimelineItem(msg) {
  TimelineItem(start: None, middle: None, end: None, box: False, connected: False)
}

/// Content at the start of this entry — `timeline-start`.
pub fn item_start(t: TimelineItem(msg), el: Element(msg)) -> TimelineItem(msg) {
  TimelineItem(..t, start: Some(el))
}

/// Content in the middle (typically an icon or dot) — `timeline-middle`.
pub fn item_middle(t: TimelineItem(msg), el: Element(msg)) -> TimelineItem(msg) {
  TimelineItem(..t, middle: Some(el))
}

/// Content at the end of this entry — `timeline-end`.
pub fn item_end(t: TimelineItem(msg), el: Element(msg)) -> TimelineItem(msg) {
  TimelineItem(..t, end: Some(el))
}

/// Adds a box style to the start/end content — `timeline-box`.
pub fn item_box(t: TimelineItem(msg)) -> TimelineItem(msg) { TimelineItem(..t, box: True) }

/// Draws a connecting `<hr>` line to the next item.
pub fn item_connected(t: TimelineItem(msg)) -> TimelineItem(msg) { TimelineItem(..t, connected: True) }

pub fn item_build(t: TimelineItem(msg)) -> Element(msg) {
  let box_cls = case t.box { True -> " timeline-box" False -> "" }
  let start_el = case t.start {
    None -> []
    Some(el) -> [html.div([attribute.class("timeline-start" <> box_cls)], [el])]
  }
  let middle_el = case t.middle {
    None -> []
    Some(el) -> [html.div([attribute.class("timeline-middle")], [el])]
  }
  let end_el = case t.end {
    None -> []
    Some(el) -> [html.div([attribute.class("timeline-end" <> box_cls)], [el])]
  }
  let hr_el = case t.connected { True -> [html.hr([])] False -> [] }
  html.li([], list.flatten([start_el, middle_el, end_el, hr_el]))
}

// ---------------------------------------------------------------------------
// Timeline container
// ---------------------------------------------------------------------------

pub opaque type Timeline(msg) {
  Timeline(
    vertical: Bool,
    compact: Bool,
    snap_icon: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

/// Create a new timeline — `<ul class="timeline">`. Default is horizontal.
pub fn new() -> Timeline(msg) {
  Timeline(vertical: False, compact: False, snap_icon: False, styles: [], attrs: [], items: [])
}

/// Vertical layout — `timeline-vertical`.
pub fn vertical(t: Timeline(msg)) -> Timeline(msg) { Timeline(..t, vertical: True) }
/// All items on one side — `timeline-compact`.
pub fn compact(t: Timeline(msg)) -> Timeline(msg) { Timeline(..t, compact: True) }
/// Snaps icon to start instead of middle — `timeline-snap-icon`.
pub fn snap_icon(t: Timeline(msg)) -> Timeline(msg) { Timeline(..t, snap_icon: True) }

/// Appends timeline entry elements (built with `item_build`).
pub fn items(t: Timeline(msg), i: List(Element(msg))) -> Timeline(msg) {
  Timeline(..t, items: list.append(t.items, i))
}

/// Appends Tailwind utility styles.
pub fn style(t: Timeline(msg), s: List(Style)) -> Timeline(msg) {
  Timeline(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(t: Timeline(msg), a: List(Attribute(msg))) -> Timeline(msg) {
  Timeline(..t, attrs: list.append(t.attrs, a))
}

/// Default circular dot for the middle slot — `<div class="timeline-dot">`.
pub fn dot() -> Element(msg) {
  html.div([attribute.class("timeline-dot")], [])
}

pub fn build(t: Timeline(msg)) -> Element(msg) {
  let class =
    [
      Some("timeline"),
      case t.vertical { True -> Some("timeline-vertical") False -> None },
      case t.compact { True -> Some("timeline-compact") False -> None },
      case t.snap_icon { True -> Some("timeline-snap-icon") False -> None },
      case to_class_string(t.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.ul([attribute.class(class), ..t.attrs], t.items)
}
