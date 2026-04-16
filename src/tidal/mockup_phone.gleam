/// Mockup Phone — phone device frame for UI previews.
///
/// ```gleam
/// import tidal/mockup_phone
/// import lustre/element/html
///
/// mockup_phone.new()
/// |> mockup_phone.content([html.p([], [html.text("Screen content")])])
/// |> mockup_phone.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type MockupPhone(msg) {
  MockupPhone(
    border_color: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    content: List(Element(msg)),
  )
}

/// Create a new phone mockup frame.
pub fn new() -> MockupPhone(msg) {
  MockupPhone(border_color: None, styles: [], attrs: [], content: [])
}

/// Sets an arbitrary border color using a Tailwind arbitrary value — e.g. `"#ff8938"`.
pub fn border_color(m: MockupPhone(msg), color: String) -> MockupPhone(msg) {
  MockupPhone(..m, border_color: Some(color))
}

/// Appends Tailwind utility styles.
pub fn style(m: MockupPhone(msg), s: List(Style)) -> MockupPhone(msg) {
  MockupPhone(..m, styles: list.append(m.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(m: MockupPhone(msg), a: List(Attribute(msg))) -> MockupPhone(msg) {
  MockupPhone(..m, attrs: list.append(m.attrs, a))
}

/// Sets the screen content. May be called multiple times — accumulates.
pub fn content(m: MockupPhone(msg), els: List(Element(msg))) -> MockupPhone(msg) {
  MockupPhone(..m, content: list.append(m.content, els))
}

pub fn build(m: MockupPhone(msg)) -> Element(msg) {
  let border_cls = case m.border_color {
    None -> ""
    Some(c) -> " border-[" <> c <> "]"
  }
  let class = case to_class_string(m.styles) {
    "" -> "mockup-phone" <> border_cls
    extra -> "mockup-phone" <> border_cls <> " " <> extra
  }
  let camera = html.div([attribute.class("camera")], [])
  let display = html.div([attribute.class("display")], [
    html.div([attribute.class("artboard artboard-demo phone-1")], m.content),
  ])
  html.div([attribute.class(class), ..m.attrs], [camera, display])
}
