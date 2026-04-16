/// Dropdown component — renders a DaisyUI `dropdown` wrapping a trigger and content.
///
/// ```gleam
/// import tidal/dropdown
/// import tidal/button
/// import tidal/menu
///
/// dropdown.new()
/// |> dropdown.trigger(
///   button.new() |> button.label("Options") |> button.ghost |> button.build,
/// )
/// |> dropdown.content([
///   menu.new()
///   |> menu.items([
///     menu.item_link("Edit", "/edit"),
///     menu.item_link("Delete", "/delete"),
///   ])
///   |> menu.build,
/// ])
/// |> dropdown.bottom
/// |> dropdown.align_end
/// |> dropdown.build
/// ```

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
pub fn trigger(d: Dropdown(msg), el: Element(msg)) -> Dropdown(msg) {
  Dropdown(..d, trigger: Some(el))
}

/// Sets the dropdown content. May be called multiple times — content accumulates.
pub fn content(d: Dropdown(msg), els: List(Element(msg))) -> Dropdown(msg) {
  Dropdown(..d, content: list.append(d.content, els))
}

/// Places dropdown above the trigger — `dropdown-top`.
pub fn top(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, placement: Some("dropdown-top")) }
/// Places dropdown below the trigger — `dropdown-bottom`.
pub fn bottom(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, placement: Some("dropdown-bottom")) }
/// Places dropdown to the left — `dropdown-left`.
pub fn left(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, placement: Some("dropdown-left")) }
/// Places dropdown to the right — `dropdown-right`.
pub fn right(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, placement: Some("dropdown-right")) }

/// Aligns dropdown to the start — `dropdown-start`.
pub fn align_start(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, alignment: Some("dropdown-start")) }
/// Aligns dropdown to the end — `dropdown-end`.
pub fn align_end(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, alignment: Some("dropdown-end")) }
/// Centers the dropdown — `dropdown-center`.
pub fn align_center(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, alignment: Some("dropdown-center")) }

/// Opens the dropdown on hover instead of click.
pub fn hover(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, hover: True) }

/// Forces the dropdown open — `dropdown-open`.
pub fn force_open(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, force: Some("dropdown-open")) }
/// Forces the dropdown closed — `dropdown-close`.
pub fn force_close(d: Dropdown(msg)) -> Dropdown(msg) { Dropdown(..d, force: Some("dropdown-close")) }

/// Appends presentation styles. May be called multiple times.
pub fn style(d: Dropdown(msg), s: List(Style)) -> Dropdown(msg) {
  Dropdown(..d, styles: list.append(d.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  d: Dropdown(msg),
  a: List(attribute.Attribute(msg)),
) -> Dropdown(msg) {
  Dropdown(..d, attrs: list.append(d.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(d: Dropdown(msg)) -> Element(msg) {
  let classes =
    [
      Some("dropdown"),
      d.placement,
      d.alignment,
      case d.hover { True -> Some("dropdown-hover") False -> None },
      d.force,
      case style.to_class_string(d.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let trigger_el = case d.trigger {
    None -> []
    Some(el) -> [el]
  }

  let content_el = case d.content {
    [] -> []
    els -> [
      html.div(
        [attribute.class("dropdown-content z-10")],
        els,
      ),
    ]
  }

  html.div(
    [attribute.class(classes), ..d.attrs],
    list.append(trigger_el, content_el),
  )
}
