/// Justification along the main axis — maps to Tailwind `justify-*` classes.
/// Used by flex and grid container components.
pub type Justify {
  Start
  Center
  End
  Between
  Around
  Evenly
  Stretch
}

pub fn to_class(j: Justify) -> String {
  case j {
    Start -> "justify-start"
    Center -> "justify-center"
    End -> "justify-end"
    Between -> "justify-between"
    Around -> "justify-around"
    Evenly -> "justify-evenly"
    Stretch -> "justify-stretch"
  }
}
