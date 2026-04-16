/// Collapse / accordion component — renders a DaisyUI `collapse`.
///
/// ```gleam
/// import tidal/collapse
///
/// collapse.new()
/// |> collapse.title("What is Tidal?")
/// |> collapse.body([
///   text.new("Tidal is a Gleam UI package built on DaisyUI and Lustre.")
///   |> text.build,
/// ])
/// |> collapse.open(model.faq_open)
/// |> collapse.build
/// ```
///
/// For an accordion group (only one open at a time), use `accordion/2` with
/// a shared group name:
///
/// ```gleam
/// collapse.new()
/// |> collapse.accordion("faq")
/// |> collapse.title("Question 1")
/// |> collapse.body([answer_1])
/// |> collapse.build
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

pub type CollapseStyle {
  Default
  Arrow
  Plus
}

pub opaque type Collapse(msg) {
  Collapse(
    title: String,
    body: List(Element(msg)),
    style_: CollapseStyle,
    open: Bool,
    force: Option(String),
    accordion: Option(String),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

/// Create a new collapse — `<div class="collapse">`.
pub fn new() -> Collapse(msg) {
  Collapse(
    title: "",
    body: [],
    style_: Default,
    open: False,
    force: None,
    accordion: None,
    styles: [],
    attrs: [],
  )
}

/// Sets the clickable title / trigger text.
pub fn title(c: Collapse(msg), text: String) -> Collapse(msg) {
  Collapse(..c, title: text)
}

/// Sets the body content. May be called multiple times — content accumulates.
pub fn body(c: Collapse(msg), els: List(Element(msg))) -> Collapse(msg) {
  Collapse(..c, body: list.append(c.body, els))
}

/// Shows an arrow indicator on the title (`collapse-arrow`).
pub fn arrow(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, style_: Arrow)
}

/// Shows a plus/minus indicator on the title (`collapse-plus`).
pub fn plus(c: Collapse(msg)) -> Collapse(msg) {
  Collapse(..c, style_: Plus)
}

/// Controls the checkbox open/closed state (standard toggle approach).
pub fn open(c: Collapse(msg), is_open: Bool) -> Collapse(msg) {
  Collapse(..c, open: is_open)
}

/// Permanently expand via `collapse-open` CSS class (no checkbox needed).
pub fn force_open(c: Collapse(msg)) -> Collapse(msg) { Collapse(..c, force: Some("collapse-open")) }
/// Permanently collapse via `collapse-close` CSS class (no checkbox needed).
pub fn force_close(c: Collapse(msg)) -> Collapse(msg) { Collapse(..c, force: Some("collapse-close")) }

/// Groups this collapse into a radio-button accordion with the given name.
/// Only one collapse in the group will be open at a time.
pub fn accordion(c: Collapse(msg), name: String) -> Collapse(msg) {
  Collapse(..c, accordion: Some(name))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(c: Collapse(msg), s: List(Style)) -> Collapse(msg) {
  Collapse(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(c: Collapse(msg), a: List(attribute.Attribute(msg))) -> Collapse(msg) {
  Collapse(..c, attrs: list.append(c.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn style_class(s: CollapseStyle) -> String {
  case s {
    Default -> ""
    Arrow -> "collapse-arrow"
    Plus -> "collapse-plus"
  }
}

pub fn build(c: Collapse(msg)) -> Element(msg) {
  let classes =
    [
      Some("collapse"),
      case style_class(c.style_) { "" -> None s -> Some(s) },
      c.force,
      case style.to_class_string(c.styles) { "" -> None s -> Some(s) },
    ]
    |> option.values
    |> list.filter(fn(cl) { cl != "" })
    |> string.join(" ")

  let title_el =
    html.div([attribute.class("collapse-title font-semibold")], [
      element.text(c.title),
    ])

  let body_el =
    html.div([attribute.class("collapse-content")], c.body)

  case c.accordion {
    Some(name) -> {
      let input =
        html.input([
          attribute.type_("radio"),
          attribute.name(name),
          attribute.checked(c.open),
        ])
      html.div([attribute.class(classes), ..c.attrs], [input, title_el, body_el])
    }
    None -> {
      let checked_attr = case c.open {
        True -> [attribute.checked(True)]
        False -> []
      }
      let input =
        html.input(list.append([attribute.type_("checkbox")], checked_attr))
      html.div([attribute.class(classes), ..c.attrs], [input, title_el, body_el])
    }
  }
}
