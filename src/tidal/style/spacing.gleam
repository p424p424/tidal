/// Spacing utilities — padding and margin.
///
/// All functions accept an `Int` from Tailwind's spacing scale (0–96).
/// Common values: 0, 1, 2, 3, 4, 5, 6, 8, 10, 12, 16, 20, 24, 32, 40, 48, 64.
///
/// ```gleam
/// import tidal/style/spacing as sp
///
/// column.style([sp.px(6), sp.py(4), sp.mb(8)])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Padding — all sides
// ---------------------------------------------------------------------------

/// `p-{n}` — padding on all sides.
pub fn p(n: Int) -> Style { make("p-" <> int.to_string(n)) }

/// `px-{n}` — padding on left and right.
pub fn px(n: Int) -> Style { make("px-" <> int.to_string(n)) }

/// `py-{n}` — padding on top and bottom.
pub fn py(n: Int) -> Style { make("py-" <> int.to_string(n)) }

/// `pt-{n}` — padding top.
pub fn pt(n: Int) -> Style { make("pt-" <> int.to_string(n)) }

/// `pr-{n}` — padding right.
pub fn pr(n: Int) -> Style { make("pr-" <> int.to_string(n)) }

/// `pb-{n}` — padding bottom.
pub fn pb(n: Int) -> Style { make("pb-" <> int.to_string(n)) }

/// `pl-{n}` — padding left.
pub fn pl(n: Int) -> Style { make("pl-" <> int.to_string(n)) }

/// `ps-{n}` — padding inline-start (RTL-aware).
pub fn ps(n: Int) -> Style { make("ps-" <> int.to_string(n)) }

/// `pe-{n}` — padding inline-end (RTL-aware).
pub fn pe(n: Int) -> Style { make("pe-" <> int.to_string(n)) }

/// `p-px` — padding of exactly 1px.
pub fn p_px() -> Style { make("p-px") }

// ---------------------------------------------------------------------------
// Margin — all sides
// ---------------------------------------------------------------------------

/// `m-{n}` — margin on all sides.
pub fn m(n: Int) -> Style { make("m-" <> int.to_string(n)) }

/// `mx-{n}` — margin on left and right.
pub fn mx(n: Int) -> Style { make("mx-" <> int.to_string(n)) }

/// `my-{n}` — margin on top and bottom.
pub fn my(n: Int) -> Style { make("my-" <> int.to_string(n)) }

/// `mt-{n}` — margin top.
pub fn mt(n: Int) -> Style { make("mt-" <> int.to_string(n)) }

/// `mr-{n}` — margin right.
pub fn mr(n: Int) -> Style { make("mr-" <> int.to_string(n)) }

/// `mb-{n}` — margin bottom.
pub fn mb(n: Int) -> Style { make("mb-" <> int.to_string(n)) }

/// `ml-{n}` — margin left.
pub fn ml(n: Int) -> Style { make("ml-" <> int.to_string(n)) }

/// `ms-{n}` — margin inline-start (RTL-aware).
pub fn ms(n: Int) -> Style { make("ms-" <> int.to_string(n)) }

/// `me-{n}` — margin inline-end (RTL-aware).
pub fn me(n: Int) -> Style { make("me-" <> int.to_string(n)) }

/// `mx-auto` — horizontal auto margin (centers a block element).
pub fn mx_auto() -> Style { make("mx-auto") }

/// `my-auto` — vertical auto margin.
pub fn my_auto() -> Style { make("my-auto") }

/// `m-auto` — auto margin on all sides.
pub fn m_auto() -> Style { make("m-auto") }

/// `m-px` — margin of exactly 1px.
pub fn m_px() -> Style { make("m-px") }

// ---------------------------------------------------------------------------
// Space between (child spacing without gap)
// ---------------------------------------------------------------------------

/// `space-x-{n}` — horizontal space between children.
pub fn space_x(n: Int) -> Style { make("space-x-" <> int.to_string(n)) }

/// `space-y-{n}` — vertical space between children.
pub fn space_y(n: Int) -> Style { make("space-y-" <> int.to_string(n)) }

/// `space-x-reverse` — reverses `space-x` direction for RTL layouts.
pub fn space_x_reverse() -> Style { make("space-x-reverse") }

/// `space-y-reverse` — reverses `space-y` direction for RTL layouts.
pub fn space_y_reverse() -> Style { make("space-y-reverse") }
