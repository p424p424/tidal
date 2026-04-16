/// SVG utilities — fill, stroke, and stroke width.
///
/// ```gleam
/// import tidal/style/svg
/// import tidal/style/color
///
/// el.style([svg.fill(color.Primary), svg.stroke_width(2)])
/// ```

import gleam/int
import tidal/style.{type Style, make}
import tidal/style/color.{type Color}

// ---------------------------------------------------------------------------
// Fill
// ---------------------------------------------------------------------------

/// `fill-{color}` — SVG fill colour using a DaisyUI semantic colour token.
pub fn fill(c: Color) -> Style { make("fill-" <> color.to_string(c)) }

/// `fill-none` — SVG fill: none.
pub fn fill_none() -> Style { make("fill-none") }

/// `fill-current` — SVG fill: currentColor.
pub fn fill_current() -> Style { make("fill-current") }

// ---------------------------------------------------------------------------
// Stroke
// ---------------------------------------------------------------------------

/// `stroke-{color}` — SVG stroke colour using a DaisyUI semantic colour token.
pub fn stroke(c: Color) -> Style { make("stroke-" <> color.to_string(c)) }

/// `stroke-none` — SVG stroke: none.
pub fn stroke_none() -> Style { make("stroke-none") }

/// `stroke-current` — SVG stroke: currentColor.
pub fn stroke_current() -> Style { make("stroke-current") }

// ---------------------------------------------------------------------------
// Stroke width
// ---------------------------------------------------------------------------

/// `stroke-{n}` — SVG stroke-width. Common values: 0, 1, 2.
pub fn stroke_width(n: Int) -> Style { make("stroke-" <> int.to_string(n)) }
