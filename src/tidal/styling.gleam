/// Style utilities — the complete Tailwind CSS utility surface for Tidal.
///
/// Import once and access all utilities:
///
/// ```gleam
/// import tidal/styling
///
/// text.new("Hello")
/// |> text.style([
///   styling.text_2xl(),
///   styling.font_bold(),
///   styling.sm(styling.text_4xl()),
/// ])
/// |> text.build
/// ```

import gleam/int
import tidal/style.{type Style, make, prefix}

// ---------------------------------------------------------------------------
// Color
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

/// DaisyUI semantic colour tokens.
///
/// These tokens are used as parameters by other style modules rather than
/// producing `Style` values directly. They map to DaisyUI's CSS custom
/// properties and update automatically when the active theme changes.
///
/// ```gleam
/// import tidal/style/color
/// import tidal/style/typography
/// import tidal/style/background as bg
///
/// text.style([
///   typography.text_color(color.Primary),
///   bg.bg(color.Base200),
/// ])
/// ```
pub type Color {
  // Brand
  Primary
  Secondary
  Accent
  Neutral
  // Base surfaces
  Base100
  Base200
  Base300
  BaseContent
  // Semantic state
  Info
  Success
  Warning
  Error
  // State content (text on top of state backgrounds)
  InfoContent
  SuccessContent
  WarningContent
  ErrorContent
  // Absolute
  White
  Black
  Transparent
  Current
}

// ---------------------------------------------------------------------------
// Internal helper (used by typography, background, border modules)
// ---------------------------------------------------------------------------

fn color_to_string(c: Color) -> String {
  case c {
    Primary -> "primary"
    Secondary -> "secondary"
    Accent -> "accent"
    Neutral -> "neutral"
    Base100 -> "base-100"
    Base200 -> "base-200"
    Base300 -> "base-300"
    BaseContent -> "base-content"
    Info -> "info"
    Success -> "success"
    Warning -> "warning"
    Error -> "error"
    InfoContent -> "info-content"
    SuccessContent -> "success-content"
    WarningContent -> "warning-content"
    ErrorContent -> "error-content"
    White -> "white"
    Black -> "black"
    Transparent -> "transparent"
    Current -> "current"
  }
}

// ---------------------------------------------------------------------------
// Spacing
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Sizing
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Typography
// ---------------------------------------------------------------------------

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
  make("text-" <> color_to_string(c))
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
  make("decoration-" <> color_to_string(c))
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

// ---------------------------------------------------------------------------
// Background
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Background colour
// ---------------------------------------------------------------------------

/// Sets the background colour using a DaisyUI semantic colour token.
///
/// ```gleam
/// bg.bg(color.Primary)    // → bg-primary
/// bg.bg(color.Base200)    // → bg-base-200
/// ```
pub fn bg(c: Color) -> Style {
  make("bg-" <> color_to_string(c))
}

// ---------------------------------------------------------------------------
// Background attachment
// ---------------------------------------------------------------------------

pub fn bg_fixed() -> Style { make("bg-fixed") }
pub fn bg_local() -> Style { make("bg-local") }
pub fn bg_scroll() -> Style { make("bg-scroll") }

// ---------------------------------------------------------------------------
// Background clip
// ---------------------------------------------------------------------------

pub fn bg_clip_border() -> Style { make("bg-clip-border") }
pub fn bg_clip_padding() -> Style { make("bg-clip-padding") }
pub fn bg_clip_content() -> Style { make("bg-clip-content") }
pub fn bg_clip_text() -> Style { make("bg-clip-text") }

// ---------------------------------------------------------------------------
// Background origin
// ---------------------------------------------------------------------------

pub fn bg_origin_border() -> Style { make("bg-origin-border") }
pub fn bg_origin_padding() -> Style { make("bg-origin-padding") }
pub fn bg_origin_content() -> Style { make("bg-origin-content") }

// ---------------------------------------------------------------------------
// Background position
// ---------------------------------------------------------------------------

