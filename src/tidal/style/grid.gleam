/// CSS Grid utilities — template columns/rows, spans, and auto placement.
///
/// ```gleam
/// import tidal/style/grid
/// import tidal/style/flexbox as fx
///
/// el.style([grid.grid_cols(3), fx.gap(4)])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Grid template columns
// ---------------------------------------------------------------------------

/// `grid-cols-{n}` — n equal-width columns.
pub fn grid_cols(n: Int) -> Style { make("grid-cols-" <> int.to_string(n)) }
pub fn grid_cols_none() -> Style { make("grid-cols-none") }
pub fn grid_cols_subgrid() -> Style { make("grid-cols-subgrid") }

// ---------------------------------------------------------------------------
// Grid column span / start / end
// ---------------------------------------------------------------------------

pub fn col_auto() -> Style { make("col-auto") }

/// `col-span-{n}` — span n columns.
pub fn col_span(n: Int) -> Style { make("col-span-" <> int.to_string(n)) }
pub fn col_span_full() -> Style { make("col-span-full") }

/// `col-start-{n}` — start at column line n.
pub fn col_start(n: Int) -> Style { make("col-start-" <> int.to_string(n)) }
pub fn col_start_auto() -> Style { make("col-start-auto") }

/// `col-end-{n}` — end at column line n.
pub fn col_end(n: Int) -> Style { make("col-end-" <> int.to_string(n)) }
pub fn col_end_auto() -> Style { make("col-end-auto") }

// ---------------------------------------------------------------------------
// Grid template rows
// ---------------------------------------------------------------------------

/// `grid-rows-{n}` — n equal-height rows.
pub fn grid_rows(n: Int) -> Style { make("grid-rows-" <> int.to_string(n)) }
pub fn grid_rows_none() -> Style { make("grid-rows-none") }
pub fn grid_rows_subgrid() -> Style { make("grid-rows-subgrid") }

// ---------------------------------------------------------------------------
// Grid row span / start / end
// ---------------------------------------------------------------------------

pub fn row_auto() -> Style { make("row-auto") }

/// `row-span-{n}` — span n rows.
pub fn row_span(n: Int) -> Style { make("row-span-" <> int.to_string(n)) }
pub fn row_span_full() -> Style { make("row-span-full") }

/// `row-start-{n}` — start at row line n.
pub fn row_start(n: Int) -> Style { make("row-start-" <> int.to_string(n)) }
pub fn row_start_auto() -> Style { make("row-start-auto") }

/// `row-end-{n}` — end at row line n.
pub fn row_end(n: Int) -> Style { make("row-end-" <> int.to_string(n)) }
pub fn row_end_auto() -> Style { make("row-end-auto") }

// ---------------------------------------------------------------------------
// Grid auto flow
// ---------------------------------------------------------------------------

pub fn grid_flow_row() -> Style { make("grid-flow-row") }
pub fn grid_flow_col() -> Style { make("grid-flow-col") }
pub fn grid_flow_dense() -> Style { make("grid-flow-dense") }
pub fn grid_flow_row_dense() -> Style { make("grid-flow-row-dense") }
pub fn grid_flow_col_dense() -> Style { make("grid-flow-col-dense") }

// ---------------------------------------------------------------------------
// Grid auto columns
// ---------------------------------------------------------------------------

pub fn auto_cols_auto() -> Style { make("auto-cols-auto") }
pub fn auto_cols_min() -> Style { make("auto-cols-min") }
pub fn auto_cols_max() -> Style { make("auto-cols-max") }
pub fn auto_cols_fr() -> Style { make("auto-cols-fr") }

// ---------------------------------------------------------------------------
// Grid auto rows
// ---------------------------------------------------------------------------

pub fn auto_rows_auto() -> Style { make("auto-rows-auto") }
pub fn auto_rows_min() -> Style { make("auto-rows-min") }
pub fn auto_rows_max() -> Style { make("auto-rows-max") }
pub fn auto_rows_fr() -> Style { make("auto-rows-fr") }
