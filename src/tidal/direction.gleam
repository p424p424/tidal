/// Shared `Direction` type for flex layout direction.
///
/// ```gleam
/// import tidal/direction
/// import tidal/row
///
/// row.new()
/// |> row.direction(direction.ColReverse)
/// |> row.build
/// ```
pub type Direction {
  Row
  Col
  RowReverse
  ColReverse
}

pub fn to_class(d: Direction) -> String {
  case d {
    Row -> "flex-row"
    Col -> "flex-col"
    RowReverse -> "flex-row-reverse"
    ColReverse -> "flex-col-reverse"
  }
}
