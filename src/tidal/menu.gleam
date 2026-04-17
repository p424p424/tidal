/// Menu — DaisyUI `menu` vertical or horizontal navigation list.
///
/// ```gleam
/// import tidal/menu
///
/// menu.new()
/// |> menu.items(entries: [
///   menu.item("Dashboard", UserNavigated("/"))
///   |> menu.item_icon(home_icon),
///   menu.title("Account"),
///   menu.item_link("Profile", "/profile"),
///   menu.item_link("Settings", "/settings"),
///   menu.divider(),
///   menu.item("Log out", UserLoggedOut),
/// ])
/// |> menu.build
/// ```
///
/// See also:
/// - DaisyUI menu docs: https://daisyui.com/components/menu/
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
// MenuItem type
// ---------------------------------------------------------------------------

pub opaque type MenuItem(msg) {
  Item(label: String, on_click: msg, active: Bool, icon: Option(Element(msg)))
  ItemLink(
    label: String,
    href: String,
    active: Bool,
    icon: Option(Element(msg)),
  )
  ItemDisabled(label: String)
  Title(label: String)
  Submenu(label: String, items: List(MenuItem(msg)))
  Divider
}

/// Standard clickable menu item — dispatches `msg` on click.
pub fn item(label: String, on_click: msg) -> MenuItem(msg) {
  Item(label: label, on_click: on_click, active: False, icon: None)
}

/// Linked menu item — renders as `<a href>`.
pub fn item_link(label: String, href: String) -> MenuItem(msg) {
  ItemLink(label: label, href: href, active: False, icon: None)
}

/// Active (highlighted/selected) version of `item`.
pub fn item_active(label: String, on_click: msg) -> MenuItem(msg) {
  Item(label: label, on_click: on_click, active: True, icon: None)
}

/// Disabled non-interactive item — `menu-disabled` on `<li>`.
pub fn item_disabled(label: String) -> MenuItem(msg) {
  ItemDisabled(label: label)
}

/// Add a leading icon to an `item` or `item_link`.
pub fn item_icon(mi: MenuItem(msg), icon: Element(msg)) -> MenuItem(msg) {
  case mi {
    Item(l, oc, a, _) -> Item(l, oc, a, Some(icon))
    ItemLink(l, h, a, _) -> ItemLink(l, h, a, Some(icon))
    other -> other
  }
}

/// Non-interactive section heading — `<li class="menu-title">`.
pub fn title(label: String) -> MenuItem(msg) {
  Title(label: label)
}

/// Collapsible submenu — renders as a nested `<ul>`.
pub fn submenu(label: String, sub_items: List(MenuItem(msg))) -> MenuItem(msg) {
  Submenu(label: label, items: sub_items)
}

/// Horizontal divider between items.
pub fn divider() -> MenuItem(msg) {
  Divider
}

// ---------------------------------------------------------------------------
// Menu container
// ---------------------------------------------------------------------------

pub opaque type Menu(msg) {
  Menu(
    items: List(MenuItem(msg)),
    size: Option(Size),
    horizontal: Bool,
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

/// Creates a new `Menu` container — `<ul class="menu">`.
///
/// Chain builder functions to configure the menu, then call `build`:
///
/// ```gleam
/// import tidal/menu
///
/// menu.new()
/// |> menu.items(entries: [
///   menu.item_link("Home", "/"),
///   menu.item_link("About", "/about"),
/// ])
/// |> menu.build
/// ```
///
/// See also:
/// - DaisyUI menu docs: https://daisyui.com/components/menu/
pub fn new() -> Menu(msg) {
  Menu(items: [], size: None, horizontal: False, styles: [], attrs: [])
}

/// Appends menu items.
pub fn items(menu: Menu(msg), entries entries: List(MenuItem(msg))) -> Menu(msg) {
  Menu(..menu, items: list.append(menu.items, entries))
}

/// Horizontal layout — `menu-horizontal`.
pub fn horizontal(menu: Menu(msg)) -> Menu(msg) {
  Menu(..menu, horizontal: True)
}

/// Menu item size.
pub fn size(menu: Menu(msg), size size: Size) -> Menu(msg) {
  Menu(..menu, size: Some(size))
}

/// Appends Tailwind utility styles.
pub fn style(menu: Menu(msg), styles styles: List(Style)) -> Menu(msg) {
  Menu(..menu, styles: list.append(menu.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  menu: Menu(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Menu(msg) {
  Menu(..menu, attrs: list.append(menu.attrs, attributes))
}

// ---------------------------------------------------------------------------
// Build helpers
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

fn icon_children(
  icon: Option(Element(msg)),
  label: String,
) -> List(Element(msg)) {
  case icon {
    None -> [element.text(label)]
    Some(el) -> [el, element.text(label)]
  }
}

fn item_el(mi: MenuItem(msg)) -> Element(msg) {
  case mi {
    Item(label, msg, active, icon) -> {
      let cls = case active {
        True -> "active"
        False -> ""
      }
      html.li([], [
        html.button(
          [event.on_click(msg), attribute.class(cls)],
          icon_children(icon, label),
        ),
      ])
    }
    ItemDisabled(label) ->
      html.li([attribute.class("menu-disabled")], [element.text(label)])
    ItemLink(label, href, active, icon) -> {
      let cls = case active {
        True -> "active"
        False -> ""
      }
      html.li([], [
        html.a(
          [attribute.href(href), attribute.class(cls)],
          icon_children(icon, label),
        ),
      ])
    }
    Title(label) ->
      html.li([attribute.class("menu-title")], [element.text(label)])
    Submenu(label, sub_items) ->
      html.li([], [
        html.details([], [
          html.summary([], [element.text(label)]),
          html.ul([], list.map(sub_items, item_el)),
        ]),
      ])
    Divider -> html.li([attribute.class("divider")], [])
  }
}

pub fn build(menu: Menu(msg)) -> Element(msg) {
  let classes =
    [
      Some("menu"),
      case menu.horizontal {
        True -> Some("menu-horizontal")
        False -> None
      },
      option.map(menu.size, size_class),
      case style.to_class_string(menu.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.ul(
    [attribute.class(classes), ..menu.attrs],
    list.map(menu.items, item_el),
  )
}
