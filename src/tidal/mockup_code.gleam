/// Mockup Code — terminal/code block display.
///
/// Call `new()`, then pipe `line(text)` or `line_prefix(text, prefix)` calls
/// to accumulate code lines, then `build`.
///
/// ```gleam
/// import tidal/mockup_code
///
/// mockup_code.new()
/// |> mockup_code.line_prefix("npm install tidal", "$")
/// |> mockup_code.line("gleam run")
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
    bg: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    lines: List(Element(msg)),
  )
}

/// Create a new empty mockup code block.
pub fn new() -> MockupCode(msg) {
  MockupCode(bg: None, styles: [], attrs: [], lines: [])
}

/// Append a plain code line (no prefix).
pub fn line(m: MockupCode(msg), text: String) -> MockupCode(msg) {
  let el = html.pre([attribute.class("line")], [html.code([], [html.text(text)])])
  MockupCode(..m, lines: list.append(m.lines, [el]))
}

/// Append a code line with a leading prefix (e.g. `"$"`, `"~"`).
pub fn line_prefix(m: MockupCode(msg), text: String, prefix: String) -> MockupCode(msg) {
  let el = html.pre(
    [attribute.class("line"), attribute.attribute("data-prefix", prefix)],
    [html.code([], [html.text(text)])],
  )
  MockupCode(..m, lines: list.append(m.lines, [el]))
}

/// Append a highlighted code line with a background color (e.g. `"warning"`).
pub fn line_highlight(m: MockupCode(msg), text: String, color: String) -> MockupCode(msg) {
  let el = html.pre(
    [attribute.class("line bg-" <> color)],
    [html.code([], [html.text(text)])],
  )
  MockupCode(..m, lines: list.append(m.lines, [el]))
}

/// Sets the wrapper background color (e.g. `"neutral"`).
pub fn bg(m: MockupCode(msg), color: String) -> MockupCode(msg) {
  MockupCode(..m, bg: Some(color))
}

/// Appends Tailwind utility styles.
pub fn style(m: MockupCode(msg), s: List(Style)) -> MockupCode(msg) {
  MockupCode(..m, styles: list.append(m.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(m: MockupCode(msg), a: List(Attribute(msg))) -> MockupCode(msg) {
  MockupCode(..m, attrs: list.append(m.attrs, a))
}

pub fn build(m: MockupCode(msg)) -> Element(msg) {
  let base = case m.bg {
    None -> "mockup-code"
    Some(c) -> "mockup-code bg-" <> c
  }
  let class = case to_class_string(m.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.div([attribute.class(class), ..m.attrs], m.lines)
}
