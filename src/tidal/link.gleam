/// Link — styled anchor element.
///
/// ```gleam
/// import tidal/link
/// import lustre/attribute
///
/// link.new("Learn more")
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
    text: String,
    color: Option(String),
    hover_only: Bool,
    attrs: List(Attribute(msg)),
  )
}

pub fn new(text: String) -> Link(msg) {
  Link(text: text, color: None, hover_only: False, attrs: [])
}

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

pub fn attrs(l: Link(msg), a: List(Attribute(msg))) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, a))
}

pub fn on_click(l: Link(msg), msg: msg) -> Link(msg) {
  Link(..l, attrs: list.append(l.attrs, [event.on_click(msg)]))
}

pub fn build(l: Link(msg)) -> Element(msg) {
  let hover_class = case l.hover_only { True -> Some("link-hover") False -> None }
  let class =
    [Some("link"), hover_class, l.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.a([attribute.class(class), ..l.attrs], [html.text(l.text)])
}
