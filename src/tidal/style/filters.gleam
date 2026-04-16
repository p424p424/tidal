/// Filter utilities — blur, brightness, contrast, drop shadow, grayscale,
/// hue-rotate, invert, saturate, sepia, and backdrop variants.
///
/// ```gleam
/// import tidal/style/filters
///
/// img.style([filters.blur_sm(), filters.brightness(75)])
/// ```

import gleam/int
import tidal/style.{type Style, make}

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
