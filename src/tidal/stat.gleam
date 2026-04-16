/// Stat component — renders a DaisyUI `stat` for displaying a key metric.
///
/// Wrap multiple stats in a `stat.group/1` for a horizontal dashboard layout.
///
/// ```gleam
/// import tidal/stat
///
/// stat.group([
///   stat.new()
///   |> stat.title("Total Users")
///   |> stat.value("31K")
///   |> stat.description("↗︎ 400 (22%)")
///   |> stat.build,
///
///   stat.new()
///   |> stat.title("New Registers")
///   |> stat.value("4,200")
///   |> stat.description("↘︎ 90 (14%)")
///   |> stat.build,
/// ])
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Stat(msg) {
  Stat(
    title: Option(String),
    value: Option(String),
    description: Option(String),
    figure: Option(Element(msg)),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Stat(msg) {
  Stat(
    title: None,
    value: None,
    description: None,
    figure: None,
    styles: [],
    attrs: [],
  )
}

/// Sets the stat label (e.g. "Total Users").
pub fn title(s: Stat(msg), text: String) -> Stat(msg) {
  Stat(..s, title: Some(text))
}

/// Sets the primary metric value (e.g. "31K").
pub fn value(s: Stat(msg), text: String) -> Stat(msg) {
  Stat(..s, value: Some(text))
}

/// Sets the supporting description text (e.g. trend information).
pub fn description(s: Stat(msg), text: String) -> Stat(msg) {
  Stat(..s, description: Some(text))
}

/// Adds a figure element (e.g. an icon or avatar) alongside the stat.
pub fn figure(s: Stat(msg), el: Element(msg)) -> Stat(msg) {
  Stat(..s, figure: Some(el))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(s: Stat(msg), st: List(Style)) -> Stat(msg) {
  Stat(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(s: Stat(msg), a: List(attribute.Attribute(msg))) -> Stat(msg) {
  Stat(..s, attrs: list.append(s.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Wraps a list of built stat elements in a `stats` container.
pub fn group(stats: List(Element(msg))) -> Element(msg) {
  html.div([attribute.class("stats shadow")], stats)
}

pub fn build(s: Stat(msg)) -> Element(msg) {
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

  let desc_el = case s.description {
    None -> []
    Some(d) -> [html.div([attribute.class("stat-desc")], [element.text(d)])]
  }

  html.div(
    [attribute.class(cls), ..s.attrs],
    list.flatten([figure_el, title_el, value_el, desc_el]),
  )
}
