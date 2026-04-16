/// Flex spacer — a zero-content `<div>` with `flex-1` that fills available space.
///
/// Drop one inside a `row` or `column` to push siblings apart.
///
/// ```gleam
/// import tidal/row
/// import tidal/spacer
/// import tidal/text
///
/// row.new()
/// |> row.children([
///   text.new("Left") |> text.build,
///   spacer.spacer(),
///   text.new("Right") |> text.build,
/// ])
/// |> row.build
/// ```

import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

/// Returns a flex-1 spacer element. No builder needed — it has no configuration.
pub fn spacer() -> Element(msg) {
  html.div([attribute.class("flex-1")], [])
}
