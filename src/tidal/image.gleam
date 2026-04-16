/// Image element — renders as an `<img>`.
///
/// ```gleam
/// import tidal/image
/// import tidal/style/sizing
/// import tidal/style/border
///
/// image.new("/assets/avatar.png")
/// |> image.alt("User avatar")
/// |> image.style([sizing.w(16), sizing.h(16), border.rounded_full()])
/// |> image.build
/// ```

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

/// Creates a new image with the given source URL.
pub fn new(src: String) -> Image(msg) {
  Image(src: src, alt: "", styles: [], attrs: [])
}

/// Sets the `alt` text for accessibility. Defaults to an empty string.
pub fn alt(img: Image(msg), text: String) -> Image(msg) {
  Image(..img, alt: text)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(img: Image(msg), s: List(Style)) -> Image(msg) {
  Image(..img, styles: list.append(img.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(img: Image(msg), a: List(attribute.Attribute(msg))) -> Image(msg) {
  Image(..img, attrs: list.append(img.attrs, a))
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
