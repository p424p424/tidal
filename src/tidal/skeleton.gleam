/// Skeleton — animated loading placeholder.
///
/// Call `new()` to start a block skeleton or `text` for inline text shimmer.
///
/// ```gleam
/// import tidal/skeleton
/// import tidal/style as s
///
/// // Block skeleton (e.g. image placeholder)
/// skeleton.new()
/// |> skeleton.style(styles: [s.h(32), s.w_full, s.rounded_full])
/// |> skeleton.build
///
/// // Text shimmer
/// skeleton.new()
/// |> skeleton.text
/// |> skeleton.build
/// ```
///
/// See also:
/// - DaisyUI skeleton docs: https://daisyui.com/components/skeleton/
import gleam/list
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

pub opaque type Skeleton(msg) {
  Skeleton(text_mode: Bool, styles: List(Style), attrs: List(Attribute(msg)))
}

/// Creates a new `Skeleton` placeholder — renders a block `<div class="skeleton">` by default.
///
/// Chain builder functions to configure the skeleton, then call `build`:
///
/// ```gleam
/// import tidal/skeleton
/// import tidal/style as s
///
/// skeleton.new()
/// |> skeleton.style(styles: [s.h(32), s.w_full])
/// |> skeleton.build
/// ```
///
/// See also:
/// - DaisyUI skeleton docs: https://daisyui.com/components/skeleton/
pub fn new() -> Skeleton(msg) {
  Skeleton(text_mode: False, styles: [], attrs: [])
}

/// Switch to inline text shimmer — renders `<span>` with `skeleton` class.
pub fn text(skeleton: Skeleton(msg)) -> Skeleton(msg) {
  Skeleton(..skeleton, text_mode: True)
}

/// Appends Tailwind utility styles for sizing and shape.
pub fn style(
  skeleton: Skeleton(msg),
  styles styles: List(Style),
) -> Skeleton(msg) {
  Skeleton(..skeleton, styles: list.append(skeleton.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  skeleton: Skeleton(msg),
  attributes attributes: List(Attribute(msg)),
) -> Skeleton(msg) {
  Skeleton(..skeleton, attrs: list.append(skeleton.attrs, attributes))
}

pub fn build(skeleton: Skeleton(msg)) -> Element(msg) {
  let extra = style.to_class_string(skeleton.styles)
  let classes = case extra {
    "" -> "skeleton"
    s -> "skeleton " <> s
  }
  case skeleton.text_mode {
    True -> html.span([attribute.class(classes), ..skeleton.attrs], [])
    False -> html.div([attribute.class(classes), ..skeleton.attrs], [])
  }
}
