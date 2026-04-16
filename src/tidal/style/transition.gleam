/// Transition and animation utilities.
///
/// ```gleam
/// import tidal/style/transition
///
/// button.style([transition.transition_colors(), transition.duration(200)])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Transition property
// ---------------------------------------------------------------------------

pub fn transition_none() -> Style { make("transition-none") }
pub fn transition_all() -> Style { make("transition-all") }
pub fn transition() -> Style { make("transition") }
pub fn transition_colors() -> Style { make("transition-colors") }
pub fn transition_opacity() -> Style { make("transition-opacity") }
pub fn transition_shadow() -> Style { make("transition-shadow") }
pub fn transition_transform() -> Style { make("transition-transform") }

/// `transition-discrete` — transition-behavior: allow-discrete (enables transitions on discrete properties like `display`).
pub fn transition_discrete() -> Style { make("transition-discrete") }

/// `transition-normal` — transition-behavior: normal.
pub fn transition_normal() -> Style { make("transition-normal") }

// ---------------------------------------------------------------------------
// Transition duration
// ---------------------------------------------------------------------------

/// `duration-{n}` — milliseconds. Common: 0, 75, 100, 150, 200, 300, 500, 700, 1000.
pub fn duration(n: Int) -> Style { make("duration-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Transition timing function
// ---------------------------------------------------------------------------

pub fn ease_linear() -> Style { make("ease-linear") }
pub fn ease_in() -> Style { make("ease-in") }
pub fn ease_out() -> Style { make("ease-out") }
pub fn ease_in_out() -> Style { make("ease-in-out") }

// ---------------------------------------------------------------------------
// Transition delay
// ---------------------------------------------------------------------------

/// `delay-{n}` — milliseconds. Common: 0, 75, 100, 150, 200, 300, 500, 700, 1000.
pub fn delay(n: Int) -> Style { make("delay-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Animation
// ---------------------------------------------------------------------------

pub fn animate_none() -> Style { make("animate-none") }
pub fn animate_spin() -> Style { make("animate-spin") }
pub fn animate_ping() -> Style { make("animate-ping") }
pub fn animate_pulse() -> Style { make("animate-pulse") }
pub fn animate_bounce() -> Style { make("animate-bounce") }
