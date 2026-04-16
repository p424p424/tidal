/// Accessibility utilities.
///
/// ```gleam
/// import tidal/style/accessibility
///
/// el.style([accessibility.forced_color_adjust_auto()])
/// ```

import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Forced color adjust
// ---------------------------------------------------------------------------

/// `forced-color-adjust-auto` — let the browser adjust colours in forced-colours mode.
pub fn forced_color_adjust_auto() -> Style { make("forced-color-adjust-auto") }

/// `forced-color-adjust-none` — opt out of forced-colours adjustments.
pub fn forced_color_adjust_none() -> Style { make("forced-color-adjust-none") }
