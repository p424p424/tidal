/// Layout utilities — display, position, overflow, visibility, z-index, and more.
///
/// ```gleam
/// import tidal/style/layout
///
/// el.style([layout.relative(), layout.overflow_hidden()])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Display
// ---------------------------------------------------------------------------

pub fn block() -> Style { make("block") }
pub fn inline_block() -> Style { make("inline-block") }
pub fn inline() -> Style { make("inline") }
pub fn flex() -> Style { make("flex") }
pub fn inline_flex() -> Style { make("inline-flex") }
pub fn grid() -> Style { make("grid") }
pub fn inline_grid() -> Style { make("inline-grid") }
pub fn hidden() -> Style { make("hidden") }
pub fn contents() -> Style { make("contents") }
pub fn flow_root() -> Style { make("flow-root") }
pub fn table() -> Style { make("table") }
pub fn table_caption() -> Style { make("table-caption") }
pub fn table_cell() -> Style { make("table-cell") }
pub fn table_row() -> Style { make("table-row") }
pub fn table_row_group() -> Style { make("table-row-group") }
pub fn table_header_group() -> Style { make("table-header-group") }
pub fn table_footer_group() -> Style { make("table-footer-group") }
pub fn table_column() -> Style { make("table-column") }
pub fn table_column_group() -> Style { make("table-column-group") }
pub fn list_item() -> Style { make("list-item") }

// ---------------------------------------------------------------------------
// Position
// ---------------------------------------------------------------------------

pub fn static() -> Style { make("static") }
pub fn fixed() -> Style { make("fixed") }
pub fn absolute() -> Style { make("absolute") }
pub fn relative() -> Style { make("relative") }
pub fn sticky() -> Style { make("sticky") }

// ---------------------------------------------------------------------------
// Top / Right / Bottom / Left
// ---------------------------------------------------------------------------

pub fn inset(n: Int) -> Style { make("inset-" <> int.to_string(n)) }
pub fn inset_x(n: Int) -> Style { make("inset-x-" <> int.to_string(n)) }
pub fn inset_y(n: Int) -> Style { make("inset-y-" <> int.to_string(n)) }
pub fn top(n: Int) -> Style { make("top-" <> int.to_string(n)) }
pub fn right(n: Int) -> Style { make("right-" <> int.to_string(n)) }
pub fn bottom(n: Int) -> Style { make("bottom-" <> int.to_string(n)) }
pub fn left(n: Int) -> Style { make("left-" <> int.to_string(n)) }
pub fn inset_auto() -> Style { make("inset-auto") }
pub fn top_auto() -> Style { make("top-auto") }
pub fn right_auto() -> Style { make("right-auto") }
pub fn bottom_auto() -> Style { make("bottom-auto") }
pub fn left_auto() -> Style { make("left-auto") }
pub fn top_full() -> Style { make("top-full") }
pub fn bottom_full() -> Style { make("bottom-full") }
pub fn left_full() -> Style { make("left-full") }
pub fn right_full() -> Style { make("right-full") }

// ---------------------------------------------------------------------------
// Z-index
// ---------------------------------------------------------------------------

/// `z-{n}` — z-index value.
pub fn z(n: Int) -> Style { make("z-" <> int.to_string(n)) }

/// `z-auto` — z-index: auto.
pub fn z_auto() -> Style { make("z-auto") }

// ---------------------------------------------------------------------------
// Overflow
// ---------------------------------------------------------------------------

pub fn overflow_auto() -> Style { make("overflow-auto") }
pub fn overflow_hidden() -> Style { make("overflow-hidden") }
pub fn overflow_clip() -> Style { make("overflow-clip") }
pub fn overflow_visible() -> Style { make("overflow-visible") }
pub fn overflow_scroll() -> Style { make("overflow-scroll") }
pub fn overflow_x_auto() -> Style { make("overflow-x-auto") }
pub fn overflow_x_hidden() -> Style { make("overflow-x-hidden") }
pub fn overflow_x_clip() -> Style { make("overflow-x-clip") }
pub fn overflow_x_visible() -> Style { make("overflow-x-visible") }
pub fn overflow_x_scroll() -> Style { make("overflow-x-scroll") }
pub fn overflow_y_auto() -> Style { make("overflow-y-auto") }
pub fn overflow_y_hidden() -> Style { make("overflow-y-hidden") }
pub fn overflow_y_clip() -> Style { make("overflow-y-clip") }
pub fn overflow_y_visible() -> Style { make("overflow-y-visible") }
pub fn overflow_y_scroll() -> Style { make("overflow-y-scroll") }

// ---------------------------------------------------------------------------
// Overscroll behaviour
// ---------------------------------------------------------------------------

