/// Modal component — renders a DaisyUI `modal` dialog.
///
/// Modals in DaisyUI are toggled via a checkbox or the `modal-open` class.
/// Tidal uses the `modal-open` class approach: set `open(True)` to show.
///
/// ```gleam
/// import tidal/modal
/// import tidal/button
///
/// modal.new()
/// |> modal.open(model.show_modal)
/// |> modal.title("Confirm action")
/// |> modal.body([
///   html.p([], [html.text("Are you sure you want to continue?")]),
/// ])
/// |> modal.actions([
///   button.new() |> button.label("Cancel") |> button.on_click(UserCancelledModal) |> button.build,
///   button.new() |> button.label("Confirm") |> button.primary |> button.on_click(UserConfirmedModal) |> button.build,
/// ])
/// |> modal.on_backdrop_click(UserCancelledModal)
/// |> modal.build
/// ```

import gleam/list
import gleam/option.{type Option, None, Some}
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import tidal/style.{type Style}

// ---------------------------------------------------------------------------
// Type
// ---------------------------------------------------------------------------

pub opaque type Modal(msg) {
  Modal(
    open: Bool,
    placement: Option(String),
    title: Option(String),
    body: List(Element(msg)),
    actions: List(Element(msg)),
    on_backdrop_click: Option(msg),
    styles: List(Style),
    attrs: List(attribute.Attribute(msg)),
  )
}

// ---------------------------------------------------------------------------
// Builder
// ---------------------------------------------------------------------------

pub fn new() -> Modal(msg) {
  Modal(
    open: False,
    placement: None,
    title: None,
    body: [],
    actions: [],
    on_backdrop_click: None,
    styles: [],
    attrs: [],
  )
}

/// Position the modal at the top of the viewport.
pub fn top(m: Modal(msg)) -> Modal(msg) { Modal(..m, placement: Some("modal-top")) }
/// Position the modal at the bottom of the viewport.
pub fn bottom(m: Modal(msg)) -> Modal(msg) { Modal(..m, placement: Some("modal-bottom")) }
/// Position the modal at the horizontal start.
pub fn start(m: Modal(msg)) -> Modal(msg) { Modal(..m, placement: Some("modal-start")) }
/// Position the modal at the horizontal end.
pub fn end_(m: Modal(msg)) -> Modal(msg) { Modal(..m, placement: Some("modal-end")) }

/// Controls whether the modal is visible.
pub fn open(m: Modal(msg), is_open: Bool) -> Modal(msg) {
  Modal(..m, open: is_open)
}

/// Sets the modal title rendered in the header.
pub fn title(m: Modal(msg), text: String) -> Modal(msg) {
  Modal(..m, title: Some(text))
}

/// Sets the modal body content. May be called multiple times — content accumulates.
pub fn body(m: Modal(msg), els: List(Element(msg))) -> Modal(msg) {
  Modal(..m, body: list.append(m.body, els))
}

/// Adds action elements (e.g. buttons) in the modal footer.
/// May be called multiple times — actions accumulate.
pub fn actions(m: Modal(msg), els: List(Element(msg))) -> Modal(msg) {
  Modal(..m, actions: list.append(m.actions, els))
}

/// Registers a callback dispatched when the backdrop is clicked.
pub fn on_backdrop_click(m: Modal(msg), msg: msg) -> Modal(msg) {
  Modal(..m, on_backdrop_click: Some(msg))
}

/// Appends presentation styles applied to the modal box. May be called multiple times.
pub fn style(m: Modal(msg), s: List(Style)) -> Modal(msg) {
  Modal(..m, styles: list.append(m.styles, s))
}

/// Appends HTML attributes to the modal wrapper. May be called multiple times.
pub fn attrs(m: Modal(msg), a: List(attribute.Attribute(msg))) -> Modal(msg) {
  Modal(..m, attrs: list.append(m.attrs, a))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(m: Modal(msg)) -> Element(msg) {
  let placement = case m.placement { None -> "" Some(p) -> " " <> p }
  let wrapper_cls = case m.open {
    True -> "modal modal-open" <> placement
    False -> "modal" <> placement
  }

  let box_cls = case style.to_class_string(m.styles) {
    "" -> "modal-box"
    s -> "modal-box " <> s
  }

  let title_el = case m.title {
    None -> []
    Some(t) -> [html.h3([attribute.class("font-bold text-lg")], [element.text(t)])]
  }

  let actions_el = case m.actions {
    [] -> []
    els -> [html.div([attribute.class("modal-action")], els)]
  }

  let box =
    html.div(
      [attribute.class(box_cls)],
      list.flatten([title_el, m.body, actions_el]),
    )

  let backdrop_attrs = case m.on_backdrop_click {
    None -> [attribute.class("modal-backdrop")]
    Some(msg) -> [attribute.class("modal-backdrop"), event.on_click(msg)]
  }
  let backdrop = html.div(backdrop_attrs, [])

  html.dialog(
    [attribute.class(wrapper_cls), ..m.attrs],
    [box, backdrop],
  )
}
