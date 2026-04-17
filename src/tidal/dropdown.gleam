/// Dropdown component — renders a DaisyUI `dropdown` wrapping a trigger and content.
///
/// ```gleam
/// import tidal/dropdown
/// import tidal/button
/// import tidal/menu
///
/// dropdown.new()
/// |> dropdown.trigger(element: button.new() |> button.label(text: "Options") |> button.ghost |> button.build)
/// |> dropdown.content(elements: [
///   menu.new()
///   |> menu.items(elements: [
///     menu.item_link("Edit", "/edit"),
///     menu.item_link("Delete", "/delete"),
///   ])
///   |> menu.build,
/// ])
/// |> dropdown.bottom
/// |> dropdown.align_end
/// |> dropdown.build
/// ```
///
/// See also:
/// - DaisyUI dropdown docs: https://daisyui.com/components/dropdown/
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------

pub opaque type Dropdown(msg) {
  Dropdown(
    trigger: Option(Element(msg)),
    content: List(Element(msg)),
    placement: Option(String),
    alignment: Option(String),
    hover: Bool,
    force: Option(String),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

/// Creates a new `Dropdown` builder with all options at their defaults.
///
/// Chain builder functions to configure the dropdown, then call `build`:
///
/// ```gleam
/// import tidal/dropdown
///
/// dropdown.new()
/// |> dropdown.trigger(element: trigger_btn)
/// |> dropdown.content(elements: [menu_el])
/// |> dropdown.bottom
/// |> dropdown.align_end
/// |> dropdown.build
/// ```
///
/// See also:
/// - DaisyUI dropdown docs: https://daisyui.com/components/dropdown/
pub fn new() -> Dropdown(msg) {
  Dropdown(
    trigger: None,
    content: [],
    placement: None,
    alignment: None,
    hover: False,
    force: None,
    styles: [],
    attrs: [],
  )
}

/// Sets the trigger element (the element that opens the dropdown).
pub fn trigger(
  dropdown: Dropdown(msg),
  element element: Element(msg),
) -> Dropdown(msg) {
  Dropdown(..dropdown, trigger: Some(element))
}

/// Sets the dropdown content. May be called multiple times — content accumulates.
pub fn content(
  dropdown: Dropdown(msg),
  elements elements: List(Element(msg)),
) -> Dropdown(msg) {
  Dropdown(..dropdown, content: list.append(dropdown.content, elements))
}

/// Places dropdown above the trigger — `dropdown-top`.
pub fn top(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, placement: Some("dropdown-top"))
}

/// Places dropdown below the trigger — `dropdown-bottom`.
pub fn bottom(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, placement: Some("dropdown-bottom"))
}

/// Places dropdown to the left — `dropdown-left`.
pub fn left(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, placement: Some("dropdown-left"))
}

/// Places dropdown to the right — `dropdown-right`.
pub fn right(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, placement: Some("dropdown-right"))
}

/// Aligns dropdown to the start — `dropdown-start`.
pub fn align_start(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, alignment: Some("dropdown-start"))
}

/// Aligns dropdown to the end — `dropdown-end`.
pub fn align_end(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, alignment: Some("dropdown-end"))
}

/// Centers the dropdown — `dropdown-center`.
pub fn align_center(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, alignment: Some("dropdown-center"))
}

/// Opens the dropdown on hover instead of click.
pub fn hover(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, hover: True)
}

/// Forces the dropdown open — `dropdown-open`.
pub fn force_open(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, force: Some("dropdown-open"))
}

/// Forces the dropdown closed — `dropdown-close`.
pub fn force_close(dropdown: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..dropdown, force: Some("dropdown-close"))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(
  dropdown: Dropdown(msg),
  styles styles: List(Style),
) -> Dropdown(msg) {
  Dropdown(..dropdown, styles: list.append(dropdown.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  dropdown: Dropdown(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Dropdown(msg) {
  Dropdown(..dropdown, attrs: list.append(dropdown.attrs, attributes))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(dropdown: Dropdown(msg)) -> Element(msg) {
  let classes =
    [
      Some("dropdown"),
      dropdown.placement,
      dropdown.alignment,
      case dropdown.hover {
        True -> Some("dropdown-hover")
        False -> None
      },
      dropdown.force,
      case style.to_class_string(dropdown.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let trigger_el = case dropdown.trigger {
    None -> []
    Some(el) -> [el]
  }

  let content_el = case dropdown.content {
    [] -> []
    els -> [
      html.div([attribute.class("dropdown-content z-10")], els),
    ]
  }

  html.div(
    [attribute.class(classes), ..dropdown.attrs],
    list.append(trigger_el, content_el),
  )
}
