/// CSS grid container — `<div class="grid">`.
///
/// ```gleam
/// import tidal/grid
/// import tidal/align
///
/// grid.new()
/// |> grid.cols(count: 3)
/// |> grid.gap(amount: 4)
/// |> grid.align(alignment: align.Start)
/// |> grid.children(elements: [card1, card2, card3])
/// |> grid.build
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

pub opaque type Grid(msg) {
  Grid(
    cols: Option(Int),
    rows: Option(Int),
    gap: Option(String),
    align: Option(String),
    justify: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

/// Creates a new `Grid` builder — a `<div class="grid">`.
///
/// Chain builder functions to configure the grid, then call `build`:
///
/// ```gleam
/// import tidal/grid
/// import tidal/align
///
/// grid.new()
/// |> grid.cols(count: 3)
/// |> grid.gap(amount: 4)
/// |> grid.align(alignment: align.Start)
/// |> grid.children(elements: [card1, card2, card3])
/// |> grid.build
/// ```
///
/// See also:
/// - Tailwind grid docs: https://tailwindcss.com/docs/grid-template-columns
pub fn new() -> Grid(msg) {
  Grid(
    cols: None,
    rows: None,
    gap: None,
    align: None,
    justify: None,
    styles: [],
    attrs: [],
    children: [],
  )
}

/// Number of equal columns (`grid-cols-{n}`).
pub fn cols(grid: Grid(msg), count count: Int) -> Grid(msg) {
  Grid(..grid, cols: Some(count))
}

/// Number of equal rows (`grid-rows-{n}`).
pub fn rows(grid: Grid(msg), count count: Int) -> Grid(msg) {
  Grid(..grid, rows: Some(count))
}

/// Uniform gap between cells.
pub fn gap(grid: Grid(msg), amount amount: Int) -> Grid(msg) {
  Grid(..grid, gap: Some("gap-" <> int.to_string(amount)))
}

/// Column gap only.
pub fn gap_x(grid: Grid(msg), amount amount: Int) -> Grid(msg) {
  Grid(..grid, gap: Some("gap-x-" <> int.to_string(amount)))
}

/// Row gap only.
pub fn gap_y(grid: Grid(msg), amount amount: Int) -> Grid(msg) {
  Grid(..grid, gap: Some("gap-y-" <> int.to_string(amount)))
}

/// Set `align-items` for all cells.
pub fn align(grid: Grid(msg), alignment alignment: Align) -> Grid(msg) {
  Grid(..grid, align: Some(align.to_class(alignment)))
}

/// Set `justify-content`.
pub fn justify(
  grid: Grid(msg),
  justification justification: Justify,
) -> Grid(msg) {
  Grid(..grid, justify: Some(justify.to_class(justification)))
}

/// Appends Tailwind utility styles. Use for custom grid template values.
pub fn style(grid: Grid(msg), styles styles: List(Style)) -> Grid(msg) {
  Grid(..grid, styles: list.append(grid.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  grid: Grid(msg),
  attributes attributes: List(Attribute(msg)),
) -> Grid(msg) {
  Grid(..grid, attrs: list.append(grid.attrs, attributes))
}

/// Sets child elements. May be called multiple times — children accumulate.
pub fn children(
  grid: Grid(msg),
  elements elements: List(Element(msg)),
) -> Grid(msg) {
  Grid(..grid, children: list.append(grid.children, elements))
}

pub fn build(grid: Grid(msg)) -> Element(msg) {
  let parts =
    [
      Some("grid"),
      option.map(grid.cols, fn(n) { "grid-cols-" <> int.to_string(n) }),
      option.map(grid.rows, fn(n) { "grid-rows-" <> int.to_string(n) }),
      grid.gap,
      grid.align,
      grid.justify,
      case style.to_class_string(grid.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
  let cls = string.join(parts, " ")
  html.div([attribute.class(cls), ..grid.attrs], grid.children)
}
