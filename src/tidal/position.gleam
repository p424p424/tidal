/// Shared `Position` type for CSS positioning.
///
/// ```gleam
/// import tidal/position
/// import tidal/style
///
/// my_component
/// |> component.style([style.position(position.Absolute)])
/// ```

pub type Position {
  Static
  Relative
  Absolute
  Fixed
  Sticky
}

pub fn to_class(p: Position) -> String {
  case p {
    Static -> "static"
    Relative -> "relative"
    Absolute -> "absolute"
    Fixed -> "fixed"
    Sticky -> "sticky"
  }
}
