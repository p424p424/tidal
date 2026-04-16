/// Sizing utilities — width and height.
///
/// Numeric functions accept values from Tailwind's spacing scale (0–96).
/// Named variants cover the most common keyword values.
///
/// ```gleam
/// import tidal/style/sizing
///
/// row.style([sizing.w_full(), sizing.h(16)])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Width
// ---------------------------------------------------------------------------

/// `w-{n}` — fixed width on the spacing scale.
pub fn w(n: Int) -> Style { make("w-" <> int.to_string(n)) }

/// `w-auto` — browser-determined width.
pub fn w_auto() -> Style { make("w-auto") }

/// `w-full` — 100% of parent width.
pub fn w_full() -> Style { make("w-full") }

/// `w-screen` — 100vw.
pub fn w_screen() -> Style { make("w-screen") }

/// `w-svw` — 100svw (small viewport width).
pub fn w_svw() -> Style { make("w-svw") }

/// `w-dvw` — 100dvw (dynamic viewport width).
pub fn w_dvw() -> Style { make("w-dvw") }

/// `w-min` — min-content width.
pub fn w_min() -> Style { make("w-min") }

/// `w-max` — max-content width.
pub fn w_max() -> Style { make("w-max") }

/// `w-fit` — fit-content width.
pub fn w_fit() -> Style { make("w-fit") }

/// `w-px` — exactly 1px wide.
pub fn w_px() -> Style { make("w-px") }

/// `w-1/2` — 50% width.
pub fn w_half() -> Style { make("w-1/2") }

/// `w-1/3` — 33.33% width.
pub fn w_one_third() -> Style { make("w-1/3") }

/// `w-2/3` — 66.67% width.
pub fn w_two_thirds() -> Style { make("w-2/3") }

/// `w-1/4` — 25% width.
pub fn w_quarter() -> Style { make("w-1/4") }

/// `w-3/4` — 75% width.
pub fn w_three_quarters() -> Style { make("w-3/4") }

// ---------------------------------------------------------------------------
// Min width
// ---------------------------------------------------------------------------

/// `min-w-{n}` — minimum width on the spacing scale.
pub fn min_w(n: Int) -> Style { make("min-w-" <> int.to_string(n)) }

/// `min-w-0` — minimum width of 0.
pub fn min_w_0() -> Style { make("min-w-0") }

/// `min-w-full` — minimum width of 100%.
pub fn min_w_full() -> Style { make("min-w-full") }

/// `min-w-min` — minimum width of min-content.
pub fn min_w_min() -> Style { make("min-w-min") }

/// `min-w-max` — minimum width of max-content.
pub fn min_w_max() -> Style { make("min-w-max") }

/// `min-w-fit` — minimum width of fit-content.
pub fn min_w_fit() -> Style { make("min-w-fit") }

// ---------------------------------------------------------------------------
// Max width
// ---------------------------------------------------------------------------

/// `max-w-none` — no maximum width.
pub fn max_w_none() -> Style { make("max-w-none") }

/// `max-w-xs` — max-width: 20rem.
pub fn max_w_xs() -> Style { make("max-w-xs") }

/// `max-w-sm` — max-width: 24rem.
pub fn max_w_sm() -> Style { make("max-w-sm") }

/// `max-w-md` — max-width: 28rem.
pub fn max_w_md() -> Style { make("max-w-md") }

/// `max-w-lg` — max-width: 32rem.
pub fn max_w_lg() -> Style { make("max-w-lg") }

/// `max-w-xl` — max-width: 36rem.
pub fn max_w_xl() -> Style { make("max-w-xl") }

/// `max-w-2xl` — max-width: 42rem.
pub fn max_w_2xl() -> Style { make("max-w-2xl") }

/// `max-w-3xl` — max-width: 48rem.
pub fn max_w_3xl() -> Style { make("max-w-3xl") }

/// `max-w-4xl` — max-width: 56rem.
pub fn max_w_4xl() -> Style { make("max-w-4xl") }

/// `max-w-5xl` — max-width: 64rem.
pub fn max_w_5xl() -> Style { make("max-w-5xl") }

/// `max-w-6xl` — max-width: 72rem.
pub fn max_w_6xl() -> Style { make("max-w-6xl") }

/// `max-w-7xl` — max-width: 80rem.
pub fn max_w_7xl() -> Style { make("max-w-7xl") }

/// `max-w-full` — max-width: 100%.
pub fn max_w_full() -> Style { make("max-w-full") }

/// `max-w-screen` — max-width: 100vw.
pub fn max_w_screen() -> Style { make("max-w-screen") }

/// `max-w-min` — max-width: min-content.
pub fn max_w_min() -> Style { make("max-w-min") }

/// `max-w-max` — max-width: max-content.
pub fn max_w_max() -> Style { make("max-w-max") }

/// `max-w-fit` — max-width: fit-content.
pub fn max_w_fit() -> Style { make("max-w-fit") }

