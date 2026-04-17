/// Mockup Code — terminal/code block display.
///
/// Call `new()`, then pipe `line(text:)` or `line_prefix(text:, prefix:)` calls
/// to accumulate code lines, then `build`.
///
/// ```gleam
/// import tidal/mockup_code
///
/// mockup_code.new()
/// |> mockup_code.line_prefix(text: "npm install tidal", prefix: "$")
/// |> mockup_code.line(text: "gleam run")
/// |> mockup_code.build
/// ```
///
/// See also:
/// - DaisyUI mockup code docs: https://daisyui.com/components/mockup-code/
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

/// Creates a new empty `MockupCode` block — renders `<div class="mockup-code">`.
///
/// Chain builder functions to add lines, then call `build`:
///
/// ```gleam
/// import tidal/mockup_code
///
/// mockup_code.new()
/// |> mockup_code.line_prefix(text: "npm install tidal", prefix: "$")
/// |> mockup_code.line(text: "gleam run")
/// |> mockup_code.build
/// ```
///
/// See also:
/// - DaisyUI mockup code docs: https://daisyui.com/components/mockup-code/
pub fn new() -> MockupCode(msg) {
  MockupCode(bg: None, styles: [], attrs: [], lines: [])
}

/// Append a plain code line (no prefix).
pub fn line(mockup: MockupCode(msg), text text: String) -> MockupCode(msg) {
  let el =
    html.pre([attribute.class("line")], [html.code([], [html.text(text)])])
  MockupCode(..mockup, lines: list.append(mockup.lines, [el]))
}

/// Append a code line with a leading prefix (e.g. `"$"`, `"~"`).
pub fn line_prefix(
  mockup: MockupCode(msg),
  text text: String,
  prefix prefix: String,
) -> MockupCode(msg) {
  let el =
    html.pre(
      [attribute.class("line"), attribute.attribute("data-prefix", prefix)],
      [html.code([], [html.text(text)])],
    )
  MockupCode(..mockup, lines: list.append(mockup.lines, [el]))
}

/// Append a highlighted code line with a background color (e.g. `"warning"`).
pub fn line_highlight(
  mockup: MockupCode(msg),
  text text: String,
  color color: String,
) -> MockupCode(msg) {
  let el =
    html.pre([attribute.class("line bg-" <> color)], [
      html.code([], [html.text(text)]),
    ])
  MockupCode(..mockup, lines: list.append(mockup.lines, [el]))
}

/// Sets the wrapper background color (e.g. `"neutral"`).
pub fn bg(mockup: MockupCode(msg), color color: String) -> MockupCode(msg) {
  MockupCode(..mockup, bg: Some(color))
}

/// Appends Tailwind utility styles.
pub fn style(
  mockup: MockupCode(msg),
  styles styles: List(Style),
) -> MockupCode(msg) {
  MockupCode(..mockup, styles: list.append(mockup.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  mockup: MockupCode(msg),
  attributes attributes: List(Attribute(msg)),
) -> MockupCode(msg) {
  MockupCode(..mockup, attrs: list.append(mockup.attrs, attributes))
}

pub fn build(mockup: MockupCode(msg)) -> Element(msg) {
  let base = case mockup.bg {
    None -> "mockup-code"
    Some(color) -> "mockup-code bg-" <> color
  }
  let class = case to_class_string(mockup.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.div([attribute.class(class), ..mockup.attrs], mockup.lines)
}
