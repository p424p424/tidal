/// Chat bubble — conversation message display.
///
/// ```gleam
/// import tidal/chat
///
/// chat.new()
/// |> chat.end_
/// |> chat.primary
/// |> chat.text("You underestimate my power!")
/// |> chat.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Chat(msg) {
  Chat(
    side: Option(String),
    color: Option(String),
    image: Option(Element(msg)),
    header: Option(Element(msg)),
    footer: Option(Element(msg)),
    bubble_content: Option(Element(msg)),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Chat(msg) {
  Chat(
    side: None,
    color: None,
    image: None,
    header: None,
    footer: None,
    bubble_content: None,
    styles: [],
    attrs: [],
  )
}

pub fn start(c: Chat(msg)) -> Chat(msg) { Chat(..c, side: Some("chat-start")) }
pub fn end_(c: Chat(msg)) -> Chat(msg) { Chat(..c, side: Some("chat-end")) }

pub fn primary(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-primary")) }
pub fn secondary(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-secondary")) }
pub fn accent(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-accent")) }
pub fn neutral(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-neutral")) }
pub fn info(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-info")) }
pub fn success(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-success")) }
pub fn warning(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-warning")) }
pub fn error(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-error")) }

/// Simple text message content.
pub fn text(c: Chat(msg), content: String) -> Chat(msg) {
  Chat(..c, bubble_content: Some(html.text(content)))
}

/// Arbitrary element content for the bubble.
pub fn bubble(c: Chat(msg), el: Element(msg)) -> Chat(msg) {
  Chat(..c, bubble_content: Some(el))
}

pub fn image_slot(c: Chat(msg), children: List(Element(msg))) -> Chat(msg) {
  Chat(..c, image: Some(html.div([attribute.class("chat-image")], children)))
}

pub fn header_slot(c: Chat(msg), children: List(Element(msg))) -> Chat(msg) {
  Chat(..c, header: Some(html.div([attribute.class("chat-header")], children)))
}

pub fn footer_slot(c: Chat(msg), children: List(Element(msg))) -> Chat(msg) {
  Chat(..c, footer: Some(html.div([attribute.class("chat-footer")], children)))
}

pub fn style(c: Chat(msg), s: List(Style)) -> Chat(msg) {
  Chat(..c, styles: list.append(c.styles, s))
}

pub fn attrs(c: Chat(msg), a: List(Attribute(msg))) -> Chat(msg) {
  Chat(..c, attrs: list.append(c.attrs, a))
}

pub fn build(c: Chat(msg)) -> Element(msg) {
  let base =
    [Some("chat"), c.side]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(c.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }

  let bubble_class =
    [Some("chat-bubble"), c.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")

  let bubble_children = case c.bubble_content {
    Some(el) -> [el]
    None -> []
  }

  let bubble_el = html.div([attribute.class(bubble_class)], bubble_children)

  let slot_els =
    [c.image, c.header, Some(bubble_el), c.footer]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })

  html.div([attribute.class(class), ..c.attrs], slot_els)
}
