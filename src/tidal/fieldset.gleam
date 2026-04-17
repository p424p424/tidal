/// Fieldset — form field grouping with legend and optional helper text.
///
/// ```gleam
/// import tidal/fieldset
/// import tidal/input
/// import lustre/element/html
///
/// fieldset.new()
/// |> fieldset.legend(text: "Email address")
/// |> fieldset.label(text: "Work email")
/// |> fieldset.control(elements: [input.new() |> input.build])
/// |> fieldset.alt_label(text: "Optional")
/// |> fieldset.build
/// ```
///
/// See also:
/// - DaisyUI fieldset docs: https://daisyui.com/components/fieldset/
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

/// Creates a new `Fieldset` builder.
///
/// Chain builder functions to configure the fieldset, then call `build`:
///
/// ```gleam
/// import tidal/fieldset
/// import tidal/input
///
/// fieldset.new()
/// |> fieldset.legend(text: "Email address")
/// |> fieldset.label(text: "Work email")
/// |> fieldset.control(elements: [input.new() |> input.build])
/// |> fieldset.build
/// ```
///
/// See also:
/// - DaisyUI fieldset docs: https://daisyui.com/components/fieldset/
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
pub fn legend(fieldset: Fieldset(msg), text text: String) -> Fieldset(msg) {
  Fieldset(..fieldset, legend: Some(text))
}

/// Label shown above the control.
pub fn label(fieldset: Fieldset(msg), text text: String) -> Fieldset(msg) {
  Fieldset(..fieldset, label: Some(text))
}

/// Secondary label shown to the right.
pub fn alt_label(fieldset: Fieldset(msg), text text: String) -> Fieldset(msg) {
  Fieldset(..fieldset, alt_label: Some(text))
}

/// The form control(s) inside the fieldset.
pub fn control(
  fieldset: Fieldset(msg),
  elements elements: List(Element(msg)),
) -> Fieldset(msg) {
  Fieldset(..fieldset, control: elements)
}

pub fn style(
  fieldset: Fieldset(msg),
  styles styles: List(Style),
) -> Fieldset(msg) {
  Fieldset(..fieldset, styles: list.append(fieldset.styles, styles))
}

pub fn attrs(
  fieldset: Fieldset(msg),
  attributes attributes: List(Attribute(msg)),
) -> Fieldset(msg) {
  Fieldset(..fieldset, attrs: list.append(fieldset.attrs, attributes))
}

pub fn build(fieldset: Fieldset(msg)) -> Element(msg) {
  let class = case to_class_string(fieldset.styles) {
    "" -> "fieldset"
    extra -> "fieldset " <> extra
  }

  let legend_el = case fieldset.legend {
    None -> []
    Some(t) -> [
      html.legend([attribute.class("fieldset-legend")], [html.text(t)]),
    ]
  }

  let label_content = case fieldset.label, fieldset.alt_label {
    None, None -> []
    l, r -> [
      html.label([attribute.class("label")], [
        case l {
          None -> html.text("")
          Some(t) -> html.span([], [html.text(t)])
        },
        case r {
          None -> html.text("")
          Some(t) ->
            html.span([attribute.class("label-text-alt")], [html.text(t)])
        },
      ]),
    ]
  }

  html.fieldset(
    [attribute.class(class), ..fieldset.attrs],
    list.flatten([legend_el, label_content, fieldset.control]),
  )
}
