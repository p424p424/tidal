/// Bottom navigation component — renders a DaisyUI `btm-nav` bar.
///
/// Items are built with `nav_item/3` and passed to `items/2`.
///
/// ```gleam
/// import tidal/bottom_nav
///
/// bottom_nav.new()
/// |> bottom_nav.items([
///   bottom_nav.nav_item("Home", home_icon, True, Some(UserClickedHome)),
///   bottom_nav.nav_item("Search", search_icon, False, Some(UserClickedSearch)),
///   bottom_nav.nav_item("Profile", profile_icon, False, Some(UserClickedProfile)),
/// ])
/// |> bottom_nav.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub type NavItem(msg) {
  NavItem(
    label: String,
    icon: Option(Element(msg)),
    active: Bool,
    on_click: Option(msg),
  )
}

pub opaque type BottomNav(msg) {
  BottomNav(
    items: List(NavItem(msg)),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Item constructor
// ---------------------------------------------------------------------------

/// Creates a bottom nav item.
///
/// Pass `None` for `icon` if you only want a label.
/// Pass `None` for `on_click` if the item has no action.
pub fn nav_item(
  label: String,
  icon: Option(Element(msg)),
  active: Bool,
  on_click: Option(msg),
) -> NavItem(msg) {
  NavItem(label: label, icon: icon, active: active, on_click: on_click)
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> BottomNav(msg) {
  BottomNav(items: [], styles: [], attrs: [])
}

/// Sets the nav items. May be called multiple times — items accumulate.
pub fn items(b: BottomNav(msg), is: List(NavItem(msg))) -> BottomNav(msg) {
  BottomNav(..b, items: list.append(b.items, is))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(b: BottomNav(msg), s: List(Style)) -> BottomNav(msg) {
  BottomNav(..b, styles: list.append(b.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  b: BottomNav(msg),
  a: List(attribute.Attribute(msg)),
) -> BottomNav(msg) {
  BottomNav(..b, attrs: list.append(b.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn item_el(ni: NavItem(msg)) -> Element(msg) {
  let cls = case ni.active { True -> "active" False -> "" }
  let click_attrs = case ni.on_click {
    None -> []
    Some(msg) -> [event.on_click(msg)]
  }
  let icon_els = case ni.icon {
    None -> []
    Some(el) -> [el]
  }
  html.button(
    [attribute.class(cls), ..click_attrs],
    list.append(icon_els, [html.span([attribute.class("btm-nav-label")], [element.text(ni.label)])]),
  )
}

pub fn build(b: BottomNav(msg)) -> Element(msg) {
  let cls = case style.to_class_string(b.styles) {
    "" -> "btm-nav"
    s -> "btm-nav " <> s
  }
  html.div([attribute.class(cls), ..b.attrs], list.map(b.items, item_el))
}
