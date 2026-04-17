/// Drawer component — renders a DaisyUI `drawer` layout with a toggleable sidebar.
///
/// The drawer wraps your page content and sidebar together. Use `open(to:)` to
/// control visibility from your model.
///
/// ```gleam
/// import tidal/drawer
///
/// drawer.new()
/// |> drawer.open(to: model.drawer_open)
/// |> drawer.on_close(UserClosedDrawer)
/// |> drawer.content(elements: [main_content])
/// |> drawer.sidebar(elements: [nav_menu])
/// |> drawer.build
/// ```
///
/// See also:
/// - DaisyUI drawer docs: https://daisyui.com/components/drawer/
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

/// Creates a new `Drawer` builder (closed by default).
///
/// Chain builder functions to configure the drawer, then call `build`:
///
/// ```gleam
/// import tidal/drawer
///
/// drawer.new()
/// |> drawer.open(to: model.drawer_open)
/// |> drawer.on_close(UserClosedDrawer)
/// |> drawer.content(elements: [main_content])
/// |> drawer.sidebar(elements: [nav_menu])
/// |> drawer.build
/// ```
///
/// See also:
/// - DaisyUI drawer docs: https://daisyui.com/components/drawer/
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
pub fn open(drawer: Drawer(msg), to is_open: Bool) -> Drawer(msg) {
  Drawer(..drawer, open: is_open)
}

/// Registers a message dispatched when the overlay backdrop is clicked.
pub fn on_close(drawer: Drawer(msg), msg: msg) -> Drawer(msg) {
  Drawer(..drawer, on_close: Some(msg))
}

/// Sets the main page content. May be called multiple times — accumulates.
pub fn content(
  drawer: Drawer(msg),
  elements elements: List(Element(msg)),
) -> Drawer(msg) {
  Drawer(..drawer, content: list.append(drawer.content, elements))
}

/// Sets the sidebar content. May be called multiple times — accumulates.
pub fn sidebar(
  drawer: Drawer(msg),
  elements elements: List(Element(msg)),
) -> Drawer(msg) {
  Drawer(..drawer, sidebar: list.append(drawer.sidebar, elements))
}

/// Places the drawer on the right side instead of the left.
pub fn end_(drawer: Drawer(msg)) -> Drawer(msg) {
  Drawer(..drawer, end_: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(drawer: Drawer(msg), styles styles: List(Style)) -> Drawer(msg) {
  Drawer(..drawer, styles: list.append(drawer.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  drawer: Drawer(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Drawer(msg) {
  Drawer(..drawer, attrs: list.append(drawer.attrs, attributes))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(drawer: Drawer(msg)) -> Element(msg) {
  let classes =
    [
      Some("drawer"),
      case drawer.end_ {
        True -> Some("drawer-end")
        False -> None
      },
      case style.to_class_string(drawer.styles) {
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
      attribute.checked(drawer.open),
    ])

  let content_el = html.div([attribute.class("drawer-content")], drawer.content)

  let overlay_attrs = case drawer.on_close {
    None -> [
      attribute.class("drawer-overlay"),
      attribute.for("tidal-drawer-toggle"),
    ]
    Some(_msg) -> [
      attribute.class("drawer-overlay"),
      attribute.for("tidal-drawer-toggle"),
    ]
  }

  let side_el =
    html.div([attribute.class("drawer-side")], [
      html.label(overlay_attrs, []),
      html.div([attribute.class("drawer-menu")], drawer.sidebar),
    ])

  html.div([attribute.class(classes), ..drawer.attrs], [
    checkbox,
    content_el,
    side_el,
  ])
}
