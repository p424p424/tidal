/// Transform utilities — rotate, scale, translate, skew, and transform origin.
///
/// ```gleam
/// import tidal/style/transform
///
/// icon.style([transform.rotate(45), transform.scale(110)])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Scale
// ---------------------------------------------------------------------------

/// `scale-{n}` — uniform scale. Common: 0, 50, 75, 90, 95, 100, 105, 110, 125, 150.
pub fn scale(n: Int) -> Style { make("scale-" <> int.to_string(n)) }
pub fn scale_x(n: Int) -> Style { make("scale-x-" <> int.to_string(n)) }
pub fn scale_y(n: Int) -> Style { make("scale-y-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Rotate
// ---------------------------------------------------------------------------

/// `rotate-{n}` — degrees. Common: 0, 1, 2, 3, 6, 12, 45, 90, 180.
pub fn rotate(n: Int) -> Style { make("rotate-" <> int.to_string(n)) }
pub fn rotate_x(n: Int) -> Style { make("rotate-x-" <> int.to_string(n)) }
pub fn rotate_y(n: Int) -> Style { make("rotate-y-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Translate
// ---------------------------------------------------------------------------

/// `translate-x-{n}` — spacing scale value.
pub fn translate_x(n: Int) -> Style { make("translate-x-" <> int.to_string(n)) }
pub fn translate_y(n: Int) -> Style { make("translate-y-" <> int.to_string(n)) }
pub fn translate_x_half() -> Style { make("translate-x-1/2") }
pub fn translate_y_half() -> Style { make("translate-y-1/2") }
pub fn translate_x_full() -> Style { make("translate-x-full") }
pub fn translate_y_full() -> Style { make("translate-y-full") }

// ---------------------------------------------------------------------------
// Skew
// ---------------------------------------------------------------------------

/// `skew-x-{n}` — degrees. Common: 0, 1, 2, 3, 6, 12.
pub fn skew_x(n: Int) -> Style { make("skew-x-" <> int.to_string(n)) }
pub fn skew_y(n: Int) -> Style { make("skew-y-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Transform origin
// ---------------------------------------------------------------------------

pub fn origin_center() -> Style { make("origin-center") }
pub fn origin_top() -> Style { make("origin-top") }
pub fn origin_top_right() -> Style { make("origin-top-right") }
pub fn origin_right() -> Style { make("origin-right") }
pub fn origin_bottom_right() -> Style { make("origin-bottom-right") }
pub fn origin_bottom() -> Style { make("origin-bottom") }
pub fn origin_bottom_left() -> Style { make("origin-bottom-left") }
pub fn origin_left() -> Style { make("origin-left") }
pub fn origin_top_left() -> Style { make("origin-top-left") }

// ---------------------------------------------------------------------------
// Transform box
// ---------------------------------------------------------------------------

pub fn transform_box_content() -> Style { make("transform-box-content") }
pub fn transform_box_border() -> Style { make("transform-box-border") }
pub fn transform_box_fill() -> Style { make("transform-box-fill") }
pub fn transform_box_stroke() -> Style { make("transform-box-stroke") }
pub fn transform_box_view() -> Style { make("transform-box-view") }

// ---------------------------------------------------------------------------
// Perspective
// ---------------------------------------------------------------------------

pub fn perspective_none() -> Style { make("perspective-none") }
pub fn perspective_dramatic() -> Style { make("perspective-dramatic") }
pub fn perspective_near() -> Style { make("perspective-near") }
pub fn perspective_normal() -> Style { make("perspective-normal") }
pub fn perspective_midrange() -> Style { make("perspective-midrange") }
pub fn perspective_distant() -> Style { make("perspective-distant") }

// ---------------------------------------------------------------------------
// Perspective origin
// ---------------------------------------------------------------------------

pub fn perspective_origin_center() -> Style { make("perspective-origin-center") }
pub fn perspective_origin_top() -> Style { make("perspective-origin-top") }
pub fn perspective_origin_top_right() -> Style { make("perspective-origin-top-right") }
pub fn perspective_origin_right() -> Style { make("perspective-origin-right") }
pub fn perspective_origin_bottom_right() -> Style { make("perspective-origin-bottom-right") }
pub fn perspective_origin_bottom() -> Style { make("perspective-origin-bottom") }
pub fn perspective_origin_bottom_left() -> Style { make("perspective-origin-bottom-left") }
pub fn perspective_origin_left() -> Style { make("perspective-origin-left") }
pub fn perspective_origin_top_left() -> Style { make("perspective-origin-top-left") }

// ---------------------------------------------------------------------------
// Backface visibility
// ---------------------------------------------------------------------------

pub fn backface_visible() -> Style { make("backface-visible") }
pub fn backface_hidden() -> Style { make("backface-hidden") }

// ---------------------------------------------------------------------------
// Transform style
// ---------------------------------------------------------------------------

pub fn transform_flat() -> Style { make("transform-flat") }
pub fn transform_3d() -> Style { make("transform-3d") }