pub fn bg_bottom() -> Style { make("bg-bottom") }
pub fn bg_center() -> Style { make("bg-center") }
pub fn bg_left() -> Style { make("bg-left") }
pub fn bg_left_bottom() -> Style { make("bg-left-bottom") }
pub fn bg_left_top() -> Style { make("bg-left-top") }
pub fn bg_right() -> Style { make("bg-right") }
pub fn bg_right_bottom() -> Style { make("bg-right-bottom") }
pub fn bg_right_top() -> Style { make("bg-right-top") }
pub fn bg_top() -> Style { make("bg-top") }

// ---------------------------------------------------------------------------
// Background repeat
// ---------------------------------------------------------------------------

pub fn bg_repeat() -> Style { make("bg-repeat") }
pub fn bg_no_repeat() -> Style { make("bg-no-repeat") }
pub fn bg_repeat_x() -> Style { make("bg-repeat-x") }
pub fn bg_repeat_y() -> Style { make("bg-repeat-y") }
pub fn bg_repeat_round() -> Style { make("bg-repeat-round") }
pub fn bg_repeat_space() -> Style { make("bg-repeat-space") }

// ---------------------------------------------------------------------------
// Background size
// ---------------------------------------------------------------------------

pub fn bg_auto() -> Style { make("bg-auto") }
pub fn bg_cover() -> Style { make("bg-cover") }
pub fn bg_contain() -> Style { make("bg-contain") }

// ---------------------------------------------------------------------------
// Border
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Border radius
// ---------------------------------------------------------------------------

pub fn rounded_none() -> Style { make("rounded-none") }
pub fn rounded_sm() -> Style { make("rounded-sm") }
pub fn rounded() -> Style { make("rounded") }
pub fn rounded_md() -> Style { make("rounded-md") }
pub fn rounded_lg() -> Style { make("rounded-lg") }
pub fn rounded_xl() -> Style { make("rounded-xl") }
pub fn rounded_2xl() -> Style { make("rounded-2xl") }
pub fn rounded_3xl() -> Style { make("rounded-3xl") }
pub fn rounded_full() -> Style { make("rounded-full") }

// Per-corner radius
pub fn rounded_t_none() -> Style { make("rounded-t-none") }
pub fn rounded_t_sm() -> Style { make("rounded-t-sm") }
pub fn rounded_t() -> Style { make("rounded-t") }
pub fn rounded_t_md() -> Style { make("rounded-t-md") }
pub fn rounded_t_lg() -> Style { make("rounded-t-lg") }
pub fn rounded_t_xl() -> Style { make("rounded-t-xl") }
pub fn rounded_t_full() -> Style { make("rounded-t-full") }

pub fn rounded_b_none() -> Style { make("rounded-b-none") }
pub fn rounded_b_sm() -> Style { make("rounded-b-sm") }
pub fn rounded_b() -> Style { make("rounded-b") }
pub fn rounded_b_md() -> Style { make("rounded-b-md") }
pub fn rounded_b_lg() -> Style { make("rounded-b-lg") }
pub fn rounded_b_xl() -> Style { make("rounded-b-xl") }
pub fn rounded_b_full() -> Style { make("rounded-b-full") }

pub fn rounded_l_none() -> Style { make("rounded-l-none") }
pub fn rounded_l_sm() -> Style { make("rounded-l-sm") }
pub fn rounded_l() -> Style { make("rounded-l") }
pub fn rounded_l_md() -> Style { make("rounded-l-md") }
pub fn rounded_l_lg() -> Style { make("rounded-l-lg") }
pub fn rounded_l_full() -> Style { make("rounded-l-full") }

pub fn rounded_r_none() -> Style { make("rounded-r-none") }
pub fn rounded_r_sm() -> Style { make("rounded-r-sm") }
pub fn rounded_r() -> Style { make("rounded-r") }
pub fn rounded_r_md() -> Style { make("rounded-r-md") }
pub fn rounded_r_lg() -> Style { make("rounded-r-lg") }
pub fn rounded_r_full() -> Style { make("rounded-r-full") }

