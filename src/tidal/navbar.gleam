/// Navbar component — renders a DaisyUI `navbar` with start, center, and end slots.
///
/// ```gleam
/// import tidal/navbar
/// import tidal/button
///
/// navbar.new()
/// |> navbar.start(elements: [
///   html.span([attribute.class("text-xl font-bold")], [html.text("MyApp")]),
/// ])
/// |> navbar.end_(elements: [
///   button.new() |> button.label(text: "Login") |> button.ghost |> button.build,
/// ])
/// |> navbar.build
/// ```
///
/// See also:
/// - DaisyUI navbar docs: https://daisyui.com/components/navbar/
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

/// Creates a new `Navbar` builder with all slots empty.
///
/// Chain builder functions to populate the navbar, then call `build`:
///
/// ```gleam
/// import tidal/navbar
///
/// navbar.new()
/// |> navbar.start(elements: [brand_el])
/// |> navbar.center(elements: [nav_links])
/// |> navbar.end_(elements: [login_btn])
/// |> navbar.build
/// ```
///
/// See also:
/// - DaisyUI navbar docs: https://daisyui.com/components/navbar/
pub fn new() -> Navbar(msg) {
  Navbar(start: [], center: [], end_: [], styles: [], attrs: [])
}

/// Sets elements in the left (start) slot. May be called multiple times — accumulates.
pub fn start(
  navbar: Navbar(msg),
  elements elements: List(Element(msg)),
) -> Navbar(msg) {
  Navbar(..navbar, start: list.append(navbar.start, elements))
}

/// Sets elements in the center slot. May be called multiple times — accumulates.
pub fn center(
  navbar: Navbar(msg),
  elements elements: List(Element(msg)),
) -> Navbar(msg) {
  Navbar(..navbar, center: list.append(navbar.center, elements))
}

/// Sets elements in the right (end) slot. May be called multiple times — accumulates.
pub fn end_(
  navbar: Navbar(msg),
  elements elements: List(Element(msg)),
) -> Navbar(msg) {
  Navbar(..navbar, end_: list.append(navbar.end_, elements))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(navbar: Navbar(msg), styles styles: List(Style)) -> Navbar(msg) {
  Navbar(..navbar, styles: list.append(navbar.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  navbar: Navbar(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Navbar(msg) {
  Navbar(..navbar, attrs: list.append(navbar.attrs, attributes))
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

pub fn build(navbar: Navbar(msg)) -> Element(msg) {
  let cls = case style.to_class_string(navbar.styles) {
    "" -> "navbar"
    s -> "navbar " <> s
  }
  let slots =
    [
      slot("navbar-start", navbar.start),
      slot("navbar-center", navbar.center),
      slot("navbar-end", navbar.end_),
    ]
    |> option.values

  html.div([attribute.class(cls), ..navbar.attrs], slots)
}
