/// Alert banner — `<div role="alert" class="alert">`.
///
/// ```gleam
/// import tidal/alert
///
/// alert.new()
/// |> alert.info
/// |> alert.title("Heads up")
/// |> alert.text("Your session expires in 5 minutes.")
/// |> alert.build
/// ```
///
/// Alert supports only `info`, `success`, `warning`, `error` — no primary/secondary.

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Alert(msg) {
  Alert(
    color: Option(String),
    style_variant: Option(String),
    layout: Option(String),
    icon: Option(Element(msg)),
    title: Option(String),
    text: Option(String),
    children: List(Element(msg)),
    actions: List(Element(msg)),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Alert(msg) {
  Alert(
    color: None,
    style_variant: None,
    layout: None,
    icon: None,
    title: None,
    text: None,
    children: [],
    actions: [],
    styles: [],
    attrs: [],
  )
}

pub fn info(a: Alert(msg)) -> Alert(msg) { Alert(..a, color: Some("alert-info")) }
pub fn success(a: Alert(msg)) -> Alert(msg) { Alert(..a, color: Some("alert-success")) }
pub fn warning(a: Alert(msg)) -> Alert(msg) { Alert(..a, color: Some("alert-warning")) }
pub fn error(a: Alert(msg)) -> Alert(msg) { Alert(..a, color: Some("alert-error")) }

/// Outlined border, no fill.
pub fn outline(a: Alert(msg)) -> Alert(msg) { Alert(..a, style_variant: Some("alert-outline")) }
/// Dashed border.
pub fn dash(a: Alert(msg)) -> Alert(msg) { Alert(..a, style_variant: Some("alert-dash")) }
/// Soft/muted background.
pub fn soft(a: Alert(msg)) -> Alert(msg) { Alert(..a, style_variant: Some("alert-soft")) }

/// Arrange content horizontally (default on wider viewports).
pub fn horizontal(a: Alert(msg)) -> Alert(msg) { Alert(..a, layout: Some("alert-horizontal")) }
/// Stack content vertically.
pub fn vertical(a: Alert(msg)) -> Alert(msg) { Alert(..a, layout: Some("alert-vertical")) }

/// Optional leading icon element.
pub fn icon(a: Alert(msg), el: Element(msg)) -> Alert(msg) { Alert(..a, icon: Some(el)) }

/// Bold alert heading.
pub fn title(a: Alert(msg), t: String) -> Alert(msg) { Alert(..a, title: Some(t)) }

/// Alert body text.
pub fn text(a: Alert(msg), t: String) -> Alert(msg) { Alert(..a, text: Some(t)) }

/// Full custom content — replaces title/text.
pub fn children(a: Alert(msg), els: List(Element(msg))) -> Alert(msg) {
  Alert(..a, children: list.append(a.children, els))
}

/// Action elements (buttons etc.) shown after the message.
pub fn actions(a: Alert(msg), els: List(Element(msg))) -> Alert(msg) {
  Alert(..a, actions: list.append(a.actions, els))
}

/// Appends Tailwind utility styles.
pub fn style(a: Alert(msg), s: List(Style)) -> Alert(msg) {
  Alert(..a, styles: list.append(a.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(a: Alert(msg), at: List(Attribute(msg))) -> Alert(msg) {
  Alert(..a, attrs: list.append(a.attrs, at))
}

pub fn build(a: Alert(msg)) -> Element(msg) {
  let classes =
    [
      Some("alert"),
      a.color,
      a.style_variant,
      a.layout,
      case style.to_class_string(a.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let icon_els = case a.icon { None -> [] Some(el) -> [el] }
  let body_els = case a.children {
    [_, ..] -> a.children
    [] ->
      list.flatten([
        case a.title { None -> [] Some(t) -> [html.h4([attribute.class("font-bold")], [html.text(t)])] },
        case a.text { None -> [] Some(t) -> [html.span([], [html.text(t)])] },
      ])
  }
  let action_els = case a.actions {
    [] -> []
    els -> [html.div([attribute.class("alert-actions")], els)]
  }
  html.div(
    [attribute.class(classes), attribute.attribute("role", "alert"), ..a.attrs],
    list.flatten([icon_els, body_els, action_els]),
  )
}
