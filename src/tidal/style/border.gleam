/// Border utilities — radius, width, colour, style, and outline.
///
/// ```gleam
/// import tidal/style/border
/// import tidal/style/color
///
/// button.style([border.rounded_lg(), border.border_color(color.Primary)])
/// ```

import gleam/int
import tidal/style.{type Style, make}
import tidal/style/color.{type Color}

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
  make("border-" <> color.to_string(c))
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
  make("outline-" <> color.to_string(c))
}

/// `outline-offset-{n}` — space between element edge and outline.
pub fn outline_offset(n: Int) -> Style {
  make("outline-offset-" <> int.to_string(n))
}
