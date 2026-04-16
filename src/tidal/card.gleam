/// Card — content container with optional image, title, body, and actions.
///
/// ```gleam
/// import tidal/card
/// import tidal/size
///
/// card.new()
/// |> card.image("/hero.jpg", "Product photo")
/// |> card.title("Product name")
/// |> card.body([html.p([], [html.text("Description")])])
/// |> card.actions([buy_btn])
/// |> card.border
/// |> card.size(size.Md)
/// |> card.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/size.{type Size}
import tidal/style.{type Style}

pub opaque type Card(msg) {
  Card(
    title: Option(String),
    body: List(Element(msg)),
    actions: List(Element(msg)),
    image_src: Option(String),
    image_alt: String,
    image_full: Bool,
    border: Bool,
    dash: Bool,
    side: Bool,
    size: Option(Size),
    color: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Card(msg) {
  Card(
    title: None,
    body: [],
    actions: [],
    image_src: None,
    image_alt: "",
    image_full: False,
    border: False,
    dash: False,
    side: False,
    size: None,
    color: None,
    styles: [],
    attrs: [],
  )
}

/// Card heading text rendered as `<h2 class="card-title">`.
pub fn title(c: Card(msg), text: String) -> Card(msg) { Card(..c, title: Some(text)) }

/// Card body content. May be called multiple times — accumulates.
pub fn body(c: Card(msg), els: List(Element(msg))) -> Card(msg) {
  Card(..c, body: list.append(c.body, els))
}

/// Action elements (e.g. buttons) in the card footer.
pub fn actions(c: Card(msg), els: List(Element(msg))) -> Card(msg) {
  Card(..c, actions: list.append(c.actions, els))
}

/// Top image (`<figure>`).
pub fn image(c: Card(msg), src: String, alt: String) -> Card(msg) {
  Card(..c, image_src: Some(src), image_alt: alt)
}

/// Image fills the full card as a background.
pub fn image_full(c: Card(msg)) -> Card(msg) { Card(..c, image_full: True) }

/// Visible border around the card.
pub fn border(c: Card(msg)) -> Card(msg) { Card(..c, border: True) }

/// Dashed border.
pub fn dash(c: Card(msg)) -> Card(msg) { Card(..c, dash: True) }

/// Horizontal (side-by-side) card layout.
pub fn side(c: Card(msg)) -> Card(msg) { Card(..c, side: True) }

/// Sets card padding/size.
pub fn size(c: Card(msg), s: Size) -> Card(msg) { Card(..c, size: Some(s)) }

pub fn primary(c: Card(msg)) -> Card(msg) { Card(..c, color: Some("bg-primary text-primary-content")) }
pub fn secondary(c: Card(msg)) -> Card(msg) { Card(..c, color: Some("bg-secondary text-secondary-content")) }
pub fn accent(c: Card(msg)) -> Card(msg) { Card(..c, color: Some("bg-accent text-accent-content")) }
pub fn neutral(c: Card(msg)) -> Card(msg) { Card(..c, color: Some("bg-neutral text-neutral-content")) }
pub fn info(c: Card(msg)) -> Card(msg) { Card(..c, color: Some("bg-info text-info-content")) }
pub fn success(c: Card(msg)) -> Card(msg) { Card(..c, color: Some("bg-success text-success-content")) }
pub fn warning(c: Card(msg)) -> Card(msg) { Card(..c, color: Some("bg-warning text-warning-content")) }
pub fn error(c: Card(msg)) -> Card(msg) { Card(..c, color: Some("bg-error text-error-content")) }

/// Appends Tailwind utility styles.
pub fn style(c: Card(msg), s: List(Style)) -> Card(msg) {
  Card(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes.
pub fn attrs(c: Card(msg), a: List(Attribute(msg))) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, a))
}

pub fn on_click(c: Card(msg), msg: msg) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, [event.on_click(msg)]))
}
pub fn on_mouse_enter(c: Card(msg), msg: msg) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, [event.on_mouse_enter(msg)]))
}
pub fn on_mouse_leave(c: Card(msg), msg: msg) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, [event.on_mouse_leave(msg)]))
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "card-xs"
    size.Sm -> "card-sm"
    size.Md -> ""
    size.Lg -> "card-lg"
    size.Xl -> "card-xl"
  }
}

pub fn build(c: Card(msg)) -> Element(msg) {
  let classes =
    [
      Some("card"),
      case c.image_full { True -> Some("image-full") False -> None },
      case c.border { True -> Some("card-border") False -> None },
      case c.dash { True -> Some("card-dash") False -> None },
      case c.side { True -> Some("card-side") False -> None },
      option.map(c.size, size_class),
      c.color,
      case style.to_class_string(c.styles) { "" -> None s -> Some(s) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(cl) { cl != "" })
    |> string.join(" ")

  let figure_el = case c.image_src {
    None -> []
    Some(src) -> [html.figure([], [html.img([attribute.src(src), attribute.alt(c.image_alt)])])]
  }
  let title_el = case c.title {
    None -> []
    Some(t) -> [html.h2([attribute.class("card-title")], [element.text(t)])]
  }
  let actions_el = case c.actions {
    [] -> []
    els -> [html.div([attribute.class("card-actions justify-end")], els)]
  }
  let body_el = html.div([attribute.class("card-body")], list.flatten([title_el, c.body, actions_el]))
  html.div([attribute.class(classes), ..c.attrs], list.append(figure_el, [body_el]))
}
