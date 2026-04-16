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

@internal
pub fn to_string(c: Color) -> String {
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
