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
/// |> tabs.items(elements: [
///   tabs.tab_new()
///   |> tabs.tab_label(text: "Home")
///   |> tabs.tab_active
///   |> tabs.tab_on_click(UserSwitchedTab("Home"))
///   |> tabs.tab_build,
///   tabs.tab_new()
///   |> tabs.tab_label(text: "Profile")
///   |> tabs.tab_on_click(UserSwitchedTab("Profile"))
///   |> tabs.tab_build,
/// ])
/// |> tabs.build
/// ```
///
/// See also:
/// - DaisyUI tabs docs: https://daisyui.com/components/tab/
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

/// Creates a new tab item. Use `tab_label` to set the label.
///
/// ```gleam
/// tabs.tab_new()
/// |> tabs.tab_label(text: "Home")
/// |> tabs.tab_active
/// |> tabs.tab_on_click(UserSwitchedTab("Home"))
/// |> tabs.tab_build
/// ```
pub fn tab_new() -> TabItem(msg) {
  TabItem(
    label: "",
    active: False,
    disabled: False,
    on_click: None,
    content: [],
    attrs: [],
  )
}

/// Sets the tab label text.
pub fn tab_label(tab: TabItem(msg), text text: String) -> TabItem(msg) {
  TabItem(..tab, label: text)
}

/// Marks this tab as the active/selected tab — `tab-active`.
pub fn tab_active(tab: TabItem(msg)) -> TabItem(msg) {
  TabItem(..tab, active: True)
}

/// Marks this tab as disabled — `tab-disabled`.
pub fn tab_disabled(tab: TabItem(msg)) -> TabItem(msg) {
  TabItem(..tab, disabled: True)
}

/// Content shown below the tab bar when this tab is active (radio-input approach).
pub fn tab_content(
  tab: TabItem(msg),
  elements elements: List(Element(msg)),
) -> TabItem(msg) {
  TabItem(..tab, content: list.append(tab.content, elements))
}

/// Click handler — fires when tab is clicked.
pub fn tab_on_click(tab: TabItem(msg), msg: msg) -> TabItem(msg) {
  TabItem(..tab, on_click: Some(msg))
}

/// Appends HTML attributes to the tab element.
pub fn tab_attrs(
  tab: TabItem(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> TabItem(msg) {
  TabItem(..tab, attrs: list.append(tab.attrs, attributes))
}

pub fn tab_build(tab: TabItem(msg)) -> Element(msg) {
  let cls =
    [
      Some("tab"),
      case tab.active {
        True -> Some("tab-active")
        False -> None
      },
      case tab.disabled {
        True -> Some("tab-disabled")
        False -> None
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let click_attrs = case tab.on_click {
    None -> []
    Some(msg) -> [event.on_click(msg)]
  }
  html.a([attribute.class(cls), ..list.append(click_attrs, tab.attrs)], [
    element.text(tab.label),
  ])
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

/// Creates a new `Tabs` container — `<div class="tabs">`.
///
/// Chain builder functions to configure the tabs, then call `build`:
///
/// ```gleam
/// import tidal/tabs
///
/// tabs.new()
/// |> tabs.boxed
/// |> tabs.items(elements: [tab1, tab2, tab3])
/// |> tabs.build
/// ```
///
/// See also:
/// - DaisyUI tabs docs: https://daisyui.com/components/tab/
pub fn new() -> Tabs(msg) {
  Tabs(
    style_variant: None,
    placement: None,
    size: None,
    items: [],
    styles: [],
    attrs: [],
  )
}

/// Appends tab item elements (built with `tab_build`).
pub fn items(
  tabs: Tabs(msg),
  elements elements: List(Element(msg)),
) -> Tabs(msg) {
  Tabs(..tabs, items: list.append(tabs.items, elements))
}

/// Boxed tab style — `tabs-box`.
pub fn boxed(tabs: Tabs(msg)) -> Tabs(msg) {
  Tabs(..tabs, style_variant: Some("tabs-box"))
}

/// Border tab style — `tabs-border`.
pub fn bordered(tabs: Tabs(msg)) -> Tabs(msg) {
  Tabs(..tabs, style_variant: Some("tabs-border"))
}

/// Lifted/raised tab style — `tabs-lift`.
pub fn lifted(tabs: Tabs(msg)) -> Tabs(msg) {
  Tabs(..tabs, style_variant: Some("tabs-lift"))
}

/// Tabs above content (default) — `tabs-top`.
pub fn top(tabs: Tabs(msg)) -> Tabs(msg) {
  Tabs(..tabs, placement: Some("tabs-top"))
}

/// Tabs below content — `tabs-bottom`.
pub fn bottom(tabs: Tabs(msg)) -> Tabs(msg) {
  Tabs(..tabs, placement: Some("tabs-bottom"))
}

/// Sets the tab bar size.
pub fn size(tabs: Tabs(msg), size size: Size) -> Tabs(msg) {
  Tabs(..tabs, size: Some(size))
}

/// Appends Tailwind utility styles.
pub fn style(tabs: Tabs(msg), styles styles: List(Style)) -> Tabs(msg) {
  Tabs(..tabs, styles: list.append(tabs.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  tabs: Tabs(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Tabs(msg) {
  Tabs(..tabs, attrs: list.append(tabs.attrs, attributes))
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

pub fn build(tabs: Tabs(msg)) -> Element(msg) {
  let classes =
    [
      Some("tabs"),
      tabs.style_variant,
      tabs.placement,
      option.map(tabs.size, size_class),
      case style.to_class_string(tabs.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")
  html.div([attribute.class(classes), ..tabs.attrs], tabs.items)
}
