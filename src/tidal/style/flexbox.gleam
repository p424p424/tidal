/// Flexbox utilities — direction, wrapping, alignment, and gap.
///
/// ```gleam
/// import tidal/style/flexbox as fx
///
/// row.style([fx.items_center(), fx.justify_between(), fx.gap(4)])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Flex basis
// ---------------------------------------------------------------------------

pub fn basis(n: Int) -> Style { make("basis-" <> int.to_string(n)) }
pub fn basis_auto() -> Style { make("basis-auto") }
pub fn basis_full() -> Style { make("basis-full") }
pub fn basis_half() -> Style { make("basis-1/2") }
pub fn basis_one_third() -> Style { make("basis-1/3") }
pub fn basis_two_thirds() -> Style { make("basis-2/3") }
pub fn basis_quarter() -> Style { make("basis-1/4") }
pub fn basis_three_quarters() -> Style { make("basis-3/4") }

// ---------------------------------------------------------------------------
// Flex direction
// ---------------------------------------------------------------------------

/// `flex-row` — left to right (default).
pub fn flex_row() -> Style { make("flex-row") }

/// `flex-row-reverse` — right to left.
pub fn flex_row_reverse() -> Style { make("flex-row-reverse") }

/// `flex-col` — top to bottom.
pub fn flex_col() -> Style { make("flex-col") }

/// `flex-col-reverse` — bottom to top.
pub fn flex_col_reverse() -> Style { make("flex-col-reverse") }

// ---------------------------------------------------------------------------
// Flex wrap
// ---------------------------------------------------------------------------

pub fn flex_wrap() -> Style { make("flex-wrap") }
pub fn flex_wrap_reverse() -> Style { make("flex-wrap-reverse") }
pub fn flex_nowrap() -> Style { make("flex-nowrap") }

// ---------------------------------------------------------------------------
// Flex grow / shrink / shorthand
// ---------------------------------------------------------------------------

/// `flex-1` — flex: 1 1 0%.
pub fn flex_1() -> Style { make("flex-1") }

/// `flex-auto` — flex: 1 1 auto.
pub fn flex_auto() -> Style { make("flex-auto") }

/// `flex-initial` — flex: 0 1 auto.
pub fn flex_initial() -> Style { make("flex-initial") }

/// `flex-none` — flex: none.
pub fn flex_none() -> Style { make("flex-none") }

/// `grow` — flex-grow: 1.
pub fn grow() -> Style { make("grow") }

/// `grow-0` — flex-grow: 0.
pub fn grow_0() -> Style { make("grow-0") }

/// `shrink` — flex-shrink: 1.
pub fn shrink() -> Style { make("shrink") }

/// `shrink-0` — flex-shrink: 0. Useful to prevent an item from shrinking.
pub fn shrink_0() -> Style { make("shrink-0") }

// ---------------------------------------------------------------------------
// Order
// ---------------------------------------------------------------------------

pub fn order(n: Int) -> Style { make("order-" <> int.to_string(n)) }
pub fn order_first() -> Style { make("order-first") }
pub fn order_last() -> Style { make("order-last") }
pub fn order_none() -> Style { make("order-none") }

// ---------------------------------------------------------------------------
// Gap
// ---------------------------------------------------------------------------

/// `gap-{n}` — gap between flex/grid children on both axes.
pub fn gap(n: Int) -> Style { make("gap-" <> int.to_string(n)) }

/// `gap-x-{n}` — horizontal gap between children.
pub fn gap_x(n: Int) -> Style { make("gap-x-" <> int.to_string(n)) }

