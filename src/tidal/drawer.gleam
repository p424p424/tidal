/// Drawer component — renders a DaisyUI `drawer` layout with a toggleable sidebar.
///
/// The drawer wraps your page content and sidebar together. Use `open/2` to
/// control visibility from your model.
///
/// ```gleam
/// import tidal/drawer
///
/// drawer.new()
/// |> drawer.open(model.drawer_open)
/// |> drawer.on_close(UserClosedDrawer)
/// |> drawer.content([main_content])
/// |> drawer.sidebar([nav_menu])
/// |> drawer.build
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

pub opaque type Drawer(msg) {
  Drawer(
    open: Bool,
    on_close: Option(msg),
    content: List(Element(msg)),
    sidebar: List(Element(msg)),
    end_: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Drawer(msg) {
  Drawer(
    open: False,
    on_close: None,
    content: [],
    sidebar: [],
    end_: False,
    styles: [],
    attrs: [],
  )
}

/// Controls whether the drawer is open.
pub fn open(d: Drawer(msg), is_open: Bool) -> Drawer(msg) {
  Drawer(..d, open: is_open)
}

/// Registers a message dispatched when the overlay backdrop is clicked.
pub fn on_close(d: Drawer(msg), msg: msg) -> Drawer(msg) {
  Drawer(..d, on_close: Some(msg))
}

/// Sets the main page content. May be called multiple times — accumulates.
pub fn content(d: Drawer(msg), els: List(Element(msg))) -> Drawer(msg) {
  Drawer(..d, content: list.append(d.content, els))
}

/// Sets the sidebar content. May be called multiple times — accumulates.
pub fn sidebar(d: Drawer(msg), els: List(Element(msg))) -> Drawer(msg) {
  Drawer(..d, sidebar: list.append(d.sidebar, els))
}

/// Places the drawer on the right side instead of the left.
pub fn end_(d: Drawer(msg)) -> Drawer(msg) {
  Drawer(..d, end_: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(d: Drawer(msg), s: List(Style)) -> Drawer(msg) {
  Drawer(..d, styles: list.append(d.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(d: Drawer(msg), a: List(attribute.Attribute(msg))) -> Drawer(msg) {
  Drawer(..d, attrs: list.append(d.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(d: Drawer(msg)) -> Element(msg) {
  let classes =
    [
      Some("drawer"),
      case d.end_ { True -> Some("drawer-end") False -> None },
      case style.to_class_string(d.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let checkbox =
    html.input([
      attribute.id("tidal-drawer-toggle"),
      attribute.type_("checkbox"),
      attribute.class("drawer-toggle"),
      attribute.checked(d.open),
    ])

  let content_el =
    html.div([attribute.class("drawer-content")], d.content)

  let overlay_attrs = case d.on_close {
    None -> [attribute.class("drawer-overlay"), attribute.for("tidal-drawer-toggle")]
    Some(_msg) -> [
      attribute.class("drawer-overlay"),
      attribute.for("tidal-drawer-toggle"),
    ]
  }

  let side_el =
    html.div(
      [attribute.class("drawer-side")],
      [html.label(overlay_attrs, []), html.div([attribute.class("drawer-menu")], d.sidebar)],
    )

  html.div([attribute.class(classes), ..d.attrs], [checkbox, content_el, side_el])
}
