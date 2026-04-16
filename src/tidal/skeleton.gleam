/// Skeleton — animated loading placeholder.
///
/// Call `new()` to start a block skeleton or `text_mode` for inline text shimmer.
///
/// ```gleam
/// import tidal/skeleton
/// import tidal/style as s
///
/// // Block skeleton (e.g. image placeholder)
/// skeleton.new()
/// |> skeleton.style([s.h(32), s.w_full, s.rounded_full])
/// |> skeleton.build
///
/// // Text shimmer
/// skeleton.new()
/// |> skeleton.text_mode
/// |> skeleton.build
/// ```

import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Skeleton(msg) {
  Skeleton(
    text_mode: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Create a new skeleton placeholder.
/// By default renders a block `<div class="skeleton">`.
/// Combine with `style([s.h(32), s.w_full])` to control sizing.
pub fn new() -> Skeleton(msg) {
  Skeleton(text_mode: False, styles: [], attrs: [])
}

/// Switch to inline text shimmer — renders `<span>` with `skeleton` class.
pub fn text(sk: Skeleton(msg)) -> Skeleton(msg) {
  Skeleton(..sk, text_mode: True)
}

/// Appends Tailwind utility styles for sizing and shape.
pub fn style(sk: Skeleton(msg), s: List(Style)) -> Skeleton(msg) {
  Skeleton(..sk, styles: list.append(sk.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(sk: Skeleton(msg), a: List(Attribute(msg))) -> Skeleton(msg) {
  Skeleton(..sk, attrs: list.append(sk.attrs, a))
}

pub fn build(sk: Skeleton(msg)) -> Element(msg) {
  let extra = style.to_class_string(sk.styles)
  let classes = case extra {
    "" -> "skeleton"
    s -> "skeleton " <> s
  }
  case sk.text_mode {
    True -> html.span([attribute.class(classes), ..sk.attrs], [])
    False -> html.div([attribute.class(classes), ..sk.attrs], [])
  }
}
