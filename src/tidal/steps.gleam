/// Steps — a progress indicator for multi-step flows.
///
/// ```gleam
/// import tidal/steps
///
/// steps.new()
/// |> steps.items([
///   steps.step("Register")   |> steps.step_primary |> steps.step_build,
///   steps.step("Choose plan")|> steps.step_primary |> steps.step_build,
///   steps.step("Purchase")   |> steps.step_build,
///   steps.step("Receive")    |> steps.step_build,
/// ])
/// |> steps.build
/// ```

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

pub fn step(label: String) -> Step(msg) {
  Step(label: label, color: None, attrs: [])
}

pub fn step_neutral(s: Step(msg)) -> Step(msg) { Step(..s, color: Some("step-neutral")) }
pub fn step_primary(s: Step(msg)) -> Step(msg) { Step(..s, color: Some("step-primary")) }
pub fn step_secondary(s: Step(msg)) -> Step(msg) { Step(..s, color: Some("step-secondary")) }
pub fn step_accent(s: Step(msg)) -> Step(msg) { Step(..s, color: Some("step-accent")) }
pub fn step_info(s: Step(msg)) -> Step(msg) { Step(..s, color: Some("step-info")) }
pub fn step_success(s: Step(msg)) -> Step(msg) { Step(..s, color: Some("step-success")) }
pub fn step_warning(s: Step(msg)) -> Step(msg) { Step(..s, color: Some("step-warning")) }
pub fn step_error(s: Step(msg)) -> Step(msg) { Step(..s, color: Some("step-error")) }

/// Custom icon/content via `data-content` attribute (e.g. `"✓"`, `"★"`).
pub fn step_icon(s: Step(msg), content: String) -> Step(msg) {
  Step(..s, attrs: list.append(s.attrs, [attribute.attribute("data-content", content)]))
}

pub fn step_attrs(s: Step(msg), a: List(Attribute(msg))) -> Step(msg) {
  Step(..s, attrs: list.append(s.attrs, a))
}

pub fn step_build(s: Step(msg)) -> Element(msg) {
  let class =
    [Some("step"), s.color]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  html.li([attribute.class(class), ..s.attrs], [html.text(s.label)])
}

pub opaque type Steps(msg) {
  Steps(
    direction: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    items: List(Element(msg)),
  )
}

pub fn new() -> Steps(msg) {
  Steps(direction: None, styles: [], attrs: [], items: [])
}

pub fn vertical(s: Steps(msg)) -> Steps(msg) { Steps(..s, direction: Some("steps-vertical")) }
pub fn horizontal(s: Steps(msg)) -> Steps(msg) { Steps(..s, direction: Some("steps-horizontal")) }

pub fn style(s: Steps(msg), st: List(Style)) -> Steps(msg) {
  Steps(..s, styles: list.append(s.styles, st))
}

pub fn attrs(s: Steps(msg), a: List(Attribute(msg))) -> Steps(msg) {
  Steps(..s, attrs: list.append(s.attrs, a))
}

pub fn items(s: Steps(msg), is: List(Element(msg))) -> Steps(msg) {
  Steps(..s, items: list.append(s.items, is))
}

pub fn build(s: Steps(msg)) -> Element(msg) {
  let base =
    [Some("steps"), s.direction]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(s.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.ul([attribute.class(class), ..s.attrs], s.items)
}
