/// Collapse / accordion component — renders a DaisyUI `collapse`.
///
/// ```gleam
/// import tidal/collapse
///
/// collapse.new()
/// |> collapse.title(text: "What is Tidal?")
/// |> collapse.body(elements: [
///   text.new("Tidal is a Gleam UI package built on DaisyUI and Lustre.")
///   |> text.build,
/// ])
/// |> collapse.open(to: model.faq_open)
/// |> collapse.build
/// ```
///
/// For an accordion group (only one open at a time), use `accordion/2` with
/// a shared group name:
///
/// ```gleam
/// collapse.new()
/// |> collapse.accordion(name: "faq")
/// |> collapse.title(text: "Question 1")
/// |> collapse.body(elements: [answer_1])
/// |> collapse.build
/// ```
///
/// See also:
/// - DaisyUI collapse docs: https://daisyui.com/components/collapse/
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

/// Creates a new `Collapse` — `<div class="collapse">`.
///
/// Chain builder functions to configure the collapse, then call `build`:
///
/// ```gleam
/// import tidal/collapse
///
/// collapse.new()
/// |> collapse.title(text: "What is Tidal?")
/// |> collapse.body(elements: [answer_el])
/// |> collapse.open(to: model.faq_open)
/// |> collapse.build
/// ```
///
/// See also:
/// - DaisyUI collapse docs: https://daisyui.com/components/collapse/
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
pub fn title(collapse: Collapse(msg), text text: String) -> Collapse(msg) {
  Collapse(..collapse, title: text)
}

/// Sets the body content. May be called multiple times — content accumulates.
pub fn body(
  collapse: Collapse(msg),
  elements elements: List(Element(msg)),
) -> Collapse(msg) {
  Collapse(..collapse, body: list.append(collapse.body, elements))
}

/// Shows an arrow indicator on the title (`collapse-arrow`).
pub fn arrow(collapse: Collapse(msg)) -> Collapse(msg) {
  Collapse(..collapse, style_: Arrow)
}

/// Shows a plus/minus indicator on the title (`collapse-plus`).
pub fn plus(collapse: Collapse(msg)) -> Collapse(msg) {
  Collapse(..collapse, style_: Plus)
}

/// Controls the checkbox open/closed state (standard toggle approach).
pub fn open(collapse: Collapse(msg), to is_open: Bool) -> Collapse(msg) {
  Collapse(..collapse, open: is_open)
}

/// Permanently expand via `collapse-open` CSS class (no checkbox needed).
pub fn force_open(collapse: Collapse(msg)) -> Collapse(msg) {
  Collapse(..collapse, force: Some("collapse-open"))
}

/// Permanently collapse via `collapse-close` CSS class (no checkbox needed).
pub fn force_close(collapse: Collapse(msg)) -> Collapse(msg) {
  Collapse(..collapse, force: Some("collapse-close"))
}

/// Groups this collapse into a radio-button accordion with the given name.
/// Only one collapse in the group will be open at a time.
pub fn accordion(collapse: Collapse(msg), name name: String) -> Collapse(msg) {
  Collapse(..collapse, accordion: Some(name))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(
  collapse: Collapse(msg),
  styles styles: List(Style),
) -> Collapse(msg) {
  Collapse(..collapse, styles: list.append(collapse.styles, styles))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(
  collapse: Collapse(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Collapse(msg) {
  Collapse(..collapse, attrs: list.append(collapse.attrs, attributes))
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

pub fn build(collapse: Collapse(msg)) -> Element(msg) {
  let classes =
    [
      Some("collapse"),
      case style_class(collapse.style_) {
        "" -> None
        s -> Some(s)
      },
      collapse.force,
      case style.to_class_string(collapse.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(cl) { cl != "" })
    |> string.join(" ")

  let title_el =
    html.div([attribute.class("collapse-title font-semibold")], [
      element.text(collapse.title),
    ])

  let body_el = html.div([attribute.class("collapse-content")], collapse.body)

  case collapse.accordion {
    Some(name) -> {
      let input =
        html.input([
          attribute.type_("radio"),
          attribute.name(name),
          attribute.checked(collapse.open),
        ])
      html.div([attribute.class(classes), ..collapse.attrs], [
        input,
        title_el,
        body_el,
      ])
    }
    None -> {
      let checked_attr = case collapse.open {
        True -> [attribute.checked(True)]
        False -> []
      }
      let input =
        html.input(list.append([attribute.type_("checkbox")], checked_attr))
      html.div([attribute.class(classes), ..collapse.attrs], [
        input,
        title_el,
        body_el,
      ])
    }
  }
}
