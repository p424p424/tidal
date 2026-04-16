/// Dock (bottom navigation) — DaisyUI `dock` bar.
///
/// Items are built with `dock_item/3` and optionally marked active with `dock_active/1`.
///
/// ```gleam
/// import tidal/dock
///
/// dock.new()
/// |> dock.items([
///   dock.dock_item(home_icon, "Home", UserClickedHome) |> dock.dock_active,
///   dock.dock_item(search_icon, "Search", UserClickedSearch),
///   dock.dock_item(profile_icon, "Profile", UserClickedProfile),
/// ])
/// |> dock.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

pub opaque type DockItem(msg) {
  DockItem(icon: Element(msg), label: String, on_click: msg, active: Bool)
}

pub opaque type Dock(msg) {
  Dock(
    size: Option(Size),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    items: List(DockItem(msg)),
  )
}

// ---------------------------------------------------------------------------
// DockItem
// ---------------------------------------------------------------------------

/// Creates a dock item with an icon, label, and click message.
pub fn dock_item(icon: Element(msg), label: String, on_click: msg) -> DockItem(msg) {
  DockItem(icon: icon, label: label, on_click: on_click, active: False)
}

/// Marks this dock item as the active/current item — `dock-active`.
pub fn dock_active(d: DockItem(msg)) -> DockItem(msg) {
  DockItem(..d, active: True)
}

// ---------------------------------------------------------------------------
// Dock container
// ---------------------------------------------------------------------------

/// Create a new dock — `<div class="dock">`.
pub fn new() -> Dock(msg) {
  Dock(size: None, styles: [], attrs: [], items: [])
}

/// Sets the dock size — `dock-xs` … `dock-xl`.
pub fn size(d: Dock(msg), s: Size) -> Dock(msg) {
  Dock(..d, size: Some(s))
}

/// Appends dock items. May be called multiple times — items accumulate.
pub fn items(d: Dock(msg), is: List(DockItem(msg))) -> Dock(msg) {
  Dock(..d, items: list.append(d.items, is))
}

/// Appends Tailwind utility styles.
pub fn style(d: Dock(msg), s: List(Style)) -> Dock(msg) {
  Dock(..d, styles: list.append(d.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(d: Dock(msg), a: List(Attribute(msg))) -> Dock(msg) {
  Dock(..d, attrs: list.append(d.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "dock-xs"
    size.Sm -> "dock-sm"
    size.Md -> ""
    size.Lg -> "dock-lg"
    size.Xl -> "dock-xl"
  }
}

fn item_el(di: DockItem(msg)) -> Element(msg) {
  let cls = case di.active { True -> "dock-active" False -> "" }
  let btn_attrs = case cls {
    "" -> [event.on_click(di.on_click)]
    c -> [attribute.class(c), event.on_click(di.on_click)]
  }
  html.button(
    btn_attrs,
    [di.icon, html.span([attribute.class("dock-label")], [html.text(di.label)])],
  )
}

pub fn build(d: Dock(msg)) -> Element(msg) {
  let classes =
    [
      Some("dock"),
      option.map(d.size, size_class),
      case style.to_class_string(d.styles) { "" -> None s -> Some(s) },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.div([attribute.class(classes), ..d.attrs], list.map(d.items, item_el))
}
