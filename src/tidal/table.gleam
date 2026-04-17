/// Table component — renders a DaisyUI styled `<table>`.
///
/// Columns are defined once; rows are provided as lists matching column order.
///
/// ```gleam
/// import tidal/table
///
/// table.new()
/// |> table.columns(headers: ["Name", "Role", "Status"])
/// |> table.rows(data: [
///   [element.text("Alice"), element.text("Admin"), status_badge],
///   [element.text("Bob"),   element.text("Editor"), status_badge],
/// ])
/// |> table.zebra()
/// |> table.pin_rows()
/// |> table.build
/// ```
///
/// See also:
/// - DaisyUI table docs: https://daisyui.com/components/table/
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Table(msg) {
  Table(
    columns: List(String),
    rows: List(List(Element(msg))),
    zebra: Bool,
    pin_rows: Bool,
    pin_cols: Bool,
    size: Option(String),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

/// Creates a new `Table` — renders `<table class="table">`.
///
/// Chain builder functions to configure the table, then call `build`:
///
/// ```gleam
/// import tidal/table
///
/// table.new()
/// |> table.columns(headers: ["Name", "Role"])
/// |> table.rows(data: [
///   [element.text("Alice"), element.text("Admin")],
/// ])
/// |> table.zebra()
/// |> table.build
/// ```
///
/// See also:
/// - DaisyUI table docs: https://daisyui.com/components/table/
pub fn new() -> Table(msg) {
  Table(
    columns: [],
    rows: [],
    zebra: False,
    pin_rows: False,
    pin_cols: False,
    size: None,
    styles: [],
    attrs: [],
  )
}

/// Sets the column header labels.
pub fn columns(tbl: Table(msg), headers headers: List(String)) -> Table(msg) {
  Table(..tbl, columns: headers)
}

/// Adds data rows. Each row is a list of `Element(msg)` matching column order.
/// May be called multiple times — rows accumulate.
pub fn rows(tbl: Table(msg), data data: List(List(Element(msg)))) -> Table(msg) {
  Table(..tbl, rows: list.append(tbl.rows, data))
}

/// Applies alternating row background colours (`table-zebra`).
pub fn zebra(tbl: Table(msg)) -> Table(msg) {
  Table(..tbl, zebra: True)
}

/// Pins header row so it stays visible while scrolling (`table-pin-rows`).
pub fn pin_rows(tbl: Table(msg)) -> Table(msg) {
  Table(..tbl, pin_rows: True)
}

/// Pins the first column so it stays visible while scrolling (`table-pin-cols`).
pub fn pin_cols(tbl: Table(msg)) -> Table(msg) {
  Table(..tbl, pin_cols: True)
}

/// Applies extra-small row padding (`table-xs`).
pub fn xs(tbl: Table(msg)) -> Table(msg) {
  Table(..tbl, size: Some("table-xs"))
}

/// Applies small row padding (`table-sm`).
pub fn sm(tbl: Table(msg)) -> Table(msg) {
  Table(..tbl, size: Some("table-sm"))
}

/// Applies large row padding (`table-lg`).
pub fn lg(tbl: Table(msg)) -> Table(msg) {
  Table(..tbl, size: Some("table-lg"))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(tbl: Table(msg), styles styles: List(Style)) -> Table(msg) {
  Table(..tbl, styles: list.append(tbl.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  tbl: Table(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Table(msg) {
  Table(..tbl, attrs: list.append(tbl.attrs, attributes))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn th(label: String) -> Element(msg) {
  html.th([], [element.text(label)])
}

fn td(el: Element(msg)) -> Element(msg) {
  html.td([], [el])
}

pub fn build(tbl: Table(msg)) -> Element(msg) {
  let classes =
    [
      Some("table"),
      case tbl.zebra {
        True -> Some("table-zebra")
        False -> None
      },
      case tbl.pin_rows {
        True -> Some("table-pin-rows")
        False -> None
      },
      case tbl.pin_cols {
        True -> Some("table-pin-cols")
        False -> None
      },
      tbl.size,
      case style.to_class_string(tbl.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let header = html.thead([], [html.tr([], list.map(tbl.columns, th))])

  let body =
    html.tbody(
      [],
      list.map(tbl.rows, fn(row) { html.tr([], list.map(row, td)) }),
    )

  html.table([attribute.class(classes), ..tbl.attrs], [header, body])
}
