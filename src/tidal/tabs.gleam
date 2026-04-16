/// Tabs — DaisyUI `tabs` navigation bar with optional tab content panels.
///
/// Build individual tabs with `tab_new()` → modifiers → `tab_build`,
/// then pass the list to the container with `new()` → `items()` → `build`.
///
/// ```gleam
/// import tidal/tabs
///
/// tabs.new()
/// |> tabs.boxed
/// |> tabs.items([
///   tabs.tab_new()
///   |> tabs.tab_label("Home")
///   |> tabs.tab_active
///   |> tabs.tab_on_click(UserSwitchedTab("Home"))
///   |> tabs.tab_build,
///   tabs.tab_new()
///   |> tabs.tab_label("Profile")
///   |> tabs.tab_on_click(UserSwitchedTab("Profile"))
///   |> tabs.tab_build,
/// ])
/// |> tabs.build
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
// TabItem sub-builder
// ---------------------------------------------------------------------------

pub opaque type TabItem(msg) {
  TabItem(
    label: String,
    active: Bool,
    disabled: Bool,
    on_click: Option(msg),
    content: List(Element(msg)),
    attrs: List(attribute.Attribute(msg)),
  )
}

/// Create a new tab item. Use `tab_label(t)` to set the label.
pub fn tab_new() -> TabItem(msg) {
  TabItem(label: "", active: False, disabled: False, on_click: None, content: [], attrs: [])
}

/// Sets the tab label text.
pub fn tab_label(t: TabItem(msg), text: String) -> TabItem(msg) {
  TabItem(..t, label: text)
}

/// Marks this tab as the active/selected tab — `tab-active`.
pub fn tab_active(t: TabItem(msg)) -> TabItem(msg) { TabItem(..t, active: True) }

/// Marks this tab as disabled — `tab-disabled`.
pub fn tab_disabled(t: TabItem(msg)) -> TabItem(msg) { TabItem(..t, disabled: True) }

/// Content shown below the tab bar when this tab is active (radio-input approach).
pub fn tab_content(t: TabItem(msg), els: List(Element(msg))) -> TabItem(msg) {
  TabItem(..t, content: list.append(t.content, els))
}

/// Click handler — fires with the tab label when clicked.
pub fn tab_on_click(t: TabItem(msg), msg: msg) -> TabItem(msg) {
  TabItem(..t, on_click: Some(msg))
}

/// Appends HTML attributes to the tab element.
pub fn tab_attrs(t: TabItem(msg), a: List(attribute.Attribute(msg))) -> TabItem(msg) {
  TabItem(..t, attrs: list.append(t.attrs, a))
}

pub fn tab_build(t: TabItem(msg)) -> Element(msg) {
  let cls =
    [
      Some("tab"),
      case t.active { True -> Some("tab-active") False -> None },
      case t.disabled { True -> Some("tab-disabled") False -> None },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let click_attrs = case t.on_click {
    None -> []
    Some(msg) -> [event.on_click(msg)]
  }
  html.a([attribute.class(cls), ..list.append(click_attrs, t.attrs)], [element.text(t.label)])
}

// ---------------------------------------------------------------------------
// Tabs container
// ---------------------------------------------------------------------------

pub opaque type Tabs(msg) {
  Tabs(
    style_variant: Option(String),
    placement: Option(String),
    size: Option(Size),
    items: List(Element(msg)),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

/// Create a new tabs container — `<div class="tabs">`.
pub fn new() -> Tabs(msg) {
  Tabs(style_variant: None, placement: None, size: None, items: [], styles: [], attrs: [])
}

/// Appends tab item elements (built with `tab_build`).
pub fn items(t: Tabs(msg), els: List(Element(msg))) -> Tabs(msg) {
  Tabs(..t, items: list.append(t.items, els))
}

/// Boxed tab style — `tabs-box`.
pub fn boxed(t: Tabs(msg)) -> Tabs(msg) { Tabs(..t, style_variant: Some("tabs-box")) }
/// Border tab style — `tabs-border`.
pub fn bordered(t: Tabs(msg)) -> Tabs(msg) { Tabs(..t, style_variant: Some("tabs-border")) }
/// Lifted/raised tab style — `tabs-lift`.
pub fn lifted(t: Tabs(msg)) -> Tabs(msg) { Tabs(..t, style_variant: Some("tabs-lift")) }

/// Tabs above content (default) — `tabs-top`.
pub fn top(t: Tabs(msg)) -> Tabs(msg) { Tabs(..t, placement: Some("tabs-top")) }
/// Tabs below content — `tabs-bottom`.
pub fn bottom(t: Tabs(msg)) -> Tabs(msg) { Tabs(..t, placement: Some("tabs-bottom")) }

/// Sets the tab bar size.
pub fn size(t: Tabs(msg), s: Size) -> Tabs(msg) { Tabs(..t, size: Some(s)) }

/// Appends Tailwind utility styles.
pub fn style(t: Tabs(msg), s: List(Style)) -> Tabs(msg) {
  Tabs(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(t: Tabs(msg), a: List(attribute.Attribute(msg))) -> Tabs(msg) {
  Tabs(..t, attrs: list.append(t.attrs, a))
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "tabs-xs"
    size.Sm -> "tabs-sm"
    size.Md -> ""
    size.Lg -> "tabs-lg"
    size.Xl -> "tabs-xl"
  }
}

pub fn build(t: Tabs(msg)) -> Element(msg) {
  let classes =
    [
      Some("tabs"),
      t.style_variant,
      t.placement,
      option.map(t.size, size_class),
      case style.to_class_string(t.styles) { "" -> None s -> Some(s) },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.div([attribute.class(classes), ..t.attrs], t.items)
}
