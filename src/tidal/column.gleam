/// Vertical flex container — `<div class="flex flex-col">`.
///
/// ```gleam
/// import tidal/column
/// import tidal/align
///
/// column.new()
/// |> column.gap(amount: 6)
/// |> column.align(alignment: align.Center)
/// |> column.children(elements: [header_el, body_el, footer_el])
/// |> column.build
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

pub opaque type Column(msg) {
  Column(
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

/// Creates a new `Column` builder — a `<div>` with `flex flex-col`.
///
/// Chain builder functions to configure the column, then call `build`:
///
/// ```gleam
/// import tidal/column
/// import tidal/align
///
/// column.new()
/// |> column.gap(amount: 6)
/// |> column.align(alignment: align.Center)
/// |> column.children(elements: [header_el, body_el, footer_el])
/// |> column.build
/// ```
///
/// See also:
/// - Tailwind flexbox docs: https://tailwindcss.com/docs/flex-direction
pub fn new() -> Column(msg) {
  Column(
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

/// Reverse the direction to `flex-col-reverse`.
pub fn reverse(col: Column(msg)) -> Column(msg) {
  Column(..col, reverse: True)
}

/// Make the column fill available space with `flex-1`.
pub fn grow(col: Column(msg)) -> Column(msg) {
  Column(..col, grow: True)
}

/// Set `align-items` — how children align on the cross axis.
pub fn align(col: Column(msg), alignment alignment: Align) -> Column(msg) {
  Column(..col, align: Some(align.to_class(alignment)))
}

/// Set `justify-content` — how children are distributed along the main axis.
pub fn justify(
  col: Column(msg),
  justification justification: Justify,
) -> Column(msg) {
  Column(..col, justify: Some(justify.to_class(justification)))
}

/// Set flex wrapping behaviour.
pub fn wrap(col: Column(msg), wrapping wrapping: Wrap) -> Column(msg) {
  Column(..col, wrap: Some(wrap.to_class(wrapping)))
}

/// Uniform gap between children.
pub fn gap(col: Column(msg), amount amount: Int) -> Column(msg) {
  Column(..col, gap: Some("gap-" <> int.to_string(amount)))
}

/// Horizontal gap only.
pub fn gap_x(col: Column(msg), amount amount: Int) -> Column(msg) {
  Column(..col, gap: Some("gap-x-" <> int.to_string(amount)))
}

/// Vertical gap only.
pub fn gap_y(col: Column(msg), amount amount: Int) -> Column(msg) {
  Column(..col, gap: Some("gap-y-" <> int.to_string(amount)))
}

/// Appends Tailwind utility styles. May be called multiple times.
pub fn style(col: Column(msg), styles styles: List(Style)) -> Column(msg) {
  Column(..col, styles: list.append(col.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  col: Column(msg),
  attributes attributes: List(Attribute(msg)),
) -> Column(msg) {
  Column(..col, attrs: list.append(col.attrs, attributes))
}

/// Appends child elements. May be called multiple times.
pub fn children(
  col: Column(msg),
  elements elements: List(Element(msg)),
) -> Column(msg) {
  Column(..col, children: list.append(col.children, elements))
}

pub fn build(col: Column(msg)) -> Element(msg) {
  let direction = case col.reverse {
    True -> "flex-col-reverse"
    False -> "flex-col"
  }
  let parts =
    [
      Some("flex"),
      Some(direction),
      case col.grow {
        True -> Some("flex-1")
        False -> None
      },
      col.align,
      col.justify,
      col.wrap,
      col.gap,
      case style.to_class_string(col.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(s) { s != "" })
  let cls = string.join(parts, " ")
  html.div([attribute.class(cls), ..col.attrs], col.children)
}
