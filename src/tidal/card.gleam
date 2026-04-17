/// Card — content container with optional image, title, body, and actions.
///
/// Creates a new `Card` builder with all options at their defaults.
///
/// Chain builder functions to configure the card, then call `build`:
///
/// ```gleam
/// import tidal/card
/// import tidal/size
///
/// card.new()
/// |> card.image(src: "/hero.jpg", alt: "Product photo")
/// |> card.title(text: "Product name")
/// |> card.body(elements: [html.p([], [html.text("Description")])])
/// |> card.actions(elements: [buy_btn])
/// |> card.border
/// |> card.size(size: size.Md)
/// |> card.build
/// ```
///
/// See also:
/// - DaisyUI card docs: https://daisyui.com/components/card/
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

/// Creates a new `Card` builder with all options at their defaults.
///
/// Chain builder functions to configure the card, then call `build`:
///
/// ```gleam
/// import tidal/card
/// import tidal/size
///
/// card.new()
/// |> card.image(src: "/hero.jpg", alt: "Product photo")
/// |> card.title(text: "Product name")
/// |> card.body(elements: [html.p([], [html.text("Description")])])
/// |> card.actions(elements: [buy_btn])
/// |> card.border
/// |> card.size(size: size.Md)
/// |> card.build
/// ```
///
/// See also:
/// - DaisyUI card docs: https://daisyui.com/components/card/
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
pub fn title(card: Card(msg), text text: String) -> Card(msg) {
  Card(..card, title: Some(text))
}

/// Card body content. May be called multiple times — accumulates.
pub fn body(card: Card(msg), elements elements: List(Element(msg))) -> Card(msg) {
  Card(..card, body: list.append(card.body, elements))
}

/// Action elements (e.g. buttons) in the card footer.
pub fn actions(
  card: Card(msg),
  elements elements: List(Element(msg)),
) -> Card(msg) {
  Card(..card, actions: list.append(card.actions, elements))
}

/// Top image (`<figure>`).
pub fn image(card: Card(msg), src src: String, alt alt: String) -> Card(msg) {
  Card(..card, image_src: Some(src), image_alt: alt)
}

/// Image fills the full card as a background.
pub fn image_full(card: Card(msg)) -> Card(msg) {
  Card(..card, image_full: True)
}

/// Visible border around the card.
pub fn border(card: Card(msg)) -> Card(msg) {
  Card(..card, border: True)
}

/// Dashed border.
pub fn dash(card: Card(msg)) -> Card(msg) {
  Card(..card, dash: True)
}

/// Horizontal (side-by-side) card layout.
pub fn side(card: Card(msg)) -> Card(msg) {
  Card(..card, side: True)
}

/// Sets card padding/size.
pub fn size(card: Card(msg), size size: Size) -> Card(msg) {
  Card(..card, size: Some(size))
}

pub fn primary(card: Card(msg)) -> Card(msg) {
  Card(..card, color: Some("bg-primary text-primary-content"))
}

pub fn secondary(card: Card(msg)) -> Card(msg) {
  Card(..card, color: Some("bg-secondary text-secondary-content"))
}

pub fn accent(card: Card(msg)) -> Card(msg) {
  Card(..card, color: Some("bg-accent text-accent-content"))
}

pub fn neutral(card: Card(msg)) -> Card(msg) {
  Card(..card, color: Some("bg-neutral text-neutral-content"))
}

pub fn info(card: Card(msg)) -> Card(msg) {
  Card(..card, color: Some("bg-info text-info-content"))
}

pub fn success(card: Card(msg)) -> Card(msg) {
  Card(..card, color: Some("bg-success text-success-content"))
}

pub fn warning(card: Card(msg)) -> Card(msg) {
  Card(..card, color: Some("bg-warning text-warning-content"))
}

pub fn error(card: Card(msg)) -> Card(msg) {
  Card(..card, color: Some("bg-error text-error-content"))
}

/// Appends Tailwind utility styles.
pub fn style(card: Card(msg), styles styles: List(Style)) -> Card(msg) {
  Card(..card, styles: list.append(card.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  card: Card(msg),
  attributes attributes: List(Attribute(msg)),
) -> Card(msg) {
  Card(..card, attrs: list.append(card.attrs, attributes))
}

pub fn on_click(card: Card(msg), msg: msg) -> Card(msg) {
  Card(..card, attrs: list.append(card.attrs, [event.on_click(msg)]))
}

pub fn on_mouse_enter(card: Card(msg), msg: msg) -> Card(msg) {
  Card(..card, attrs: list.append(card.attrs, [event.on_mouse_enter(msg)]))
}

pub fn on_mouse_leave(card: Card(msg), msg: msg) -> Card(msg) {
  Card(..card, attrs: list.append(card.attrs, [event.on_mouse_leave(msg)]))
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

pub fn build(card: Card(msg)) -> Element(msg) {
  let classes =
    [
      Some("card"),
      case card.image_full {
        True -> Some("image-full")
        False -> None
      },
      case card.border {
        True -> Some("card-border")
        False -> None
      },
      case card.dash {
        True -> Some("card-dash")
        False -> None
      },
      case card.side {
        True -> Some("card-side")
        False -> None
      },
      option.map(card.size, size_class),
      card.color,
      case style.to_class_string(card.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(cl) { cl != "" })
    |> string.join(" ")

  let figure_el = case card.image_src {
    None -> []
    Some(src) -> [
      html.figure([], [
        html.img([attribute.src(src), attribute.alt(card.image_alt)]),
      ]),
    ]
  }
  let title_el = case card.title {
    None -> []
    Some(t) -> [html.h2([attribute.class("card-title")], [element.text(t)])]
  }
  let actions_el = case card.actions {
    [] -> []
    els -> [html.div([attribute.class("card-actions justify-end")], els)]
  }
  let body_el =
    html.div(
      [attribute.class("card-body")],
      list.flatten([title_el, card.body, actions_el]),
    )
  html.div(
    [attribute.class(classes), ..card.attrs],
    list.append(figure_el, [body_el]),
  )
}
