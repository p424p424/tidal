/// Horizontal flex container — `<div class="flex flex-row">`.
///
/// ```gleam
/// import tidal/row
/// import tidal/align
/// import tidal/justify
///
/// row.new()
/// |> row.align(alignment: align.Center)
/// |> row.justify(justification: justify.Between)
/// |> row.gap(amount: 4)
/// |> row.children(elements: [left_el, right_el])
/// |> row.build
/// ```
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/align.{type Align}
import tidal/justify.{type Justify}
import tidal/style.{type Style}
import tidal/wrap.{type Wrap}

pub opaque type Row(msg) {
  Row(
    reverse: Bool,
    grow: Bool,
    align: Option(String),
    justify: Option(String),
    wrap: Option(String),
    gap: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

/// Creates a new `Row` builder — a `<div>` with `flex flex-row`.
///
/// Chain builder functions to configure the row, then call `build`:
///
/// ```gleam
/// import tidal/row
/// import tidal/align
/// import tidal/justify
///
/// row.new()
/// |> row.align(alignment: align.Center)
/// |> row.justify(justification: justify.Between)
/// |> row.gap(amount: 4)
/// |> row.children(elements: [left_el, right_el])
/// |> row.build
/// ```
///
/// See also:
/// - Tailwind flexbox docs: https://tailwindcss.com/docs/flex-direction
pub fn new() -> Row(msg) {
  Row(
    reverse: False,
    grow: False,
    align: None,
    justify: None,
    wrap: None,
    gap: None,
    styles: [],
    attrs: [],
    children: [],
  )
}

/// Reverse the direction to `flex-row-reverse`.
pub fn reverse(row: Row(msg)) -> Row(msg) {
  Row(..row, reverse: True)
}

/// Make the row fill available space with `flex-1`.
pub fn grow(row: Row(msg)) -> Row(msg) {
  Row(..row, grow: True)
}

/// Set `align-items` — how children align on the cross axis.
pub fn align(row: Row(msg), alignment alignment: Align) -> Row(msg) {
  Row(..row, align: Some(align.to_class(alignment)))
}

/// Set `justify-content` — how children are distributed along the main axis.
pub fn justify(row: Row(msg), justification justification: Justify) -> Row(msg) {
  Row(..row, justify: Some(justify.to_class(justification)))
}

/// Set flex wrapping behaviour.
pub fn wrap(row: Row(msg), wrapping wrapping: Wrap) -> Row(msg) {
  Row(..row, wrap: Some(wrap.to_class(wrapping)))
}

/// Uniform gap between children.
pub fn gap(row: Row(msg), amount amount: Int) -> Row(msg) {
  Row(..row, gap: Some("gap-" <> int.to_string(amount)))
}

/// Horizontal gap only.
pub fn gap_x(row: Row(msg), amount amount: Int) -> Row(msg) {
  Row(..row, gap: Some("gap-x-" <> int.to_string(amount)))
}

/// Vertical gap only.
pub fn gap_y(row: Row(msg), amount amount: Int) -> Row(msg) {
  Row(..row, gap: Some("gap-y-" <> int.to_string(amount)))
}

/// Appends Tailwind utility styles. May be called multiple times.
pub fn style(row: Row(msg), styles styles: List(Style)) -> Row(msg) {
  Row(..row, styles: list.append(row.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  row: Row(msg),
  attributes attributes: List(Attribute(msg)),
) -> Row(msg) {
  Row(..row, attrs: list.append(row.attrs, attributes))
}

/// Appends child elements. May be called multiple times.
pub fn children(
  row: Row(msg),
  elements elements: List(Element(msg)),
) -> Row(msg) {
  Row(..row, children: list.append(row.children, elements))
}

pub fn build(row: Row(msg)) -> Element(msg) {
  let direction = case row.reverse {
    True -> "flex-row-reverse"
    False -> "flex-row"
  }
  let parts =
    [
      Some("flex"),
      Some(direction),
      case row.grow {
        True -> Some("flex-1")
        False -> None
      },
      row.align,
      row.justify,
      row.wrap,
      row.gap,
      case style.to_class_string(row.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
  let cls = string.join(parts, " ")
  html.div([attribute.class(cls), ..row.attrs], row.children)
}