/// `gap-y-{n}` — vertical gap between children.
pub fn gap_y(n: Int) -> Style { make("gap-y-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Justify content (main axis)
// ---------------------------------------------------------------------------

pub fn justify_normal() -> Style { make("justify-normal") }
pub fn justify_start() -> Style { make("justify-start") }
pub fn justify_end() -> Style { make("justify-end") }
pub fn justify_center() -> Style { make("justify-center") }
pub fn justify_between() -> Style { make("justify-between") }
pub fn justify_around() -> Style { make("justify-around") }
pub fn justify_evenly() -> Style { make("justify-evenly") }
pub fn justify_stretch() -> Style { make("justify-stretch") }

// ---------------------------------------------------------------------------
// Justify items (grid — inline axis per cell)
// ---------------------------------------------------------------------------

pub fn justify_items_start() -> Style { make("justify-items-start") }
pub fn justify_items_end() -> Style { make("justify-items-end") }
pub fn justify_items_center() -> Style { make("justify-items-center") }
pub fn justify_items_stretch() -> Style { make("justify-items-stretch") }
pub fn justify_items_normal() -> Style { make("justify-items-normal") }

// ---------------------------------------------------------------------------
// Justify self (individual item override)
// ---------------------------------------------------------------------------

pub fn justify_self_auto() -> Style { make("justify-self-auto") }
pub fn justify_self_start() -> Style { make("justify-self-start") }
pub fn justify_self_end() -> Style { make("justify-self-end") }
pub fn justify_self_center() -> Style { make("justify-self-center") }
pub fn justify_self_stretch() -> Style { make("justify-self-stretch") }

// ---------------------------------------------------------------------------
// Align content (cross axis — when wrapping)
// ---------------------------------------------------------------------------

pub fn content_normal() -> Style { make("content-normal") }
pub fn content_start() -> Style { make("content-start") }
pub fn content_end() -> Style { make("content-end") }
pub fn content_center() -> Style { make("content-center") }
pub fn content_between() -> Style { make("content-between") }
pub fn content_around() -> Style { make("content-around") }
pub fn content_evenly() -> Style { make("content-evenly") }
pub fn content_baseline() -> Style { make("content-baseline") }
pub fn content_stretch() -> Style { make("content-stretch") }

// ---------------------------------------------------------------------------
// Align items (cross axis — all items)
// ---------------------------------------------------------------------------

pub fn items_start() -> Style { make("items-start") }
pub fn items_end() -> Style { make("items-end") }
pub fn items_center() -> Style { make("items-center") }
pub fn items_baseline() -> Style { make("items-baseline") }
pub fn items_stretch() -> Style { make("items-stretch") }

// ---------------------------------------------------------------------------
// Align self (individual item override)
// ---------------------------------------------------------------------------

pub fn self_auto() -> Style { make("self-auto") }
pub fn self_start() -> Style { make("self-start") }
pub fn self_end() -> Style { make("self-end") }
pub fn self_center() -> Style { make("self-center") }
pub fn self_baseline() -> Style { make("self-baseline") }
pub fn self_stretch() -> Style { make("self-stretch") }

// ---------------------------------------------------------------------------
// Place (shorthand for align + justify — grid)
// ---------------------------------------------------------------------------

pub fn place_content_center() -> Style { make("place-content-center") }
pub fn place_content_start() -> Style { make("place-content-start") }
pub fn place_content_end() -> Style { make("place-content-end") }
pub fn place_content_between() -> Style { make("place-content-between") }
pub fn place_content_around() -> Style { make("place-content-around") }
pub fn place_content_evenly() -> Style { make("place-content-evenly") }
pub fn place_content_stretch() -> Style { make("place-content-stretch") }

pub fn place_items_start() -> Style { make("place-items-start") }
pub fn place_items_end() -> Style { make("place-items-end") }
pub fn place_items_center() -> Style { make("place-items-center") }
pub fn place_items_baseline() -> Style { make("place-items-baseline") }
pub fn place_items_stretch() -> Style { make("place-items-stretch") }

pub fn place_self_auto() -> Style { make("place-self-auto") }
pub fn place_self_start() -> Style { make("place-self-start") }
pub fn place_self_end() -> Style { make("place-self-end") }
pub fn place_self_center() -> Style { make("place-self-center") }
pub fn place_self_stretch() -> Style { make("place-self-stretch") }
