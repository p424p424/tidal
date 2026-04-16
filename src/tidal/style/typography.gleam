/// Typography utilities — font, text, and line styling.
///
/// ```gleam
/// import tidal/style/typography as type_
/// import tidal/style/color
///
/// text.style([
///   type_.text_2xl(),
///   type_.font_bold(),
///   type_.text_color(color.Primary),
///   type_.tracking_wide(),
///   type_.leading_relaxed(),
/// ])
/// ```

import gleam/int
import tidal/style.{type Style, make}
import tidal/style/color.{type Color}

// ---------------------------------------------------------------------------
// Font family
// ---------------------------------------------------------------------------

/// `font-sans` — sans-serif font stack.
pub fn font_sans() -> Style { make("font-sans") }

/// `font-serif` — serif font stack.
pub fn font_serif() -> Style { make("font-serif") }

/// `font-mono` — monospace font stack.
pub fn font_mono() -> Style { make("font-mono") }

// ---------------------------------------------------------------------------
// Font size
// ---------------------------------------------------------------------------

/// `text-xs` — 0.75rem / 1rem line-height.
pub fn text_xs() -> Style { make("text-xs") }

/// `text-sm` — 0.875rem / 1.25rem line-height.
pub fn text_sm() -> Style { make("text-sm") }

/// `text-base` — 1rem / 1.5rem line-height.
pub fn text_base() -> Style { make("text-base") }

/// `text-lg` — 1.125rem / 1.75rem line-height.
pub fn text_lg() -> Style { make("text-lg") }

/// `text-xl` — 1.25rem / 1.75rem line-height.
pub fn text_xl() -> Style { make("text-xl") }

/// `text-2xl` — 1.5rem / 2rem line-height.
pub fn text_2xl() -> Style { make("text-2xl") }

/// `text-3xl` — 1.875rem / 2.25rem line-height.
pub fn text_3xl() -> Style { make("text-3xl") }

/// `text-4xl` — 2.25rem / 2.5rem line-height.
pub fn text_4xl() -> Style { make("text-4xl") }

/// `text-5xl` — 3rem / 1 line-height.
pub fn text_5xl() -> Style { make("text-5xl") }

/// `text-6xl` — 3.75rem / 1 line-height.
pub fn text_6xl() -> Style { make("text-6xl") }

/// `text-7xl` — 4.5rem / 1 line-height.
pub fn text_7xl() -> Style { make("text-7xl") }

/// `text-8xl` — 6rem / 1 line-height.
pub fn text_8xl() -> Style { make("text-8xl") }

/// `text-9xl` — 8rem / 1 line-height.
pub fn text_9xl() -> Style { make("text-9xl") }

// ---------------------------------------------------------------------------
// Font weight
// ---------------------------------------------------------------------------

/// `font-thin` — font-weight: 100.
pub fn font_thin() -> Style { make("font-thin") }

/// `font-extralight` — font-weight: 200.
pub fn font_extralight() -> Style { make("font-extralight") }

/// `font-light` — font-weight: 300.
pub fn font_light() -> Style { make("font-light") }

/// `font-normal` — font-weight: 400.
pub fn font_normal() -> Style { make("font-normal") }

/// `font-medium` — font-weight: 500.
pub fn font_medium() -> Style { make("font-medium") }

/// `font-semibold` — font-weight: 600.
pub fn font_semibold() -> Style { make("font-semibold") }

/// `font-bold` — font-weight: 700.
pub fn font_bold() -> Style { make("font-bold") }

/// `font-extrabold` — font-weight: 800.
pub fn font_extrabold() -> Style { make("font-extrabold") }

/// `font-black` — font-weight: 900.
pub fn font_black() -> Style { make("font-black") }

// ---------------------------------------------------------------------------
// Font style
// ---------------------------------------------------------------------------

/// `italic` — font-style: italic.
pub fn italic() -> Style { make("italic") }

/// `not-italic` — font-style: normal.
pub fn not_italic() -> Style { make("not-italic") }

// ---------------------------------------------------------------------------
// Text colour
// ---------------------------------------------------------------------------

