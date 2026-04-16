/// The core `Style` type for Tidal.
///
/// A `Style` value represents a single Tailwind CSS utility class. You never
/// construct these directly — use the functions in the `tidal/style/*`
/// sub-modules instead:
///
/// ```gleam
/// import tidal/style/typography
/// import tidal/style/spacing
///
/// text.new()
/// |> text.content("Hello")
/// |> text.style([typography.text_2xl(), typography.font_bold(), spacing.mt(4)])
/// |> text.build
/// ```
///
/// The only public escape hatch is `raw/1`, for one-off classes that the
/// typed API does not yet cover.
import gleam/list
import gleam/string

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Style {
  Style(class: String)
}

// ---------------------------------------------------------------------------
// Internal constructors (available to tidal package modules only)
// ---------------------------------------------------------------------------

/// Creates a `Style` from a raw class string.
/// For use by `tidal/style/*` sub-modules only — not part of the public API.
@internal
pub fn make(class: String) -> Style {
  Style(class)
}

/// Wraps a `Style` with a responsive prefix, e.g. `sm:text-xl`.
/// For use by `tidal/style/responsive` only.
@internal
pub fn prefix(p: String, s: Style) -> Style {
  let Style(c) = s
  Style(p <> ":" <> c)
}

/// Converts a list of `Style` values into a single space-separated class string.
/// For use by component `build` functions only — not part of the public API.
@internal
pub fn to_class_string(styles: List(Style)) -> String {
  styles
  |> list.map(fn(s) {
    let Style(c) = s
    c
  })
  |> list.filter(fn(c) { !string.is_empty(c) })
  |> string.join(" ")
}

// ---------------------------------------------------------------------------
// Public escape hatch
// ---------------------------------------------------------------------------

/// Wraps a raw CSS class string as a `Style`.
///
/// Use this sparingly — prefer the typed functions in the style sub-modules.
/// This exists for one-off utility classes that the typed API does not yet cover.
///
/// ```gleam
/// text.style([typography.text_xl(), style.raw("tabular-nums")])
/// ```
pub fn raw(class: String) -> Style {
  Style(class)
}
