/// Tooltip wrapper — adds a hover tooltip to any element.
///
/// ```gleam
/// import tidal/tooltip
///
/// tooltip.new()
/// |> tooltip.tip("Click to save")
/// |> tooltip.top
/// |> tooltip.primary
/// |> tooltip.child(save_btn)
/// |> tooltip.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Tooltip(msg) {
  Tooltip(
    child: Option(Element(msg)),
    tip: String,
    position: Option(String),
    color: Option(String),
    open: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Tooltip(msg) {
  Tooltip(child: None, tip: "", position: None, color: None, open: False, styles: [], attrs: [])
}

/// The tooltip text shown on hover.
pub fn tip(t: Tooltip(msg), text: String) -> Tooltip(msg) { Tooltip(..t, tip: text) }

/// The element the tooltip wraps (trigger).
pub fn child(t: Tooltip(msg), el: Element(msg)) -> Tooltip(msg) { Tooltip(..t, child: Some(el)) }

pub fn top(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, position: Some("tooltip-top")) }
pub fn bottom(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, position: Some("tooltip-bottom")) }
pub fn left(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, position: Some("tooltip-left")) }
pub fn right(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, position: Some("tooltip-right")) }

/// Force the tooltip to always be visible.
pub fn open(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, open: True) }

pub fn primary(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, color: Some("tooltip-primary")) }
pub fn secondary(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, color: Some("tooltip-secondary")) }
pub fn accent(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, color: Some("tooltip-accent")) }
pub fn neutral(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, color: Some("tooltip-neutral")) }
pub fn info(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, color: Some("tooltip-info")) }
pub fn success(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, color: Some("tooltip-success")) }
pub fn warning(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, color: Some("tooltip-warning")) }
pub fn error(t: Tooltip(msg)) -> Tooltip(msg) { Tooltip(..t, color: Some("tooltip-error")) }

/// Appends Tailwind utility styles.
pub fn style(t: Tooltip(msg), s: List(Style)) -> Tooltip(msg) {
  Tooltip(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(t: Tooltip(msg), a: List(Attribute(msg))) -> Tooltip(msg) {
  Tooltip(..t, attrs: list.append(t.attrs, a))
}

pub fn build(t: Tooltip(msg)) -> Element(msg) {
  let classes =
    [
      Some("tooltip"),
      t.position,
      t.color,
      case t.open { True -> Some("tooltip-open") False -> None },
      case style.to_class_string(t.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  let children = case t.child { None -> [] Some(el) -> [el] }
  html.div([attribute.class(classes), attribute.attribute("data-tip", t.tip), ..t.attrs], children)
}
