/// Stat — display key metrics in a DaisyUI `stats` grid.
///
/// Build individual stat items with `stat_new()` → modifiers → `stat_build`,
/// then pass the list to a `Stats` container with `new()` → `items()` → `build`.
///
/// ```gleam
/// import tidal/stat
///
/// stat.new()
/// |> stat.items([
///   stat.stat_new()
///   |> stat.stat_title("Total Users")
///   |> stat.stat_value("31K")
///   |> stat.stat_desc("↗︎ 400 (22%)")
///   |> stat.stat_build,
///
///   stat.stat_new()
///   |> stat.stat_title("Revenue")
///   |> stat.stat_value("$4,200")
///   |> stat.stat_build,
/// ])
/// |> stat.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Stats container
// ---------------------------------------------------------------------------

pub opaque type Stats(msg) {
  Stats(
    vertical: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
    items: List(Element(msg)),
  )
}

/// Create a new stats container — `<div class="stats">`.
/// By default stats are arranged horizontally.
pub fn new() -> Stats(msg) {
  Stats(vertical: False, styles: [], attrs: [], items: [])
}

/// Stack stats vertically — `stats-vertical`.
pub fn vertical(s: Stats(msg)) -> Stats(msg) { Stats(..s, vertical: True) }

/// Appends stat item elements (built with `stat_build`).
pub fn items(s: Stats(msg), els: List(Element(msg))) -> Stats(msg) {
  Stats(..s, items: list.append(s.items, els))
}

/// Appends Tailwind utility styles.
pub fn style(s: Stats(msg), st: List(Style)) -> Stats(msg) {
  Stats(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes.
pub fn attrs(s: Stats(msg), a: List(attribute.Attribute(msg))) -> Stats(msg) {
  Stats(..s, attrs: list.append(s.attrs, a))
}

pub fn build(s: Stats(msg)) -> Element(msg) {
  let cls =
    "stats"
    <> case s.vertical { True -> " stats-vertical" False -> "" }
    <> case style.to_class_string(s.styles) { "" -> "" st -> " " <> st }
  html.div([attribute.class(cls), ..s.attrs], s.items)
}

// ---------------------------------------------------------------------------
// Stat item
// ---------------------------------------------------------------------------

pub opaque type Stat(msg) {
  Stat(
    title: Option(String),
    value: Option(String),
    desc: Option(String),
    figure: Option(Element(msg)),
    actions: List(Element(msg)),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

/// Create a new stat item. Chain `stat_title`, `stat_value`, etc., then `stat_build`.
pub fn stat_new() -> Stat(msg) {
  Stat(title: None, value: None, desc: None, figure: None, actions: [], styles: [], attrs: [])
}

/// Label above the value (e.g. "Total Users").
pub fn stat_title(s: Stat(msg), text: String) -> Stat(msg) {
  Stat(..s, title: Some(text))
}

/// The primary metric value (e.g. "31K").
pub fn stat_value(s: Stat(msg), text: String) -> Stat(msg) {
  Stat(..s, value: Some(text))
}

/// Supporting description below the value (e.g. "↗︎ 400 (22%)").
pub fn stat_desc(s: Stat(msg), text: String) -> Stat(msg) {
  Stat(..s, desc: Some(text))
}

/// Icon or avatar element displayed to the right — `stat-figure`.
pub fn stat_figure(s: Stat(msg), el: Element(msg)) -> Stat(msg) {
  Stat(..s, figure: Some(el))
}

/// Action buttons shown below the description — `stat-actions`.
pub fn stat_actions(s: Stat(msg), els: List(Element(msg))) -> Stat(msg) {
  Stat(..s, actions: list.append(s.actions, els))
}

/// Appends Tailwind utility styles to the stat item.
pub fn stat_style(s: Stat(msg), st: List(Style)) -> Stat(msg) {
  Stat(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes to the stat item.
pub fn stat_attrs(s: Stat(msg), a: List(attribute.Attribute(msg))) -> Stat(msg) {
  Stat(..s, attrs: list.append(s.attrs, a))
}

pub fn stat_build(s: Stat(msg)) -> Element(msg) {
  let cls = case style.to_class_string(s.styles) {
    "" -> "stat"
    st -> "stat " <> st
  }
  let figure_el = case s.figure {
    None -> []
    Some(el) -> [html.div([attribute.class("stat-figure")], [el])]
  }
  let title_el = case s.title {
    None -> []
    Some(t) -> [html.div([attribute.class("stat-title")], [element.text(t)])]
  }
  let value_el = case s.value {
    None -> []
    Some(v) -> [html.div([attribute.class("stat-value")], [element.text(v)])]
  }
  let desc_el = case s.desc {
    None -> []
    Some(d) -> [html.div([attribute.class("stat-desc")], [element.text(d)])]
  }
  let actions_el = case s.actions {
    [] -> []
    els -> [html.div([attribute.class("stat-actions")], els)]
  }
  html.div(
    [attribute.class(cls), ..s.attrs],
    list.flatten([figure_el, title_el, value_el, desc_el, actions_el]),
  )
}
