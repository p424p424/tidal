/// Fieldset — form field grouping with legend and optional helper text.
///
/// ```gleam
/// import tidal/fieldset
/// import tidal/input
/// import lustre/element/html
///
/// fieldset.new()
/// |> fieldset.legend("Email address")
/// |> fieldset.label("Work email")
/// |> fieldset.control([input.new() |> input.build])
/// |> fieldset.alt_label("Optional")
/// |> fieldset.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Fieldset(msg) {
  Fieldset(
    legend: Option(String),
    label: Option(String),
    alt_label: Option(String),
    control: List(Element(msg)),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Fieldset(msg) {
  Fieldset(
    legend: None,
    label: None,
    alt_label: None,
    control: [],
    styles: [],
    attrs: [],
  )
}

/// The `<legend>` text shown at the top of the fieldset.
pub fn legend(f: Fieldset(msg), text: String) -> Fieldset(msg) {
  Fieldset(..f, legend: Some(text))
}

/// Label shown above the control.
pub fn label(f: Fieldset(msg), text: String) -> Fieldset(msg) {
  Fieldset(..f, label: Some(text))
}

/// Secondary label shown to the right.
pub fn alt_label(f: Fieldset(msg), text: String) -> Fieldset(msg) {
  Fieldset(..f, alt_label: Some(text))
}

/// The form control(s) inside the fieldset.
pub fn control(f: Fieldset(msg), children: List(Element(msg))) -> Fieldset(msg) {
  Fieldset(..f, control: children)
}

pub fn style(f: Fieldset(msg), s: List(Style)) -> Fieldset(msg) {
  Fieldset(..f, styles: list.append(f.styles, s))
}

pub fn attrs(f: Fieldset(msg), a: List(Attribute(msg))) -> Fieldset(msg) {
  Fieldset(..f, attrs: list.append(f.attrs, a))
}

pub fn build(f: Fieldset(msg)) -> Element(msg) {
  let class = case to_class_string(f.styles) {
    "" -> "fieldset"
    extra -> "fieldset " <> extra
  }

  let legend_el = case f.legend {
    None -> []
    Some(t) -> [html.legend([attribute.class("fieldset-legend")], [html.text(t)])]
  }

  let label_content = case f.label, f.alt_label {
    None, None -> []
    l, r ->
      [
        html.label(
          [attribute.class("label")],
          [
            case l {
              None -> html.text("")
              Some(t) -> html.span([], [html.text(t)])
            },
            case r {
              None -> html.text("")
              Some(t) ->
                html.span([attribute.class("label-text-alt")], [html.text(t)])
            },
          ],
        ),
      ]
  }

  html.fieldset(
    [attribute.class(class), ..f.attrs],
    list.flatten([legend_el, label_content, f.control]),
  )
}
