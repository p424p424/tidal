/// Mockup Window — browser/desktop window frame for UI previews.
///
/// ```gleam
/// import tidal/mockup_window
/// import lustre/attribute
/// import lustre/element/html
///
/// mockup_window.new()
/// |> mockup_window.attrs([attribute.class("border border-base-300")])
/// |> mockup_window.content([html.p([], [html.text("Window content")])])
/// |> mockup_window.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type MockupWindow(msg) {
  MockupWindow(
    url: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    content: List(Element(msg)),
  )
}

pub fn new() -> MockupWindow(msg) {
  MockupWindow(url: None, styles: [], attrs: [], content: [])
}

/// Set the fake URL shown in the address bar.
pub fn url(m: MockupWindow(msg), u: String) -> MockupWindow(msg) {
  MockupWindow(..m, url: Some(u))
}

pub fn style(m: MockupWindow(msg), s: List(Style)) -> MockupWindow(msg) {
  MockupWindow(..m, styles: list.append(m.styles, s))
}

pub fn attrs(m: MockupWindow(msg), a: List(Attribute(msg))) -> MockupWindow(msg) {
  MockupWindow(..m, attrs: list.append(m.attrs, a))
}

pub fn content(m: MockupWindow(msg), c: List(Element(msg))) -> MockupWindow(msg) {
  MockupWindow(..m, content: list.append(m.content, c))
}

pub fn build(m: MockupWindow(msg)) -> Element(msg) {
  let class = case to_class_string(m.styles) {
    "" -> "mockup-window"
    extra -> "mockup-window " <> extra
  }
  let bar_content = case m.url {
    None -> []
    Some(u) -> [html.span([], [html.text(u)])]
  }
  let bar = html.div([attribute.class("mockup-window-bar")], bar_content)
  html.div([attribute.class(class), ..m.attrs], [bar, ..m.content])
}
