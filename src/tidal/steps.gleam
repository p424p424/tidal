/// Steps — a progress indicator for multi-step flows.
///
/// ```gleam
/// import tidal/steps
///
/// steps.new()
/// |> steps.items(elements: [
///   steps.step("Register")    |> steps.step_primary |> steps.step_build,
///   steps.step("Choose plan") |> steps.step_primary |> steps.step_build,
///   steps.step("Purchase")    |> steps.step_build,
///   steps.step("Receive")     |> steps.step_build,
/// ])
/// |> steps.build
/// ```
///
/// See also:
/// - DaisyUI steps docs: https://daisyui.com/components/steps/
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Step(msg) {
  Step(label: String, color: Option(String), attrs: List(Attribute(msg)))
}

/// Creates a new step with the given label text.
///
/// ```gleam
/// steps.step("Register") |> steps.step_primary |> steps.step_build
/// ```
pub fn step(label: String) -> Step(msg) {
  Step(label: label, color: None, attrs: [])
}

pub fn step_neutral(step: Step(msg)) -> Step(msg) {
  Step(..step, color: Some("step-neutral"))
}

pub fn step_primary(step: Step(msg)) -> Step(msg) {
  Step(..step, color: Some("step-primary"))
}

pub fn step_secondary(step: Step(msg)) -> Step(msg) {
  Step(..step, color: Some("step-secondary"))
}

pub fn step_accent(step: Step(msg)) -> Step(msg) {
  Step(..step, color: Some("step-accent"))
}

pub fn step_info(step: Step(msg)) -> Step(msg) {
  Step(..step, color: Some("step-info"))
}

pub fn step_success(step: Step(msg)) -> Step(msg) {
  Step(..step, color: Some("step-success"))
}

pub fn step_warning(step: Step(msg)) -> Step(msg) {
  Step(..step, color: Some("step-warning"))
}

pub fn step_error(step: Step(msg)) -> Step(msg) {
  Step(..step, color: Some("step-error"))
}

/// Custom icon/content via `data-content` attribute (e.g. `"✓"`, `"★"`).
pub fn step_icon(step: Step(msg), content content: String) -> Step(msg) {
  Step(
    ..step,
    attrs: list.append(step.attrs, [
      attribute.attribute("data-content", content),
    ]),
  )
}

pub fn step_attrs(
  step: Step(msg),
  attributes attributes: List(Attribute(msg)),
) -> Step(msg) {
  Step(..step, attrs: list.append(step.attrs, attributes))
}

pub fn step_build(step: Step(msg)) -> Element(msg) {
  let class =
    [Some("step"), step.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.li([attribute.class(class), ..step.attrs], [html.text(step.label)])
}

pub opaque type Steps(msg) {
  Steps(
    direction: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

/// Creates a new `Steps` container — `<ul class="steps">`.
///
/// Chain builder functions to configure the steps, then call `build`:
///
/// ```gleam
/// import tidal/steps
///
/// steps.new()
/// |> steps.items(elements: [
///   steps.step("Register") |> steps.step_primary |> steps.step_build,
///   steps.step("Purchase") |> steps.step_build,
/// ])
/// |> steps.build
/// ```
///
/// See also:
/// - DaisyUI steps docs: https://daisyui.com/components/steps/
pub fn new() -> Steps(msg) {
  Steps(direction: None, styles: [], attrs: [], items: [])
}

pub fn vertical(steps: Steps(msg)) -> Steps(msg) {
  Steps(..steps, direction: Some("steps-vertical"))
}

pub fn horizontal(steps: Steps(msg)) -> Steps(msg) {
  Steps(..steps, direction: Some("steps-horizontal"))
}

pub fn style(steps: Steps(msg), styles styles: List(Style)) -> Steps(msg) {
  Steps(..steps, styles: list.append(steps.styles, styles))
}

pub fn attrs(
  steps: Steps(msg),
  attributes attributes: List(Attribute(msg)),
) -> Steps(msg) {
  Steps(..steps, attrs: list.append(steps.attrs, attributes))
}

pub fn items(
  steps: Steps(msg),
  elements elements: List(Element(msg)),
) -> Steps(msg) {
  Steps(..steps, items: list.append(steps.items, elements))
}

pub fn build(steps: Steps(msg)) -> Element(msg) {
  let base =
    [Some("steps"), steps.direction]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(steps.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.ul([attribute.class(class), ..steps.attrs], steps.items)
}
