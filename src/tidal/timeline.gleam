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
/// |> timeline.items(elements: [
///   timeline.item_new()
///   |> timeline.item_start(element: html.text("2020"))
///   |> timeline.item_middle(element: timeline.dot())
///   |> timeline.item_end(element: html.p([], [html.text("Founded")]))
///   |> timeline.item_connected
///   |> timeline.item_build,
/// ])
/// |> timeline.build
/// ```
///
/// See also:
/// - DaisyUI timeline docs: https://daisyui.com/components/timeline/
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

/// Creates a new timeline entry.
///
/// ```gleam
/// timeline.item_new()
/// |> timeline.item_start(element: html.text("2020"))
/// |> timeline.item_middle(element: timeline.dot())
/// |> timeline.item_end(element: html.p([], [html.text("Founded")]))
/// |> timeline.item_build
/// ```
pub fn item_new() -> TimelineItem(msg) {
  TimelineItem(
    start: None,
    middle: None,
    end: None,
    box: False,
    connected: False,
  )
}

/// Content at the start of this entry — `timeline-start`.
pub fn item_start(
  item: TimelineItem(msg),
  element element: Element(msg),
) -> TimelineItem(msg) {
  TimelineItem(..item, start: Some(element))
}

/// Content in the middle (typically an icon or dot) — `timeline-middle`.
pub fn item_middle(
  item: TimelineItem(msg),
  element element: Element(msg),
) -> TimelineItem(msg) {
  TimelineItem(..item, middle: Some(element))
}

/// Content at the end of this entry — `timeline-end`.
pub fn item_end(
  item: TimelineItem(msg),
  element element: Element(msg),
) -> TimelineItem(msg) {
  TimelineItem(..item, end: Some(element))
}

/// Adds a box style to the start/end content — `timeline-box`.
pub fn item_box(item: TimelineItem(msg)) -> TimelineItem(msg) {
  TimelineItem(..item, box: True)
}

/// Draws a connecting `<hr>` line to the next item.
pub fn item_connected(item: TimelineItem(msg)) -> TimelineItem(msg) {
  TimelineItem(..item, connected: True)
}

pub fn item_build(item: TimelineItem(msg)) -> Element(msg) {
  let box_cls = case item.box {
    True -> " timeline-box"
    False -> ""
  }
  let start_el = case item.start {
    None -> []
    Some(el) -> [html.div([attribute.class("timeline-start" <> box_cls)], [el])]
  }
  let middle_el = case item.middle {
    None -> []
    Some(el) -> [html.div([attribute.class("timeline-middle")], [el])]
  }
  let end_el = case item.end {
    None -> []
    Some(el) -> [html.div([attribute.class("timeline-end" <> box_cls)], [el])]
  }
  let hr_el = case item.connected {
    True -> [html.hr([])]
    False -> []
  }
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

/// Creates a new `Timeline` container — `<ul class="timeline">`. Default is horizontal.
///
/// Chain builder functions to configure the timeline, then call `build`:
///
/// ```gleam
/// import tidal/timeline
///
/// timeline.new()
/// |> timeline.vertical
/// |> timeline.items(elements: [item1, item2, item3])
/// |> timeline.build
/// ```
///
/// See also:
/// - DaisyUI timeline docs: https://daisyui.com/components/timeline/
pub fn new() -> Timeline(msg) {
  Timeline(
    vertical: False,
    compact: False,
    snap_icon: False,
    styles: [],
    attrs: [],
    items: [],
  )
}

/// Vertical layout — `timeline-vertical`.
pub fn vertical(timeline: Timeline(msg)) -> Timeline(msg) {
  Timeline(..timeline, vertical: True)
}

/// All items on one side — `timeline-compact`.
pub fn compact(timeline: Timeline(msg)) -> Timeline(msg) {
  Timeline(..timeline, compact: True)
}

/// Snaps icon to start instead of middle — `timeline-snap-icon`.
pub fn snap_icon(timeline: Timeline(msg)) -> Timeline(msg) {
  Timeline(..timeline, snap_icon: True)
}

/// Appends timeline entry elements (built with `item_build`).
pub fn items(
  timeline: Timeline(msg),
  elements elements: List(Element(msg)),
) -> Timeline(msg) {
  Timeline(..timeline, items: list.append(timeline.items, elements))
}

/// Appends Tailwind utility styles.
pub fn style(
  timeline: Timeline(msg),
  styles styles: List(Style),
) -> Timeline(msg) {
  Timeline(..timeline, styles: list.append(timeline.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  timeline: Timeline(msg),
  attributes attributes: List(Attribute(msg)),
) -> Timeline(msg) {
  Timeline(..timeline, attrs: list.append(timeline.attrs, attributes))
}

/// Default circular dot for the middle slot — `<div class="timeline-dot">`.
pub fn dot() -> Element(msg) {
  html.div([attribute.class("timeline-dot")], [])
}

pub fn build(timeline: Timeline(msg)) -> Element(msg) {
  let class =
    [
      Some("timeline"),
      case timeline.vertical {
        True -> Some("timeline-vertical")
        False -> None
      },
      case timeline.compact {
        True -> Some("timeline-compact")
        False -> None
      },
      case timeline.snap_icon {
        True -> Some("timeline-snap-icon")
        False -> None
      },
      case to_class_string(timeline.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.ul([attribute.class(class), ..timeline.attrs], timeline.items)
}
