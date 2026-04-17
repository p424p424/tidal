/// Inline text element — renders as a `<span>` by default.
///
/// Use `paragraph()` to switch to a `<p>` tag, or the heading functions
/// (`h1` through `h6`) to produce semantic heading elements.
///
/// ```gleam
/// import tidal/text
/// import tidal/styling as s
///
/// text.new("Hello, world!")
/// |> text.style(styles: [s.text_2xl(), s.font_bold()])
/// |> text.build
/// ```
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub type Tag {
  Span
  Paragraph
  H1
  H2
  H3
  H4
  H5
  H6
}

pub opaque type Text(msg) {
  Text(
    content: String,
    tag: Tag,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

/// Creates a new inline text element with the given string content.
///
/// Renders as a `<span>` by default. Use `paragraph()`, `h1()` … `h6()` to
/// change the tag, then call `build`:
///
/// ```gleam
/// import tidal/text
/// import tidal/styling as s
///
/// text.new("Hello, world!")
/// |> text.h2
/// |> text.style(styles: [s.font_bold()])
/// |> text.build
/// ```
///
/// See also:
/// - Tailwind typography docs: https://tailwindcss.com/docs/font-size
pub fn new(content: String) -> Text(msg) {
  Text(content: content, tag: Span, styles: [], attrs: [])
}

/// Switches the rendered tag to `<p>`.
pub fn paragraph(txt: Text(msg)) -> Text(msg) {
  Text(..txt, tag: Paragraph)
}

/// Switches the rendered tag to `<h1>`.
pub fn h1(txt: Text(msg)) -> Text(msg) {
  Text(..txt, tag: H1)
}

/// Switches the rendered tag to `<h2>`.
pub fn h2(txt: Text(msg)) -> Text(msg) {
  Text(..txt, tag: H2)
}

/// Switches the rendered tag to `<h3>`.
pub fn h3(txt: Text(msg)) -> Text(msg) {
  Text(..txt, tag: H3)
}

/// Switches the rendered tag to `<h4>`.
pub fn h4(txt: Text(msg)) -> Text(msg) {
  Text(..txt, tag: H4)
}

/// Switches the rendered tag to `<h5>`.
pub fn h5(txt: Text(msg)) -> Text(msg) {
  Text(..txt, tag: H5)
}

/// Switches the rendered tag to `<h6>`.
pub fn h6(txt: Text(msg)) -> Text(msg) {
  Text(..txt, tag: H6)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(txt: Text(msg), styles styles: List(Style)) -> Text(msg) {
  Text(..txt, styles: list.append(txt.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  txt: Text(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Text(msg) {
  Text(..txt, attrs: list.append(txt.attrs, attributes))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(txt: Text(msg)) -> Element(msg) {
  let cls = attribute.class(style.to_class_string(txt.styles))
  let all_attrs = [cls, ..txt.attrs]
  let body = [element.text(txt.content)]
  case txt.tag {
    Span -> html.span(all_attrs, body)
    Paragraph -> html.p(all_attrs, body)
    H1 -> html.h1(all_attrs, body)
    H2 -> html.h2(all_attrs, body)
    H3 -> html.h3(all_attrs, body)
    H4 -> html.h4(all_attrs, body)
    H5 -> html.h5(all_attrs, body)
    H6 -> html.h6(all_attrs, body)
  }
}
