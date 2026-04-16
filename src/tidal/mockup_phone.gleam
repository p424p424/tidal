/// Mockup Phone — phone device frame for UI previews.
///
/// ```gleam
/// import tidal/mockup_phone
/// import lustre/element/html
///
/// mockup_phone.new()
/// |> mockup_phone.children([html.p([], [html.text("Screen content")])])
/// |> mockup_phone.build
/// ```

import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type MockupPhone(msg) {
  MockupPhone(
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

pub fn new() -> MockupPhone(msg) {
  MockupPhone(styles: [], attrs: [], children: [])
}

pub fn style(m: MockupPhone(msg), s: List(Style)) -> MockupPhone(msg) {
  MockupPhone(..m, styles: list.append(m.styles, s))
}

pub fn attrs(m: MockupPhone(msg), a: List(Attribute(msg))) -> MockupPhone(msg) {
  MockupPhone(..m, attrs: list.append(m.attrs, a))
}

pub fn children(m: MockupPhone(msg), c: List(Element(msg))) -> MockupPhone(msg) {
  MockupPhone(..m, children: c)
}

pub fn build(m: MockupPhone(msg)) -> Element(msg) {
  let class = case to_class_string(m.styles) {
    "" -> "mockup-phone"
    extra -> "mockup-phone " <> extra
  }
  let camera = html.div([attribute.class("camera")], [])
  let display = html.div([attribute.class("display")], [
    html.div([attribute.class("artboard artboard-demo phone-1")], m.children),
  ])
  html.div([attribute.class(class), ..m.attrs], [camera, display])
}
