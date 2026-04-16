/// Card component — renders a DaisyUI `card` with optional image, title, body, and actions.
///
/// ```gleam
/// import tidal/card
/// import tidal/button
/// import tidal/variant
///
/// card.new()
/// |> card.image("/images/hero.jpg", "Hero image")
/// |> card.title("Hello, Tidal!")
/// |> card.body([
///   text.new("A simple card example.") |> text.build,
/// ])
/// |> card.actions([
///   button.new("Buy Now") |> button.variant(variant.Primary) |> button.build,
/// ])
/// |> card.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/style.{type Style}
import tidal/variant.{type Variant}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Card(msg) {
  Card(
    title: Option(String),
    body: List(Element(msg)),
    actions: List(Element(msg)),
    image_src: Option(String),
    image_alt: String,
    image_full: Bool,
    bordered: Bool,
    compact: Bool,
    side: Bool,
    variant: Option(Variant),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Card(msg) {
  Card(
    title: None,
    body: [],
    actions: [],
    image_src: None,
    image_alt: "",
    image_full: False,
    bordered: False,
    compact: False,
    side: False,
    variant: None,
    styles: [],
    attrs: [],
  )
}

/// Sets the card title rendered as an `<h2>` inside the card body.
pub fn title(c: Card(msg), text: String) -> Card(msg) {
  Card(..c, title: Some(text))
}

/// Sets the card body content. May be called multiple times — content accumulates.
pub fn body(c: Card(msg), els: List(Element(msg))) -> Card(msg) {
  Card(..c, body: list.append(c.body, els))
}

/// Adds action elements (e.g. buttons) in the card footer area.
/// May be called multiple times — actions accumulate.
pub fn actions(c: Card(msg), els: List(Element(msg))) -> Card(msg) {
  Card(..c, actions: list.append(c.actions, els))
}

/// Adds a top image (`<figure>`) with the given src and alt text.
pub fn image(c: Card(msg), src: String, alt: String) -> Card(msg) {
  Card(..c, image_src: Some(src), image_alt: alt)
}

/// Applies `image-full` so the image extends to fill the entire card.
pub fn image_full(c: Card(msg)) -> Card(msg) {
  Card(..c, image_full: True)
}

/// Adds a visible border around the card.
pub fn bordered(c: Card(msg)) -> Card(msg) {
  Card(..c, bordered: True)
}

/// Uses compact padding inside the card.
pub fn compact(c: Card(msg)) -> Card(msg) {
  Card(..c, compact: True)
}

/// Switches to a horizontal (side-by-side) card layout.
pub fn side(c: Card(msg)) -> Card(msg) {
  Card(..c, side: True)
}

/// Sets a background colour role for the card.
pub fn variant(c: Card(msg), v: Variant) -> Card(msg) {
  Card(..c, variant: Some(v))
}

/// Appends presentation styles. May be called multiple times.
pub fn style(c: Card(msg), s: List(Style)) -> Card(msg) {
  Card(..c, styles: list.append(c.styles, s))
}

/// Appends HTML attributes. May be called multiple times.
pub fn attrs(c: Card(msg), a: List(attribute.Attribute(msg))) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, a))
}

// ---------------------------------------------------------------------------
// Events
// ---------------------------------------------------------------------------

pub fn on_click(c: Card(msg), msg: msg) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, [event.on_click(msg)]))
}

pub fn on_mouse_enter(c: Card(msg), msg: msg) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, [event.on_mouse_enter(msg)]))
}

pub fn on_mouse_leave(c: Card(msg), msg: msg) -> Card(msg) {
  Card(..c, attrs: list.append(c.attrs, [event.on_mouse_leave(msg)]))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

fn variant_class(v: Variant) -> String {
  case v {
    variant.Primary -> "bg-primary text-primary-content"
    variant.Secondary -> "bg-secondary text-secondary-content"
    variant.Accent -> "bg-accent text-accent-content"
    variant.Neutral -> "bg-neutral text-neutral-content"
    variant.Info -> "bg-info text-info-content"
    variant.Success -> "bg-success text-success-content"
    variant.Warning -> "bg-warning text-warning-content"
    variant.Error -> "bg-error text-error-content"
    variant.Ghost | variant.Link | variant.Outline -> ""
  }
}

pub fn build(c: Card(msg)) -> Element(msg) {
  let classes =
    [
      Some("card"),
      case c.image_full { True -> Some("image-full") False -> None },
      case c.bordered { True -> Some("card-bordered") False -> None },
      case c.compact { True -> Some("card-compact") False -> None },
      case c.side { True -> Some("card-side") False -> None },
      option.map(c.variant, variant_class),
      case style.to_class_string(c.styles) {
        "" -> None
        s -> Some(s)
      },
    ]
    |> option.values
    |> list.filter(fn(cl) { cl != "" })
    |> string.join(" ")

  let figure_el = case c.image_src {
    None -> []
    Some(src) -> [
      html.figure([], [
        html.img([attribute.src(src), attribute.alt(c.image_alt)]),
      ]),
    ]
  }

  let title_el = case c.title {
    None -> []
    Some(t) -> [html.h2([attribute.class("card-title")], [element.text(t)])]
  }

  let actions_el = case c.actions {
    [] -> []
    els -> [html.div([attribute.class("card-actions justify-end")], els)]
  }

  let body_el =
    html.div(
      [attribute.class("card-body")],
      list.flatten([title_el, c.body, actions_el]),
    )

  html.div(
    [attribute.class(classes), ..c.attrs],
    list.append(figure_el, [body_el]),
  )
}