pub fn overscroll_auto() -> Style { make("overscroll-auto") }
pub fn overscroll_contain() -> Style { make("overscroll-contain") }
pub fn overscroll_none() -> Style { make("overscroll-none") }
pub fn overscroll_y_auto() -> Style { make("overscroll-y-auto") }
pub fn overscroll_y_contain() -> Style { make("overscroll-y-contain") }
pub fn overscroll_y_none() -> Style { make("overscroll-y-none") }
pub fn overscroll_x_auto() -> Style { make("overscroll-x-auto") }
pub fn overscroll_x_contain() -> Style { make("overscroll-x-contain") }
pub fn overscroll_x_none() -> Style { make("overscroll-x-none") }

// ---------------------------------------------------------------------------
// Visibility
// ---------------------------------------------------------------------------

pub fn visible() -> Style { make("visible") }
pub fn invisible() -> Style { make("invisible") }
pub fn collapse() -> Style { make("collapse") }

// ---------------------------------------------------------------------------
// Float / clear
// ---------------------------------------------------------------------------

pub fn float_right() -> Style { make("float-right") }
pub fn float_left() -> Style { make("float-left") }
pub fn float_start() -> Style { make("float-start") }
pub fn float_end() -> Style { make("float-end") }
pub fn float_none() -> Style { make("float-none") }
pub fn clear_left() -> Style { make("clear-left") }
pub fn clear_right() -> Style { make("clear-right") }
pub fn clear_both() -> Style { make("clear-both") }
pub fn clear_start() -> Style { make("clear-start") }
pub fn clear_end() -> Style { make("clear-end") }
pub fn clear_none() -> Style { make("clear-none") }

// ---------------------------------------------------------------------------
// Isolation
// ---------------------------------------------------------------------------

pub fn isolate() -> Style { make("isolate") }
pub fn isolation_auto() -> Style { make("isolation-auto") }

// ---------------------------------------------------------------------------
// Object fit / position
// ---------------------------------------------------------------------------

pub fn object_contain() -> Style { make("object-contain") }
pub fn object_cover() -> Style { make("object-cover") }
pub fn object_fill() -> Style { make("object-fill") }
pub fn object_none() -> Style { make("object-none") }
pub fn object_scale_down() -> Style { make("object-scale-down") }
pub fn object_bottom() -> Style { make("object-bottom") }
pub fn object_center() -> Style { make("object-center") }
pub fn object_left() -> Style { make("object-left") }
pub fn object_left_bottom() -> Style { make("object-left-bottom") }
pub fn object_left_top() -> Style { make("object-left-top") }
pub fn object_right() -> Style { make("object-right") }
pub fn object_right_bottom() -> Style { make("object-right-bottom") }
pub fn object_right_top() -> Style { make("object-right-top") }
pub fn object_top() -> Style { make("object-top") }

// ---------------------------------------------------------------------------
// Aspect ratio
// ---------------------------------------------------------------------------

pub fn aspect_auto() -> Style { make("aspect-auto") }
pub fn aspect_square() -> Style { make("aspect-square") }
pub fn aspect_video() -> Style { make("aspect-video") }

// ---------------------------------------------------------------------------
// Box sizing
// ---------------------------------------------------------------------------

pub fn box_border() -> Style { make("box-border") }
pub fn box_content() -> Style { make("box-content") }

// ---------------------------------------------------------------------------
// Columns
// ---------------------------------------------------------------------------

/// `columns-{n}` — number of CSS columns.
pub fn columns(n: Int) -> Style { make("columns-" <> int.to_string(n)) }
pub fn columns_auto() -> Style { make("columns-auto") }

// ---------------------------------------------------------------------------
// Break
// ---------------------------------------------------------------------------

pub fn break_after_auto() -> Style { make("break-after-auto") }
pub fn break_after_avoid() -> Style { make("break-after-avoid") }
pub fn break_after_all() -> Style { make("break-after-all") }
pub fn break_after_page() -> Style { make("break-after-page") }
pub fn break_after_column() -> Style { make("break-after-column") }
pub fn break_before_auto() -> Style { make("break-before-auto") }
pub fn break_before_avoid() -> Style { make("break-before-avoid") }
pub fn break_before_all() -> Style { make("break-before-all") }
pub fn break_before_page() -> Style { make("break-before-page") }
pub fn break_before_column() -> Style { make("break-before-column") }
pub fn break_inside_auto() -> Style { make("break-inside-auto") }
pub fn break_inside_avoid() -> Style { make("break-inside-avoid") }
pub fn break_inside_avoid_page() -> Style { make("break-inside-avoid-page") }
pub fn break_inside_avoid_column() -> Style { make("break-inside-avoid-column") }

// ---------------------------------------------------------------------------
// Box decoration break
// ---------------------------------------------------------------------------

/// `box-decoration-clone` — render box decorations as if the element were not fragmented.
pub fn box_decoration_clone() -> Style { make("box-decoration-clone") }

/// `box-decoration-slice` — render box decorations independently on each fragment.
pub fn box_decoration_slice() -> Style { make("box-decoration-slice") }
