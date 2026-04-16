/// Alignment along the cross axis — maps to Tailwind `items-*` classes.
/// Used by flex and grid container components.
pub type Align {
  Start
  Center
  End
  Stretch
  Baseline
}

pub fn to_class(a: Align) -> String {
  case a {
    Start -> "items-start"
    Center -> "items-center"
    End -> "items-end"
    Stretch -> "items-stretch"
    Baseline -> "items-baseline"
  }
}
