/// Table utilities — border collapse, spacing, layout, and caption placement.
///
/// ```gleam
/// import tidal/style/tables
///
/// el.style([tables.border_collapse(), tables.table_auto()])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Border collapse
// ---------------------------------------------------------------------------

/// `border-collapse` — collapse adjacent cell borders into one.
pub fn border_collapse() -> Style { make("border-collapse") }

/// `border-separate` — keep cell borders separate.
pub fn border_separate() -> Style { make("border-separate") }

// ---------------------------------------------------------------------------
// Border spacing
// ---------------------------------------------------------------------------

/// `border-spacing-{n}` — spacing between separated cell borders on the spacing scale.
pub fn border_spacing(n: Int) -> Style { make("border-spacing-" <> int.to_string(n)) }

/// `border-spacing-x-{n}` — horizontal spacing between separated cell borders.
pub fn border_spacing_x(n: Int) -> Style { make("border-spacing-x-" <> int.to_string(n)) }

/// `border-spacing-y-{n}` — vertical spacing between separated cell borders.
pub fn border_spacing_y(n: Int) -> Style { make("border-spacing-y-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Table layout
// ---------------------------------------------------------------------------

/// `table-auto` — column widths determined by content.
pub fn table_auto() -> Style { make("table-auto") }

/// `table-fixed` — column widths determined by the first row.
pub fn table_fixed() -> Style { make("table-fixed") }

// ---------------------------------------------------------------------------
// Caption side
// ---------------------------------------------------------------------------

/// `caption-top` — position the table caption above the table.
pub fn caption_top() -> Style { make("caption-top") }

/// `caption-bottom` — position the table caption below the table.
pub fn caption_bottom() -> Style { make("caption-bottom") }
