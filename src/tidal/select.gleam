/// Select dropdown — `<select class="select">`.
///
/// Options are `(value, label)` pairs. An optional placeholder renders as a
/// disabled first option shown when nothing is selected.
///
/// ```gleam
/// import tidal/select
///
/// select.new()
/// |> select.placeholder("Choose a country")
/// |> select.options([#("au", "Australia"), #("nz", "New Zealand")])
/// |> select.primary
/// |> select.on_change(UserSelectedCountry)
/// |> select.build
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

pub opaque type Select(msg) {
  Select(
    options: List(#(String, String)),
    placeholder: Option(String),
    value: Option(String),
    color: Option(String),
    ghost: Bool,
    size: Option(Size),
    disabled: Bool,
    required: Bool,
    styles: List(Style),
    attrs: List(Attribute(msg)),
  )
}

pub fn new() -> Select(msg) {
  Select(
    options: [],
    placeholder: None,
    value: None,
    color: None,
    ghost: False,
    size: None,
    disabled: False,
    required: False,
    styles: [],
    attrs: [],
  )
}

/// List of `(value, label)` option pairs.
pub fn options(s: Select(msg), opts: List(#(String, String))) -> Select(msg) {
  Select(..s, options: opts)
}

/// Disabled placeholder option shown when nothing is selected.
pub fn placeholder(s: Select(msg), text: String) -> Select(msg) { Select(..s, placeholder: Some(text)) }

/// Currently selected value.
pub fn value(s: Select(msg), v: String) -> Select(msg) { Select(..s, value: Some(v)) }

pub fn primary(s: Select(msg)) -> Select(msg) { Select(..s, color: Some("select-primary")) }
pub fn secondary(s: Select(msg)) -> Select(msg) { Select(..s, color: Some("select-secondary")) }
pub fn accent(s: Select(msg)) -> Select(msg) { Select(..s, color: Some("select-accent")) }
pub fn neutral(s: Select(msg)) -> Select(msg) { Select(..s, color: Some("select-neutral")) }
pub fn info(s: Select(msg)) -> Select(msg) { Select(..s, color: Some("select-info")) }
pub fn success(s: Select(msg)) -> Select(msg) { Select(..s, color: Some("select-success")) }
pub fn warning(s: Select(msg)) -> Select(msg) { Select(..s, color: Some("select-warning")) }
pub fn error(s: Select(msg)) -> Select(msg) { Select(..s, color: Some("select-error")) }

/// Minimal ghost style.
pub fn ghost(s: Select(msg)) -> Select(msg) { Select(..s, ghost: True) }

/// Sets the select size.
pub fn size(s: Select(msg), sz: Size) -> Select(msg) { Select(..s, size: Some(sz)) }

/// Marks the select as disabled.
pub fn disabled(s: Select(msg)) -> Select(msg) { Select(..s, disabled: True) }

/// Marks the select as required.
pub fn required(s: Select(msg)) -> Select(msg) { Select(..s, required: True) }

/// Appends Tailwind utility styles.
pub fn style(s: Select(msg), st: List(Style)) -> Select(msg) {
  Select(..s, styles: list.append(s.styles, st))
}

/// Appends HTML attributes.
pub fn attrs(s: Select(msg), a: List(Attribute(msg))) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, a))
}

pub fn on_change(s: Select(msg), f: fn(String) -> msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_change(f)]))
}
pub fn on_focus(s: Select(msg), msg: msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_focus(msg)]))
}
pub fn on_blur(s: Select(msg), msg: msg) -> Select(msg) {
  Select(..s, attrs: list.append(s.attrs, [event.on_blur(msg)]))
}

fn size_class(s: Size) -> String {
  case s {
    size.Xs -> "select-xs"
    size.Sm -> "select-sm"
    size.Md -> ""
    size.Lg -> "select-lg"
    size.Xl -> "select-xl"
  }
}

fn option_el(selected_value: Option(String), pair: #(String, String)) -> Element(msg) {
  let #(val, lbl) = pair
  let is_selected = case selected_value { Some(v) -> v == val None -> False }
  html.option([attribute.value(val), attribute.selected(is_selected)], lbl)
}

pub fn build(s: Select(msg)) -> Element(msg) {
  let classes =
    [
      Some("select"),
      s.color,
      case s.ghost { True -> Some("select-ghost") False -> None },
      option.map(s.size, size_class),
      case style.to_class_string(s.styles) { "" -> None st -> Some(st) },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let placeholder_el = case s.placeholder {
    None -> []
    Some(text) -> [html.option([attribute.disabled(True), attribute.selected(True)], text)]
  }
  let option_els = list.map(s.options, option_el(s.value, _))

  html.select(
    [attribute.class(classes), attribute.disabled(s.disabled), attribute.required(s.required), ..s.attrs],
    list.append(placeholder_el, option_els),
  )
}
