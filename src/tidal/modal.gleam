/// Modal component — renders a DaisyUI `modal` dialog.
///
/// Modals in DaisyUI are toggled via a checkbox or the `modal-open` class.
/// Tidal uses the `modal-open` class approach: set `open(to: True)` to show.
///
/// ```gleam
/// import tidal/modal
/// import tidal/button
///
/// modal.new()
/// |> modal.open(to: model.show_modal)
/// |> modal.title(text: "Confirm action")
/// |> modal.body(elements: [
///   html.p([], [html.text("Are you sure you want to continue?")]),
/// ])
/// |> modal.actions(elements: [
///   button.new() |> button.label(text: "Cancel") |> button.on_click(UserCancelledModal) |> button.build,
///   button.new() |> button.label(text: "Confirm") |> button.primary |> button.on_click(UserConfirmedModal) |> button.build,
/// ])
/// |> modal.on_backdrop_click(UserCancelledModal)
/// |> modal.build
/// ```
///
/// See also:
/// - DaisyUI modal docs: https://daisyui.com/components/modal/
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

/// Creates a new `Modal` builder with all options at their defaults (hidden).
///
/// Chain builder functions to configure the modal, then call `build`:
///
/// ```gleam
/// import tidal/modal
///
/// modal.new()
/// |> modal.open(to: model.show_modal)
/// |> modal.title(text: "Confirm action")
/// |> modal.body(elements: [html.p([], [html.text("Are you sure?")])])
/// |> modal.actions(elements: [cancel_btn, confirm_btn])
/// |> modal.on_backdrop_click(UserCancelledModal)
/// |> modal.build
/// ```
///
/// See also:
/// - DaisyUI modal docs: https://daisyui.com/components/modal/
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
pub fn top(modal: Modal(msg)) -> Modal(msg) {
  Modal(..modal, placement: Some("modal-top"))
}

/// Position the modal at the bottom of the viewport.
pub fn bottom(modal: Modal(msg)) -> Modal(msg) {
  Modal(..modal, placement: Some("modal-bottom"))
}

/// Position the modal at the horizontal start.
pub fn start(modal: Modal(msg)) -> Modal(msg) {
  Modal(..modal, placement: Some("modal-start"))
}

/// Position the modal at the horizontal end.
pub fn end_(modal: Modal(msg)) -> Modal(msg) {
  Modal(..modal, placement: Some("modal-end"))
}

/// Controls whether the modal is visible.
pub fn open(modal: Modal(msg), to is_open: Bool) -> Modal(msg) {
  Modal(..modal, open: is_open)
}

/// Sets the modal title rendered in the header.
pub fn title(modal: Modal(msg), text text: String) -> Modal(msg) {
  Modal(..modal, title: Some(text))
}

/// Sets the modal body content. May be called multiple times — content accumulates.
pub fn body(
  modal: Modal(msg),
  elements elements: List(Element(msg)),
) -> Modal(msg) {
  Modal(..modal, body: list.append(modal.body, elements))
}

/// Adds action elements (e.g. buttons) in the modal footer.
/// May be called multiple times — actions accumulate.
pub fn actions(
  modal: Modal(msg),
  elements elements: List(Element(msg)),
) -> Modal(msg) {
  Modal(..modal, actions: list.append(modal.actions, elements))
}

/// Registers a callback dispatched when the backdrop is clicked.
pub fn on_backdrop_click(modal: Modal(msg), msg: msg) -> Modal(msg) {
  Modal(..modal, on_backdrop_click: Some(msg))
}

/// Appends presentation styles applied to the modal box. May be called multiple times.
pub fn style(modal: Modal(msg), styles styles: List(Style)) -> Modal(msg) {
  Modal(..modal, styles: list.append(modal.styles, styles))
}

/// Appends HTML attributes to the modal wrapper. May be called multiple times.
pub fn attrs(
  modal: Modal(msg),
  attributes attributes: List(attribute.Attribute(msg)),
) -> Modal(msg) {
  Modal(..modal, attrs: list.append(modal.attrs, attributes))
}

// ---------------------------------------------------------------------------
// Build
// ---------------------------------------------------------------------------

pub fn build(modal: Modal(msg)) -> Element(msg) {
  let placement = case modal.placement {
    None -> ""
    Some(p) -> " " <> p
  }
  let wrapper_cls = case modal.open {
    True -> "modal modal-open" <> placement
    False -> "modal" <> placement
  }

  let box_cls = case style.to_class_string(modal.styles) {
    "" -> "modal-box"
    s -> "modal-box " <> s
  }

  let title_el = case modal.title {
    None -> []
    Some(t) -> [
      html.h3([attribute.class("font-bold text-lg")], [element.text(t)]),
    ]
  }

  let actions_el = case modal.actions {
    [] -> []
    els -> [html.div([attribute.class("modal-action")], els)]
  }

  let box =
    html.div(
      [attribute.class(box_cls)],
      list.flatten([title_el, modal.body, actions_el]),
    )

  let backdrop_attrs = case modal.on_backdrop_click {
    None -> [attribute.class("modal-backdrop")]
    Some(msg) -> [attribute.class("modal-backdrop"), event.on_click(msg)]
  }
  let backdrop = html.div(backdrop_attrs, [])

  html.dialog([attribute.class(wrapper_cls), ..modal.attrs], [box, backdrop])
}
