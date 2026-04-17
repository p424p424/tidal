/// Image element — renders as an `<img>`.
///
/// ```gleam
/// import tidal/image
/// import tidal/style/sizing
/// import tidal/style/border
///
/// image.new(src: "/assets/avatar.png")
/// |> image.alt(text: "User avatar")
/// |> image.style(styles: [sizing.w(16), sizing.h(16), border.rounded_full()])
/// |> image.build
/// ```
///
/// See also:
/// - Lustre element/html docs: https://hexdocs.pm/lustre/lustre/element/html.html
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Image(msg) {
  Image(
    src: String,
    alt: String,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

/// Creates a new `Image` with the given source URL — renders `<img src="...">`.
///
/// Chain builder functions to configure the image, then call `build`:
///
/// ```gleam
/// import tidal/image
/// import tidal/style/sizing
///
/// image.new(src: "/assets/avatar.png")
/// |> image.alt(text: "User avatar")
/// |> image.style(styles: [sizing.w(16), sizing.h(16)])
/// |> image.build
/// ```
///
/// See also:
/// - Lustre element/html docs: https://hexdocs.pm/lustre/lustre/element/html.html
pub fn new(src src: String) -> Image(msg) {
  Image(src: src, alt: "", styles: [], attrs: [])
}

/// Sets the `alt` text for accessibility. Defaults to an empty string.
pub fn alt(img: Image(msg), text text: String) -> Image(msg) {
  Image(..img, alt: text)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(img: Image(msg), styles styles: List(Style)) -> Image(msg) {
  Image(..img, styles: list.append(img.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  img: Image(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Image(msg) {
  Image(..img, attrs: list.append(img.attrs, attributes))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(img: Image(msg)) -> Element(msg) {
  html.img([
    attribute.src(img.src),
    attribute.alt(img.alt),
    attribute.class(style.to_class_string(img.styles)),
    ..img.attrs
  ])
}
