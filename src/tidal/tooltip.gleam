/// Tooltip wrapper — adds a hover tooltip to any element.
///
/// ```gleam
/// import tidal/tooltip
///
/// tooltip.new()
/// |> tooltip.tip(text: "Click to save")
/// |> tooltip.top
/// |> tooltip.primary
/// |> tooltip.child(element: save_btn)
/// |> tooltip.build
/// ```
///
/// See also:
/// - DaisyUI tooltip docs: https://daisyui.com/components/tooltip/
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

/// Creates a new `Tooltip` builder with all options at their defaults.
///
/// Chain builder functions to configure the tooltip, then call `build`:
///
/// ```gleam
/// import tidal/tooltip
///
/// tooltip.new()
/// |> tooltip.tip(text: "Click to save")
/// |> tooltip.top
/// |> tooltip.primary
/// |> tooltip.child(element: save_btn)
/// |> tooltip.build
/// ```
///
/// See also:
/// - DaisyUI tooltip docs: https://daisyui.com/components/tooltip/
pub fn new() -> Tooltip(msg) {
  Tooltip(
    child: None,
    tip: "",
    position: None,
    color: None,
    open: False,
    styles: [],
    attrs: [],
  )
}

/// The tooltip text shown on hover.
pub fn tip(tooltip: Tooltip(msg), text text: String) -> Tooltip(msg) {
  Tooltip(..tooltip, tip: text)
}

/// The element the tooltip wraps (trigger).
pub fn child(
  tooltip: Tooltip(msg),
  element element: Element(msg),
) -> Tooltip(msg) {
  Tooltip(..tooltip, child: Some(element))
}

pub fn top(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, position: Some("tooltip-top"))
}

pub fn bottom(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, position: Some("tooltip-bottom"))
}

pub fn left(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, position: Some("tooltip-left"))
}

pub fn right(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, position: Some("tooltip-right"))
}

/// Force the tooltip to always be visible.
pub fn open(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, open: True)
}

pub fn primary(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, color: Some("tooltip-primary"))
}

pub fn secondary(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, color: Some("tooltip-secondary"))
}

pub fn accent(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, color: Some("tooltip-accent"))
}

pub fn neutral(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, color: Some("tooltip-neutral"))
}

pub fn info(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, color: Some("tooltip-info"))
}

pub fn success(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, color: Some("tooltip-success"))
}

pub fn warning(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, color: Some("tooltip-warning"))
}

pub fn error(tooltip: Tooltip(msg)) -> Tooltip(msg) {
  Tooltip(..tooltip, color: Some("tooltip-error"))
}

/// Appends Tailwind utility styles.
pub fn style(tooltip: Tooltip(msg), styles styles: List(Style)) -> Tooltip(msg) {
  Tooltip(..tooltip, styles: list.append(tooltip.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  tooltip: Tooltip(msg),
  attributes attributes: List(Attribute(msg)),
) -> Tooltip(msg) {
  Tooltip(..tooltip, attrs: list.append(tooltip.attrs, attributes))
}

pub fn build(tooltip: Tooltip(msg)) -> Element(msg) {
  let classes =
    [
      Some("tooltip"),
      tooltip.position,
      tooltip.color,
      case tooltip.open {
        True -> Some("tooltip-open")
        False -> None
      },
      case style.to_class_string(tooltip.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  let children = case tooltip.child {
    None -> []
    Some(el) -> [el]
  }
  html.div(
    [
      attribute.class(classes),
      attribute.attribute("data-tip", tooltip.tip),
      ..tooltip.attrs
    ],
    children,
  )
}
