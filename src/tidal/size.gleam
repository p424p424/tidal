/// Shared `Size` type used by all interactive components.
///
/// `Md` is the default size for all components and adds no extra class.
///
/// ```gleam
/// import tidal/button
/// import tidal/size
///
/// button.new("Save")
/// |> button.size(size.Lg)
/// |> button.build
/// ```

pub type Size {
  Xs
  Sm
  Md
  Lg
  Xl
}
