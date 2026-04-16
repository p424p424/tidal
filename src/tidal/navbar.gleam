/// Navbar component — renders a DaisyUI `navbar` with start, center, and end slots.
///
/// ```gleam
/// import tidal/navbar
/// import tidal/button
///
/// navbar.new()
/// |> navbar.start([
///   html.span([attribute.class("text-xl font-bold")], [html.text("MyApp")]),
/// ])
/// |> navbar.end_([
///   button.new() |> button.label("Login") |> button.ghost |> button.build,
/// ])
/// |> navbar.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Navbar(msg) {
  Navbar(
    start: List(Element(msg)),
    center: List(Element(msg)),
    end_: List(Element(msg)),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Navbar(msg) {
  Navbar(start: [], center: [], end_: [], styles: [], attrs: [])
}

/// Sets elements in the left (start) slot. May be called multiple times — accumulates.
pub fn start(n: Navbar(msg), els: List(Element(msg))) -> Navbar(msg) {
  Navbar(..n, start: list.append(n.start, els))
}

/// Sets elements in the center slot. May be called multiple times — accumulates.
pub fn center(n: Navbar(msg), els: List(Element(msg))) -> Navbar(msg) {
  Navbar(..n, center: list.append(n.center, els))
}

/// Sets elements in the right (end) slot. May be called multiple times — accumulates.
pub fn end_(n: Navbar(msg), els: List(Element(msg))) -> Navbar(msg) {
  Navbar(..n, end_: list.append(n.end_, els))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(n: Navbar(msg), s: List(Style)) -> Navbar(msg) {
  Navbar(..n, styles: list.append(n.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(n: Navbar(msg), a: List(attribute.Attribute(msg))) -> Navbar(msg) {
  Navbar(..n, attrs: list.append(n.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn slot(cls: String, els: List(Element(msg))) -> Option(Element(msg)) {
  case els {
    [] -> None
    _ -> Some(html.div([attribute.class(cls)], els))
  }
}

pub fn build(n: Navbar(msg)) -> Element(msg) {
  let cls = case style.to_class_string(n.styles) {
    "" -> "navbar"
    s -> "navbar " <> s
  }
  let slots =
    [
      slot("navbar-start", n.start),
      slot("navbar-center", n.center),
      slot("navbar-end", n.end_),
    ]
    |> option.values

  html.div([attribute.class(cls), ..n.attrs], slots)
}
