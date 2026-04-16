/// Link — styled anchor element.
///
/// ```gleam
/// import tidal/link
/// import lustre/attribute
///
/// link.new()
/// |> link.label("Learn more")
/// |> link.primary
/// |> link.attrs([attribute.href("/docs")])
/// |> link.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event

pub opaque type Link(msg) {
  Link(
    label: String,
    color: Option(String),
    hover_only: Bool,
    custom_children: List(Element(msg)),
    attrs: List(Attribute(msg)),
  )
}

/// Create a new link. Use `label(t)` for text or `children(els)` for custom content.
pub fn new() -> Link(msg) {
  Link(label: "", color: None, hover_only: False, custom_children: [], attrs: [])
}

/// Sets the link text.
pub fn label(l: Link(msg), text: String) -> Link(msg) { Link(..l, label: text) }

/// Show underline only on hover — `link-hover`.
pub fn hover(l: Link(msg)) -> Link(msg) { Link(..l, hover_only: True) }

pub fn neutral(l: Link(msg)) -> Link(msg) { Link(..l, color: Some("link-neutral")) }
pub fn primary(l: Link(msg)) -> Link(msg) { Link(..l, color: Some("link-primary")) }
pub fn secondary(l: Link(msg)) -> Link(msg) { Link(..l, color: Some("link-secondary")) }
pub fn accent(l: Link(msg)) -> Link(msg) { Link(..l, color: Some("link-accent")) }
pub fn info(l: Link(msg)) -> Link(msg) { Link(..l, color: Some("link-info")) }
pub fn success(l: Link(msg)) -> Link(msg) { Link(..l, color: Some("link-success")) }
pub fn warning(l: Link(msg)) -> Link(msg) { Link(..l, color: Some("link-warning")) }
pub fn error(l: Link(msg)) -> Link(msg) { Link(..l, color: Some("link-error")) }

/// Sets the destination URL — shorthand for `attrs([attribute.href(url)])`.
pub fn href(l: Link(msg), url: String) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, [attribute.href(url)]))
}

/// Custom link content (icon + text, etc.) — replaces `label` when set.
pub fn children(l: Link(msg), els: List(Element(msg))) -> Link(msg) {
  Link(..l, custom_children: list.append(l.custom_children, els))
}

/// Appends HTML attributes (e.g. `attribute.href("/about")`).
pub fn attrs(l: Link(msg), a: List(Attribute(msg))) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, a))
}

pub fn on_click(l: Link(msg), msg: msg) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, [event.on_click(msg)]))
}

pub fn on_mouse_enter(l: Link(msg), msg: msg) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, [event.on_mouse_enter(msg)]))
}

pub fn on_mouse_leave(l: Link(msg), msg: msg) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, [event.on_mouse_leave(msg)]))
}

pub fn on_focus(l: Link(msg), msg: msg) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(l: Link(msg), msg: msg) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, [event.on_blur(msg)]))
}

pub fn build(l: Link(msg)) -> Element(msg) {
  let hover_class = case l.hover_only { True -> Some("link-hover") False -> None }
  let class =
    [Some("link"), hover_class, l.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let inner = case l.custom_children {
    [_, ..] -> l.custom_children
    [] -> [html.text(l.label)]
  }
  html.a([attribute.class(class), ..l.attrs], inner)
}
