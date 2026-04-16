/// Menu component — renders a DaisyUI `menu` list.
///
/// Build items using the helper constructors, then pass them to `items/2`.
///
/// ```gleam
/// import tidal/menu
///
/// menu.new()
/// |> menu.items([
///   menu.link("Home", "/", False),
///   menu.section_title("Account"),
///   menu.link("Profile", "/profile", True),
///   menu.link("Settings", "/settings", False),
///   menu.divider(),
///   menu.button("Log out", UserLoggedOut),
/// ])
/// |> menu.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub type MenuItem(msg) {
  /// A navigational link item.
  Link(label: String, href: String, active: Bool)
  /// A clickable item that dispatches a message.
  Button(label: String, on_click: msg)
  /// A non-interactive section heading.
  SectionTitle(label: String)
  /// A horizontal separator line.
  Divider
}

pub opaque type Menu(msg) {
  Menu(
    items: List(MenuItem(msg)),
    size: Option(Size),
    horizontal: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Item constructors (convenience)
// ---------------------------------------------------------------------------

/// Creates a navigational link item.
pub fn link(label: String, href: String, active: Bool) -> MenuItem(msg) {
  Link(label: label, href: href, active: active)
}

/// Creates a clickable item that dispatches `msg` on click.
pub fn button(label: String, on_click: msg) -> MenuItem(msg) {
  Button(label: label, on_click: on_click)
}

/// Creates a non-interactive section heading.
pub fn section_title(label: String) -> MenuItem(msg) {
  SectionTitle(label: label)
}

/// Creates a horizontal divider between items.
pub fn divider() -> MenuItem(msg) {
  Divider
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Menu(msg) {
  Menu(items: [], size: None, horizontal: False, styles: [], attrs: [])
}

/// Sets the menu items. May be called multiple times — items accumulate.
pub fn items(m: Menu(msg), is: List(MenuItem(msg))) -> Menu(msg) {
  Menu(..m, items: list.append(m.items, is))
}

/// Sets the menu size. Defaults to `Md` (no extra class).
pub fn size(m: Menu(msg), s: Size) -> Menu(msg) {
  Menu(..m, size: Some(s))
}

/// Switches to a horizontal menu layout.
pub fn horizontal(m: Menu(msg)) -> Menu(msg) {
  Menu(..m, horizontal: True)
}

/// Appends presentation styles. May be called multiple times.
pub fn style(m: Menu(msg), s: List(Style)) -> Menu(msg) {
  Menu(..m, styles: list.append(m.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(m: Menu(msg), a: List(attribute.Attribute(msg))) -> Menu(msg) {
  Menu(..m, attrs: list.append(m.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "menu-xs"
    size.Sm -> "menu-sm"
    size.Md -> ""
    size.Lg -> "menu-lg"
    size.Xl -> "menu-xl"
  }
}

fn item_el(mi: MenuItem(msg)) -> Element(msg) {
  case mi {
    Link(label, href, active) -> {
      let cls = case active { True -> "active" False -> "" }
      html.li([], [html.a([attribute.href(href), attribute.class(cls)], [element.text(label)])])
    }
    Button(label, msg) ->
      html.li([], [html.button([event.on_click(msg)], [element.text(label)])])
    SectionTitle(label) ->
      html.li([attribute.class("menu-title")], [element.text(label)])
    Divider ->
      html.li([attribute.class("divider")], [])
  }
}

pub fn build(m: Menu(msg)) -> Element(msg) {
  let classes =
    [
      Some("menu"),
      case m.horizontal { True -> Some("menu-horizontal") False -> None },
      option.map(m.size, size_class),
      case style.to_class_string(m.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  html.ul([attribute.class(classes), ..m.attrs], list.map(m.items, item_el))
}