pub fn rounded_tl_none() -> Style { make("rounded-tl-none") }
pub fn rounded_tl() -> Style { make("rounded-tl") }
pub fn rounded_tl_lg() -> Style { make("rounded-tl-lg") }
pub fn rounded_tl_full() -> Style { make("rounded-tl-full") }

pub fn rounded_tr_none() -> Style { make("rounded-tr-none") }
pub fn rounded_tr() -> Style { make("rounded-tr") }
pub fn rounded_tr_lg() -> Style { make("rounded-tr-lg") }
pub fn rounded_tr_full() -> Style { make("rounded-tr-full") }

pub fn rounded_bl_none() -> Style { make("rounded-bl-none") }
pub fn rounded_bl() -> Style { make("rounded-bl") }
pub fn rounded_bl_lg() -> Style { make("rounded-bl-lg") }
pub fn rounded_bl_full() -> Style { make("rounded-bl-full") }

pub fn rounded_br_none() -> Style { make("rounded-br-none") }
pub fn rounded_br() -> Style { make("rounded-br") }
pub fn rounded_br_lg() -> Style { make("rounded-br-lg") }
pub fn rounded_br_full() -> Style { make("rounded-br-full") }

// ---------------------------------------------------------------------------
// Border width
// ---------------------------------------------------------------------------

/// `border` — 1px border (default).
pub fn border() -> Style { make("border") }

/// `border-{n}` — border width in px.
pub fn border_w(n: Int) -> Style { make("border-" <> int.to_string(n)) }

pub fn border_x(n: Int) -> Style { make("border-x-" <> int.to_string(n)) }
pub fn border_y(n: Int) -> Style { make("border-y-" <> int.to_string(n)) }
pub fn border_t(n: Int) -> Style { make("border-t-" <> int.to_string(n)) }
pub fn border_r(n: Int) -> Style { make("border-r-" <> int.to_string(n)) }
pub fn border_b(n: Int) -> Style { make("border-b-" <> int.to_string(n)) }
pub fn border_l(n: Int) -> Style { make("border-l-" <> int.to_string(n)) }

pub fn border_0() -> Style { make("border-0") }
pub fn border_x_0() -> Style { make("border-x-0") }
pub fn border_y_0() -> Style { make("border-y-0") }

// ---------------------------------------------------------------------------
// Border colour
// ---------------------------------------------------------------------------

/// Sets border colour using a DaisyUI semantic colour token.
pub fn border_color(c: Color) -> Style {
  make("border-" <> color_to_string(c))
}

// ---------------------------------------------------------------------------
// Border style
// ---------------------------------------------------------------------------

pub fn border_solid() -> Style { make("border-solid") }
pub fn border_dashed() -> Style { make("border-dashed") }
pub fn border_dotted() -> Style { make("border-dotted") }
pub fn border_double() -> Style { make("border-double") }
pub fn border_hidden() -> Style { make("border-hidden") }
pub fn border_none() -> Style { make("border-none") }

// ---------------------------------------------------------------------------
// Outline
// ---------------------------------------------------------------------------

pub fn outline_none() -> Style { make("outline-none") }
pub fn outline() -> Style { make("outline") }
pub fn outline_w(n: Int) -> Style { make("outline-" <> int.to_string(n)) }
pub fn outline_dashed() -> Style { make("outline-dashed") }
pub fn outline_dotted() -> Style { make("outline-dotted") }
pub fn outline_double() -> Style { make("outline-double") }

/// Sets outline colour using a DaisyUI semantic colour token.
pub fn outline_color(c: Color) -> Style {
  make("outline-" <> color_to_string(c))
}

/// `outline-offset-{n}` — space between element edge and outline.
pub fn outline_offset(n: Int) -> Style {
  make("outline-offset-" <> int.to_string(n))
}

// ---------------------------------------------------------------------------
// Effects
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Box shadow
// ---------------------------------------------------------------------------

pub fn shadow_none() -> Style { make("shadow-none") }
pub fn shadow_xs() -> Style { make("shadow-xs") }
pub fn shadow_sm() -> Style { make("shadow-sm") }
pub fn shadow() -> Style { make("shadow") }
pub fn shadow_md() -> Style { make("shadow-md") }
pub fn shadow_lg() -> Style { make("shadow-lg") }
pub fn shadow_xl() -> Style { make("shadow-xl") }
pub fn shadow_2xl() -> Style { make("shadow-2xl") }
pub fn shadow_inner() -> Style { make("shadow-inner") }

