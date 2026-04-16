/// Dropdown component — renders a DaisyUI `dropdown` wrapping a trigger and content.
///
/// ```gleam
/// import tidal/dropdown
/// import tidal/button
/// import tidal/menu
/// import tidal/variant
///
/// dropdown.new()
/// |> dropdown.trigger(
///   button.new("Options") |> button.variant(variant.Ghost) |> button.build,
/// )
/// |> dropdown.content([
///   menu.new()
///   |> menu.items([
///     menu.link("Edit", "/edit", False),
///     menu.link("Delete", "/delete", False),
///   ])
///   |> menu.build,
/// ])
/// |> dropdown.position(dropdown.End)
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

pub type DropdownPosition {
  Start
  End
  Top
  TopStart
  TopEnd
  Bottom
  BottomStart
  BottomEnd
  Left
  LeftStart
  LeftEnd
  Right
  RightStart
  RightEnd
}

pub opaque type Dropdown(msg) {
  Dropdown(
    trigger: Option(Element(msg)),
    content: List(Element(msg)),
    position: Option(DropdownPosition),
    hover: Bool,
    open: Bool,
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
    position: None,
    hover: False,
    open: False,
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

/// Sets the opening direction.
pub fn position(d: Dropdown(msg), p: DropdownPosition) -> Dropdown(msg) {
  Dropdown(..d, position: Some(p))
}

/// Opens the dropdown on hover instead of click.
pub fn hover(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, hover: True)
}

/// Forces the dropdown open.
pub fn open(d: Dropdown(msg)) -> Dropdown(msg) {
  Dropdown(..d, open: True)
}

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

fn position_class(p: DropdownPosition) -> String {
  case p {
    Start -> "dropdown-start"
    End -> "dropdown-end"
    Top -> "dropdown-top"
    TopStart -> "dropdown-top dropdown-start"
    TopEnd -> "dropdown-top dropdown-end"
    Bottom -> "dropdown-bottom"
    BottomStart -> "dropdown-bottom dropdown-start"
    BottomEnd -> "dropdown-bottom dropdown-end"
    Left -> "dropdown-left"
    LeftStart -> "dropdown-left dropdown-start"
    LeftEnd -> "dropdown-left dropdown-end"
    Right -> "dropdown-right"
    RightStart -> "dropdown-right dropdown-start"
    RightEnd -> "dropdown-right dropdown-end"
  }
}

pub fn build(d: Dropdown(msg)) -> Element(msg) {
  let classes =
    [
      Some("dropdown"),
      option.map(d.position, position_class),
      case d.hover { True -> Some("dropdown-hover") False -> None },
      case d.open { True -> Some("dropdown-open") False -> None },
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
