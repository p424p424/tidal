/// Interactivity utilities — cursor, user selection, pointer events, resize,
/// scroll behaviour, touch action, caret, and appearance.
///
/// ```gleam
/// import tidal/style/interactivity
///
/// button.style([interactivity.cursor_pointer(), interactivity.select_none()])
/// ```

import gleam/int
import tidal/style.{type Style, make}

// ---------------------------------------------------------------------------
// Cursor
// ---------------------------------------------------------------------------

pub fn cursor_auto() -> Style { make("cursor-auto") }
pub fn cursor_default() -> Style { make("cursor-default") }
pub fn cursor_pointer() -> Style { make("cursor-pointer") }
pub fn cursor_wait() -> Style { make("cursor-wait") }
pub fn cursor_text() -> Style { make("cursor-text") }
pub fn cursor_move() -> Style { make("cursor-move") }
pub fn cursor_help() -> Style { make("cursor-help") }
pub fn cursor_not_allowed() -> Style { make("cursor-not-allowed") }
pub fn cursor_none() -> Style { make("cursor-none") }
pub fn cursor_context_menu() -> Style { make("cursor-context-menu") }
pub fn cursor_progress() -> Style { make("cursor-progress") }
pub fn cursor_cell() -> Style { make("cursor-cell") }
pub fn cursor_crosshair() -> Style { make("cursor-crosshair") }
pub fn cursor_vertical_text() -> Style { make("cursor-vertical-text") }
pub fn cursor_alias() -> Style { make("cursor-alias") }
pub fn cursor_copy() -> Style { make("cursor-copy") }
pub fn cursor_no_drop() -> Style { make("cursor-no-drop") }
pub fn cursor_grab() -> Style { make("cursor-grab") }
pub fn cursor_grabbing() -> Style { make("cursor-grabbing") }
pub fn cursor_all_scroll() -> Style { make("cursor-all-scroll") }
pub fn cursor_col_resize() -> Style { make("cursor-col-resize") }
pub fn cursor_row_resize() -> Style { make("cursor-row-resize") }
pub fn cursor_n_resize() -> Style { make("cursor-n-resize") }
pub fn cursor_e_resize() -> Style { make("cursor-e-resize") }
pub fn cursor_s_resize() -> Style { make("cursor-s-resize") }
pub fn cursor_w_resize() -> Style { make("cursor-w-resize") }
pub fn cursor_zoom_in() -> Style { make("cursor-zoom-in") }
pub fn cursor_zoom_out() -> Style { make("cursor-zoom-out") }

// ---------------------------------------------------------------------------
// User select
// ---------------------------------------------------------------------------

pub fn select_none() -> Style { make("select-none") }
pub fn select_text() -> Style { make("select-text") }
pub fn select_all() -> Style { make("select-all") }
pub fn select_auto() -> Style { make("select-auto") }

// ---------------------------------------------------------------------------
// Pointer events
// ---------------------------------------------------------------------------

pub fn pointer_events_none() -> Style { make("pointer-events-none") }
pub fn pointer_events_auto() -> Style { make("pointer-events-auto") }

// ---------------------------------------------------------------------------
// Resize
// ---------------------------------------------------------------------------

pub fn resize_none() -> Style { make("resize-none") }
pub fn resize() -> Style { make("resize") }
pub fn resize_x() -> Style { make("resize-x") }
pub fn resize_y() -> Style { make("resize-y") }

// ---------------------------------------------------------------------------
// Scroll behaviour
// ---------------------------------------------------------------------------

pub fn scroll_auto() -> Style { make("scroll-auto") }
pub fn scroll_smooth() -> Style { make("scroll-smooth") }

// ---------------------------------------------------------------------------
// Scroll margin
// ---------------------------------------------------------------------------

