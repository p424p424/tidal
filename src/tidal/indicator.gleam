/// Indicator — overlay a badge or notification dot on a corner of another element.
///
/// Set the decorated element with `child(el)`, the overlay badge with `badge(el)`,
/// and optionally adjust placement with `top`/`bottom`/`start`/`end_` etc.
///
/// ```gleam
/// import tidal/indicator
/// import tidal/badge
///
/// indicator.new()
/// |> indicator.child(inbox_button)
/// |> indicator.badge(
///   badge.new() |> badge.label("3") |> badge.primary |> badge.build
/// )
/// |> indicator.top
/// |> indicator.end_
/// |> indicator.build
/// ```

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

/// Create a new indicator wrapper.
pub fn new() -> Indicator(msg) {
  Indicator(child: None, badge: None, h_placement: None, v_placement: None, styles: [], attrs: [])
}

/// The element to decorate.
pub fn child(ind: Indicator(msg), el: Element(msg)) -> Indicator(msg) {
  Indicator(..ind, child: Some(el))
}

/// The badge/dot element overlaid on the corner — wrapped in `indicator-item`.
pub fn badge(ind: Indicator(msg), el: Element(msg)) -> Indicator(msg) {
  Indicator(..ind, badge: Some(el))
}

/// Place badge at the top (default) — `indicator-top`.
pub fn top(ind: Indicator(msg)) -> Indicator(msg) { Indicator(..ind, v_placement: Some("indicator-top")) }
/// Place badge in the middle vertically — `indicator-middle`.
pub fn middle(ind: Indicator(msg)) -> Indicator(msg) { Indicator(..ind, v_placement: Some("indicator-middle")) }
/// Place badge at the bottom — `indicator-bottom`.
pub fn bottom(ind: Indicator(msg)) -> Indicator(msg) { Indicator(..ind, v_placement: Some("indicator-bottom")) }
/// Place badge at the start (left) — `indicator-start`.
pub fn start(ind: Indicator(msg)) -> Indicator(msg) { Indicator(..ind, h_placement: Some("indicator-start")) }
/// Place badge centered horizontally — `indicator-center`.
pub fn center(ind: Indicator(msg)) -> Indicator(msg) { Indicator(..ind, h_placement: Some("indicator-center")) }
/// Place badge at the end (right, default) — `indicator-end`.
pub fn end_(ind: Indicator(msg)) -> Indicator(msg) { Indicator(..ind, h_placement: Some("indicator-end")) }

/// Appends Tailwind utility styles.
pub fn style(ind: Indicator(msg), s: List(Style)) -> Indicator(msg) {
  Indicator(..ind, styles: list.append(ind.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(ind: Indicator(msg), a: List(Attribute(msg))) -> Indicator(msg) {
  Indicator(..ind, attrs: list.append(ind.attrs, a))
}

pub fn build(ind: Indicator(msg)) -> Element(msg) {
  let class = case to_class_string(ind.styles) {
    "" -> "indicator"
    extra -> "indicator " <> extra
  }
  let badge_el = case ind.badge {
    None -> []
    Some(el) ->
      [html.span(
        [attribute.class(
          [Some("indicator-item"), ind.v_placement, ind.h_placement]
          |> list.filter_map(fn(x) { option.to_result(x, Nil) })
          |> string.join(" "),
        )],
        [el],
      )]
  }
  let child_el = case ind.child { None -> [] Some(el) -> [el] }
  html.div([attribute.class(class), ..ind.attrs], list.append(badge_el, child_el))
}