/// Sets the box shadow colour using a DaisyUI semantic colour token.
pub fn shadow_color(c: Color) -> Style {
  make("shadow-" <> color_to_string(c))
}

// ---------------------------------------------------------------------------
// Text shadow
// ---------------------------------------------------------------------------

pub fn text_shadow_none() -> Style { make("text-shadow-none") }
pub fn text_shadow_xs() -> Style { make("text-shadow-xs") }
pub fn text_shadow_sm() -> Style { make("text-shadow-sm") }
pub fn text_shadow() -> Style { make("text-shadow") }
pub fn text_shadow_md() -> Style { make("text-shadow-md") }
pub fn text_shadow_lg() -> Style { make("text-shadow-lg") }

/// Sets the text shadow colour using a DaisyUI semantic colour token.
pub fn text_shadow_color(c: Color) -> Style {
  make("text-shadow-" <> color_to_string(c))
}

// ---------------------------------------------------------------------------
// Opacity
// ---------------------------------------------------------------------------

/// `opacity-{n}` — opacity from 0 to 100 (maps to 0–1 in CSS).
/// Common values: 0, 5, 10, 20, 25, 30, 40, 50, 60, 70, 75, 80, 90, 95, 100.
pub fn opacity(n: Int) -> Style { make("opacity-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Mix blend mode
// ---------------------------------------------------------------------------

pub fn mix_blend_normal() -> Style { make("mix-blend-normal") }
pub fn mix_blend_multiply() -> Style { make("mix-blend-multiply") }
pub fn mix_blend_screen() -> Style { make("mix-blend-screen") }
pub fn mix_blend_overlay() -> Style { make("mix-blend-overlay") }
pub fn mix_blend_darken() -> Style { make("mix-blend-darken") }
pub fn mix_blend_lighten() -> Style { make("mix-blend-lighten") }
pub fn mix_blend_color_dodge() -> Style { make("mix-blend-color-dodge") }
pub fn mix_blend_color_burn() -> Style { make("mix-blend-color-burn") }
pub fn mix_blend_hard_light() -> Style { make("mix-blend-hard-light") }
pub fn mix_blend_soft_light() -> Style { make("mix-blend-soft-light") }
pub fn mix_blend_difference() -> Style { make("mix-blend-difference") }
pub fn mix_blend_exclusion() -> Style { make("mix-blend-exclusion") }
pub fn mix_blend_hue() -> Style { make("mix-blend-hue") }
pub fn mix_blend_saturation() -> Style { make("mix-blend-saturation") }
pub fn mix_blend_color() -> Style { make("mix-blend-color") }
pub fn mix_blend_luminosity() -> Style { make("mix-blend-luminosity") }

// ---------------------------------------------------------------------------
// Background blend mode
// ---------------------------------------------------------------------------

pub fn bg_blend_normal() -> Style { make("bg-blend-normal") }
pub fn bg_blend_multiply() -> Style { make("bg-blend-multiply") }
pub fn bg_blend_screen() -> Style { make("bg-blend-screen") }
pub fn bg_blend_overlay() -> Style { make("bg-blend-overlay") }
pub fn bg_blend_darken() -> Style { make("bg-blend-darken") }
pub fn bg_blend_lighten() -> Style { make("bg-blend-lighten") }
pub fn bg_blend_color_dodge() -> Style { make("bg-blend-color-dodge") }
pub fn bg_blend_color_burn() -> Style { make("bg-blend-color-burn") }
pub fn bg_blend_hard_light() -> Style { make("bg-blend-hard-light") }
pub fn bg_blend_soft_light() -> Style { make("bg-blend-soft-light") }
pub fn bg_blend_difference() -> Style { make("bg-blend-difference") }
pub fn bg_blend_exclusion() -> Style { make("bg-blend-exclusion") }
pub fn bg_blend_hue() -> Style { make("bg-blend-hue") }
pub fn bg_blend_saturation() -> Style { make("bg-blend-saturation") }
pub fn bg_blend_color() -> Style { make("bg-blend-color") }
pub fn bg_blend_luminosity() -> Style { make("bg-blend-luminosity") }

// ---------------------------------------------------------------------------
// Mask
// ---------------------------------------------------------------------------

pub fn mask_clip_border() -> Style { make("mask-clip-border") }
pub fn mask_clip_padding() -> Style { make("mask-clip-padding") }
pub fn mask_clip_content() -> Style { make("mask-clip-content") }
pub fn mask_clip_fill() -> Style { make("mask-clip-fill") }
pub fn mask_clip_stroke() -> Style { make("mask-clip-stroke") }
pub fn mask_clip_view() -> Style { make("mask-clip-view") }
pub fn mask_clip_no_clip() -> Style { make("mask-clip-no-clip") }

pub fn mask_composite_add() -> Style { make("mask-composite-add") }
pub fn mask_composite_subtract() -> Style { make("mask-composite-subtract") }
pub fn mask_composite_intersect() -> Style { make("mask-composite-intersect") }
pub fn mask_composite_exclude() -> Style { make("mask-composite-exclude") }

pub fn mask_none() -> Style { make("mask-none") }

pub fn mask_alpha() -> Style { make("mask-alpha") }
pub fn mask_luminance() -> Style { make("mask-luminance") }

pub fn mask_origin_border() -> Style { make("mask-origin-border") }
pub fn mask_origin_padding() -> Style { make("mask-origin-padding") }
pub fn mask_origin_content() -> Style { make("mask-origin-content") }
pub fn mask_origin_fill() -> Style { make("mask-origin-fill") }
pub fn mask_origin_stroke() -> Style { make("mask-origin-stroke") }
pub fn mask_origin_view() -> Style { make("mask-origin-view") }

pub fn mask_position_center() -> Style { make("mask-center") }
pub fn mask_position_top() -> Style { make("mask-top") }
pub fn mask_position_right() -> Style { make("mask-right") }
pub fn mask_position_bottom() -> Style { make("mask-bottom") }
pub fn mask_position_left() -> Style { make("mask-left") }

pub fn mask_no_repeat() -> Style { make("mask-no-repeat") }
pub fn mask_repeat() -> Style { make("mask-repeat") }
pub fn mask_repeat_x() -> Style { make("mask-repeat-x") }
pub fn mask_repeat_y() -> Style { make("mask-repeat-y") }
pub fn mask_repeat_space() -> Style { make("mask-repeat-space") }
pub fn mask_repeat_round() -> Style { make("mask-repeat-round") }

pub fn mask_size_auto() -> Style { make("mask-auto") }
pub fn mask_size_cover() -> Style { make("mask-cover") }
pub fn mask_size_contain() -> Style { make("mask-contain") }

pub fn mask_type_alpha() -> Style { make("mask-type-alpha") }
pub fn mask_type_luminance() -> Style { make("mask-type-luminance") }

// ---------------------------------------------------------------------------
// Filters
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Filter: blur
// ---------------------------------------------------------------------------

pub fn blur_none() -> Style { make("blur-none") }
pub fn blur_xs() -> Style { make("blur-xs") }
pub fn blur_sm() -> Style { make("blur-sm") }
pub fn blur() -> Style { make("blur") }
pub fn blur_md() -> Style { make("blur-md") }
pub fn blur_lg() -> Style { make("blur-lg") }
pub fn blur_xl() -> Style { make("blur-xl") }
pub fn blur_2xl() -> Style { make("blur-2xl") }
pub fn blur_3xl() -> Style { make("blur-3xl") }

// ---------------------------------------------------------------------------
// Filter: brightness
// ---------------------------------------------------------------------------

/// `brightness-{n}` — e.g. brightness(75) → brightness-75.
/// Common values: 0, 50, 75, 90, 95, 100, 105, 110, 125, 150, 200.
pub fn brightness(n: Int) -> Style { make("brightness-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Filter: contrast
// ---------------------------------------------------------------------------

/// `contrast-{n}` — e.g. contrast(125) → contrast-125.
/// Common values: 0, 50, 75, 100, 125, 150, 200.
pub fn contrast(n: Int) -> Style { make("contrast-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Filter: drop-shadow
// ---------------------------------------------------------------------------

pub fn drop_shadow_none() -> Style { make("drop-shadow-none") }
pub fn drop_shadow_xs() -> Style { make("drop-shadow-xs") }
pub fn drop_shadow_sm() -> Style { make("drop-shadow-sm") }
pub fn drop_shadow() -> Style { make("drop-shadow") }
pub fn drop_shadow_md() -> Style { make("drop-shadow-md") }
pub fn drop_shadow_lg() -> Style { make("drop-shadow-lg") }
pub fn drop_shadow_xl() -> Style { make("drop-shadow-xl") }
pub fn drop_shadow_2xl() -> Style { make("drop-shadow-2xl") }

// ---------------------------------------------------------------------------
// Filter: grayscale
// ---------------------------------------------------------------------------

pub fn grayscale() -> Style { make("grayscale") }
pub fn grayscale_0() -> Style { make("grayscale-0") }

// ---------------------------------------------------------------------------
// Filter: hue-rotate
// ---------------------------------------------------------------------------

/// `hue-rotate-{n}` — degrees. Common: 0, 15, 30, 60, 90, 180.
pub fn hue_rotate(n: Int) -> Style { make("hue-rotate-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Filter: invert
// ---------------------------------------------------------------------------

pub fn invert() -> Style { make("invert") }
pub fn invert_0() -> Style { make("invert-0") }

// ---------------------------------------------------------------------------
// Filter: saturate
// ---------------------------------------------------------------------------

/// `saturate-{n}` — e.g. saturate(150) → saturate-150.
/// Common values: 0, 50, 100, 150, 200.
pub fn saturate(n: Int) -> Style { make("saturate-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Filter: sepia
// ---------------------------------------------------------------------------

pub fn sepia() -> Style { make("sepia") }
pub fn sepia_0() -> Style { make("sepia-0") }

// ---------------------------------------------------------------------------
// Backdrop filter: blur
// ---------------------------------------------------------------------------

pub fn backdrop_blur_none() -> Style { make("backdrop-blur-none") }
pub fn backdrop_blur_xs() -> Style { make("backdrop-blur-xs") }
pub fn backdrop_blur_sm() -> Style { make("backdrop-blur-sm") }
pub fn backdrop_blur() -> Style { make("backdrop-blur") }
pub fn backdrop_blur_md() -> Style { make("backdrop-blur-md") }
pub fn backdrop_blur_lg() -> Style { make("backdrop-blur-lg") }
pub fn backdrop_blur_xl() -> Style { make("backdrop-blur-xl") }
pub fn backdrop_blur_2xl() -> Style { make("backdrop-blur-2xl") }
pub fn backdrop_blur_3xl() -> Style { make("backdrop-blur-3xl") }

// ---------------------------------------------------------------------------
// Backdrop filter: brightness / contrast / grayscale / hue-rotate / invert
//                  opacity / saturate / sepia
// ---------------------------------------------------------------------------

pub fn backdrop_brightness(n: Int) -> Style {
  make("backdrop-brightness-" <> int.to_string(n))
}

pub fn backdrop_contrast(n: Int) -> Style {
  make("backdrop-contrast-" <> int.to_string(n))
}

pub fn backdrop_grayscale() -> Style { make("backdrop-grayscale") }
pub fn backdrop_grayscale_0() -> Style { make("backdrop-grayscale-0") }

pub fn backdrop_hue_rotate(n: Int) -> Style {
  make("backdrop-hue-rotate-" <> int.to_string(n))
}

pub fn backdrop_invert() -> Style { make("backdrop-invert") }
pub fn backdrop_invert_0() -> Style { make("backdrop-invert-0") }

pub fn backdrop_opacity(n: Int) -> Style {
  make("backdrop-opacity-" <> int.to_string(n))
}

pub fn backdrop_saturate(n: Int) -> Style {
  make("backdrop-saturate-" <> int.to_string(n))
}

pub fn backdrop_sepia() -> Style { make("backdrop-sepia") }
pub fn backdrop_sepia_0() -> Style { make("backdrop-sepia-0") }

// ---------------------------------------------------------------------------
// Transition
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Transform
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Scale
// ---------------------------------------------------------------------------

/// `scale-{n}` — uniform scale. Common: 0, 50, 75, 90, 95, 100, 105, 110, 125, 150.
pub fn scale(n: Int) -> Style { make("scale-" <> int.to_string(n)) }
pub fn scale_x(n: Int) -> Style { make("scale-x-" <> int.to_string(n)) }
pub fn scale_y(n: Int) -> Style { make("scale-y-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Rotate
// ---------------------------------------------------------------------------

/// `rotate-{n}` — degrees. Common: 0, 1, 2, 3, 6, 12, 45, 90, 180.
pub fn rotate(n: Int) -> Style { make("rotate-" <> int.to_string(n)) }
pub fn rotate_x(n: Int) -> Style { make("rotate-x-" <> int.to_string(n)) }
pub fn rotate_y(n: Int) -> Style { make("rotate-y-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Translate
// ---------------------------------------------------------------------------

/// `translate-x-{n}` — spacing scale value.
pub fn translate_x(n: Int) -> Style { make("translate-x-" <> int.to_string(n)) }
pub fn translate_y(n: Int) -> Style { make("translate-y-" <> int.to_string(n)) }
pub fn translate_x_half() -> Style { make("translate-x-1/2") }
pub fn translate_y_half() -> Style { make("translate-y-1/2") }
pub fn translate_x_full() -> Style { make("translate-x-full") }
pub fn translate_y_full() -> Style { make("translate-y-full") }

// ---------------------------------------------------------------------------
// Skew
// ---------------------------------------------------------------------------

/// `skew-x-{n}` — degrees. Common: 0, 1, 2, 3, 6, 12.
pub fn skew_x(n: Int) -> Style { make("skew-x-" <> int.to_string(n)) }
pub fn skew_y(n: Int) -> Style { make("skew-y-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Transform origin
// ---------------------------------------------------------------------------

pub fn origin_center() -> Style { make("origin-center") }
pub fn origin_top() -> Style { make("origin-top") }
pub fn origin_top_right() -> Style { make("origin-top-right") }
pub fn origin_right() -> Style { make("origin-right") }
pub fn origin_bottom_right() -> Style { make("origin-bottom-right") }
pub fn origin_bottom() -> Style { make("origin-bottom") }
pub fn origin_bottom_left() -> Style { make("origin-bottom-left") }
pub fn origin_left() -> Style { make("origin-left") }
pub fn origin_top_left() -> Style { make("origin-top-left") }

// ---------------------------------------------------------------------------
// Transform box
// ---------------------------------------------------------------------------

pub fn transform_box_content() -> Style { make("transform-box-content") }
pub fn transform_box_border() -> Style { make("transform-box-border") }
pub fn transform_box_fill() -> Style { make("transform-box-fill") }
pub fn transform_box_stroke() -> Style { make("transform-box-stroke") }
pub fn transform_box_view() -> Style { make("transform-box-view") }

// ---------------------------------------------------------------------------
// Perspective
// ---------------------------------------------------------------------------

pub fn perspective_none() -> Style { make("perspective-none") }
pub fn perspective_dramatic() -> Style { make("perspective-dramatic") }
pub fn perspective_near() -> Style { make("perspective-near") }
pub fn perspective_normal() -> Style { make("perspective-normal") }
pub fn perspective_midrange() -> Style { make("perspective-midrange") }
pub fn perspective_distant() -> Style { make("perspective-distant") }

// ---------------------------------------------------------------------------
// Perspective origin
// ---------------------------------------------------------------------------

pub fn perspective_origin_center() -> Style { make("perspective-origin-center") }
pub fn perspective_origin_top() -> Style { make("perspective-origin-top") }
pub fn perspective_origin_top_right() -> Style { make("perspective-origin-top-right") }
pub fn perspective_origin_right() -> Style { make("perspective-origin-right") }
pub fn perspective_origin_bottom_right() -> Style { make("perspective-origin-bottom-right") }
pub fn perspective_origin_bottom() -> Style { make("perspective-origin-bottom") }
pub fn perspective_origin_bottom_left() -> Style { make("perspective-origin-bottom-left") }
pub fn perspective_origin_left() -> Style { make("perspective-origin-left") }
pub fn perspective_origin_top_left() -> Style { make("perspective-origin-top-left") }

// ---------------------------------------------------------------------------
// Backface visibility
// ---------------------------------------------------------------------------

pub fn backface_visible() -> Style { make("backface-visible") }
pub fn backface_hidden() -> Style { make("backface-hidden") }

// ---------------------------------------------------------------------------
// Transform style
// ---------------------------------------------------------------------------

pub fn transform_flat() -> Style { make("transform-flat") }
pub fn transform_3d() -> Style { make("transform-3d") }

// ---------------------------------------------------------------------------
// Interactivity
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Layout
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Flexbox
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Grid
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Tables
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Svg
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Fill
// ---------------------------------------------------------------------------

/// `fill-{color}` — SVG fill colour using a DaisyUI semantic colour token.
pub fn fill(c: Color) -> Style { make("fill-" <> color_to_string(c)) }

/// `fill-none` — SVG fill: none.
pub fn fill_none() -> Style { make("fill-none") }

/// `fill-current` — SVG fill: currentColor.
pub fn fill_current() -> Style { make("fill-current") }

// ---------------------------------------------------------------------------
// Stroke
// ---------------------------------------------------------------------------

/// `stroke-{color}` — SVG stroke colour using a DaisyUI semantic colour token.
pub fn stroke(c: Color) -> Style { make("stroke-" <> color_to_string(c)) }

/// `stroke-none` — SVG stroke: none.
pub fn stroke_none() -> Style { make("stroke-none") }

/// `stroke-current` — SVG stroke: currentColor.
pub fn stroke_current() -> Style { make("stroke-current") }

// ---------------------------------------------------------------------------
// Stroke width
// ---------------------------------------------------------------------------

/// `stroke-{n}` — SVG stroke-width. Common values: 0, 1, 2.
pub fn stroke_width(n: Int) -> Style { make("stroke-" <> int.to_string(n)) }

// ---------------------------------------------------------------------------
// Accessibility
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Forced color adjust
// ---------------------------------------------------------------------------

/// `forced-color-adjust-auto` — let the browser adjust colours in forced-colours mode.
pub fn forced_color_adjust_auto() -> Style { make("forced-color-adjust-auto") }

/// `forced-color-adjust-none` — opt out of forced-colours adjustments.
pub fn forced_color_adjust_none() -> Style { make("forced-color-adjust-none") }

// ---------------------------------------------------------------------------
// Responsive
// ---------------------------------------------------------------------------

/// Apply style only at the `sm` breakpoint (≥ 640px).
pub fn sm(s: Style) -> Style { prefix("sm", s) }

/// Apply style only at the `md` breakpoint (≥ 768px).
pub fn md(s: Style) -> Style { prefix("md", s) }

/// Apply style only at the `lg` breakpoint (≥ 1024px).
pub fn lg(s: Style) -> Style { prefix("lg", s) }

/// Apply style only at the `xl` breakpoint (≥ 1280px).
pub fn xl(s: Style) -> Style { prefix("xl", s) }

/// Apply style only at the `2xl` breakpoint (≥ 1536px).
pub fn xxl(s: Style) -> Style { prefix("2xl", s) }


// ---------------------------------------------------------------------------
// Escape hatch
// ---------------------------------------------------------------------------

/// Pass an arbitrary Tailwind class string when no typed function exists.
/// Classes passed via `raw` are not included in Tidal's safelist — ensure
/// Tailwind can see them another way (e.g. `@source inline("my-class")`).
pub fn raw(class: String) -> Style {
  style.raw(class)
}
