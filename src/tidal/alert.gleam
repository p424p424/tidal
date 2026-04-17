/// Alert banner — `<div role="alert" class="alert">`.
///
/// ```gleam
/// import tidal/alert
///
/// alert.new()
/// |> alert.info
/// |> alert.title(text: "Heads up")
/// |> alert.text(content: "Your session expires in 5 minutes.")
/// |> alert.build
/// ```
///
/// Alert supports only `info`, `success`, `warning`, `error` — no primary/secondary.
///
/// See also:
/// - DaisyUI alert docs: https://daisyui.com/components/alert/
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

/// Creates a new `Alert` builder with all options at their defaults.
///
/// Chain builder functions to configure the alert, then call `build`:
///
/// ```gleam
/// import tidal/alert
///
/// alert.new()
/// |> alert.info
/// |> alert.title(text: "Heads up")
/// |> alert.text(content: "Your session expires in 5 minutes.")
/// |> alert.build
/// ```
///
/// See also:
/// - DaisyUI alert docs: https://daisyui.com/components/alert/
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

pub fn info(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, color: Some("alert-info"))
}

pub fn success(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, color: Some("alert-success"))
}

pub fn warning(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, color: Some("alert-warning"))
}

pub fn error(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, color: Some("alert-error"))
}

/// Outlined border, no fill.
pub fn outline(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, style_variant: Some("alert-outline"))
}

/// Dashed border.
pub fn dash(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, style_variant: Some("alert-dash"))
}

/// Soft/muted background.
pub fn soft(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, style_variant: Some("alert-soft"))
}

/// Arrange content horizontally (default on wider viewports).
pub fn horizontal(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, layout: Some("alert-horizontal"))
}

/// Stack content vertically.
pub fn vertical(alert: Alert(msg)) -> Alert(msg) {
  Alert(..alert, layout: Some("alert-vertical"))
}

/// Optional leading icon element.
pub fn icon(alert: Alert(msg), element element: Element(msg)) -> Alert(msg) {
  Alert(..alert, icon: Some(element))
}

/// Bold alert heading.
pub fn title(alert: Alert(msg), text text: String) -> Alert(msg) {
  Alert(..alert, title: Some(text))
}

/// Alert body text.
pub fn text(alert: Alert(msg), content content: String) -> Alert(msg) {
  Alert(..alert, text: Some(content))
}

/// Full custom content — replaces title/text.
pub fn children(
  alert: Alert(msg),
  elements elements: List(Element(msg)),
) -> Alert(msg) {
  Alert(..alert, children: list.append(alert.children, elements))
}

/// Action elements (buttons etc.) shown after the message.
pub fn actions(
  alert: Alert(msg),
  elements elements: List(Element(msg)),
) -> Alert(msg) {
  Alert(..alert, actions: list.append(alert.actions, elements))
}

/// Appends Tailwind utility styles.
pub fn style(alert: Alert(msg), styles styles: List(Style)) -> Alert(msg) {
  Alert(..alert, styles: list.append(alert.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  alert: Alert(msg),
  attributes attributes: List(Attribute(msg)),
) -> Alert(msg) {
  Alert(..alert, attrs: list.append(alert.attrs, attributes))
}

pub fn build(alert: Alert(msg)) -> Element(msg) {
  let classes =
    [
      Some("alert"),
      alert.color,
      alert.style_variant,
      alert.layout,
      case style.to_class_string(alert.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let icon_els = case alert.icon {
    None -> []
    Some(el) -> [el]
  }
  let body_els = case alert.children {
    [_, ..] -> alert.children
    [] ->
      list.flatten([
        case alert.title {
          None -> []
          Some(t) -> [html.h4([attribute.class("font-bold")], [html.text(t)])]
        },
        case alert.text {
          None -> []
          Some(t) -> [html.span([], [html.text(t)])]
        },
      ])
  }
  let action_els = case alert.actions {
    [] -> []
    els -> [html.div([attribute.class("alert-actions")], els)]
  }
  html.div(
    [
      attribute.class(classes),
      attribute.attribute("role", "alert"),
      ..alert.attrs
    ],
    list.flatten([icon_els, body_els, action_els]),
  )
}
