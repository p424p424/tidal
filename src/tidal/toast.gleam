/// Toast — fixed-position notification stack.
///
/// ```gleam
/// import tidal/toast
/// import tidal/alert
/// import tidal/variant
///
/// toast.new()
/// |> toast.top
/// |> toast.end_
/// |> toast.children([
///   alert.new()
///   |> alert.message("Saved!")
///   |> alert.variant(variant.Success)
///   |> alert.build,
/// ])
/// |> toast.build
/// ```

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

pub fn new() -> Toast(msg) {
  Toast(horiz: None, vert: None, styles: [], attrs: [], children: [])
}

pub fn start(t: Toast(msg)) -> Toast(msg) { Toast(..t, horiz: Some("toast-start")) }
pub fn center(t: Toast(msg)) -> Toast(msg) { Toast(..t, horiz: Some("toast-center")) }
pub fn end_(t: Toast(msg)) -> Toast(msg) { Toast(..t, horiz: Some("toast-end")) }

pub fn top(t: Toast(msg)) -> Toast(msg) { Toast(..t, vert: Some("toast-top")) }
pub fn middle(t: Toast(msg)) -> Toast(msg) { Toast(..t, vert: Some("toast-middle")) }
pub fn bottom(t: Toast(msg)) -> Toast(msg) { Toast(..t, vert: Some("toast-bottom")) }

pub fn style(t: Toast(msg), s: List(Style)) -> Toast(msg) {
  Toast(..t, styles: list.append(t.styles, s))
}

pub fn attrs(t: Toast(msg), a: List(Attribute(msg))) -> Toast(msg) {
  Toast(..t, attrs: list.append(t.attrs, a))
}

pub fn children(t: Toast(msg), c: List(Element(msg))) -> Toast(msg) {
  Toast(..t, children: c)
}

pub fn build(t: Toast(msg)) -> Element(msg) {
  let base =
    [Some("toast"), t.horiz, t.vert]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> string.join(" ")
  let class = case to_class_string(t.styles) {
    "" -> base
    extra -> base <> " " <> extra
  }
  html.div([attribute.class(class), ..t.attrs], t.children)
}
