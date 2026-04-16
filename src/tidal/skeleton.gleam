/// Skeleton — animated loading placeholder.
///
/// ```gleam
/// import tidal/skeleton
/// import lustre/attribute
///
/// skeleton.box([attribute.class("h-32 w-full")])
/// skeleton.box([attribute.class("h-16 w-16 rounded-full")])
/// skeleton.text("Loading…")
/// ```

import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html

/// Renders `<div class="skeleton" …attrs></div>`.
/// Pass sizing and shape via attrs, e.g. `attribute.class("h-32 w-full")`.
pub fn box(attrs: List(Attribute(msg))) -> Element(msg) {
  html.div([attribute.class("skeleton"), ..attrs], [])
}

/// Renders `<span class="skeleton skeleton-text">content</span>`.
/// Animates text with a shimmer gradient.
pub fn text(content: String) -> Element(msg) {
  html.span([attribute.class("skeleton skeleton-text")], [html.text(content)])
}
