/// Table component — renders a DaisyUI styled `<table>`.
///
/// Columns are defined once; rows are provided as lists matching column order.
///
/// ```gleam
/// import tidal/table
///
/// table.new()
/// |> table.columns(["Name", "Role", "Status"])
/// |> table.rows([
///   [element.text("Alice"), element.text("Admin"), status_badge],
///   [element.text("Bob"),   element.text("Editor"), status_badge],
/// ])
/// |> table.zebra()
/// |> table.pin_rows()
/// |> table.build
/// ```

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
pub fn columns(t: Table(msg), cols: List(String)) -> Table(msg) {
  Table(..t, columns: cols)
}

/// Adds data rows. Each row is a list of `Element(msg)` matching column order.
/// May be called multiple times — rows accumulate.
pub fn rows(t: Table(msg), rs: List(List(Element(msg)))) -> Table(msg) {
  Table(..t, rows: list.append(t.rows, rs))
}

/// Applies alternating row background colours (`table-zebra`).
pub fn zebra(t: Table(msg)) -> Table(msg) {
  Table(..t, zebra: True)
}

/// Pins header row so it stays visible while scrolling (`table-pin-rows`).
pub fn pin_rows(t: Table(msg)) -> Table(msg) {
  Table(..t, pin_rows: True)
}

/// Pins the first column so it stays visible while scrolling (`table-pin-cols`).
pub fn pin_cols(t: Table(msg)) -> Table(msg) {
  Table(..t, pin_cols: True)
}

/// Applies extra-small row padding (`table-xs`).
pub fn xs(t: Table(msg)) -> Table(msg) {
  Table(..t, size: Some("table-xs"))
}

/// Applies small row padding (`table-sm`).
pub fn sm(t: Table(msg)) -> Table(msg) {
  Table(..t, size: Some("table-sm"))
}

/// Applies large row padding (`table-lg`).
pub fn lg(t: Table(msg)) -> Table(msg) {
  Table(..t, size: Some("table-lg"))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(t: Table(msg), s: List(Style)) -> Table(msg) {
  Table(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(t: Table(msg), a: List(attribute.Attribute(msg))) -> Table(msg) {
  Table(..t, attrs: list.append(t.attrs, a))
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

pub fn build(t: Table(msg)) -> Element(msg) {
  let classes =
    [
      Some("table"),
      case t.zebra { True -> Some("table-zebra") False -> None },
      case t.pin_rows { True -> Some("table-pin-rows") False -> None },
      case t.pin_cols { True -> Some("table-pin-cols") False -> None },
      t.size,
      case style.to_class_string(t.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let header =
    html.thead([], [html.tr([], list.map(t.columns, th))])

  let body =
    html.tbody(
      [],
      list.map(t.rows, fn(row) { html.tr([], list.map(row, td)) }),
    )

  html.table([attribute.class(classes), ..t.attrs], [header, body])
}
