/// Effects utilities — box shadow, text shadow, opacity, and blend modes.
///
/// ```gleam
/// import tidal/style/effects
///
/// card.style([effects.shadow_lg(), effects.opacity(90)])
/// ```

import gleam/int
import tidal/style.{type Style, make}
import tidal/style/color.{type Color}

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
  make("shadow-" <> color.to_string(c))
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
  make("text-shadow-" <> color.to_string(c))
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
