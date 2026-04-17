/// Select dropdown — `<select class="select">`.
///
/// Options are `(value, label)` pairs. An optional placeholder renders as a
/// disabled first option shown when nothing is selected.
///
/// ```gleam
/// import tidal/select
///
/// select.new()
/// |> select.placeholder(text: "Choose a country")
/// |> select.options(pairs: [#("au", "Australia"), #("nz", "New Zealand")])
/// |> select.primary
/// |> select.on_change(UserSelectedCountry)
/// |> select.build
/// ```
///
/// See also:
/// - DaisyUI select docs: https://daisyui.com/components/select/
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

/// Creates a new `Select` builder with all options at their defaults.
///
/// Chain builder functions to configure the select, then call `build`:
///
/// ```gleam
/// import tidal/select
///
/// select.new()
/// |> select.placeholder(text: "Choose a country")
/// |> select.options(pairs: [#("au", "Australia"), #("nz", "New Zealand")])
/// |> select.primary
/// |> select.on_change(UserSelectedCountry)
/// |> select.build
/// ```
///
/// See also:
/// - DaisyUI select docs: https://daisyui.com/components/select/
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
pub fn options(
  select: Select(msg),
  pairs pairs: List(#(String, String)),
) -> Select(msg) {
  Select(..select, options: pairs)
}

/// Disabled placeholder option shown when nothing is selected.
pub fn placeholder(select: Select(msg), text text: String) -> Select(msg) {
  Select(..select, placeholder: Some(text))
}

/// Currently selected value.
pub fn value(select: Select(msg), to selected: String) -> Select(msg) {
  Select(..select, value: Some(selected))
}

pub fn primary(select: Select(msg)) -> Select(msg) {
  Select(..select, color: Some("select-primary"))
}

pub fn secondary(select: Select(msg)) -> Select(msg) {
  Select(..select, color: Some("select-secondary"))
}

pub fn accent(select: Select(msg)) -> Select(msg) {
  Select(..select, color: Some("select-accent"))
}

pub fn neutral(select: Select(msg)) -> Select(msg) {
  Select(..select, color: Some("select-neutral"))
}

pub fn info(select: Select(msg)) -> Select(msg) {
  Select(..select, color: Some("select-info"))
}

pub fn success(select: Select(msg)) -> Select(msg) {
  Select(..select, color: Some("select-success"))
}

pub fn warning(select: Select(msg)) -> Select(msg) {
  Select(..select, color: Some("select-warning"))
}

pub fn error(select: Select(msg)) -> Select(msg) {
  Select(..select, color: Some("select-error"))
}

/// Minimal ghost style.
pub fn ghost(select: Select(msg)) -> Select(msg) {
  Select(..select, ghost: True)
}

/// Sets the select size.
pub fn size(select: Select(msg), size size: Size) -> Select(msg) {
  Select(..select, size: Some(size))
}

/// Marks the select as disabled.
pub fn disabled(select: Select(msg)) -> Select(msg) {
  Select(..select, disabled: True)
}

/// Marks the select as required.
pub fn required(select: Select(msg)) -> Select(msg) {
  Select(..select, required: True)
}

/// Appends Tailwind utility styles.
pub fn style(select: Select(msg), styles styles: List(Style)) -> Select(msg) {
  Select(..select, styles: list.append(select.styles, styles))
}

/// Appends HTML attributes.
pub fn attrs(
  select: Select(msg),
  attributes attributes: List(Attribute(msg)),
) -> Select(msg) {
  Select(..select, attrs: list.append(select.attrs, attributes))
}

pub fn on_change(
  select: Select(msg),
  handler handler: fn(String) -> msg,
) -> Select(msg) {
  Select(..select, attrs: list.append(select.attrs, [event.on_change(handler)]))
}

pub fn on_focus(select: Select(msg), msg: msg) -> Select(msg) {
  Select(..select, attrs: list.append(select.attrs, [event.on_focus(msg)]))
}

pub fn on_blur(select: Select(msg), msg: msg) -> Select(msg) {
  Select(..select, attrs: list.append(select.attrs, [event.on_blur(msg)]))
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

fn option_el(
  selected_value: Option(String),
  pair: #(String, String),
) -> Element(msg) {
  let #(val, lbl) = pair
  let is_selected = case selected_value {
    Some(v) -> v == val
    None -> False
  }
  html.option([attribute.value(val), attribute.selected(is_selected)], lbl)
}

pub fn build(select: Select(msg)) -> Element(msg) {
  let classes =
    [
      Some("select"),
      select.color,
      case select.ghost {
        True -> Some("select-ghost")
        False -> None
      },
      option.map(select.size, size_class),
      case style.to_class_string(select.styles) {
        "" -> None
        st -> Some(st)
      },
    ]
    |> list.filter_map(fn(x) { option.to_result(x, Nil) })
    |> list.filter(fn(c) { c != "" })
    |> string.join(" ")

  let placeholder_el = case select.placeholder {
    None -> []
    Some(text) -> [
      html.option([attribute.disabled(True), attribute.selected(True)], text),
    ]
  }
  let option_els = list.map(select.options, option_el(select.value, _))

  html.select(
    [
      attribute.class(classes),
      attribute.disabled(select.disabled),
      attribute.required(select.required),
      ..select.attrs
    ],
    list.append(placeholder_el, option_els),
  )
}