/// Sets text colour using a DaisyUI semantic colour token.
///
/// ```gleam
/// type_.text_color(color.Primary)   // → text-primary
/// type_.text_color(color.Error)     // → text-error
/// ```
pub fn text_color(c: Color) -> Style {
  make("text-" <> color.to_string(c))
}

// ---------------------------------------------------------------------------
// Text alignment
// ---------------------------------------------------------------------------

/// `text-left` — align text to the left.
pub fn text_left() -> Style { make("text-left") }

/// `text-center` — centre text.
pub fn text_center() -> Style { make("text-center") }

/// `text-right` — align text to the right.
pub fn text_right() -> Style { make("text-right") }

/// `text-justify` — justify text.
pub fn text_justify() -> Style { make("text-justify") }

/// `text-start` — align to the inline start (RTL-aware).
pub fn text_start() -> Style { make("text-start") }

/// `text-end` — align to the inline end (RTL-aware).
pub fn text_end() -> Style { make("text-end") }

// ---------------------------------------------------------------------------
// Line height (leading)
// ---------------------------------------------------------------------------

/// `leading-none` — line-height: 1.
pub fn leading_none() -> Style { make("leading-none") }

/// `leading-tight` — line-height: 1.25.
pub fn leading_tight() -> Style { make("leading-tight") }

/// `leading-snug` — line-height: 1.375.
pub fn leading_snug() -> Style { make("leading-snug") }

/// `leading-normal` — line-height: 1.5.
pub fn leading_normal() -> Style { make("leading-normal") }

/// `leading-relaxed` — line-height: 1.625.
pub fn leading_relaxed() -> Style { make("leading-relaxed") }

/// `leading-loose` — line-height: 2.
pub fn leading_loose() -> Style { make("leading-loose") }

