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
/// |> chat.bubble(text: "You underestimate my power!")
/// |> chat.build
/// ```
///
/// See also:
/// - DaisyUI chat docs: https://daisyui.com/components/chat/
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

/// Creates a new `Chat` bubble builder — defaults to left-aligned (`chat-start`).
///
/// Chain builder functions to configure the chat bubble, then call `build`:
///
/// ```gleam
/// import tidal/chat
///
/// chat.new()
/// |> chat.end_
/// |> chat.primary
/// |> chat.header(text: "Darth Vader")
/// |> chat.bubble(text: "You underestimate my power!")
/// |> chat.build
/// ```
///
/// See also:
/// - DaisyUI chat docs: https://daisyui.com/components/chat/
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
pub fn start(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, side: "chat-start")
}

/// Right-aligned chat bubble (sent messages) — `chat-end`.
pub fn end_(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, side: "chat-end")
}

pub fn primary(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, color: Some("chat-bubble-primary"))
}

pub fn secondary(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, color: Some("chat-bubble-secondary"))
}

pub fn accent(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, color: Some("chat-bubble-accent"))
}

pub fn neutral(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, color: Some("chat-bubble-neutral"))
}

pub fn info(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, color: Some("chat-bubble-info"))
}

pub fn success(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, color: Some("chat-bubble-success"))
}

pub fn warning(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, color: Some("chat-bubble-warning"))
}

pub fn error(chat: Chat(msg)) -> Chat(msg) {
  Chat(..chat, color: Some("chat-bubble-error"))
}

/// Text content for the chat bubble.
pub fn bubble(chat: Chat(msg), text text: String) -> Chat(msg) {
  Chat(..chat, bubble_content: Some(html.text(text)))
}

/// Custom element content for the bubble (images, formatted text, etc.).
pub fn bubble_el(chat: Chat(msg), element element: Element(msg)) -> Chat(msg) {
  Chat(..chat, bubble_content: Some(element))
}

/// Avatar element shown beside the bubble — `chat-image`.
pub fn avatar(chat: Chat(msg), element element: Element(msg)) -> Chat(msg) {
  Chat(
    ..chat,
    avatar: Some(html.div([attribute.class("chat-image")], [element])),
  )
}

/// Text above the bubble (name, timestamp) — `chat-header`.
pub fn header(chat: Chat(msg), text text: String) -> Chat(msg) {
  Chat(..chat, header: Some(text))
}

/// Text below the bubble (status, timestamp) — `chat-footer`.
pub fn footer(chat: Chat(msg), text text: String) -> Chat(msg) {
  Chat(..chat, footer: Some(text))
}

/// Appends Tailwind utility styles.
pub fn style(chat: Chat(msg), styles styles: List(Style)) -> Chat(msg) {
  Chat(..chat, styles: list.append(chat.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  chat: Chat(msg),
  attributes attributes: List(Attribute(msg)),
) -> Chat(msg) {
  Chat(..chat, attrs: list.append(chat.attrs, attributes))
}

pub fn build(chat: Chat(msg)) -> Element(msg) {
  let class = case to_class_string(chat.styles) {
    "" -> "chat " <> chat.side
    extra -> "chat " <> chat.side <> " " <> extra
  }
  let bubble_class =
    [Some("chat-bubble"), chat.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let bubble_children = case chat.bubble_content {
    Some(el) -> [el]
    None -> []
  }
  let bubble_el = html.div([attribute.class(bubble_class)], bubble_children)
  let header_el = case chat.header {
    None -> []
    Some(t) -> [html.div([attribute.class("chat-header")], [html.text(t)])]
  }
  let footer_el = case chat.footer {
    None -> []
    Some(t) -> [html.div([attribute.class("chat-footer")], [html.text(t)])]
  }
  let avatar_el = case chat.avatar {
    None -> []
    Some(el) -> [el]
  }
  html.div(
    [attribute.class(class), ..chat.attrs],
    list.flatten([avatar_el, header_el, [bubble_el], footer_el]),
  )
}
