/// Indicator — overlay a badge or notification dot on a corner of another element.
///
/// Set the decorated element with `child(element:)`, the overlay badge with `badge(element:)`,
/// and optionally adjust placement with `top`/`bottom`/`start`/`end_` etc.
///
/// ```gleam
/// import tidal/indicator
/// import tidal/badge
///
/// indicator.new()
/// |> indicator.child(element: inbox_button)
/// |> indicator.badge(element:
///   badge.new() |> badge.label(text: "3") |> badge.primary |> badge.build
/// )
/// |> indicator.top
/// |> indicator.end_
/// |> indicator.build
/// ```
///
/// See also:
/// - DaisyUI indicator docs: https://daisyui.com/components/indicator/
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Indicator(msg) {
  Indicator(
    child: Option(Element(msg)),
    badge: Option(Element(msg)),
    h_placement: Option(String),
    v_placement: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

/// Creates a new `Indicator` wrapper.
///
/// Chain builder functions to configure the indicator, then call `build`:
///
/// ```gleam
/// import tidal/indicator
///
/// indicator.new()
/// |> indicator.child(element: target_el)
/// |> indicator.badge(element: badge_el)
/// |> indicator.top
/// |> indicator.end_
/// |> indicator.build
/// ```
///
/// See also:
/// - DaisyUI indicator docs: https://daisyui.com/components/indicator/
pub fn new() -> Indicator(msg) {
  Indicator(
    child: None,
    badge: None,
    h_placement: None,
    v_placement: None,
    styles: [],
    attrs: [],
  )
}

/// The element to decorate.
pub fn child(
  indicator: Indicator(msg),
  element element: Element(msg),
) -> Indicator(msg) {
  Indicator(..indicator, child: Some(element))
}

/// The badge/dot element overlaid on the corner — wrapped in `indicator-item`.
pub fn badge(
  indicator: Indicator(msg),
  element element: Element(msg),
) -> Indicator(msg) {
  Indicator(..indicator, badge: Some(element))
}

/// Place badge at the top (default) — `indicator-top`.
pub fn top(indicator: Indicator(msg)) -> Indicator(msg) {
  Indicator(..indicator, v_placement: Some("indicator-top"))
}

/// Place badge in the middle vertically — `indicator-middle`.
pub fn middle(indicator: Indicator(msg)) -> Indicator(msg) {
  Indicator(..indicator, v_placement: Some("indicator-middle"))
}

/// Place badge at the bottom — `indicator-bottom`.
pub fn bottom(indicator: Indicator(msg)) -> Indicator(msg) {
  Indicator(..indicator, v_placement: Some("indicator-bottom"))
}

/// Place badge at the start (left) — `indicator-start`.
pub fn start(indicator: Indicator(msg)) -> Indicator(msg) {
  Indicator(..indicator, h_placement: Some("indicator-start"))
}

/// Place badge centered horizontally — `indicator-center`.
pub fn center(indicator: Indicator(msg)) -> Indicator(msg) {
  Indicator(..indicator, h_placement: Some("indicator-center"))
}

/// Place badge at the end (right, default) — `indicator-end`.
pub fn end_(indicator: Indicator(msg)) -> Indicator(msg) {
  Indicator(..indicator, h_placement: Some("indicator-end"))
}

/// Appends Tailwind utility styles.
pub fn style(
  indicator: Indicator(msg),
  styles styles: List(Style),
) -> Indicator(msg) {
  Indicator(..indicator, styles: list.append(indicator.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  indicator: Indicator(msg),
  attributes attributes: List(Attribute(msg)),
) -> Indicator(msg) {
  Indicator(..indicator, attrs: list.append(indicator.attrs, attributes))
}

pub fn build(indicator: Indicator(msg)) -> Element(msg) {
  let class = case to_class_string(indicator.styles) {
    "" -> "indicator"
    extra -> "indicator " <> extra
  }
  let badge_el = case indicator.badge {
    None -> []
    Some(el) -> [
      html.span(
        [
          attribute.class(
            [
              Some("indicator-item"),
              indicator.v_placement,
              indicator.h_placement,
            ]
            |> list.filter_map(fn(x) { option.to_result(x, Nil) })
            |> string.join(" "),
          ),
        ],
        [el],
      ),
    ]
  }
  let child_el = case indicator.child {
    None -> []
    Some(el) -> [el]
  }
  html.div(
    [attribute.class(class), ..indicator.attrs],
    list.append(badge_el, child_el),
  )
}
