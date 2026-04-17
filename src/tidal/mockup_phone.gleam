/// Mockup Phone — phone device frame for UI previews.
///
/// ```gleam
/// import tidal/mockup_phone
/// import lustre/element/html
///
/// mockup_phone.new()
/// |> mockup_phone.content(elements: [html.p([], [html.text("Screen content")])])
/// |> mockup_phone.build
/// ```
///
/// See also:
/// - DaisyUI mockup phone docs: https://daisyui.com/components/mockup-phone/
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

/// Creates a new `MockupPhone` — renders a phone device frame.
///
/// Chain builder functions to configure it, then call `build`:
///
/// ```gleam
/// import tidal/mockup_phone
/// import lustre/element/html
///
/// mockup_phone.new()
/// |> mockup_phone.content(elements: [html.p([], [html.text("Screen content")])])
/// |> mockup_phone.build
/// ```
///
/// See also:
/// - DaisyUI mockup phone docs: https://daisyui.com/components/mockup-phone/
pub fn new() -> MockupPhone(msg) {
  MockupPhone(border_color: None, styles: [], attrs: [], content: [])
}

/// Sets an arbitrary border color using a Tailwind arbitrary value — e.g. `"#ff8938"`.
pub fn border_color(
  mockup: MockupPhone(msg),
  color color: String,
) -> MockupPhone(msg) {
  MockupPhone(..mockup, border_color: Some(color))
}

/// Appends Tailwind utility styles.
pub fn style(
  mockup: MockupPhone(msg),
  styles styles: List(Style),
) -> MockupPhone(msg) {
  MockupPhone(..mockup, styles: list.append(mockup.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  mockup: MockupPhone(msg),
  attributes attributes: List(Attribute(msg)),
) -> MockupPhone(msg) {
  MockupPhone(..mockup, attrs: list.append(mockup.attrs, attributes))
}

/// Sets the screen content. May be called multiple times — accumulates.
pub fn content(
  mockup: MockupPhone(msg),
  elements elements: List(Element(msg)),
) -> MockupPhone(msg) {
  MockupPhone(..mockup, content: list.append(mockup.content, elements))
}

pub fn build(mockup: MockupPhone(msg)) -> Element(msg) {
  let border_cls = case mockup.border_color {
    None -> ""
    Some(color) -> " border-[" <> color <> "]"
  }
  let class = case to_class_string(mockup.styles) {
    "" -> "mockup-phone" <> border_cls
    extra -> "mockup-phone" <> border_cls <> " " <> extra
  }
  let camera = html.div([attribute.class("camera")], [])
  let display =
    html.div([attribute.class("display")], [
      html.div(
        [attribute.class("artboard artboard-demo phone-1")],
        mockup.content,
      ),
    ])
  html.div([attribute.class(class), ..mockup.attrs], [camera, display])
}
