/// CSS grid container — `<div class="grid">`.
///
/// ```gleam
/// import tidal/grid
/// import tidal/align
///
/// grid.new()
/// |> grid.cols(3)
/// |> grid.gap(4)
/// |> grid.align(align.Start)
/// |> grid.children([card1, card2, card3])
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
pub fn cols(g: Grid(msg), n: Int) -> Grid(msg) { Grid(..g, cols: Some(n)) }

/// Number of equal rows (`grid-rows-{n}`).
pub fn rows(g: Grid(msg), n: Int) -> Grid(msg) { Grid(..g, rows: Some(n)) }

/// Uniform gap between cells.
pub fn gap(g: Grid(msg), n: Int) -> Grid(msg) {
  Grid(..g, gap: Some("gap-" <> int.to_string(n)))
}

/// Column gap only.
pub fn gap_x(g: Grid(msg), n: Int) -> Grid(msg) {
  Grid(..g, gap: Some("gap-x-" <> int.to_string(n)))
}

/// Row gap only.
pub fn gap_y(g: Grid(msg), n: Int) -> Grid(msg) {
  Grid(..g, gap: Some("gap-y-" <> int.to_string(n)))
}

/// Set `align-items` for all cells.
pub fn align(g: Grid(msg), a: Align) -> Grid(msg) {
  Grid(..g, align: Some(align.to_class(a)))
}

/// Set `justify-content`.
pub fn justify(g: Grid(msg), j: Justify) -> Grid(msg) {
  Grid(..g, justify: Some(justify.to_class(j)))
}

/// Appends Tailwind utility styles. Use for custom grid template values.
pub fn style(g: Grid(msg), s: List(Style)) -> Grid(msg) {
  Grid(..g, styles: list.append(g.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(g: Grid(msg), a: List(Attribute(msg))) -> Grid(msg) {
  Grid(..g, attrs: list.append(g.attrs, a))
}

/// Sets child elements. May be called multiple times — children accumulate.
pub fn children(g: Grid(msg), c: List(Element(msg))) -> Grid(msg) {
  Grid(..g, children: list.append(g.children, c))
}

pub fn build(g: Grid(msg)) -> Element(msg) {
  let parts =
    [
      Some("grid"),
      option.map(g.cols, fn(n) { "grid-cols-" <> int.to_string(n) }),
      option.map(g.rows, fn(n) { "grid-rows-" <> int.to_string(n) }),
      g.gap,
      g.align,
      g.justify,
      case style.to_class_string(g.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
  let cls = string.join(parts, " ")
  html.div([attribute.class(cls), ..g.attrs], g.children)
}
