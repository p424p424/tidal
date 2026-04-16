/// Background utilities — colour, image, position, size, and repeat.
///
/// ```gleam
/// import tidal/style/background as bg
/// import tidal/style/color
///
/// el.style([bg.bg(color.Base200), bg.bg_cover()])
/// ```

import tidal/style.{type Style, make}
import tidal/style/color.{type Color}

// ---------------------------------------------------------------------------
// Background colour
// ---------------------------------------------------------------------------

/// Sets the background colour using a DaisyUI semantic colour token.
///
/// ```gleam
/// bg.bg(color.Primary)    // → bg-primary
/// bg.bg(color.Base200)    // → bg-base-200
/// ```
pub fn bg(c: Color) -> Style {
  make("bg-" <> color.to_string(c))
}

// ---------------------------------------------------------------------------
// Background attachment
// ---------------------------------------------------------------------------

pub fn bg_fixed() -> Style { make("bg-fixed") }
pub fn bg_local() -> Style { make("bg-local") }
pub fn bg_scroll() -> Style { make("bg-scroll") }

// ---------------------------------------------------------------------------
// Background clip
// ---------------------------------------------------------------------------

pub fn bg_clip_border() -> Style { make("bg-clip-border") }
pub fn bg_clip_padding() -> Style { make("bg-clip-padding") }
pub fn bg_clip_content() -> Style { make("bg-clip-content") }
pub fn bg_clip_text() -> Style { make("bg-clip-text") }

// ---------------------------------------------------------------------------
// Background origin
// ---------------------------------------------------------------------------

pub fn bg_origin_border() -> Style { make("bg-origin-border") }
pub fn bg_origin_padding() -> Style { make("bg-origin-padding") }
pub fn bg_origin_content() -> Style { make("bg-origin-content") }

// ---------------------------------------------------------------------------
// Background position
// ---------------------------------------------------------------------------

pub fn bg_bottom() -> Style { make("bg-bottom") }
pub fn bg_center() -> Style { make("bg-center") }
pub fn bg_left() -> Style { make("bg-left") }
pub fn bg_left_bottom() -> Style { make("bg-left-bottom") }
pub fn bg_left_top() -> Style { make("bg-left-top") }
pub fn bg_right() -> Style { make("bg-right") }
pub fn bg_right_bottom() -> Style { make("bg-right-bottom") }
pub fn bg_right_top() -> Style { make("bg-right-top") }
pub fn bg_top() -> Style { make("bg-top") }

// ---------------------------------------------------------------------------
// Background repeat
// ---------------------------------------------------------------------------

pub fn bg_repeat() -> Style { make("bg-repeat") }
pub fn bg_no_repeat() -> Style { make("bg-no-repeat") }
pub fn bg_repeat_x() -> Style { make("bg-repeat-x") }
pub fn bg_repeat_y() -> Style { make("bg-repeat-y") }
pub fn bg_repeat_round() -> Style { make("bg-repeat-round") }
pub fn bg_repeat_space() -> Style { make("bg-repeat-space") }

// ---------------------------------------------------------------------------
// Background size
// ---------------------------------------------------------------------------

pub fn bg_auto() -> Style { make("bg-auto") }
pub fn bg_cover() -> Style { make("bg-cover") }
pub fn bg_contain() -> Style { make("bg-contain") }
