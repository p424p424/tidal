/// Mockup Code — terminal/code block display.
///
/// ```gleam
/// import tidal/mockup_code
///
/// mockup_code.new()
/// |> mockup_code.lines([
///   mockup_code.line("npm install tidal", mockup_code.prefix("$")),
///   mockup_code.line("gleam run", mockup_code.no_prefix),
/// ])
/// |> mockup_code.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type MockupCode(msg) {
  MockupCode(
    styles: List(Style),
    attrs: List(Attribute(msg)),
    lines: List(Element(msg)),
  )
}

pub type LinePrefix {
  Prefix(String)
  NoPrefix
}

pub fn prefix(p: String) -> LinePrefix { Prefix(p) }
pub fn no_prefix() -> LinePrefix { NoPrefix }

pub fn new() -> MockupCode(msg) {
  MockupCode(styles: [], attrs: [], lines: [])
}

pub fn style(m: MockupCode(msg), s: List(Style)) -> MockupCode(msg) {
  MockupCode(..m, styles: list.append(m.styles, s))
}

pub fn attrs(m: MockupCode(msg), a: List(Attribute(msg))) -> MockupCode(msg) {
  MockupCode(..m, attrs: list.append(m.attrs, a))
}

pub fn lines(m: MockupCode(msg), l: List(Element(msg))) -> MockupCode(msg) {
  MockupCode(..m, lines: l)
}

/// Build a single `<pre>` line with an optional data-prefix.
pub fn line(text: String, p: LinePrefix) -> Element(msg) {
  let prefix_attr: Option(Attribute(msg)) = case p {
    Prefix(s) -> Some(attribute.attribute("data-prefix", s))
    NoPrefix -> None
  }
  let base_attrs = [attribute.class("line")]
  let all_attrs = case prefix_attr {
    Some(a) -> list.append(base_attrs, [a])
    None -> base_attrs
  }
  html.pre(all_attrs, [html.code([], [html.text(text)])])
}

pub fn build(m: MockupCode(msg)) -> Element(msg) {
  let class = case to_class_string(m.styles) {
    "" -> "mockup-code"
    extra -> "mockup-code " <> extra
  }
  html.div([attribute.class(class), ..m.attrs], m.lines)
}