/// `leading-{n}` — fixed line-height on the spacing scale.
pub fn leading(n: Int) -> Style { make("leading-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Letter spacing (tracking)
// ---------------------------------------------------------------------------

/// `tracking-tighter` — letter-spacing: -0.05em.
pub fn tracking_tighter() -> Style { make("tracking-tighter") }

/// `tracking-tight` — letter-spacing: -0.025em.
pub fn tracking_tight() -> Style { make("tracking-tight") }

/// `tracking-normal` — letter-spacing: 0.
pub fn tracking_normal() -> Style { make("tracking-normal") }

/// `tracking-wide` — letter-spacing: 0.025em.
pub fn tracking_wide() -> Style { make("tracking-wide") }

/// `tracking-wider` — letter-spacing: 0.05em.
pub fn tracking_wider() -> Style { make("tracking-wider") }

/// `tracking-widest` — letter-spacing: 0.1em.
pub fn tracking_widest() -> Style { make("tracking-widest") }

// ---------------------------------------------------------------------------
// Text decoration
// ---------------------------------------------------------------------------

/// `underline` — text-decoration-line: underline.
pub fn underline() -> Style { make("underline") }

/// `overline` — text-decoration-line: overline.
pub fn overline() -> Style { make("overline") }

/// `line-through` — text-decoration-line: line-through.
pub fn line_through() -> Style { make("line-through") }

/// `no-underline` — text-decoration-line: none.
pub fn no_underline() -> Style { make("no-underline") }

// ---------------------------------------------------------------------------
// Text transform
// ---------------------------------------------------------------------------

/// `uppercase` — text-transform: uppercase.
pub fn uppercase() -> Style { make("uppercase") }

/// `lowercase` — text-transform: lowercase.
pub fn lowercase() -> Style { make("lowercase") }

/// `capitalize` — text-transform: capitalize.
pub fn capitalize() -> Style { make("capitalize") }

/// `normal-case` — text-transform: none.
pub fn normal_case() -> Style { make("normal-case") }

// ---------------------------------------------------------------------------
// Text overflow
// ---------------------------------------------------------------------------

/// `truncate` — overflow: hidden; text-overflow: ellipsis; white-space: nowrap.
pub fn truncate() -> Style { make("truncate") }

/// `text-ellipsis` — text-overflow: ellipsis.
pub fn text_ellipsis() -> Style { make("text-ellipsis") }

/// `text-clip` — text-overflow: clip.
pub fn text_clip() -> Style { make("text-clip") }

// ---------------------------------------------------------------------------
// Text wrap
// ---------------------------------------------------------------------------

/// `text-wrap` — white-space: normal (wraps).
pub fn text_wrap() -> Style { make("text-wrap") }

/// `text-nowrap` — white-space: nowrap.
pub fn text_nowrap() -> Style { make("text-nowrap") }

/// `text-balance` — text-wrap: balance (even line lengths).
pub fn text_balance() -> Style { make("text-balance") }

/// `text-pretty` — text-wrap: pretty (avoids orphans).
pub fn text_pretty() -> Style { make("text-pretty") }

// ---------------------------------------------------------------------------
// Line clamp
// ---------------------------------------------------------------------------

/// `line-clamp-{n}` — clamp text to n lines with an ellipsis.
pub fn line_clamp(n: Int) -> Style { make("line-clamp-" <> int.to_string(n)) }

/// `line-clamp-none` — remove line clamping.
pub fn line_clamp_none() -> Style { make("line-clamp-none") }

// ---------------------------------------------------------------------------
// White space
// ---------------------------------------------------------------------------

/// `whitespace-normal` — white-space: normal.
pub fn whitespace_normal() -> Style { make("whitespace-normal") }

/// `whitespace-nowrap` — white-space: nowrap.
pub fn whitespace_nowrap() -> Style { make("whitespace-nowrap") }

/// `whitespace-pre` — white-space: pre.
pub fn whitespace_pre() -> Style { make("whitespace-pre") }

/// `whitespace-pre-line` — white-space: pre-line.
pub fn whitespace_pre_line() -> Style { make("whitespace-pre-line") }

/// `whitespace-pre-wrap` — white-space: pre-wrap.
pub fn whitespace_pre_wrap() -> Style { make("whitespace-pre-wrap") }

/// `whitespace-break-spaces` — white-space: break-spaces.
pub fn whitespace_break_spaces() -> Style { make("whitespace-break-spaces") }

// ---------------------------------------------------------------------------
// Word break / overflow wrap
// ---------------------------------------------------------------------------

/// `break-normal` — word-break: normal; overflow-wrap: normal.
pub fn break_normal() -> Style { make("break-normal") }

/// `break-words` — overflow-wrap: break-word.
pub fn break_words() -> Style { make("break-words") }

/// `break-all` — word-break: break-all.
pub fn break_all() -> Style { make("break-all") }

/// `break-keep` — word-break: keep-all.
pub fn break_keep() -> Style { make("break-keep") }

// ---------------------------------------------------------------------------
// Vertical align
// ---------------------------------------------------------------------------

/// `align-baseline` — vertical-align: baseline.
pub fn align_baseline() -> Style { make("align-baseline") }

/// `align-top` — vertical-align: top.
pub fn align_top() -> Style { make("align-top") }

/// `align-middle` — vertical-align: middle.
pub fn align_middle() -> Style { make("align-middle") }

/// `align-bottom` — vertical-align: bottom.
pub fn align_bottom() -> Style { make("align-bottom") }

/// `align-text-top` — vertical-align: text-top.
pub fn align_text_top() -> Style { make("align-text-top") }

/// `align-text-bottom` — vertical-align: text-bottom.
pub fn align_text_bottom() -> Style { make("align-text-bottom") }

// ---------------------------------------------------------------------------
// Text indent
// ---------------------------------------------------------------------------

/// `indent-{n}` — text-indent on the spacing scale.
pub fn indent(n: Int) -> Style { make("indent-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Font smoothing
// ---------------------------------------------------------------------------

/// `antialiased` — font-smoothing: antialiased (macOS subpixel off).
pub fn antialiased() -> Style { make("antialiased") }

/// `subpixel-antialiased` — font-smoothing: auto (subpixel rendering).
pub fn subpixel_antialiased() -> Style { make("subpixel-antialiased") }

// ---------------------------------------------------------------------------
// Font stretch
// ---------------------------------------------------------------------------

pub fn font_ultra_condensed() -> Style { make("font-ultra-condensed") }
pub fn font_extra_condensed() -> Style { make("font-extra-condensed") }
pub fn font_condensed() -> Style { make("font-condensed") }
pub fn font_semi_condensed() -> Style { make("font-semi-condensed") }
pub fn font_normal_stretch() -> Style { make("font-normal") }
pub fn font_semi_expanded() -> Style { make("font-semi-expanded") }
pub fn font_expanded() -> Style { make("font-expanded") }
pub fn font_extra_expanded() -> Style { make("font-extra-expanded") }
pub fn font_ultra_expanded() -> Style { make("font-ultra-expanded") }

// ---------------------------------------------------------------------------
// Font variant numeric
// ---------------------------------------------------------------------------

pub fn normal_nums() -> Style { make("normal-nums") }
pub fn ordinal() -> Style { make("ordinal") }
pub fn slashed_zero() -> Style { make("slashed-zero") }
pub fn lining_nums() -> Style { make("lining-nums") }
pub fn oldstyle_nums() -> Style { make("oldstyle-nums") }
pub fn proportional_nums() -> Style { make("proportional-nums") }
pub fn tabular_nums() -> Style { make("tabular-nums") }
pub fn diagonal_fractions() -> Style { make("diagonal-fractions") }
pub fn stacked_fractions() -> Style { make("stacked-fractions") }

// ---------------------------------------------------------------------------
// List style
// ---------------------------------------------------------------------------

pub fn list_none() -> Style { make("list-none") }
pub fn list_disc() -> Style { make("list-disc") }
pub fn list_decimal() -> Style { make("list-decimal") }
pub fn list_inside() -> Style { make("list-inside") }
pub fn list_outside() -> Style { make("list-outside") }

// ---------------------------------------------------------------------------
// Text decoration extras
// ---------------------------------------------------------------------------

/// `decoration-{color}` — text-decoration-color using a DaisyUI semantic colour.
pub fn decoration_color(c: Color) -> Style {
  make("decoration-" <> color.to_string(c))
}

pub fn decoration_solid() -> Style { make("decoration-solid") }
pub fn decoration_double() -> Style { make("decoration-double") }
pub fn decoration_dotted() -> Style { make("decoration-dotted") }
pub fn decoration_dashed() -> Style { make("decoration-dashed") }
pub fn decoration_wavy() -> Style { make("decoration-wavy") }

/// `decoration-{n}` — text-decoration-thickness. Common: 0, 1, 2, 4, 8.
pub fn decoration_thickness(n: Int) -> Style {
  make("decoration-" <> int.to_string(n))
}

pub fn decoration_auto() -> Style { make("decoration-auto") }
pub fn decoration_from_font() -> Style { make("decoration-from-font") }

/// `underline-offset-{n}` — text-underline-offset. Common: 0, 1, 2, 4, 8.
pub fn underline_offset(n: Int) -> Style {
  make("underline-offset-" <> int.to_string(n))
}

pub fn underline_offset_auto() -> Style { make("underline-offset-auto") }

// ---------------------------------------------------------------------------
// Overflow wrap
// ---------------------------------------------------------------------------

/// `wrap-break-word` — overflow-wrap: break-word.
pub fn wrap_break_word() -> Style { make("wrap-break-word") }

/// `wrap-anywhere` — overflow-wrap: anywhere.
pub fn wrap_anywhere() -> Style { make("wrap-anywhere") }

/// `wrap-normal` — overflow-wrap: normal.
pub fn wrap_normal() -> Style { make("wrap-normal") }

// ---------------------------------------------------------------------------
// Hyphens
// ---------------------------------------------------------------------------

pub fn hyphens_none() -> Style { make("hyphens-none") }
pub fn hyphens_manual() -> Style { make("hyphens-manual") }
pub fn hyphens_auto() -> Style { make("hyphens-auto") }

// ---------------------------------------------------------------------------
// Content (CSS content property)
// ---------------------------------------------------------------------------

/// `content-none` — content: none (for ::before / ::after).
pub fn content_none() -> Style { make("content-none") }
