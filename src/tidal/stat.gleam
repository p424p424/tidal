/// Stat — display key metrics in a DaisyUI `stats` grid.
///
/// Build individual stat items with `stat_new()` → modifiers → `stat_build`,
/// then pass the list to a `Stats` container with `new()` → `items()` → `build`.
///
/// ```gleam
/// import tidal/stat
///
/// stat.new()
/// |> stat.items(elements: [
///   stat.stat_new()
///   |> stat.stat_title(text: "Total Users")
///   |> stat.stat_value(text: "31K")
///   |> stat.stat_desc(text: "↗︎ 400 (22%)")
///   |> stat.stat_build,
///
///   stat.stat_new()
///   |> stat.stat_title(text: "Revenue")
///   |> stat.stat_value(text: "$4,200")
///   |> stat.stat_build,
/// ])
/// |> stat.build
/// ```
///
/// See also:
/// - DaisyUI stat docs: https://daisyui.com/components/stat/
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

/// Creates a new `Stats` container — `<div class="stats">`.
/// By default stats are arranged horizontally.
///
/// ```gleam
/// import tidal/stat
///
/// stat.new()
/// |> stat.items(elements: [stat1, stat2])
/// |> stat.build
/// ```
///
/// See also:
/// - DaisyUI stat docs: https://daisyui.com/components/stat/
pub fn new() -> Stats(msg) {
  Stats(vertical: False, styles: [], attrs: [], items: [])
}

/// Stack stats vertically — `stats-vertical`.
pub fn vertical(stats: Stats(msg)) -> Stats(msg) {
  Stats(..stats, vertical: True)
}

/// Appends stat item elements (built with `stat_build`).
pub fn items(
  stats: Stats(msg),
  elements elements: List(Element(msg)),
) -> Stats(msg) {
  Stats(..stats, items: list.append(stats.items, elements))
}

/// Appends Tailwind utility styles.
pub fn style(stats: Stats(msg), styles styles: List(Style)) -> Stats(msg) {
  Stats(..stats, styles: list.append(stats.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  stats: Stats(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Stats(msg) {
  Stats(..stats, attrs: list.append(stats.attrs, attributes))
}

pub fn build(stats: Stats(msg)) -> Element(msg) {
  let cls =
    "stats"
    <> case stats.vertical {
      True -> " stats-vertical"
      False -> ""
    }
    <> case style.to_class_string(stats.styles) {
      "" -> ""
      st -> " " <> st
    }
  html.div([attribute.class(cls), ..stats.attrs], stats.items)
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

/// Creates a new stat item. Chain `stat_title`, `stat_value`, etc., then `stat_build`.
///
/// ```gleam
/// stat.stat_new()
/// |> stat.stat_title(text: "Total Users")
/// |> stat.stat_value(text: "31K")
/// |> stat.stat_desc(text: "↗︎ 400 (22%)")
/// |> stat.stat_build
/// ```
pub fn stat_new() -> Stat(msg) {
  Stat(
    title: None,
    value: None,
    desc: None,
    figure: None,
    actions: [],
    styles: [],
    attrs: [],
  )
}

/// Label above the value (e.g. "Total Users").
pub fn stat_title(stat: Stat(msg), text text: String) -> Stat(msg) {
  Stat(..stat, title: Some(text))
}

/// The primary metric value (e.g. "31K").
pub fn stat_value(stat: Stat(msg), text text: String) -> Stat(msg) {
  Stat(..stat, value: Some(text))
}

/// Supporting description below the value (e.g. "↗︎ 400 (22%)").
pub fn stat_desc(stat: Stat(msg), text text: String) -> Stat(msg) {
  Stat(..stat, desc: Some(text))
}

/// Icon or avatar element displayed to the right — `stat-figure`.
pub fn stat_figure(stat: Stat(msg), element element: Element(msg)) -> Stat(msg) {
  Stat(..stat, figure: Some(element))
}

/// Action buttons shown below the description — `stat-actions`.
pub fn stat_actions(
  stat: Stat(msg),
  elements elements: List(Element(msg)),
) -> Stat(msg) {
  Stat(..stat, actions: list.append(stat.actions, elements))
}

/// Appends Tailwind utility styles to the stat item.
pub fn stat_style(stat: Stat(msg), styles styles: List(Style)) -> Stat(msg) {
  Stat(..stat, styles: list.append(stat.styles, styles))
}

/// Appends HTML attributes to the stat item.
pub fn stat_attrs(
  stat: Stat(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Stat(msg) {
  Stat(..stat, attrs: list.append(stat.attrs, attributes))
}

pub fn stat_build(stat: Stat(msg)) -> Element(msg) {
  let cls = case style.to_class_string(stat.styles) {
    "" -> "stat"
    st -> "stat " <> st
  }
  let figure_el = case stat.figure {
    None -> []
    Some(el) -> [html.div([attribute.class("stat-figure")], [el])]
  }
  let title_el = case stat.title {
    None -> []
    Some(t) -> [html.div([attribute.class("stat-title")], [element.text(t)])]
  }
  let value_el = case stat.value {
    None -> []
    Some(v) -> [html.div([attribute.class("stat-value")], [element.text(v)])]
  }
  let desc_el = case stat.desc {
    None -> []
    Some(d) -> [html.div([attribute.class("stat-desc")], [element.text(d)])]
  }
  let actions_el = case stat.actions {
    [] -> []
    els -> [html.div([attribute.class("stat-actions")], els)]
  }
  html.div(
    [attribute.class(cls), ..stat.attrs],
    list.flatten([figure_el, title_el, value_el, desc_el, actions_el]),
  )
}
