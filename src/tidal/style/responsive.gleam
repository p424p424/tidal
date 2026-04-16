/// Responsive modifier utilities — wrap any Style value with a breakpoint prefix.
///
/// Breakpoints follow Tailwind's default scale:
/// - `sm`  — 640 px and above
/// - `md`  — 768 px and above
/// - `lg`  — 1024 px and above
/// - `xl`  — 1280 px and above
/// - `xxl` — 1536 px and above
///
/// ```gleam
/// import tidal/style/responsive
/// import tidal/style/typography
/// import tidal/style/flexbox as fx
///
/// el.style([
///   typography.text_base(),
///   responsive.md(typography.text_lg()),
///   responsive.lg(typography.text_xl()),
///   fx.flex_col(),
///   responsive.md(fx.flex_row()),
/// ])
/// ```

import tidal/style.{type Style, prefix}

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
