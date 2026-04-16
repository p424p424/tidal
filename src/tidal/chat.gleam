/// Chat bubble — DaisyUI `chat` conversation message.
///
/// Default side is `start` (left-aligned). Use `end_` for sent messages.
///
/// ```gleam
/// import tidal/chat
///
/// chat.new()
/// |> chat.end_
/// |> chat.primary
/// |> chat.bubble("You underestimate my power!")
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
    side: String,
    color: Option(String),
    avatar: Option(Element(msg)),
    header: Option(String),
    footer: Option(String),
    bubble_content: Option(Element(msg)),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Create a new chat bubble — defaults to left-aligned (`chat-start`).
pub fn new() -> Chat(msg) {
  Chat(
    side: "chat-start",
    color: None,
    avatar: None,
    header: None,
    footer: None,
    bubble_content: None,
    styles: [],
    attrs: [],
  )
}

/// Left-aligned chat bubble (default) — `chat-start`.
pub fn start(c: Chat(msg)) -> Chat(msg) { Chat(..c, side: "chat-start") }
/// Right-aligned chat bubble (sent messages) — `chat-end`.
pub fn end_(c: Chat(msg)) -> Chat(msg) { Chat(..c, side: "chat-end") }

pub fn primary(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-primary")) }
pub fn secondary(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-secondary")) }
pub fn accent(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-accent")) }
pub fn neutral(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-neutral")) }
pub fn info(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-info")) }
pub fn success(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-success")) }
pub fn warning(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-warning")) }
pub fn error(c: Chat(msg)) -> Chat(msg) { Chat(..c, color: Some("chat-bubble-error")) }

/// Text content for the chat bubble.
pub fn bubble(c: Chat(msg), text: String) -> Chat(msg) {
  Chat(..c, bubble_content: Some(html.text(text)))
}

/// Custom element content for the bubble (images, formatted text, etc.).
pub fn bubble_el(c: Chat(msg), el: Element(msg)) -> Chat(msg) {
  Chat(..c, bubble_content: Some(el))
}

/// Avatar element shown beside the bubble — `chat-image`.
pub fn avatar(c: Chat(msg), el: Element(msg)) -> Chat(msg) {
  Chat(..c, avatar: Some(html.div([attribute.class("chat-image")], [el])))
}

/// Text above the bubble (name, timestamp) — `chat-header`.
pub fn header(c: Chat(msg), text: String) -> Chat(msg) {
  Chat(..c, header: Some(text))
}

/// Text below the bubble (status, timestamp) — `chat-footer`.
pub fn footer(c: Chat(msg), text: String) -> Chat(msg) {
  Chat(..c, footer: Some(text))
}

/// Appends Tailwind utility styles.
pub fn style(c: Chat(msg), s: List(Style)) -> Chat(msg) {
  Chat(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(c: Chat(msg), a: List(Attribute(msg))) -> Chat(msg) {
  Chat(..c, attrs: list.append(c.attrs, a))
}

pub fn build(c: Chat(msg)) -> Element(msg) {
  let class = case to_class_string(c.styles) {
    "" -> "chat " <> c.side
    extra -> "chat " <> c.side <> " " <> extra
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
  let header_el = case c.header {
    None -> []
    Some(t) -> [html.div([attribute.class("chat-header")], [html.text(t)])]
  }
  let footer_el = case c.footer {
    None -> []
    Some(t) -> [html.div([attribute.class("chat-footer")], [html.text(t)])]
  }
  let avatar_el = case c.avatar { None -> [] Some(el) -> [el] }
  html.div(
    [attribute.class(class), ..c.attrs],
    list.flatten([avatar_el, header_el, [bubble_el], footer_el]),
  )
}
