/// Inline text element — renders as a `<span>` by default.
///
/// Use `paragraph()` to switch to a `<p>` tag, or the heading functions
/// (`h1` through `h6`) to produce semantic heading elements.
///
/// ```gleam
/// import tidal/text
/// import tidal/style/typography
/// import tidal/style/color
///
/// text.new("Hello, world!")
/// |> text.style([typography.text_2xl(), typography.font_bold()])
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
pub fn new(content: String) -> Text(msg) {
  Text(content: content, tag: Span, styles: [], attrs: [])
}

/// Switches the rendered tag to `<p>`.
pub fn paragraph(t: Text(msg)) -> Text(msg) {
  Text(..t, tag: Paragraph)
}

/// Switches the rendered tag to `<h1>`.
pub fn h1(t: Text(msg)) -> Text(msg) {
  Text(..t, tag: H1)
}

/// Switches the rendered tag to `<h2>`.
pub fn h2(t: Text(msg)) -> Text(msg) {
  Text(..t, tag: H2)
}

/// Switches the rendered tag to `<h3>`.
pub fn h3(t: Text(msg)) -> Text(msg) {
  Text(..t, tag: H3)
}

/// Switches the rendered tag to `<h4>`.
pub fn h4(t: Text(msg)) -> Text(msg) {
  Text(..t, tag: H4)
}

/// Switches the rendered tag to `<h5>`.
pub fn h5(t: Text(msg)) -> Text(msg) {
  Text(..t, tag: H5)
}

/// Switches the rendered tag to `<h6>`.
pub fn h6(t: Text(msg)) -> Text(msg) {
  Text(..t, tag: H6)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(t: Text(msg), s: List(Style)) -> Text(msg) {
  Text(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(t: Text(msg), a: List(attribute.Attribute(msg))) -> Text(msg) {
  Text(..t, attrs: list.append(t.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(t: Text(msg)) -> Element(msg) {
  let cls = attribute.class(style.to_class_string(t.styles))
  let all_attrs = [cls, ..t.attrs]
  let body = [element.text(t.content)]
  case t.tag {
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