/// `max-w-prose` — max-width: 65ch (ideal reading width).
pub fn max_w_prose() -> Style { make("max-w-prose") }

// ---------------------------------------------------------------------------
// Height
// ---------------------------------------------------------------------------

/// `h-{n}` — fixed height on the spacing scale.
pub fn h(n: Int) -> Style { make("h-" <> int.to_string(n)) }

/// `h-auto` — browser-determined height.
pub fn h_auto() -> Style { make("h-auto") }

/// `h-full` — 100% of parent height.
pub fn h_full() -> Style { make("h-full") }

/// `h-screen` — 100vh.
pub fn h_screen() -> Style { make("h-screen") }

/// `h-svh` — 100svh (small viewport height).
pub fn h_svh() -> Style { make("h-svh") }

/// `h-dvh` — 100dvh (dynamic viewport height).
pub fn h_dvh() -> Style { make("h-dvh") }

/// `h-min` — min-content height.
pub fn h_min() -> Style { make("h-min") }

/// `h-max` — max-content height.
pub fn h_max() -> Style { make("h-max") }

/// `h-fit` — fit-content height.
pub fn h_fit() -> Style { make("h-fit") }

/// `h-px` — exactly 1px tall.
pub fn h_px() -> Style { make("h-px") }

// ---------------------------------------------------------------------------
// Min / max height
// ---------------------------------------------------------------------------

/// `min-h-{n}` — minimum height on the spacing scale.
pub fn min_h(n: Int) -> Style { make("min-h-" <> int.to_string(n)) }

/// `min-h-0` — minimum height of 0.
pub fn min_h_0() -> Style { make("min-h-0") }

/// `min-h-full` — minimum height of 100%.
pub fn min_h_full() -> Style { make("min-h-full") }

/// `min-h-screen` — minimum height of 100vh.
pub fn min_h_screen() -> Style { make("min-h-screen") }

/// `min-h-dvh` — minimum height of 100dvh.
pub fn min_h_dvh() -> Style { make("min-h-dvh") }

/// `min-h-fit` — minimum height of fit-content.
pub fn min_h_fit() -> Style { make("min-h-fit") }

/// `max-h-none` — no maximum height.
pub fn max_h_none() -> Style { make("max-h-none") }

/// `max-h-{n}` — maximum height on the spacing scale.
pub fn max_h(n: Int) -> Style { make("max-h-" <> int.to_string(n)) }

/// `max-h-full` — maximum height of 100%.
pub fn max_h_full() -> Style { make("max-h-full") }

/// `max-h-screen` — maximum height of 100vh.
pub fn max_h_screen() -> Style { make("max-h-screen") }

/// `max-h-dvh` — maximum height of 100dvh.
pub fn max_h_dvh() -> Style { make("max-h-dvh") }

/// `max-h-fit` — maximum height of fit-content.
pub fn max_h_fit() -> Style { make("max-h-fit") }

// ---------------------------------------------------------------------------
// Logical sizing (inline-size / block-size)
// ---------------------------------------------------------------------------

/// `size-{n}` — sets both width and height together on the spacing scale.
pub fn size(n: Int) -> Style { make("size-" <> int.to_string(n)) }
pub fn size_auto() -> Style { make("size-auto") }
pub fn size_full() -> Style { make("size-full") }
pub fn size_fit() -> Style { make("size-fit") }
pub fn size_min() -> Style { make("size-min") }
pub fn size_max() -> Style { make("size-max") }

/// `is-{n}` — inline-size (width in horizontal writing mode) on the spacing scale.
pub fn is(n: Int) -> Style { make("is-" <> int.to_string(n)) }
pub fn is_auto() -> Style { make("is-auto") }
pub fn is_full() -> Style { make("is-full") }
pub fn is_fit() -> Style { make("is-fit") }
pub fn min_is(n: Int) -> Style { make("min-is-" <> int.to_string(n)) }
pub fn min_is_full() -> Style { make("min-is-full") }
pub fn max_is(n: Int) -> Style { make("max-is-" <> int.to_string(n)) }
pub fn max_is_full() -> Style { make("max-is-full") }
pub fn max_is_none() -> Style { make("max-is-none") }

/// `bs-{n}` — block-size (height in horizontal writing mode) on the spacing scale.
pub fn bs(n: Int) -> Style { make("bs-" <> int.to_string(n)) }
pub fn bs_auto() -> Style { make("bs-auto") }
pub fn bs_full() -> Style { make("bs-full") }
pub fn bs_fit() -> Style { make("bs-fit") }
pub fn min_bs(n: Int) -> Style { make("min-bs-" <> int.to_string(n)) }
pub fn min_bs_full() -> Style { make("min-bs-full") }
pub fn max_bs(n: Int) -> Style { make("max-bs-" <> int.to_string(n)) }
pub fn max_bs_full() -> Style { make("max-bs-full") }
pub fn max_bs_none() -> Style { make("max-bs-none") }
