/// Tabs component — renders a DaisyUI `tabs` navigation.
///
/// Tabs are passed as `(label, is_active)` pairs. Use `on_change` to receive
/// the label of the clicked tab.
///
/// ```gleam
/// import tidal/tabs
///
/// tabs.new()
/// |> tabs.tabs([#("Home", True), #("Profile", False), #("Settings", False)])
/// |> tabs.variant(tabs.Boxed)
/// |> tabs.on_change(UserSwitchedTab)
/// |> tabs.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub type TabVariant {
  Default
  Boxed
  Bordered
  Lifted
}

pub opaque type Tabs(msg) {
  Tabs(
    tabs: List(#(String, Bool)),
    variant: TabVariant,
    on_change: Option(fn(String) -> msg),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Tabs(msg) {
  Tabs(tabs: [], variant: Default, on_change: None, styles: [], attrs: [])
}

/// Sets the list of `(label, is_active)` tab pairs.
pub fn tabs(t: Tabs(msg), items: List(#(String, Bool))) -> Tabs(msg) {
  Tabs(..t, tabs: items)
}

/// Sets the visual style of the tab bar.
pub fn variant(t: Tabs(msg), v: TabVariant) -> Tabs(msg) {
  Tabs(..t, variant: v)
}

/// Registers a callback receiving the label of the clicked tab.
pub fn on_change(t: Tabs(msg), msg: fn(String) -> msg) -> Tabs(msg) {
  Tabs(..t, on_change: Some(msg))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(t: Tabs(msg), s: List(Style)) -> Tabs(msg) {
  Tabs(..t, styles: list.append(t.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(t: Tabs(msg), a: List(attribute.Attribute(msg))) -> Tabs(msg) {
  Tabs(..t, attrs: list.append(t.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: TabVariant) -> String {
  case v {
    Default -> ""
    Boxed -> "tabs-boxed"
    Bordered -> "tabs-bordered"
    Lifted -> "tabs-lifted"
  }
}

fn tab_el(
  on_change: Option(fn(String) -> msg),
  pair: #(String, Bool),
) -> Element(msg) {
  let #(label, active) = pair
  let cls = case active {
    True -> "tab tab-active"
    False -> "tab"
  }
  let click_attrs = case on_change {
    None -> []
    Some(handler) -> [event.on_click(handler(label))]
  }
  html.a([attribute.class(cls), ..click_attrs], [element.text(label)])
}

pub fn build(t: Tabs(msg)) -> Element(msg) {
  let classes =
    [
      Some("tabs"),
      case variant_class(t.variant) {
        "" -> None
        c -> Some(c)
      },
      case style.to_class_string(t.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> string.join(" ")

  let tab_els = list.map(t.tabs, tab_el(t.on_change, _))

  html.div([attribute.class(classes), ..t.attrs], tab_els)
}