pub fn scroll_m(n: Int) -> Style { make("scroll-m-" <> int.to_string(n)) }
pub fn scroll_mx(n: Int) -> Style { make("scroll-mx-" <> int.to_string(n)) }
pub fn scroll_my(n: Int) -> Style { make("scroll-my-" <> int.to_string(n)) }
pub fn scroll_mt(n: Int) -> Style { make("scroll-mt-" <> int.to_string(n)) }
pub fn scroll_mr(n: Int) -> Style { make("scroll-mr-" <> int.to_string(n)) }
pub fn scroll_mb(n: Int) -> Style { make("scroll-mb-" <> int.to_string(n)) }
pub fn scroll_ml(n: Int) -> Style { make("scroll-ml-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Scroll padding
// ---------------------------------------------------------------------------

pub fn scroll_p(n: Int) -> Style { make("scroll-p-" <> int.to_string(n)) }
pub fn scroll_px(n: Int) -> Style { make("scroll-px-" <> int.to_string(n)) }
pub fn scroll_py(n: Int) -> Style { make("scroll-py-" <> int.to_string(n)) }
pub fn scroll_pt(n: Int) -> Style { make("scroll-pt-" <> int.to_string(n)) }
pub fn scroll_pr(n: Int) -> Style { make("scroll-pr-" <> int.to_string(n)) }
pub fn scroll_pb(n: Int) -> Style { make("scroll-pb-" <> int.to_string(n)) }
pub fn scroll_pl(n: Int) -> Style { make("scroll-pl-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Scroll snap
// ---------------------------------------------------------------------------

pub fn snap_none() -> Style { make("snap-none") }
pub fn snap_x() -> Style { make("snap-x") }
pub fn snap_y() -> Style { make("snap-y") }
pub fn snap_both() -> Style { make("snap-both") }
pub fn snap_mandatory() -> Style { make("snap-mandatory") }
pub fn snap_proximity() -> Style { make("snap-proximity") }
pub fn snap_start() -> Style { make("snap-start") }
pub fn snap_end() -> Style { make("snap-end") }
pub fn snap_center() -> Style { make("snap-center") }
pub fn snap_align_none() -> Style { make("snap-align-none") }
pub fn snap_normal() -> Style { make("snap-normal") }
pub fn snap_always() -> Style { make("snap-always") }

// ---------------------------------------------------------------------------
// Touch action
// ---------------------------------------------------------------------------

pub fn touch_auto() -> Style { make("touch-auto") }
pub fn touch_none() -> Style { make("touch-none") }
pub fn touch_pan_x() -> Style { make("touch-pan-x") }
pub fn touch_pan_left() -> Style { make("touch-pan-left") }
pub fn touch_pan_right() -> Style { make("touch-pan-right") }
pub fn touch_pan_y() -> Style { make("touch-pan-y") }
pub fn touch_pan_up() -> Style { make("touch-pan-up") }
pub fn touch_pan_down() -> Style { make("touch-pan-down") }
pub fn touch_pinch_zoom() -> Style { make("touch-pinch-zoom") }
pub fn touch_manipulation() -> Style { make("touch-manipulation") }

// ---------------------------------------------------------------------------
// Caret colour — uses raw string to keep color dependency out
// ---------------------------------------------------------------------------

pub fn caret_transparent() -> Style { make("caret-transparent") }
pub fn caret_current() -> Style { make("caret-current") }

// ---------------------------------------------------------------------------
// Appearance
// ---------------------------------------------------------------------------

pub fn appearance_none() -> Style { make("appearance-none") }
pub fn appearance_auto() -> Style { make("appearance-auto") }

// ---------------------------------------------------------------------------
// Will change
// ---------------------------------------------------------------------------

pub fn will_change_auto() -> Style { make("will-change-auto") }
pub fn will_change_scroll() -> Style { make("will-change-scroll") }
pub fn will_change_contents() -> Style { make("will-change-contents") }
pub fn will_change_transform() -> Style { make("will-change-transform") }

// ---------------------------------------------------------------------------
// Accent colour
// ---------------------------------------------------------------------------

pub fn accent_auto() -> Style { make("accent-auto") }

// ---------------------------------------------------------------------------
// Color scheme
// ---------------------------------------------------------------------------

pub fn color_scheme_normal() -> Style { make("color-scheme-normal") }
pub fn color_scheme_light() -> Style { make("color-scheme-light") }
pub fn color_scheme_dark() -> Style { make("color-scheme-dark") }
pub fn color_scheme_light_dark() -> Style { make("color-scheme-light-dark") }
pub fn color_scheme_only_dark() -> Style { make("color-scheme-only-dark") }
pub fn color_scheme_only_light() -> Style { make("color-scheme-only-light") }

// ---------------------------------------------------------------------------
// Field sizing
// ---------------------------------------------------------------------------

pub fn field_sizing_fixed() -> Style { make("field-sizing-fixed") }
pub fn field_sizing_content() -> Style { make("field-sizing-content") }
