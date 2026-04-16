/// Shared `Overflow` type for CSS overflow control.
///
/// Use via `styling.overflow`, `styling.overflow_x`, `styling.overflow_y`.
///
/// ```gleam
/// import tidal/overflow
/// import tidal/style
///
/// my_component
/// |> component.style([style.overflow(overflow.Hidden)])
/// ```

pub type Overflow {
  Auto
  Hidden
  Visible
  Scroll
  Clip
}

pub fn to_class(o: Overflow) -> String {
  case o {
    Auto -> "overflow-auto"
    Hidden -> "overflow-hidden"
    Visible -> "overflow-visible"
    Scroll -> "overflow-scroll"
    Clip -> "overflow-clip"
  }
}

pub fn to_class_x(o: Overflow) -> String {
  case o {
    Auto -> "overflow-x-auto"
    Hidden -> "overflow-x-hidden"
    Visible -> "overflow-x-visible"
    Scroll -> "overflow-x-scroll"
    Clip -> "overflow-x-clip"
  }
}

pub fn to_class_y(o: Overflow) -> String {
  case o {
    Auto -> "overflow-y-auto"
    Hidden -> "overflow-y-hidden"
    Visible -> "overflow-y-visible"
    Scroll -> "overflow-y-scroll"
    Clip -> "overflow-y-clip"
  }
}
