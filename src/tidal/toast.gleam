/// Toast — fixed-position notification stack.
///
/// ```gleam
/// import tidal/toast
/// import tidal/alert
///
/// toast.new()
/// |> toast.top
/// |> toast.end_
/// |> toast.children(elements: [
///   alert.new()
///   |> alert.success
///   |> alert.text(content: "Saved!")
///   |> alert.build,
/// ])
/// |> toast.build
/// ```
///
/// See also:
/// - DaisyUI toast docs: https://daisyui.com/components/toast/
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import lustre/attribute.{type Attribute}
import lustre/element.{type Element}
import lustre/element/html
import tidal/style.{type Style, to_class_string}

pub opaque type Toast(msg) {
  Toast(
    horiz: Option(String),
    vert: Option(String),
    styles: List(Style),
    attrs: List(Attribute(msg)),
    children: List(Element(msg)),
  )
}

/// Creates a new `Toast` container — fixed-position notification stack.
///
/// Chain builder functions to configure the toast, then call `build`:
///
/// ```gleam
/// import tidal/toast
///
/// toast.new()
/// |> toast.top
/// |> toast.end_
/// |> toast.children(elements: [notification_el])
/// |> toast.build
/// ```
///
/// See also:
/// - DaisyUI toast docs: https://daisyui.com/components/toast/
pub fn new() -> Toast(msg) {
  Toast(horiz: None, vert: None, styles: [], attrs: [], children: [])
}

pub fn start(toast: Toast(msg)) -> Toast(msg) {
  Toast(..toast, horiz: Some("toast-start"))
}

pub fn center(toast: Toast(msg)) -> Toast(msg) {
  Toast(..toast, horiz: Some("toast-center"))
}

pub fn end_(toast: Toast(msg)) -> Toast(msg) {
  Toast(..toast, horiz: Some("toast-end"))
}

pub fn top(toast: Toast(msg)) -> Toast(msg) {
  Toast(..toast, vert: Some("toast-top"))
}

pub fn middle(toast: Toast(msg)) -> Toast(msg) {
  Toast(..toast, vert: Some("toast-middle"))
}

pub fn bottom(toast: Toast(msg)) -> Toast(msg) {
  Toast(..toast, vert: Some("toast-bottom"))
}

pub fn style(toast: Toast(msg), styles styles: List(Style)) -> Toast(msg) {
  Toast(..toast, styles: list.append(toast.styles, styles))
}

pub fn attrs(
  toast: Toast(msg),
  attributes attributes: List(Attribute(msg)),
) -> Toast(msg) {
  Toast(..toast, attrs: list.append(toast.attrs, attributes))
}

pub fn children(
  toast: Toast(msg),
  elements elements: List(Element(msg)),
) -> Toast(msg) {
  Toast(..toast, children: list.append(toast.children, elements))
}

pub fn build(toast: Toast(msg)) -> Element(msg) {
  let base =
    [Some("toast"), toast.horiz, toast.vert]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(toast.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.div([attribute.class(class), ..toast.attrs], toast.children)
}
