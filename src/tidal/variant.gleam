/// Shared `Variant` type used by all interactive components.
///
/// Not every component supports every variant — unsupported ones simply
/// produce no extra class. Check each component's docs for what it accepts.
///
/// ```gleam
/// import tidal/button
/// import tidal/variant
///
/// button.new("Save")
/// |> button.variant(variant.Primary)
/// |> button.build
/// ```
pub type Variant {
  Primary
  Secondary
  Accent
  Neutral
  Ghost
  Link
  Outline
  Info
  Success
  Warning
  Error
}
