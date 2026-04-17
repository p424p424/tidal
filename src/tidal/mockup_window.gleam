/// Mockup Window — browser/desktop window frame for UI previews.
///
/// ```gleam
/// import tidal/mockup_window
/// import lustre/attribute
/// import lustre/element/html
///
/// mockup_window.new()
/// |> mockup_window.attrs(attributes: [attribute.class("border border-base-300")])
/// |> mockup_window.content(elements: [html.p([], [html.text("Window content")])])
/// |> mockup_window.build
/// ```
///
/// See also:
/// - DaisyUI mockup window docs: https://daisyui.com/components/mockup-window/
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

/// Creates a new `MockupWindow` — renders a browser/desktop window frame.
///
/// Chain builder functions to configure it, then call `build`:
///
/// ```gleam
/// import tidal/mockup_window
/// import lustre/attribute
/// import lustre/element/html
///
/// mockup_window.new()
/// |> mockup_window.url(url: "https://example.com")
/// |> mockup_window.content(elements: [html.p([], [html.text("Window content")])])
/// |> mockup_window.build
/// ```
///
/// See also:
/// - DaisyUI mockup window docs: https://daisyui.com/components/mockup-window/
pub fn new() -> MockupWindow(msg) {
  MockupWindow(url: None, styles: [], attrs: [], content: [])
}

/// Set the fake URL shown in the address bar.
pub fn url(mockup: MockupWindow(msg), url url: String) -> MockupWindow(msg) {
  MockupWindow(..mockup, url: Some(url))
}

/// Appends Tailwind utility styles.
pub fn style(
  mockup: MockupWindow(msg),
  styles styles: List(Style),
) -> MockupWindow(msg) {
  MockupWindow(..mockup, styles: list.append(mockup.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  mockup: MockupWindow(msg),
  attributes attributes: List(Attribute(msg)),
) -> MockupWindow(msg) {
  MockupWindow(..mockup, attrs: list.append(mockup.attrs, attributes))
}

/// Sets the window content. May be called multiple times — accumulates.
pub fn content(
  mockup: MockupWindow(msg),
  elements elements: List(Element(msg)),
) -> MockupWindow(msg) {
  MockupWindow(..mockup, content: list.append(mockup.content, elements))
}

pub fn build(mockup: MockupWindow(msg)) -> Element(msg) {
  let class = case to_class_string(mockup.styles) {
    "" -> "mockup-window"
    extra -> "mockup-window " <> extra
  }
  let bar_content = case mockup.url {
    None -> []
    Some(address) -> [html.span([], [html.text(address)])]
  }
  let bar = html.div([attribute.class("mockup-window-bar")], bar_content)
  html.div([attribute.class(class), ..mockup.attrs], [bar, ..mockup.content])
}
