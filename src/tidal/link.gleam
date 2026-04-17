/// Link — styled anchor element.
///
/// ```gleam
/// import tidal/link
/// import lustre/attribute
///
/// link.new()
/// |> link.label(text: "Learn more")
/// |> link.primary
/// |> link.attrs(attributes: [attribute.href("/docs")])
/// |> link.build
/// ```
///
/// See also:
/// - DaisyUI link docs: https://daisyui.com/components/link/
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

/// Creates a new `Link` builder. Use `label(text:)` for text or `children(elements:)` for custom content.
///
/// Chain builder functions to configure the link, then call `build`:
///
/// ```gleam
/// import tidal/link
/// import lustre/attribute
///
/// link.new()
/// |> link.label(text: "Learn more")
/// |> link.primary
/// |> link.attrs(attributes: [attribute.href("/docs")])
/// |> link.build
/// ```
///
/// See also:
/// - DaisyUI link docs: https://daisyui.com/components/link/
pub fn new() -> Link(msg) {
  Link(
    label: "",
    color: None,
    hover_only: False,
    custom_children: [],
    attrs: [],
  )
}

/// Sets the link text.
pub fn label(lnk: Link(msg), text text: String) -> Link(msg) {
  Link(..lnk, label: text)
}

/// Show underline only on hover — `link-hover`.
pub fn hover(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, hover_only: True)
}

pub fn neutral(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, color: Some("link-neutral"))
}

pub fn primary(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, color: Some("link-primary"))
}

pub fn secondary(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, color: Some("link-secondary"))
}

pub fn accent(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, color: Some("link-accent"))
}

pub fn info(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, color: Some("link-info"))
}

pub fn success(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, color: Some("link-success"))
}

pub fn warning(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, color: Some("link-warning"))
}

pub fn error(lnk: Link(msg)) -> Link(msg) {
  Link(..lnk, color: Some("link-error"))
}

/// Sets the destination URL — shorthand for `attrs(attributes: [attribute.href(url)])`.
pub fn href(lnk: Link(msg), url url: String) -> Link(msg) {
  Link(..lnk, attrs: list.append(lnk.attrs, [attribute.href(url)]))
}

/// Custom link content (icon + text, etc.) — replaces `label` when set.
pub fn children(
  lnk: Link(msg),
  elements elements: List(Element(msg)),
) -> Link(msg) {
  Link(..lnk, custom_children: list.append(lnk.custom_children, elements))
}

/// Appends HTML attributes (e.g. `attribute.href("/about")`).
pub fn attrs(
  lnk: Link(msg),
  attributes attributes: List(Attribute(msg)),
) -> Link(msg) {
  Link(..lnk, attrs: list.append(lnk.attrs, attributes))
}

pub fn on_click(lnk: Link(msg), msg: msg) -> Link(msg) {
  Link(..lnk, attrs: list.append(lnk.attrs, [event.on_click(msg)]))
}

pub fn on_mouse_enter(lnk: Link(msg), msg: msg) -> Link(msg) {
  Link(..lnk, attrs: list.append(lnk.attrs, [event.on_mouse_enter(msg)]))
}

pub fn on_mouse_leave(lnk: Link(msg), msg: msg) -> Link(msg) {
  Link(..lnk, attrs: list.append(lnk.attrs, [event.on_mouse_leave(msg)]))
}

pub fn on_focus(lnk: Link(msg), msg: msg) -> Link(msg) {
  Link(..lnk, attrs: list.append(lnk.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(lnk: Link(msg), msg: msg) -> Link(msg) {
  Link(..lnk, attrs: list.append(lnk.attrs, [event.on_blur(msg)]))
}

pub fn build(lnk: Link(msg)) -> Element(msg) {
  let hover_class = case lnk.hover_only {
    True -> Some("link-hover")
    False -> None
  }
  let class =
    [Some("link"), hover_class, lnk.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let inner = case lnk.custom_children {
    [_, ..] -> lnk.custom_children
    [] -> [html.text(lnk.label)]
  }
  html.a([attribute.class(class), ..lnk.attrs], inner)
}
